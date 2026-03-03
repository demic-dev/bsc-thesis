{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [ pkgs.typst ];

  shellHook = ''
    echo "Compiling..."
    typst compile thesis.typ thesis.pdf
    echo "Done!"
    exit 0
  '';
}
