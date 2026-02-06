#!/usr/bin/env python3
"""
Toy-example networks for polarisation analysis.

Generates SBM, BA, ER, WS networks with:
  • 5 opinion levels  (A = most moderate  →  E = most extreme)
  • 5 community-isolation levels  (A = fully mixed  →  E = nearly isolated),
    applied to the most-extreme opinion distribution only
  • Directed **and** undirected variants of every configuration

Measurements per network:
  - polarisation   (magnetic Laplacian for directed, classic for undirected)
  - assortativity  (numeric, on the continuous opinion values)
  - social balance (signed A³ trace ratio; edge sign from disagreement threshold)
  - triangle counts: +++  and  +--  (following 98_magnetic_laplacian/tests.py)

Outputs:
  gephi-networks/  *.gexf   - network files importable in Gephi
  res/              *.csv    - measurement tables

Usage:
  python toy_examples.py [N_NODES]       # default 500
"""

import sys, os
sys.path.append("..")
import numpy as np
import pandas as pd
import torch
import torch_geometric
import networkx as nx
from tqdm import tqdm
import warnings
warnings.filterwarnings("ignore", message="Sparse CSR tensor support is in beta state")

from utils import polarization_score as ps

device = "cuda" if torch.cuda.is_available() else "cpu"

GEPHI_DIR = "output/toy-examples"
os.makedirs(GEPHI_DIR, exist_ok=True)

N_NODES               = 500
BASE_SEED             = 42
TOXICITY_THRESHOLD    = 0.5   # used only for edge_attr in tensors
# Edge sign for social-balance / triangles: +1 if the two nodes largely
# agree (|opinion_u - opinion_v| < threshold), -1 if they disagree.
# Opinions live in [-1, 1], so max disagreement is 2.0; 1.0 neatly
# separates same-side nodes (disagreement ≈ 0) from cross-side ones.
DISAGREEMENT_THRESHOLD = 1.5
# Extremeness factor: how strongly extreme opinions drive negative interactions.
# Higher = more negative edges at extreme opinions (0 disables the effect).
EXTREMENESS_FACTOR    = 2.5


# ═══════════════════════════════════════════════════════════════════════════
# 0.  Toxicity calculation
# ═══════════════════════════════════════════════════════════════════════════

def calc_node_toxicity(opinion, extremeness_factor=2.0) -> float:
    """
    Calculate toxicity based on opinion extremeness.
    More extreme opinions -> higher toxicity, but not 1:1 with stance.
    Returns value in [0, 1].
    """
    abs_opinion = abs(opinion)
    # Use a sigmoid-like function to map extremeness to toxicity
    return min(1.0, abs_opinion ** extremeness_factor)

def calc_edge_toxicity(u_opinion, v_opinion) -> float:
    """
    Calculate edge toxicity as the maximum of the two nodes' toxicities.
    """
    return max(calc_node_toxicity(u_opinion), calc_node_toxicity(v_opinion))

def edge_sign(u_opinion, v_opinion, extremeness_factor=None):
    """
    Sign of an edge for social-balance / triangle counting.
    +1 if the two nodes largely agree, -1 if they disagree.
    
    With extremeness_factor > 0, more extreme opinions increase the 
    threshold for "disagreement", making extreme nodes more likely to 
    have negative edges.
    
    Args:
        u_opinion, v_opinion: opinions in [-1, 1]
        extremeness_factor: how much extremeness increases negativity
                           (None/0 = no effect, higher = more polarization-driven)
    """
    if extremeness_factor is None:
        extremeness_factor = EXTREMENESS_FACTOR
    
    disagreement = abs(u_opinion - v_opinion)
    
    if extremeness_factor <= 0:
        # No extremeness effect: use base threshold only
        return 1 if disagreement < DISAGREEMENT_THRESHOLD else -1
    
    # Dynamic threshold: more extreme opinions → lower threshold → more negatives
    # extremeness = [0, 1] for opinions in [-1, 1]
    # reduce threshold significantly for fully extreme opinions
    extremeness = max(abs(u_opinion), abs(v_opinion))
    adjusted_threshold = DISAGREEMENT_THRESHOLD - (extremeness ** extremeness_factor) * 0.8
    
    return 1 if disagreement < adjusted_threshold else -1


# ═══════════════════════════════════════════════════════════════════════════
# 2.  Graph generators  (all return **directed** graphs)
# ═══════════════════════════════════════════════════════════════════════════

def make_sbm(n, seed):
    sizes = [n // 2, n - n // 2]
    probs = [[0.05, 0.005], [0.005, 0.05]]
    return nx.stochastic_block_model(sizes, probs, seed=seed, directed=True)

def make_ba(n, seed):
    return nx.barabasi_albert_graph(n, 4, seed=seed).to_directed()

def make_er(n, seed):
    return nx.erdos_renyi_graph(n, 0.10, seed=seed, directed=True)

def make_ws(n, seed):
    k = min(6, n - 1)
    return nx.watts_strogatz_graph(n, k, 0.3, seed=seed).to_directed()

GENERATORS = {"sbm": make_sbm, "ba": make_ba, "er": make_er, "ws": make_ws}


# ═══════════════════════════════════════════════════════════════════════════
# 3.  Opinion assignment   A (most moderate)  →  H (most extreme)
#
#     A : tight unimodal at 0       (std 0.15)
#     B : wider unimodal at 0       (std 0.30)
#     C : emerging bimodal ±0.3 + center (30% center)
#     D : clearly bimodal  ±0.5 + center (25% center)
#     E : sharp bimodal    ±0.85 + center (25% center)
# ═══════════════════════════════════════════════════════════════════════════

# Tuples: (mode, center/split_value, std_dev, center_fraction)
# For bimodal modes:
#   - center_fraction: proportion of nodes sampled from center (0)
#   - remaining fraction: split between the two extreme centers (±p1)
#   - This creates polarized distributions with a populated center
_OPINION_CFG = {
    "A": ("unimodal", 0.0, 0.20, None),      # tight center
    "B": ("unimodal", 0.0, 0.30, None),      # loose center
    "C": ("bimodal",  0.5, 0.15, 0.15),      # emerging split + thick center
    "D": ("bimodal",  0.7, 0.15, 0.10),      # clear split + thick center
    "E": ("bimodal",  0.85, 0.25, 0.05),     # sharp split + thick center
}
OPINION_LEVELS = list(_OPINION_CFG.keys())

def assign_opinions(G, level, rng):
    """Return {node_id: opinion_value} for every node in G."""
    kind, p1, p2, center_frac = _OPINION_CFG[level]
    vals = {}
    for v in sorted(G.nodes()):
        if kind == "unimodal":
            vals[v] = float(np.clip(rng.normal(p1, p2), -1, 1))
        else:
            # Bimodal with center: some nodes from extremes, some from center
            if rng.random() < center_frac:
                # Sample from center
                vals[v] = float(np.clip(rng.normal(0, (p2 + 0.1) * 0.5), -1, 1))
            else:
                # Sample from one of the two extreme centers
                centre = rng.choice([-p1, p1])
                vals[v] = float(np.clip(rng.normal(centre, p2), -1, 1))
    return vals


# ═══════════════════════════════════════════════════════════════════════════
# 4.  Community isolation   A (fully mixed)  →  E (nearly isolated)
#
#     Starting from the most-extreme opinion assignment (level E),
#     progressively remove cross-community edges (community = sign of opinion).
# ═══════════════════════════════════════════════════════════════════════════

# Fraction of cross-community edges to remove at each isolation level.
# A = mildly isolated  →  E = nearly fully isolated.
_ISOLATION_FRAC = {"A": 0.20, "B": 0.40, "C": 0.60, "D": 0.75, "E": 0.90}
ISOLATION_LEVELS = list(_ISOLATION_FRAC.keys())

def enforce_isolation(G, node_vals, level, rng):
    """
    Rewire a graph to increase community isolation while preserving
    the total edge count and the underlying model's structure.

    1. Remove a fraction of cross-community edges (community = sign of opinion).
    2. Compensate by adding the same number of *new* intra-community edges,
       chosen uniformly at random among non-existing intra-community pairs.

    Works correctly on both directed and undirected NetworkX graphs;
    the caller should pass the right type.
    """
    frac = _ISOLATION_FRAC[level]
    G_new = G.copy()
    target_edges = G_new.number_of_edges()
    directed = G_new.is_directed()

    # ── 1. Identify and remove cross-community edges ─────────────────
    cross = [(u, v) for u, v in G_new.edges()
             if (node_vals[u] >= 0) != (node_vals[v] >= 0)]
    n_rm = round(len(cross) * frac)
    if n_rm == 0 or not cross:
        return G_new

    rm_idxs = rng.choice(len(cross), size=n_rm, replace=False)
    for i in rm_idxs:
        G_new.remove_edge(*cross[i])

    # ── 2. Enumerate non-existing intra-community pairs ──────────────
    nodes    = sorted(G_new.nodes())
    comm_pos = [v for v in nodes if node_vals[v] >= 0]
    comm_neg = [v for v in nodes if node_vals[v] <  0]

    intra_cands = []
    for comm in (comm_pos, comm_neg):
        for u in comm:
            for v in comm:
                if u == v:
                    continue
                if not directed and u > v:   # avoid counting each pair twice
                    continue
                if not G_new.has_edge(u, v): # safe for both directed & undirected
                    intra_cands.append((u, v))

    # # ── 3. Add intra-community edges to compensate ───────────────────
    # n_add = min(n_rm, len(intra_cands))
    # if n_add > 0:
    #     add_idxs = rng.choice(len(intra_cands), size=n_add, replace=False)
    #     for i in add_idxs:
    #         G_new.add_edge(*intra_cands[i])

    return G_new

# ═══════════════════════════════════════════════════════════════════════════
# 5.  Helpers: LCC extraction, reindexing, undirected conversion
# ═══════════════════════════════════════════════════════════════════════════

def lcc_reindex(G, node_vals):
    """Extract largest (weakly) connected component, relabel 0..n-1."""
    comps = list(nx.weakly_connected_components(G) if G.is_directed()
                 else nx.connected_components(G))
    if not comps:
        return None, None
    lcc = max(comps, key=len)
    G   = G.subgraph(lcc).copy()
    old = sorted(G.nodes())
    mapping = {o: i for i, o in enumerate(old)}
    G  = nx.relabel_nodes(G, mapping)
    nv = {mapping[o]: node_vals[o] for o in old}
    return G, nv

# ═══════════════════════════════════════════════════════════════════════════
# 6.  Save network in Gephi format (GEXF)
# ═══════════════════════════════════════════════════════════════════════════

def save_gephi(G, node_vals, filename):
    """Save graph with opinion + group node attributes as GEXF."""
    G = G.copy()
    nx.set_node_attributes(G, node_vals, "opinion")
    nx.write_gexf(G, os.path.join(GEPHI_DIR, filename))

# ═══════════════════════════════════════════════════════════════════════════
# 7. Main
# ═══════════════════════════════════════════════════════════════════════════

def execute_generation(n_nodes=N_NODES, seed=BASE_SEED):
    rng  = np.random.default_rng(seed)

    for model_name, gen_fn in tqdm(GENERATORS.items(), desc="models"):
        # Generate the base **directed** graph, integer-labelled
        G_base = gen_fn(n_nodes, seed=int(rng.integers(1e8)))
        if not G_base.is_directed():
            G_base = G_base.to_directed()
        G_base = nx.convert_node_labels_to_integers(G_base, ordering="sorted")

        # ── Experiment 1: opinion spectrum (A→H) ──────────────────────
        for olevel in tqdm(OPINION_LEVELS, desc=f"  {model_name} opinion", leave=False):
            node_vals = assign_opinions(G_base, olevel, rng)

            G_work = G_base.copy()

            G_work, nv = lcc_reindex(G_work, node_vals)

            if G_work is None or G_work.number_of_nodes() < 3:
                continue

            save_gephi(G_work, nv,
                        f"{model_name}_opinion_{olevel}.gexf")

        # ── Experiment 2: isolation on extreme opinions (A→E) ─────────
        extreme_vals = assign_opinions(G_base, "E", rng)

        for ilevel in tqdm(ISOLATION_LEVELS, desc=f"  {model_name} isolation", leave=False):
            G_src  = G_base.copy()
            G_iso  = enforce_isolation(G_src, extreme_vals, ilevel, rng)

            G_work, nv = lcc_reindex(G_iso, extreme_vals)

            if G_work is None or G_work.number_of_nodes() < 3:
                continue

            save_gephi(G_work, nv,
                        f"{model_name}_isolation_{ilevel}.gexf")

    return


def main(n_nodes=N_NODES, iterations=1):
    for i in tqdm(range(iterations), desc="Iterations"):
        seed = BASE_SEED + i
        execute_generation(n_nodes, seed)

    return 1


if __name__ == "__main__":
    num_nodes = N_NODES
    main(n_nodes=num_nodes)
