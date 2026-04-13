let
  pkgs = import <nixpkgs> {};
  python = pkgs.python3;
in pkgs.mkShell {
  packages = [
    (python.withPackages (python-pkgs: with python-pkgs; [
        ipython
        ipykernel
        jupyter
        jupyter-core
        pandas
        numpy
        torch
        torch-geometric
        networkx
        tqdm
        sklearn-compat
        matplotlib
    ]))
  ];
}
