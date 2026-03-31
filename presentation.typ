#import "@preview/touying:0.5.2": *
#import themes.metropolis: *

// UniMi Colors
#let unimi-blue = rgb("#003366") // Pantone 281
#let unimi-gray = rgb("#707173") // Pantone Cool Gray 10C
#let faculty-color = rgb("#009933") // VerdePino (Science and Technology as example)

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  config-colors(
    primary: unimi-blue,
    primary-light: unimi-gray,
    secondary: faculty-color,
    neutral-light: rgb("#FFFFFF"),
    neutral-dark: rgb("#000000"),
  ),
  config-info(
    title: [Titolo],
    subtitle: [Sottotitolo],
    author: [Autore],
    date: [AA 2020/21],
    institution: [Università degli Studi Milano],
  ),
)

// Define blocks with UniMi colors
// Typst doesn't have an exact `exampleblock` equivalent built-in, 
// so we'll simulate them with custom functions if needed, or stick to the ones provided by the theme.

#title-slide()

= Sezione

== Frame Title

#grid(
  columns: (1fr, 1fr),
  column-gutter: 2em,
  [
    // Instead of blocks, we can use simple colored boxes or just text for simplicity
    // A simple approximation for a block in typst
    #block(fill: luma(240), inset: 8pt, radius: 4pt, width: 100%, [
      *Example Block Title*
      - Item
    ])
    
    #block(fill: luma(240), inset: 8pt, radius: 4pt, width: 100%, [
      *Block title*
      + Item
    ])
    
    #block(fill: luma(240), inset: 8pt, radius: 4pt, width: 100%, [
      *Alert Block Title*
      / Bla: bla bla
    ])
  ],
  [
    $ I_(q c t)(E) = 1/(2T) abs(integral_0^T d t  e^(i E t/planck.reduce) p(t))^2 $
  ]
)

// "Thank you" slide equivalents
#focus-slide[
  #set text(size: 2em, weight: "bold")
  Thank you for listening! \ \
  Please ask your questions
]

#slide[
  #set page(fill: unimi-blue)
  #set place(center + horizon)
  #set text(fill: white, size: 2em, weight: "bold")
  #align(center)[Thank you for your attention! \ \
  Please ask your questions]
]

= Appendix
#show: appendix

== Appendix

// This is the appendix frame
