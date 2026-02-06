{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [ 
    typst 
    ghostscript_headless
    # optipng
  ];

  shellHook = ''
    echo "Compiling..."
    typst compile thesis.typ thesis.raw.pdf
    echo "Compressing..."
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress -dNOPAUSE -dQUIET -dBATCH -sOutputFile=thesis.pdf thesis.raw.pdf
    echo "Cleaning up..."
    rm thesis.raw.pdf
    echo "Done!"
    exit 0
  '';
}
