import torch, torch_geometric
import numpy as np

device = "cuda" if torch.cuda.is_available() else "cpu"

def classic(tensor):
    L_ei, Lew = torch_geometric.utils.get_laplacian(tensor.edge_index, edge_weight = tensor.edge_attr[:,0])
    L = torch_geometric.utils.to_dense_adj(edge_index = L_ei, edge_attr = Lew)[0]
    return L

def signed_laplacian(tensor):
    num_nodes = tensor.edge_index.max() + 1 if tensor.edge_index.min() == 0 else tensor.edge_index.max()
    A = torch.zeros((num_nodes, num_nodes), dtype = torch.float).to(device)
    A[tensor.edge_index[0], tensor.edge_index[1]] = tensor.edge_attr[:,0]

    A = A + A.T
    A = A / 2

    D = torch.diag(torch.abs(A).sum(dim = 1))

    return D - A

def numpy_magnetic_laplacian(tensor, theta = torch.pi / 2):
    num_nodes = tensor['edge_index'].max() + 1 if tensor['edge_index'].min() == 0 else tensor['edge_index'].max()
    phase = np.exp(1j * theta, dtype=np.clongfloat)
    
    H = np.zeros((num_nodes, num_nodes), dtype=np.clongfloat)
    H[tensor['edge_index'][0], tensor['edge_index'][1]] = tensor['edge_attr'][:,0] * phase

    H = H + H.conj().T
    H = H / 2
	
    D = np.diag(np.abs(H).sum(axis=1))
 
    return D - H

def magnetic_laplacian(tensor, theta = np.pi / 2):
    num_nodes = tensor.edge_index.max() + 1 if tensor.edge_index.min() == 0 else tensor.edge_index.max()
    phase = torch.exp(1j * torch.as_tensor(theta, dtype = torch.cfloat)).to(device)

    H = torch.zeros(num_nodes, num_nodes, dtype = torch.cfloat).to(device)
    H[tensor.edge_index[0], tensor.edge_index[1]] = tensor.edge_attr[:,0] * phase

    H = H + H.conj().T
    H = H / 2
	
    D = torch.diag(torch.abs(H).sum(dim = 1))
 
    return D - H
