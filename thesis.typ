// Page setup
#set page(
  paper: "a4",
  margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in),
)

// Font and text setup
#set text(
  font: "New Computer Modern",
  size: 12pt,
  // lang: "it",
)

// Paragraph setup
#set par(
  justify: true,
  leading: 0.65em,
)

// Heading setup
#set heading(numbering: "1.1.")

// Link setup
#show link: underline

// Bibliography setup
#show bibliography: set heading(numbering: "1.1.")

// Theorem environment
#let theorem(body, number: none) = {
  block(
    width: 100%,
    inset: 8pt,
    [
      #text(weight: "bold")[Teorema#if number != none [ #number]:]
      #text(style: "italic")[#body]
    ],
  )
}

// Title page function
#let make-title(
  title: "",
  author: "",
  dept: "",
  anno: "",
  matricola: "",
  relatore: "",
  correlatore: none,
) = {
  set align(center)

  v(1fr)

  // University name
  text(size: 20pt)[
    #smallcaps[Università degli Studi di Milano]
  ]

  v(0.2em)
  text(size: 18pt)[Facoltà di Scienze e Tecnologie]
  v(0.2em)

  // Department
  text(size: 18pt)[#dept]

  v(3em)

  // Title
  text(size: 30pt)[
    #smallcaps[#title]
  ]

  v(3em)

  // Author info
  grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    align: (left, right),
    [
      *Relatore:*\
      #relatore

      #if correlatore != none [
        \
        *Correlatore:*\
        #correlatore
      ]
    ],
    [
      *Tesi di:*\
      #author\
      Matricola: #matricola
    ],
  )

  v(1fr)

  // Academic year
  text(size: 14pt)[
    Anno Accademico #anno
  ]

  v(2em)

  pagebreak()
}

// Preface section function
#let prefacesection(title, body) = {
  if title != "" {
    heading(numbering: none, outlined: false)[#title]
  }
  body
  pagebreak()
}

#make-title(
  title: [Improving Estimation of Polarization in\ Online Discourse],
  author: [Michele DE CILLIS],
  dept: [Corso di Laurea in Informatica],
  anno: [2024-2025],
  matricola: [24260A],
  relatore: [Prof. Elena CASIRAGHI],
  correlatore: [Prof. Michele COSCIA],
)

#set page(numbering: "i")
#counter(page).update(1)

#prefacesection("")[
  #align(right)[
    #text(size: 14pt, style: "italic")[dedicato a ...]
  ]
]

#outline(
  title: [Indice],
  depth: 3,
)
#pagebreak()

= Introduzione
Introduzione bla bla...

== NERDS: Network, Data and Society
#quote[Si consiglia di premettere una descrizione dell'ente presso il quale è stato svolto il tirocinio e delle attivita svolte;  ]\

Il gruppo di ricerca NERDS (_Network, Data and Society_), si trova a Copenhagen, nella ITU (IT-Universitetet i København) e si concentra sullo studio delle applicazioni di data science e network science nell'ambito delle scienze sociali. Dalla sua fondazione, il loro focus è

== Social Network Analysis
#quote[è consigliabile inoltre descrivere brevemente il tema del lavoro mostrandone il rapporto con le attivita svolte dall'ente ospitante.]

== Obiettivi della tesi
#quote[L'introduzione dovrebbe poi contenere gli obiettivi del lavoro svolto (esigenze e motivazioni dell'ente ospitante, soluzioni alternative prese in considerazione, precedenti progetti effettuati dall'ente) e le modalita di svolgimento del progetto (con eventuale piano delle attivita).]\

#pagebreak()

= Descrizione delle attivita preliminari
#quote[Descrivere brevemente le attivita preliminari svolte, quali studio e analisi di soluzioni esistenti, studio delle tecnologie utilizzate nel seguito del lavoro.]\

== Social Network Analysis

La Social Network Analysis - analisi delle reti sociali - non è una vera e propria teoria, ma più una strategia generale da usare per analizzare le strutture sociali. Nasce da ben prima dell'informatica, con la sociologia. È nata con l'intento di studiare i comportamenti delle persone, in base al contesto in cui si trovano. Le relazioni tra gli "attori" di una rete sono la priorità. Nonostante questo, le proprietà singole di un attore sono necessarie per analizzare fenomeni sociali.

Grazie alla diffusione su larga scala della tecnologia e grazie alle crescenti prestazioni dei computer, la SNA ha trovato una sinergia con l'informatica. Attualmente, la SNA si concentra nello studio delle reti sociali, quali Facebook, Twitter (X) o Reddit tra i principali, data la grande mole di dati presenti.\
Le crescenti prestazioni dei computer hanno aiutato la SNA fornendo uno strumento matematico e pratico su cui effettuare le proprie analisi. Modellizzando le reti tramite la teoria dei grafi (presa dall'algebra), l'informatica ha fornito la possibilità di eseguire algoritmi complessi su reti grandi con migliaia o milioni di nodi, in relativamente poco tempo.

Un altro aspetto della SNA è lo studio di come le strutture sociali influenzano il comportamento di una persona. Vengono distinte due tipi di SNA: la ego network analysis, in cui da una rete vai ad identificare un "_ego node_" e studi tutte le proprietà di quella rete, ma ristrette ai nodi confinant, fino ad un certo grado @coscia2021atlas; e la global network analysis, dove invece non prendi in considerazione un singolo nodo ma si cercano di studiare tutte le relazioni tra i partecipanti nella rete.

=== Polarizzazione

Per polarizzazione, si intende la tendenza di un gruppo di prendere decisioni più divisive ed estreme rispetto alle singole opinioni iniziali dei membri. Si riferisce anche al fenomeno per il quale i membri di un gruppo rafforzano le loro opinioni dopo aver avuto una discussione su un determinato argomento.

È un fenomeno importante in psicologia sociale e viene ritrovato in molti contesti. Si inizia a parlare di polarizzazione negli anni '60, quando viene studiato il "risky-shift" @myers1976group, ovvero la tendenza di un gruppo a prendere decisioni più rischiose, rispetto alle stesse singole decisioni prese da ogni individuo di quel gruppo.\
Negli anni più recenti, invece, internet e i social media hanno portato un nuovo contesto dentro il quale studiare la polarizzazione. Ricercatori hanno dimostrato come, grazie alle reti sociali, possono esserci episodi di polarizzazione anche quando le persone non sono fisicamente vicine.

Ai fini della tesi e del tirocinio, andremo nello specifico a parlare di polarizzazione politica, un fenomeno più specifico nel quale le opinioni politiche di una persona -o di un partito- divergono dal centro, fino ad atterrare verso opinioni estreme. Possiamo quindi dire che non vi è alcuna, o quasi, intersezione tra le posizioni dei partiti presi in considerazione. Gli accademici la distinguono in _ideological polarization_, ovvero le differenze tra le posizioni politiche e _affective polarization_.

*Ideological Polarization*: si intende la differenza tra le posizioni politiche e l'esitazione nell'avere a che fare con chi ha opinioni politche diverse.

*Affective Polarization*: misura l'avversione di una persona nell'avere a che fare con persone di idee politiche differenti. Inizialmente veniva misurata con delle surveys @measure-affective-pol, dove le persone rispondevano a domande circa quanto attitudini verso i partiti opposti, ma anche rispetto ai comportamenti che metterebbero in atto rispetto a persone di un partito opposto (sarebbero amici? sarebbero felici di averli come vicini di casa?). Al giorno d'oggi, è possibile anche misurare la _affective polarization_ anche analizzando le reti sociali @hohmann2025estimating che, a differenza dei sondaggi, misurano comportamenti compiuti, su larga scala.

Più avanti nel capitolo, vedremo come quantificarle entrambe, grazie alla della Node Vector Distance e della Generalized Euclidean.

== Teoria dei Grafi

La teoria dei grafi è una branca della matematica e dell'informatica che modella situazioni o processi sotto forma di nodi (attori dell'evento) e di archi (interazioni tra i nodi). Questi vengono rappresentati discretamente come vettori e matrici #footnote[Liste e matrici di adiacenza.], il che consente di sviluppare analisi e algoritmi. I grafi si distinguono in diretti, dove gli archi hanno una direzione specifica dal nodo $a$ al nodo $a'$, e non direzionali, dove invece gli archi non hanno una direzione e quindi non è possibile distinguere il verso del collegamento tra nodo $a$ e nodo $a'$.\
Formalmente, definiamo un grafo: $G = (V, E)$
dove:
- $V = {V_1, V_2, ...}$ è un insieme di nodi
- $E subset.eq {{x, y} | x, y in V and x eq.not y}$ è un insieme di archi non diretto, *oppure*
  - $E subset.eq {{x, y} | (x, y) in V^2 and x eq.not y}$ è un insieme di archi diretto

I grafi vengono usati per modellizzare moltissime relazioni e processi in numerosi campi. Nell'informatica stessa, i grafi sono stati fondamentali per permetterci di sviluppare sistemi operativi multiutente e multiprocesso (nell'ambito della gestione delle risorse) e per poter espandere internet globalmente e senza sosta (routing dei pacchetti).

=== Proprietà principali

+ Degree (single node)
+ Cliques
+ Paths and Cycles
+ Connected Components
+ Distance and Diameter
+ Trees
+ Bipartite Graphs
+ Centrality Measures (?)
+ Clustering Coefficient (?)
+ Independence Number (?)
+ Dense/Sparse (?)

== Network Science

La Network Science è una disciplina che studia le reti complesse. È un campo multidisciplinare, poiché affonda le sue radici in: _matematica_ (teoria dei grafi), _fisica_ (meccanica statistica), _statistica_ (inferenza statistica), _sociologia_ (strutture sociali) e _informatica_ (data mining). Viene definita come #quote()[lo studio delle rappresentazioni di rete dei fenomeni fisici, biologici e sociali che portano alla creazione di modelli predittivi di tali fenomeni.] [nap11516]

Le reti sono modellate mediante grafi, come vedremo in dettaglio più avanti, ma sono sempre composte da due elementi: nodi ($V$) e archi ($E$). Due nodi sono collegati se esiste un arco che parte dal primo nodo e arriva al secondo. Moltissime situazioni complesse possono essere modellate come reti:

- *Social Networks*: nell'informatica, è uno degli esempi più ricorrenti. I social network sono letteralmente delle reti sociali, che modellano relazioni e interazioni tra persone. È immediato pensare alle persone come nodi di una rete e alle relazioni come archi. Instagram o Twitter sono esempi di rete diretta, poiché una persona $a$ può seguire un'altra persona $a'$, ma non è detto che $a'$ ricambi. Esiste quindi un arco diretto che parte da $a$ e arriva ad $a'$, ma non viceversa;
- *Citazioni negli articoli scientifici*: ogni volta che un articolo viene pubblicato, questo contiene $n$ citazioni verso altri articoli e si aggiunge alla rete di articoli già esistenti. Ogni articolo è quindi un nodo e una citazione è un arco che collega due nodi. Anche in questo caso, la rete è diretta;
- *Interazione Proteina-Proteina*: nella biologia, si parla di _interazione proteina-proteina_ quando due o più proteine interagiscono tra di loro per mezzo di reazioni biochimiche. Queste interazioni avvengono all'interno delle cellule di un organismo vivente. In questo contesto, i nodi sono le proteine e il risultato di una reazione porta alla creazione di un arco tra le proteine.

La Network Science è esplosa dopo la pubblicazione dell'articolo di Barabási-Albert "Emergence of Scaling in Random Networks" [Baraba_si_1999]: le reti reali complesse di grandi dimensioni non si sviluppano in modo casuale (la probabilità che un nodo $a$ abbia un arco verso un nodo $a'$ non è approssimabile casualmente, come veniva assunto nel modello _Erdős-Rényi_ [Erdos2022OnRG]), ma seguono una _power-law degree distribution_: è più probabile che nuovi nodi che entrano nella rete cerchino collegamenti con nodi che hanno già molti collegamenti. Questo fenomeno si chiama _preferential attachment_ (ad esempio, nel WWW, un nuovo sito avrà link verso siti più grandi e conosciuti). Di conseguenza, in una rete pochi nodi (detti anche _hub_) avranno un grado elevato [scale-free] e la maggior parte dei nodi avrà un grado basso.

=== Proprietà principali
Posso dire che teoria dei grafi e network science siano altamente interconnesse, però giusto per semplificare, vado a spiegare che le tratto come proprietà della NS solo perché si riferiscono a misure che si possono effettuare su reti grandi/reali, mentre quelle sotto graph theory valgono per qualsiasi grafo.

+ Degree Distribution
+ Assortativity (Degree Mixing)
+ Homophily
+ Clustering Coefficient
+ Small-World Property
+ Modularity
+ Average Path Length (?)
+ Power Law
+ Centrality Variants: Betweenness, eigenvector for network flow/influence
+ Subgraph Counts (Motifs)

=== Node Vector Distance
=== Generalized Euclidean

== Python

== Procedura di costruzione della rete
- Reddit + Dumps
- `playground.ipynb`
- Laplacian
- Node Vector Distance

// Il mio lavoro si andava ad inserire all'interno di un progetto più ampio, dove sono stati raccolti i dati da Reddit, processati in modo da fornire delle reti settimanali che catturavano le interazioni degli utenti in subreddit (comunità) politici e su cui venivano svolte varie analisi sociali.
//
// Finora, il lavoro presentava un limite strutturale: le interazioni che venivano catturate, non rappresentavano la direzionalità delle interazioni. Questo vuol dire che, se utente $a$ parlava con utente $b$, per il modello, $b$ parlava anche con utente $a$. Questo però, specie nelle interazioni online, non è sempre vero, perché un utente può commentare il post/commento di un altro utente ma senza ricevere risposte a sua volta.
//
// Matematicamente, la polarizzazione viene calcolata sfruttando la Node Vector Distance (NVD). (spiegare...) Per essere calcolata abbiamo bisogno della matrice Laplacian, che ha due proprietà principali che devono essere soddisfatte per poter essere usate nella NVD: è simmetrica e semi-definita. Nel caso di una rete simmetrica, il problema è banale perché avendo gli archi non direzionali, la matrice $L$ sarà sempre simmetrica. Non è così invece per le reti dirette, che sono le reti che vorremmo ottenere dalla fine di questo tiricinio.
//
// Grazie ad un operatore, chiamato Magnetic Laplacian (cit articolo),

#pagebreak()

= Modifiche apportate

#quote[Descrivere le attivita svolte, riportando attivita, tempi, strumenti utilizzati, risultati conseguiti, problemi affrontati e modalita di risoluzione. Potranno essere qui descritte le attivita anche dal punto di vista strettamente tecnico, approfondendo le scelte effettuate, le motivazioni, le alternative prese in considerazione, l’uso o il possibile uso dei risultati del lavoro.]\
//

- Tempi: ?
- Strumenti utilizzati:
  - NetworkX
  - pytorch
  - numpy
  - pandas(?)
  - magnetic Laplacian
- Risultati conseguiti
  - Mostrare toy examples
  - Mostrare polarization results
- Problemi affrontati
  - Prende più in considerazione la topologia rispetto all'opinione in sé
- Modalità di risoluzione
  - Parlare di come son stati risolti bla bla

#pagebreak()

= Presentazione dei risultati
#quote[La presentazione dei risultati dovrebbe consistere in una descrizione tecnica dei risultati raggiunti, unitamente ad un commento critico e ad un’analisi della rispondenza agli obiettivi iniziali (si consiglia per tanto di motivare la rilevanza dei risultati e l’eventuale scostamento dagli obiettivi iniziali). La sezione relativa ai risultati dovrebbe infine contenere una sintesi critica e un giudizio sull’esperienza effettuata, che renda conto di aspetti positivi e negativi per il tirocinante e per l’ente ospitante, del valore formativo, professionale e umano, e cosı via.]\
Parlare dei risultati (+ robe che mi mandera' Michele)

#pagebreak()

= Conclusioni e Sviluppi Futuri
Conclusioni bla bla...

#pagebreak()

#bibliography(
  ("./works.yaml", "./works.bib"),
  title: "Bibliografia",
  style: "american-physics-society",
)
