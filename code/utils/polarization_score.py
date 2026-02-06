import torch, torch_geometric
import pandas as pd
import networkx as nx
import numpy as np
from sklearn.decomposition import PCA

from utils import laplacians

device = "cuda" if torch.cuda.is_available() else "cpu"
topics = ["abortion", "climate", "gender", "guns", "health", "racial_justice", "unauthorized_immigration"]

# Here we make sure nodes ids run from 0 to n-1 for n nodes, without gaps
# Wa also map this into the dataframe with the message data
def _consolidate_node_ids(G, df, is_directed):
   # Making sure the dataframe only contains messages from users in the graph
   df = df[df["user"].isin(set(G.nodes))].copy()
   # First, we make all node labels into integer
   G = nx.convert_node_labels_to_integers(G, ordering = "sorted", label_attribute = "original_id")
   # We create convenience dictionaries to keep track of which old id has been translated into which new id
   node2id = {n[1]["original_id"]: n[0] for n in G.nodes(data = True)}
   id2node = {node2id[n]: n for n in node2id}
   # We create a temporary graph because we want to add the nodes first and the edges later
   # This is because if we just add the edges then networkx will order nodes not by id but by how early they appear in the edge list
   # Which would cause bugs when calculating the ideological scores because the order of node ids would not be consistent with the order of the rows in the adjacency matrix
   _ = nx.DiGraph() if is_directed else nx.Graph()
   _.add_nodes_from(sorted(G.nodes))
   _.add_edges_from(G.edges(data = True))
   G = _
   df["user"] = df["user"].map(node2id)
   return G, df, node2id, id2node

# Here we make sure to reduce a network only to its largest connected component
def _select_lcc(G, userset, is_directed):
   # First we only consider users with a properly defined stance
   G = G[G["src"].isin(userset) & G["trg"].isin(userset)]
   G = nx.from_pandas_edgelist(G, source = "src", target = "trg", edge_attr = True, create_using=nx.DiGraph() if is_directed else nx.Graph())
   # Find all connected components
   ccs = list(nx.weakly_connected_components(G) if is_directed else nx.connected_components(G))
   if len(ccs) > 0:
      # If we have at least one component, then we return the subgraph containing the nodes and the edges of the one with most nodes
      lcc = max(ccs, key = len)
      return G.subgraph(lcc).copy()
   else:
      # If we do not have a single component, the network si empty and we return None
      return None

# This function returns the set of users with a properly defined stance value on all topics of interest from the dataframe with all message data
# rolling is defined below, and change how we define whether a user has a defined stance on a topic or not
def _select_active_users(df, topic, rolling):
   # This table contains the map between a Reddit username and its node id in the data
   # users = pd.read_csv("../01_preprocess/user_nodeid.csv", sep = "\t")
   # users = users.set_index("index")["nodeid"].to_dict()

   # df contains the Reddit usernames, but here we need the node ids, so we remap the usernames
   # df["user"] = df["user"].map(users)

   if topic is not None:
      # If topic is specified, we only want to look at a specific topic in the message data
      df = df[df["topic"] == topic]
      # Here we keep track of how many messages a user has sent
      userset = df.groupby(by = "user").size()
      if rolling:
         # If we are using rolling averages for opinion scores, we can accept users with a single message
         return df, set(userset.index)
      else:
         # Otherwise we need at least four messages for a proper ideological score
         return df, set(userset[userset > 3].index)
   else:
      # If we're here it is because we want to look at all topics at once
      userset = df.groupby(by = ["user", "topic"]).size()
      if rolling:
         # If we are using rolling averages for opinion scores, we can accept users with a single message per topic
         userset = userset.reset_index().groupby(by = "user").size()
      else:
         # Otherwise we need at least four messages per topic for a proper ideological score
         userset = userset[userset > 3].reset_index().groupby(by = "user").size()
      return df, set(userset[userset == 7].index)

# This function takes a graph and its node attributes and makes sure we only have nodes with a properly defined stance on all topics of interest
# The topics of interest are defined by topic (which is None if we want all topics)
# rolling is defined below, and change how we define whether a user has a defined stance on a topic or not
def _consolidate_network(G, df, topic, rolling, is_directed):
   # Here we select the users with a properly defined stance on all topics of interest
   df, userset = _select_active_users(df, topic, rolling)
   # Make sure that the network is a single connected component, otherwise we cannot calculate the polarization value
   G = _select_lcc(G, userset, is_directed)
   # G will be None if the largest connected component is empty
   if G is not None:
      # To build a torch_geometric tensor we must have node ids from 0 to n-1 (for n nodes) without gaps, here we ensure that
      # We also keep dictionaries with the node id mapping, just in case we need them later
      G, df, node2id, id2node = _consolidate_node_ids(G, df, is_directed)
      if rolling:
         # If we want rolling opinions, then we look at the columns containing the rolling averages and we take the last (most updated) one
         node_attr = df.groupby(by = ["user", "topic"])["weekly_opinion"].last().reset_index()
         node_attr = pd.pivot_table(data = node_attr, index = "user", columns = "topic", values = "weekly_opinion").reset_index()
      else:
         # If we don't want rolling opinions, we average all stance values within the current week
         node_attr = df.groupby(by = ["user", "topic"])["opinion"].mean().reset_index()
         node_attr = pd.pivot_table(data = node_attr, index = "user", columns = "topic", values = "opinion").reset_index()
      return G, node_attr.sort_values(by = "user"), node2id, id2node
   else:
      return None, None, None, None

# This function produces the torch_geometric tensor needed to calculate ideological and affective polarization. It requires
# - a networkx graph G with the edge topology
# - a pandas dataframe df with the node attributes
# - the string week with the id of the week of study
# Then one needs to specify about which topic one needs to calculate the polarization. Leave to None to calculate multi-topic polarization
# "rolling" enables looking at messages from previous weeks to estimate the stance of a user, if not enough messages were sent during the present week
# "zombie" enables to estimate the stance of a user in a topic even if they did not write about that topic during that week
# Both rolling and zombie are set to True for the study
def make_tensor(G, df, week, topic = None, rolling = False, zombie = False, is_directed = False):
   if zombie:
      # Choosing the zombie option also implies using rolling opinion and not specifiying a topic
      assert rolling, "Choosing the zombie option must use rolling opinions"
      assert topic is None, "Choosing the zombie option must run on all topics"
      # If we chose the zombie option, we know the user's stance was the last rolling stance from any week, whether the present week or any week before it
      df = df[df["week"] <= week].groupby(by = ["user", "topic"])["weekly_opinion"].last().reset_index()
   else:
      # If we do not choose the zombie option, we only need the information from the current week
      df = df[df["week"] == week].copy()
      
   # See above for the documentation of this function, the result is a network with a single connected component and all stances from the users in it
   G, df, node2id, id2node = _consolidate_network(G, df, topic, rolling, is_directed)
   # G is none when the consolidation code lost all nodes
   if G is not None:
      edge_index = [[], []]
      edge_attr = []
      # This loops build a graph with edge attributes in the format needed to create a torch_geometric tensor
      for edge in G.edges(data = True):
         edge_index[0].append(edge[0])
         edge_index[1].append(edge[1])
         edge_attr.append([edge[2]["nij"], edge[2]["score"], edge[2]["toxic"]])
         if not is_directed:
            # If the network is undirected, we need to add both directions for each edge
            edge_index[0].append(edge[1])
            edge_index[1].append(edge[0])
            edge_attr.append([edge[2]["nij"], edge[2]["score"], edge[2]["toxic"]])
      # Build the torch_geometric tensor with node and edge attributes
      tensor = torch_geometric.data.Data(
         edge_index = torch.tensor(edge_index, dtype = torch.long).to(device),
         node_vects = torch.tensor(df.set_index("user").values, dtype = torch.float32).to(device),
         edge_attr = torch.tensor(edge_attr, dtype = torch.float32).to(device)
      )
      if topic is not None:
         # If we are looking at a specific topic, the disagreement edge attribute is the absolute difference between the stances of the two connected users
         disagreement = (tensor.node_vects[tensor.edge_index[0], 0] - tensor.node_vects[tensor.edge_index[1], 0]).abs()
      else:
         try:   
            # If we are looking at all topics at once, we need to run PCA to reduce them to a single dimension
            reducer = PCA(n_components = 1)
            # Run the PCA and force the embeddings in a -1,+1 interval, any value beyond the bounds is lowered to the bound value
            embedding = reducer.fit_transform(tensor.node_vects.cpu().numpy()) / 2
            embedding[embedding < -1] = -1
            embedding[embedding > 1] = 1
         except:
            embedding = np.zeros((tensor.node_vects.shape[0], 1))
         # Add the embedding to the node attributes
         tensor.node_vects = torch.cat((tensor.node_vects, torch.tensor(embedding, dtype = torch.float32).to(device)), 1)
         # Now the multi topic disagreement is the difference between the embeddings of the two nodes
         disagreement = (tensor.node_vects[tensor.edge_index[0], 7] - tensor.node_vects[tensor.edge_index[1], 7]).abs()
      # Add the disagreement as an edge attribute
      tensor.edge_attr = torch.cat((tensor.edge_attr, disagreement.unsqueeze(dim = 1)), 1)
      return tensor, node2id, id2node
   else:
      return None, None, None

# Calcultes the pseudoinverse of the Laplacian of a graph stored in a torch_geometric tensor built with the code from the make_tensor function above.
# Useful to cache the result, since the Laplacian only depends on the graph and we might want to calculate a different distance for many vectors on the same graph.
def _Linv(tensor, mode = "classic", edges = "unsigned", theta = 0.8 * torch.pi):
   assert mode in ["classic", "magnetic"], "Mode must be either 'classic', or 'magnetic'"
   assert edges in ["unsigned", "signed"], "Edges must be either 'unsigned' or 'signed'"
   if mode == "classic" and edges == "unsigned":
      L = laplacians.classic(tensor)
   elif mode == "classic" and edges == "signed":
      L = laplacians.signed_laplacian(tensor)
   elif mode == "magnetic":
      theta = torch.pi if edges == "signed" else theta
      L = laplacians.magnetic_laplacian(tensor, theta).real
   return torch.linalg.pinv(L, hermitian=True)

# This is the basic GE function. Given a vector from -1 to +1 representing the difference between two vectors from 0 to 1, it will calculate
# the Euclidean distance of the two vectors using the graph's topology (represented by the inverse of its Laplacian).
# The code requires a torch_geometric tensor built using the make_tensor function above and the index of its node attributes of which we
# want to calculate the Euclidean distance. You can also provide a precomputed inverse of the Laplacian, to save time.
def ge(tensor: torch.tensor, vector_index, Linv = None):
   node_vects = tensor.node_vects[:, vector_index].clone()
   return float(torch.sqrt(node_vects.t().matmul(Linv.matmul(node_vects))).cpu().numpy())

