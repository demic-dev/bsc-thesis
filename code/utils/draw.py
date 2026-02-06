import numpy as np
import networkx as nx
import matplotlib.colors as mcolors

from constants import COLORS

layout_args = {
    "max_iter": 100,
    "gravity": 0.05,
    "scaling_ratio": 1.0,
    "jitter_tolerance": 7.9,
    "seed": 42
}

draw_properties = {
    "nodes": {
        "gradient": mcolors.LinearSegmentedColormap.from_list(
            "opinion_nodes", [COLORS['DEMOCRAT'], COLORS['NEUTRAL'], COLORS['REPUBLICAN']]
        ),
        "norm_opinion": mcolors.Normalize(vmin=-1, vmax=1),
        "size_min": 12.0,
        "size_max": 24.0,
    },
    "edges": {
        "color": "#CCCCCC",
        "width": 1.0
    },
}

def with_layout(G, ax, layout = "forceatlas2_layout", args = layout_args, draw_properties = draw_properties):
    # Extract opinion values
    opinions = {}
    for node, data in G.nodes(data=True):
        opinions[node] = float(data.get("opinion", 0.0))

    # Compute degree-based node sizes
    degrees = dict(G.degree())
    deg_values = np.array([degrees[n] for n in G.nodes()])
    if deg_values.max() > deg_values.min():
        sizes = draw_properties["nodes"]["size_min"] + (draw_properties["nodes"]["size_max"] - draw_properties["nodes"]["size_min"]) * (
            (deg_values - deg_values.min()) / (deg_values.max() - deg_values.min())
        )
    else:
        sizes = np.full(len(deg_values), (draw_properties["nodes"]["size_min"] + draw_properties["nodes"]["size_max"]) / 2)

    # Node colors from opinion
    node_colors = [draw_properties["nodes"]["gradient"](draw_properties["nodes"]["norm_opinion"](opinions[n])) for n in G.nodes()]

    layout_func = getattr(nx, layout)
    pos = layout_func(G, **args)

    # Draw edges
    nx.draw_networkx_edges(
        G, pos, ax=ax,
        edge_color=draw_properties['edges']['color'],
        width=draw_properties['edges']['width'],
        alpha=0.15,
        arrows=False,
    )

    # Draw nodes
    # matplotlib node size is in points² — square the values
    nx.draw_networkx_nodes(
        G, pos, ax=ax,
        node_color=node_colors,
        node_size=sizes ** 2,
        linewidths=0,
    )

    return ax
