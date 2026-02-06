import sys, glob
import pandas as pd
import numpy as np
import torch, torch_geometric
import networkx as nx
from tqdm import tqdm
from scipy.stats import spearmanr

from utils import polarization_score as ps

device = "cuda" if torch.cuda.is_available() else "cpu"

toxicity_threshold = 0.5
topics = ["abortion", "climate", "gender", "guns", "health", "racial_justice", "unauthorized_immigration"]
topics_pca = topics + ["pca"]

assert len(sys.argv) > 1 and (sys.argv[1] == "directed" or sys.argv[1] == "undirected"), "Specify if networks are directed or undirected!"
is_directed=sys.argv[1] == "directed"

valid_modes = ["original", "random", "extreme", "moderate"]
opinion_mode = sys.argv[2] if len(sys.argv) > 2 else "original"
assert opinion_mode in valid_modes, f"Opinion mode must be one of {valid_modes}!"

def get_social_balance(networks, week_ids):
    """
        Returns the social balance of a given network.
    """

    def evaluate_balance(edges, nodes):
        """
            Same as in 04_insights/02_fig_b2
        """
        # We start from the signed adjacency matrix
        A = pd.pivot_table(data = edges, index = "#src", columns = "trg", values = "sign")
        # We make sure it is squared, since A at the moment is upper triangular we might miss some rows and columns
        A = A.reindex(index = nodes.index, columns = nodes.index).fillna(0)
        # We sum A with its transpose, making it undirected
        A += A.T
        # Put it on the GPU to speed up calculations
        A = torch.from_numpy(A.values).float().to(device).to_sparse()
        # Raising an adjacency matrix to the power of 3 gives for each entry in the diagonal the number of cycles of length 3 (triangles) around the corresponding node
        # Since it is signed, it is counting the number of balanced triangles minus the unbalanced ones
        A3 = torch.linalg.matrix_power(A, 3)
        # By raising to the power of 3 the unsigned adjacency (taking its absolute value) we count all triangles, whether balanced or not
        A3_abs = torch.linalg.matrix_power(torch.abs(A), 3)
        A3_indices = A3.indices()
        # With this we can select the diagonal
        diagonal = A3_indices[0] == A3_indices[1]
        # By summing all entries in the diagonal we calculate the trace of the matrix
        # The ratio of the trace of signed over unsigned adjacency is how many balanced triangles we have over all triangles in the network
        # The higher the more balanced the network (and therefore the more polarization)
        if A3_abs.values()[diagonal].sum() > 0:
            overall_balance = float(A3.values()[diagonal].sum() / A3_abs.values()[diagonal].sum())
        else:
            overall_balance = 0.0
        # Divided by six, because each triangle correspond to 6 walks (3 starting nodes x 2 directions)
        return (week, overall_balance, float(A3_abs.values()[diagonal].sum()/6))
    
    df = []
    cols = ("week", "overall_balance", "triangles")
    
    for week in tqdm(week_ids):
        index = week_ids.index(week)
        edges = networks['edges'][index]
        nodes = networks['nodes'][index]
        
        nodes = nodes.set_index("node")
        
        edges['sign'] = np.where(edges['toxic'] > toxicity_threshold, -1, 1)

        df.append(evaluate_balance(edges, nodes))
            
    return pd.DataFrame(data=df, columns=cols)

def get_triangles(networks, week_ids, topic='pca'):
    """
    Find the triangles +++ and +-- triangles for a network, based on the passed topic.
    +++ means that every cycle of three nodes have positive interactions
    +-- means that every cycle of three nodes have positive interactions only between likely minded people (same stance)
        
    :param networks: the final networks
    :param week_ids: list of week_ids (24_01, 24_02, ...)
    :param topic: the topic chosen by the user
    """
    
    df = []
    for week in tqdm(week_ids):
        index = week_ids.index(week)
        edges = networks['edges'][index]
        nodes = networks['nodes'][index]
        
        nodes = nodes.set_index("node")
        
        edges['sign'] = np.where(edges['toxic'] > toxicity_threshold, -1, 1)
        
        G = nx.from_pandas_edgelist(
            edges,
            source="#src",
            target="trg",
        )
        cliques = list(nx.enumerate_all_cliques(G))
        triangles = [clique for clique in cliques if len(clique) == 3]
        
        plusplusplus = 0
        plusminmin = 0
        
        if not triangles:
            df.append((0, 0, 0, 0, 0))
            continue

        for triangle in triangles:
            reps = [nodes.iloc[triangle[0]][topic] >= 0, nodes.iloc[triangle[1]][topic] >= 0, nodes.iloc[triangle[2]][topic] >= 0]
            dems = [not r for r in reps]
            
            # Get edge signs for each pair in the triangle, checking both directions
            interactions = []
            for src, trg in [(triangle[0], triangle[1]), (triangle[1], triangle[2]), (triangle[2], triangle[0])]:
                mask = (edges["#src"] == src) & (edges["trg"] == trg)
                result = edges.loc[mask, 'sign'].values
                if len(result) == 0:
                    mask = (edges["#src"] == trg) & (edges["trg"] == src)
                    result = edges.loc[mask, 'sign'].values
                interactions.append(result[0] if len(result) > 0 else None)
            
            if None in interactions:
                continue  # Skip triangles with missing edges
            
            # only positive interactions in a group of likely-minded peers
            if (all(dems) and all(i == 1 for i in interactions)) or (all(reps) and all(i == 1 for i in interactions)):
                plusplusplus += 1
            # 2 vs 1: positive interaction between two peers that have negative against another one
            # the index of the two true values in dems is the index of which I want to access to iterations array and check whether the iterations[truedems[0]] and iterations[truedems[1]]
            elif (sum(dems) == 2 and len([1 for i, d in enumerate(dems) if d and interactions[i] == 1]) == 2) or (sum(reps) == 2 and len([1 for i, r in enumerate(reps) if r and interactions[i] == 1]) == 2):
                plusminmin += 1

        df.append((plusplusplus, plusplusplus / len(triangles), plusminmin, plusminmin / len(triangles), len(triangles)))
        
    return pd.DataFrame(data=df, columns=("+++", "+++%", "+--", "+--%", "triangles"), index=week_ids)

def reassign_opinions(networks, mode):
    """
    Reassign node opinions according to the specified mode.
    Opinions are the topic columns (topics_pca) in each node DataFrame.

    Modes:
        - "random":   shuffle opinions randomly (uniform in [-1, 1]).
        - "extreme":  push opinions towards the extremes (+1 or -1)
                      by applying sign(x) * |x|^0.5, amplifying values away from 0.
        - "moderate": push opinions towards 0 (moderate)
                      by applying sign(x) * x^2, compressing values towards 0.

    :param networks: dict with keys "edges" and "nodes", each a list of DataFrames.
    :param mode: one of "random", "extreme", "moderate".
    :returns: a new networks dict with reassigned opinions (edges are unchanged).
    """
    import copy
    new_networks = {
        "edges": networks["edges"],          # edges are unchanged
        "nodes": [df.copy() for df in networks["nodes"]]
    }

    for nodes in new_networks["nodes"]:
        for col in topics_pca:
            values = nodes[col].values
            if mode == "random":
                nodes[col] = np.random.uniform(-1, 1, size=len(values))
            elif mode == "extreme":
                # sign(x) * |x|^0.5  — pushes values away from 0 towards ±1
                nodes[col] = np.sign(values) * np.power(np.abs(values), 0.5)
            elif mode == "moderate":
                # sign(x) * x²  — compresses values towards 0
                nodes[col] = np.sign(values) * np.power(values, 2)
    return new_networks

def load_final_networks(is_directed):
    """
        Loading the final networks from folder and parsing in `{ "edges": [ ... ], "nodes": [ ... ] }`
        as needed for the next functions.
    """
    final_networks_dir = f"data/final_networks{"" if is_directed else ""}"
    final_networks = {
        "edges": [],
        "nodes": []
    }
    final_networks_files = sorted(glob.glob(f"{final_networks_dir}/*_edges.tsv", recursive=True))
    
    week_ids = []

    if not final_networks_files:
        print("⚠ No final network files found. Run network pipeline scripts first.")
        final_networks = None

    print(f"Loading {len(final_networks_files)} final networks...")
    for final_network_file in tqdm(final_networks_files):
        id = final_network_file.replace(f"{final_networks_dir}/", "").split('_edges.tsv')[0]
        
        edges = pd.read_csv(f"{final_networks_dir}/{id}_edges.tsv", sep='\t')
        nodes = pd.read_csv(f"{final_networks_dir}/{id}_nodes.tsv", sep='\t')
        
        final_networks["edges"].append(edges)
        final_networks["nodes"].append(nodes)
        week_ids.append(id)

    return final_networks, week_ids

def calculate_polarization_with_theta(networks, week_ids, theta):
    """
    Similar to 02_ideological/07_fig_2c.py
    
    :param networks: the final networks
    :param week_ids: list of week_ids (24_01, 24_02, ...)
    :param theta: theta values
    """
    results = []
    
    for week in tqdm(week_ids):
        index = week_ids.index(week)
        edges = networks['edges'][index]
        nodes = networks['nodes'][index]

        if theta == np.pi:
            edges['weight'] = np.where(edges['toxic'] > toxicity_threshold, -edges['weight'], edges['weight'])
    
        tensor = torch_geometric.data.Data(
            edge_index=torch.tensor(
                np.array([edges["#src"].values, edges["trg"].values]),
                dtype=torch.long
            ).to(device),
            node_vects=torch.tensor(
                nodes.sort_values(by="node").set_index("node").values,
                dtype=torch.float32
            ).to(device),
            edge_attr=torch.tensor(
                edges[["weight", "signific", "toxic", "disagreement"]].values,
                dtype=torch.float32
            ).to(device)
        )
        
        # Calculate pseudoinverse of Laplacian
        Linv = ps._Linv(tensor, mode="magnetic", theta=theta)
        
        # #alculate polarization (using first topic/PCA component)
        pol = [ps.ge(tensor, i, Linv=Linv) for i in range(len(topics_pca))]
            
        results.append((week, *pol))

    polarization = pd.DataFrame(
        data=results,
        columns=("week", *topics_pca)
    ).set_index('week')
    
    return polarization

def main():
    final_networks, week_ids = load_final_networks(is_directed)

    # Reassign opinions if a non-original mode was selected
    if opinion_mode != "original":
        print(f"Reassigning opinions with mode: {opinion_mode}")
        final_networks = reassign_opinions(final_networks, opinion_mode)

    mode_suffix = f"_{opinion_mode}" if opinion_mode != "original" else ""
    
    # Save network statistics (nodes and edges per week)
    network_stats = []
    for i, week in tqdm(enumerate(week_ids)):
        num_nodes = len(final_networks['nodes'][i])
        num_edges = len(final_networks['edges'][i])
        density = num_edges / (num_nodes * (num_nodes - 1)) if num_nodes > 1 else 0
        G = nx.from_pandas_edgelist(final_networks['edges'][i], source="#src", target="trg", create_using=nx.DiGraph() if is_directed else nx.Graph())

        G.add_nodes_from(final_networks['nodes'][i]['node'])
        for _, row in final_networks['nodes'][i].iterrows():
            G.nodes[row['node']]['pca'] = row['pca']

        assortativity = nx.numeric_assortativity_coefficient(G, "pca")
        network_stats.append((week, num_nodes, num_edges, round(density, 6), round(assortativity, 6)))

    network_stats_df = pd.DataFrame(network_stats, columns=['week', 'num_nodes', 'num_edges', 'density', 'assortativity'])
    network_stats_df.to_csv(f"null-models/network_statistics{mode_suffix}.csv", index=False)
    print(f"Saved network statistics to network_statistics{mode_suffix}.csv")
    
    # Calculate social balance and triangles
    sb = get_social_balance(final_networks, week_ids)
    sbt = [get_triangles(final_networks, week_ids, topic=topic) for topic in topics_pca]

    sb.to_csv(f"social_balance-{sys.argv[1]}{mode_suffix}-.csv")
    sbt[topics_pca.index("pca")].to_csv(f"triangles-{sys.argv[1]}{mode_suffix}-pca.csv")

    # Calculate polarization and correlations for each theta
    theta_values = [0, np.pi/2, 2/3 * np.pi, 4/5 * np.pi, np.pi]
    theta_values_map = {0: "0", np.pi/2: "pi:2", 2/3 * np.pi: "2:3pi", 4/5 * np.pi: "45pi", np.pi: "pi"}
    
    sb_correlations = {topic: [] for topic in topics_pca}
    sbt_correlations = {topic: [] for topic in topics_pca}
    theta_polarizations = {theta: None for theta in theta_values}

    for theta in tqdm(theta_values):
        if theta == 0:
            pol_df = pd.read_csv("data/fig_2c-UNDIRECTED.csv", sep = '\t')
        else:
            pol_df = calculate_polarization_with_theta(final_networks, week_ids, theta)
        theta_polarizations[theta] = pol_df
        pd.DataFrame(pol_df).to_csv(f"null-models/polarization_by_theta_{theta_values_map[theta]}{mode_suffix}.csv")
        for i, topic in enumerate(topics_pca):
            sb_correlations[topic].append(spearmanr(pol_df[topic], sb['overall_balance'])[0])
            sbt_correlations[topic].append(spearmanr(pol_df[topic], sbt[i]['+++'] + sbt[i]['+--'])[0])

    # Print correlations
    print("Correlations between polarization and social balance:")
    for topic in topics_pca:
        print(f"Social Balance {topic}: {sb_correlations[topic]}")
        print(f"Triangles {topic}: {sbt_correlations[topic]}")

    # Save correlations as CSV 
    pd.DataFrame(sb_correlations, index=[theta_values_map[t] for t in theta_values]).to_csv(f"null-models/social_balance_correlations{mode_suffix}.csv")
    pd.DataFrame(sbt_correlations, index=[theta_values_map[t] for t in theta_values]).to_csv(f"null-models/triangles_correlations{mode_suffix}.csv")

if __name__ == "__main__":
    main()
