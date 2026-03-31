{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [ 
    typst 
    ghostscript_headless
    # optipng
  ];

  shellHook = ''
    echo "Compiling..."
    typst compile thesis.typ thesis.raw.pdf --pdf-standard a-4f
    typst compile summary.typ summary.raw.pdf --pdf-standard a-4f
    echo "Compressing..."
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress -dNOPAUSE -dQUIET -dBATCH -sOutputFile=thesis.pdf thesis.raw.pdf
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress -dNOPAUSE -dQUIET -dBATCH -sOutputFile=summary.pdf summary.raw.pdf
    echo "Cleaning up..."
    rm thesis.raw.pdf
    rm summary.raw.pdf
    echo "Done!"
    exit 0
  '';
}
