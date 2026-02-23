#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/subpar:0.2.2" as subpar: grid

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
  relatore: [Prof.ssa Elena CASIRAGHI],
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
  // depth: 2,
)
#pagebreak()

= Introduzione
#quote[Questa parte, da scrivere quando avrò finito la tesi...]

Qualcosa del tipo: in questa tesi vedremo etc... Nel primo capitolo ... etc.

== NERDS: Network, Data and Society
NERDS è il gruppo di ricerca presso il quale ho svolto il mio tirocinio. È un gruppo di ricerca interdisciplinare, che studia Network Science, Intelligenza Artificiale (AI) e Computational Social Science (CSS). Anche l'ambiente è interdisciplinare: ha studenti, PhD, PostDoc e professori con background in fisica, informatica, matematica e sociologia. Si trova a Copenhagen, all'interno della IT-Universitetet i København (ITU). Gli interessi di ricerca includono, tra gli altri: science of science, reti sociali, reti complesse, sostenibilità urbana, mobilità urbana e umana, visualizzazione di dati e aspetti fondamentali dei sistemi complessi.

== Computational Social Science
Le Scienze Sociali Computazionali (o Computational Social Science, CSS), sono una scienza che studia le scienze sociali classiche (sociologia, antropologia, economia e scienze politiche) mediante l'uso di strumenti odierni per esplorarle con approcci innovativi e su larga scala.\
La CSS utilizza due approcci principali: uno _empirico_, che fa leva su big data per generalizzare problemi e restituire analisi e inferenze utili per affrontare la ricerca, e uno _scientifico_, che permette di creare modelli e simulazioni di certi fenomeni. Inoltre, negli ultimi anni, grazie all'esplosione dell'intelligenza artificiale, strumenti come il Natural Language Processing (NLP) o i più recenti Large Language Model (LLM) hanno accelerato la ricerca, grazie alla loro capacità di annotare dati con accuratezza più alta rispetto a un umano non esperto; di conseguenza, è diventato possibile automatizzare tali task che altrimenti avrebbero richiesto un'elevata quantità di tempo #footnote[Annotare manualmente milioni di dati può compromettere la fattibilità di un progetto @Sylolypavan2023-ov.] o di denaro #footnote[Servizi come Amazon Mechanical Turk (https://www.mturk.com/) possono essere costosi per laboratori con fondi limitati.]. Nei capitoli successivi, porteremo un esempio concreto di annotazioni automatiche tramite modelli NLP prima e LLM dopo, che hanno avuto una grande utilità nel progetto per classificare la tossicità e l'opinione politica dei messaggi inviati dagli utenti. Mostreremo anche un test per misurare l'attendibilità dei modelli utilizzati.

In questa tesi useremo un approccio empirico della CSS; analizzeremo i dati di una rete sociale (Reddit) per stabilirne la polarizzazione politica. Nei capitoli successivi, introdurremo quindi il concetto di polarizzazione (a livello sociologico) e la Network Science, una scienza che studia le reti complesse.

== Obiettivi della tesi

Il lavoro iniziale fa un'analisi estesa sui subreddit (ovvero comunità, ne parleremo in dettaglio nel capitolo successivo) politici di Reddit, mostrando come sono cambiati negli anni, la distribuzione di democratici e repubblicani e come è cambiata l'opinione degli utenti nel tempo su sette argomenti (_aborto_, _cambiamenti climatici_, _identità di genere_, _controllo delle armi_, _sanità_, _razzismo_ e _immigrazione_), che sono diventati sempre più divisivi nel dibattito pubblico statunitense. Analizza anche le polarizzazioni ideologiche e affettive di questa rete sociale, fenomeni che hanno portato gli utenti di Reddit a interagire solamente con utenti con idee affini alle loro.
\ Questo studio è incentrato sul contesto statunitense, poiché più del 50% degli utenti che visita il sito ogni giorno è statunitense e abbiamo a disposizione una grande quantità di dati da analizzare.

Una rete è formata da un insieme di nodi, che rappresentano gli utenti, e un insieme di archi, che indicano che due utenti hanno avuto un'interazione significativa tra di loro.

Il limite del progetto iniziale era quello di rappresentare le reti come reti non dirette, perdendo quindi la direzionalità dell'informazione. Il mio lavoro si inserisce quindi in un'espansione del progetto iniziale, ovvero il supporto delle reti dirette e, successivamente, l'analisi dei nuovi risultati per verificare se sono, in primo luogo, attendibili e congruenti con quanto ci si aspetterebbe e, in secondo luogo, se possono essere utili per conoscere meglio la rete iniziale, dandoci informazioni che prima non avevamo.
\ Il mio lavoro si concentra maggiormente nel calcolo della polarizzazione, usando un nuovo metodo che consente di calcolare la matrice Laplaciana su reti dirette. In più, proveremo ad estendere il calcolo anche su reti con segno: l'euristica è che, se un messaggio supera una certa tossicità, allora l'interazione tra due utenti è considerata negativa, e quindi ha un punteggio diverso. Intuitivamente, ci aspettiamo che la polarizzazione ideologica aumenti.

In sintesi, vogliamo capire se ha senso aggiungere complessità supportando le reti dirette, oppure se con le reti non dirette riusciamo ad avere un'approssimazione che ci soddisfa.

Solitamente, nella Network Science, vengono preferite reti semplici, quindi non dirette, poiché è complicato adattare tutte le misure a reti dirette e, in alcuni casi, non è proprio possibile. L'obiettivo finale è aggiungere un tassello in più nel grande puzzle della generalizzazione e comprensione dei sistemi complessi.

#pagebreak()

= Stato dell'arte

== Social Network Analysis
La Social Network Analysis - analisi delle reti sociali - non è una vera e propria teoria, ma più una strategia generale per analizzare le strutture sociali. Nasce ben prima dell'informatica, nell'ambito della sociologia, con l'intento di studiare i comportamenti delle persone in base al contesto in cui si trovano. Le relazioni tra gli "attori" di una rete sono la priorità; nonostante ciò, le proprietà singole di un attore sono necessarie per analizzare fenomeni sociali.

Grazie alla diffusione su larga scala della tecnologia e alle crescenti prestazioni dei computer, la SNA ha trovato una sinergia con l'informatica. Attualmente, la SNA si concentra sullo studio delle reti sociali, quali Facebook, Twitter (X) e Reddit, tra i principali, data la grande mole di dati presenti.\
Le crescenti prestazioni dei computer hanno aiutato la SNA fornendo uno strumento matematico e pratico su cui effettuare le proprie analisi. Modellizzando le reti tramite la teoria dei grafi (presa dall'algebra), l'informatica ha fornito la possibilità di eseguire algoritmi complessi su reti grandi con migliaia o milioni di nodi, in relativamente poco tempo.

Un altro aspetto della SNA è lo studio di come le strutture sociali influenzano il comportamento di una persona. Vengono distinti due tipi di SNA: la ego network analysis, in cui si identifica un "_ego node_" in una rete e si studiano tutte le proprietà di quella rete ristrette ai nodi adiacenti, fino a un certo grado @coscia2021atlas; e la global network analysis, dove invece non si prende in considerazione un singolo nodo ma si cercano di studiare tutte le relazioni tra i partecipanti nella rete.

=== Polarizzazione

Per polarizzazione si intende la tendenza di un gruppo a prendere decisioni più divisive ed estreme rispetto alle singole opinioni iniziali dei membri. Si riferisce anche al fenomeno per il quale i membri di un gruppo rafforzano le loro opinioni dopo aver avuto una discussione su un determinato argomento.

È un fenomeno importante in psicologia sociale e viene ritrovato in molti contesti. Si inizia a parlare di polarizzazione negli anni '60, quando viene studiato il "risky-shift" @myers1976group, ovvero la tendenza di un gruppo a prendere decisioni più rischiose, rispetto alle stesse singole decisioni prese da ogni individuo di quel gruppo.\
Negli anni più recenti, invece, internet e i social media hanno portato un nuovo contesto dentro il quale studiare la polarizzazione. Ricercatori hanno dimostrato come, grazie alle reti sociali, possono esserci episodi di polarizzazione anche quando le persone non sono fisicamente vicine.

Ai fini della tesi e del tirocinio, andremo a parlare nello specifico di polarizzazione politica, un fenomeno nel quale le opinioni politiche di una persona - o di un partito - divergono dal centro, fino ad assumere posizioni estreme. Possiamo quindi dire che non vi è alcuna, o quasi, intersezione tra le posizioni dei partiti presi in considerazione. Gli accademici la distinguono in _ideological polarization_, ovvero le differenze tra le posizioni politiche, e _affective polarization_.

*Ideological Polarization*: si intende la differenza tra le posizioni politiche.

*Affective Polarization*: misura l'avversione di una persona nell'avere a che fare con persone di idee politiche differenti.

Inizialmente veniva misurata con delle survey @measure-affective-pol, dove le persone rispondevano a domande circa le attitudini verso i partiti opposti, ma anche riguardo ai comportamenti che metterebbero in atto nei confronti di persone di un partito opposto (sarebbero amici? sarebbero felici di averli come vicini di casa?). Al giorno d'oggi, è possibile misurare la _affective polarization_ anche analizzando le reti sociali @hohmann2025estimating che, a differenza dei sondaggi, misurano comportamenti compiuti su larga scala.

Più avanti nel capitolo, vedremo come quantificarle entrambe, grazie alla Node Vector Distance e alla Generalized Euclidean.

== Teoria dei Grafi

La teoria dei grafi è una branca della matematica e dell'informatica che modella situazioni o processi sotto forma di nodi (attori dell'evento) e di archi (interazioni tra i nodi).

Un grafo si dice diretto (anche chiamato _digraph_) quando gli archi che collegano i nodi hanno una direzione; altrimenti, viene detto indiretto.

Formalmente, definiamo un grafo: $ G = (V, E) $
dove:
- $V = {V_1, V_2, ...}$ è un insieme di nodi
- $E subset.eq {{x, y} | x, y in V and x eq.not y}$ è un insieme di archi non diretto, *oppure*
- $E subset.eq {{x, y} | (x, y) in V^2 and x eq.not y}$ è un insieme di archi diretto

Questi possono essere rappresentati, come struttura dati, con una lista delle adiacenze o una matrice delle adiacenze. La lista delle adiacenze associa a ogni nodo $i$ l'elenco di tutti i nodi $i'$ verso i quali esiste un arco. Richiede $Theta(V + E)$ spazio di memoria.

La matrice delle adiacenze $M$, invece, usa una matrice $N times N$, dove $N$ è il numero dei nodi: $ M = cases(
  M_(i j) = 0 arrow.double.r exists.not (i, j) in E,
  M_(i j) = w arrow.double.r exists (i, j) in E
) $

dove $w$ è il peso dell'arco $(i, j)$. Richiede $Theta (V^2)$ spazio di memoria.

I grafi vengono usati per modellare moltissime relazioni e processi in numerosi campi. Nell'informatica stessa, i grafi sono stati fondamentali per permetterci di sviluppare sistemi operativi multiutente e multiprocesso (nell'ambito della gestione delle risorse) e per espandere internet globalmente e senza sosta (routing dei pacchetti) #footnote[aggiungere citazioni].

=== Proprietà principali

Dati un grafo indiretto $G = (V, E)$ e un grafo diretto $G_1 = (V, E_1)$, essi riportano le seguenti proprietà:

+ *Grado*: Il grado di un nodo è il numero di archi incidenti a esso. Dato un nodo $x in V$, è definito come: $ deg(x) $ Nel caso dei digraph, si distinguono il $deg_(i n) (x)$ e il $deg_(o u t) (x)$, rispettivamente il numero di archi entranti e il numero di archi uscenti.

+ *Cammino*: Un cammino è una sequenza di nodi $v_1, v_2, ..., v_n$ tale che due nodi consecutivi nella sequenza, siano adiacenti: $ w = {v_1, v_2, ..., v_n } $

+ *Percorsi*: Un percorso è un cammino dove tutti i nodi nella sequenza, sono distinti: $ p_1 = { w_1, w_2 in w | w_1 eq.not w_2 } $

+ *Cicli*: Un ciclo è un percorso dove il nodo di partenza e di arrivo sono uguali:$ p_2 = { (i, e_1), (e_1, e_2), ..., (e_n, i) } $

+ *Cricca*: Una cricca è una partizione di un grafo $G$ tale che, per ogni coppia di nodi della partizione, esiste un arco che li collega. $ c = { i,j in V | (e_i, e_j) exists in E or (e_j, e_i) exists in E } $

+ *Componenti Connesse*: Una componente connessa di un grafo $G$ è un sottografo in cui qualunque coppia di nodi è connessa da un cammino e che non è parte di un sottografo connesso più grande.

+ *Distanza*: La distanza tra due nodi equivale al numero di archi in un cammino minimo che li connette.

+ *Diametro*: Il diametro di un grafo è anche detto _longest shortest path_, ovvero la massima distanza tra due nodi di un grafo.

+ *Alberi*: Un albero è un grafo indiretto dove ogni coppia di vertici è connessa da esattamente un percorso.

+ *Grafi Bipartiti*: Un grafo si dice bipartito se può essere diviso in due sottoinsiemi disgiunti $G'$ e $G''$, dove ogni arco di $G'$ connette i nodi di $G''$.

+ *Densità*: La densità in un grafo indica quanto questo è connesso. Se ogni nodo è connesso a tutti gli altri, avremo un grafo completo. Al contrario, un grafo con pochi archi rispetto ai nodi è detto sparso. Per un grafo indiretto, la densità viene definita: $ d = (2 * |E|)/(|V|(|V|-1)) $

== Network Science

La Network Science è una scienza che studia le reti complesse. È un campo multidisciplinare poiché affonda le sue radici nella _matematica_ (teoria dei grafi), nella _fisica_ (meccanica statistica), nella _statistica_ (inferenza statistica), nella _sociologia_ (strutture sociali) e nell'_informatica_ (data mining). Viene definita come #quote()[lo studio delle rappresentazioni di rete dei fenomeni fisici, biologici e sociali che portano alla creazione di modelli predittivi di tali fenomeni.] @nap11516

Moltissime situazioni complesse possono essere modellate come reti:

- *Social Networks*: nell'informatica, è uno degli esempi più ricorrenti. I social network sono letteralmente delle reti sociali, che modellano relazioni e interazioni tra persone. È immediato pensare alle persone come nodi di una rete e alle relazioni come archi. Instagram o Twitter sono esempi di rete diretta, poiché una persona $a$ può seguire un'altra persona $a'$, ma non è detto che $a'$ ricambi. Esiste quindi un arco diretto che parte da $a$ e arriva ad $a'$, ma non viceversa;
- *Citazioni negli articoli scientifici*: ogni volta che un articolo viene pubblicato, questo contiene $n$ citazioni verso altri articoli e si aggiunge alla rete di articoli già esistenti. Ogni articolo è quindi un nodo e una citazione è un arco che collega due nodi. Anche in questo caso, la rete è diretta;
- *Interazione Proteina-Proteina*: nella biologia, si parla di _interazione proteina-proteina_ quando due o più proteine interagiscono tra di loro per mezzo di reazioni biochimiche. Queste interazioni avvengono all'interno delle cellule di un organismo vivente. In questo contesto, i nodi sono le proteine e il risultato di una reazione porta alla creazione di un arco tra le proteine.

La Network Science è esplosa dopo la pubblicazione dell'articolo di Barabási-Albert "Emergence of Scaling in Random Networks" @Barabasi1999Emergence: le reti reali complesse di grandi dimensioni non si sviluppano in modo casuale (la probabilità che un nodo $a$ abbia un arco verso un nodo $a'$ non è approssimabile come casuale, come veniva ipotizzato nel modello _Erdős-Rényi_ @ErdosRenyi2022OnRandomGraphs), ma seguono una _power-law degree distribution_: è più probabile che nuovi nodi che entrano nella rete cerchino collegamenti con nodi che hanno già molti collegamenti. Questo fenomeno si chiama _preferential attachment_ (ad esempio, nel WWW, un nuovo sito avrà link verso siti più grandi e conosciuti). Di conseguenza, in una rete pochi nodi (detti anche _hub_) avranno un grado elevato e la maggior parte dei nodi avrà un grado basso.

La teoria dei grafi e la Network Science sono altamente interconnesse. Quest'ultima usa la teoria dei grafi per rappresentare le informazioni ed eseguire algoritmi sulle sue strutture dati. Tuttavia, per facilità di comprensione, nei prossimi paragrafi ci riferiremo in particolare a proprietà che tornano utili in Network Science.

=== Distribuzione di grado
La distribuzione del grado è la distribuzione delle probabilità dei gradi dei nodi nella rete. Data una rete di $n$ nodi, la probabilità che un nodo abbia grado $k$ equivale a: $ P(k) = (n_k)/n $

=== Matrice Laplaciana
La matrice Laplaciana $L$, anche detta Laplacian, è una matrice che rappresenta le informazioni topologiche di un grafo o di una rete. Dato un grafo indiretto $G = (V, E)$, da cui si ricava la matrice delle adiacenze $A_G$ e la matrice di grado $D_G$, la matrice Laplaciana $L_G$ si ottiene sottraendo la matrice di grado dalla matrice delle adiacenze: $ L_G = D_G - A_G $
$L_G$, di dimensioni $|V|times|V|$, è simmetrica e la somma di tutte le righe e colonne è uguale a $0$: $ sum_(i = 0 in |V|) L_(i j) = 0 $ e $ sum_(j = 0 in |V|) L_(j i) = 0 $
In un grafo diretto, invece, la matrice Laplacian utilizza l'indegree matrix oppure l'outdegree matrix, rispettivamente $D_(G_(i n))$ e $D_(G_(o u t))$. Pertanto, non è simmetrica e, di conseguenza, invalida le proprietà della Laplacian che vedremo nei prossimi paragrafi e che danno uno scopo alla misura. Quindi, solitamente, questa viene simmetrizzata oppure si tratta il grafo come un grafo indiretto.

Una matrice Laplaciana rispetta sempre le seguenti proprietà:
- È simmetrica: $L_(i j) = L_(j i)$;
- È positiva semidefinita, ovvero tutti gli autovalori $lambda_1, lambda_2, ... lambda_n >=0$;
- $lambda_0 = 0$;
- La somma di tutte le righe è $0$: $sum_(i = 0 in |V|) L_(i j) = 0$;
- La somma di tutte le colonne è $0$: $sum_(j = 0 in |V|) L_(j i) = 0$

La matrice Laplacian ha numerose applicazioni nella teoria dei grafi e nella network science. Lo studio dei suoi autovalori ed autovettori permette di svolgere la _spectral analysis_, che fornisce informazioni importanti sulla struttura della rete, o per la _community evaluation_. Permette di calcolare la _node distance vector_, ovvero la diffusione di una proprietà di un nodo all'interno della rete @node-distance-vector. Inoltre, trova moltissime applicazioni nella fisica, campo da cui è nata, per modellizzare matematicamente reti elettriche @doyle2000randomwalkselectricnetworks. Viene anche usata per trovare il numero di Spanning Tree in un grafo, in tempo polinomiale @kirchoff-theory.

Esistono diverse declinazioni della Laplacian, ognuna adattata a diversi usi. Ad esempio, c'è la laplaciana normalizzata, una matrice che normalizza il grado dei nodi, utile quando c'è una disuguaglianza marcata nel grado dei nodi, come nel caso delle scale-free network. Esiste poi la matrice Laplacian costruita tramite la matrice delle incidenze (una matrice che codifica le relazioni tra i nodi e gli archi), usata per reti con archi pesati. Infine, abbiamo la _magnetic laplacian_, una matrice che rappresenta un grafo diretto, trattando le direzioni degli archi come una fase in un piano complesso. La approfondiremo nei capitoli successivi, poiché parte centrale del progetto di tesi.

=== Null Model
Il _null model_ è un modello di rete che viene usato come benchmark rispetto a una rete reale. Viene generato casualmente partendo da alcune proprietà di una rete reale (ad es. la densità, la distribuzione di grado, l'assortatività, ...). Viene usato per attribuire uno specifico comportamento di una rete a un ristretto gruppo di proprietà, generando casualmente delle reti che hanno quelle singole proprietà. Inoltre, può essere usato per trovare correlazioni tra proprietà su reti particolari: se data una rete reale con proprietà $X$ (es. average degree = 4), accade $Y$ (es. l'omofilia cresce), allora verranno generate delle reti randomiche con proprietà $X$ (average degree = 4) per verificare la presenza di $Y$.

Un null model può essere randomico o generativo @Váša2022. Il modello randomico è il più comune: solitamente si ottiene tramite il metodo di rewiring, dove, dato un insieme di archi, questi vengono riscritti casualmente preservando il grado di ogni nodo. In @rewiring-null-model è riportato un esempio. Invece, con l'approccio generativo, date delle ipotesi nulle che devono essere raggiunte, si preleva una partizione della rete iniziale e si aggiungono nuovi nodi e archi finché non si raggiungono le ipotesi nulle definite inizialmente.

#figure(
  diagram(
    node-stroke: .1em,
    spacing: 3em,
    node((0, 0), `A`, radius: 1em),
    edge(``, "-", stroke: 0.1em),
    node((1, 0), `B`, radius: 1em),
    node((2, 0), `C`, radius: 1em),
    edge(``, "-", stroke: 0.1em),
    node((3, 0), `D`, radius: 1em),
    // -----------------------
    node((0, 1), `A`, radius: 1em),
    edge(``, "-", stroke: 0.1em),
    node((1, 1), `C`, radius: 1em),
    node((2, 1), `B`, radius: 1em),
    edge(``, "-", stroke: 0.1em),
    node((3, 1), `D`, radius: 1em),
  ),
  caption: [Sopra: prima del rewiring. Sotto: dopo il rewiring],
) <rewiring-null-model>

=== Backboning
Le reti reali sono piene di rumore, ovvero di archi e nodi che non hanno significatività statistica e che possono inquinare i risultati. Occorre, quindi, usare un metodo per rimuovere il rumore dalla rete e lasciare solamente gli elementi significativi. Questa tecnica si chiama _backboning_. Esso nasce con la necessità di mantenere solamente le strutture e le gerarchie rilevanti in una rete, così che sia più facile analizzarle e anche più computazionalmente economico.

Con il backboning si mantiene un focus globale, per evidenziare le _highways_ di una rete, ovvero quei cammini che sono importanti per far circolare l'informazione. Il backboning ha una funzione analoga alla _Principal Component Analysis_ in statistica.

Esistono vari algoritmi di backboning, in base ai fenomeni che si vogliono evidenziare e successivamente analizzare. Alcuni algoritmi consistono in: trovare il _minimum spanning tree_ @backbone-tree-filter, usare un _disparity filter_ @backbone-tree-filter, ricavare il _salience skeleton_ @Grady2012 o il metodo di _noise correction_ @noise-corrected-backboning. In questa tesi approfondiremo solamente l'ultimo metodo, poiché utilizzato in questo progetto.

L'algoritmo Noise-Correction (NC) @noise-corrected-backboning si basa sull'assunzione che ogni arco sia un'interazione tra i nodi. Se un arco vuole essere mantenuto, deve raggiungere o superare una certa soglia di significatività statistica.

Dato un grafo $G=(V, E, N)$, dove $V$ è l'insieme dei nodi, $E$ è l'insieme degli archi e $N$ è l'insieme dei pesi e $N subset.eq RR$, con $N_(i .) = sum_(i in E) N_(i j)$ e $N_(. j) = sum_(i in E) N_(i j)$ e quindi $N_(. .) = sum_(i, j in E) N_(i j)$, l'algoritmo di _Noise-Correction_ definisce una misura chiamata _lift_ $L_(i j)$, che rappresenta quanto il peso di un arco devia dal valore atteso di un null model randomico: $ L_(i j) = hat(N)_i / (E[N]_(i j)) $con $E[N_(i j)]$ il peso atteso per una coppia di nodi $(i, j)$: $ E[N_(i j)] = hat(N)_(i \.) (hat(N)_(\. j))/(hat(N)_(. .)) $
$L_(i j)$ misura quanto il peso di un arco, tra i nodi $i$ e $j$ sia alto rispetto al valore atteso: $ L_(i j) = cases(
  = 1 arrow.double.r "peso equivalente a quanto atteso",
  > 1 arrow.double.r "peso maggiore a quanto atteso",
  > 0 and < 1 arrow.double.r "peso minore a quanto atteso"
) $
quindi, viene successivamente centrato in $0$, che chiameremo $tilde(L)_(i j)$.

Successivamente, viene calcolata la varianza con il metodo delta, dei valori ottenuti in precedenza: $ v a r[tilde(L)_(i j)] = v a r[hat(N)_(i j)] ((2(kappa + hat(N)_(i j) (d kappa)/(d hat(N)_(i j))))/(k hat(N)_(i j) + 1 )^2) $dove $v a r[hat(N)_(i j)]$ è la varianza di una distribuzione Binomiale: $ v a r [N_(i j)] = N_(. .)hat(P)_(i j) (1 - hat(P)_(i j)) $
e $kappa$: $ kappa = 1/(E[N_(i j)]) $ e: $ (d kappa)/(d hat(N)_(i j)) = 1/(hat(N)_(i .)hat(N)_(. j)) - hat(N)_(. .) (hat(N)_(i .) + hat(N)_(. j))/((hat(N)_(i .) hat(N)_(. j))^2) $

dato che le reti reali sono sparse ed è difficile stimare con precisione $hat(P)_(i j)$, si assume che $hat(P)_(i j)$ usi un framework bayesiano che segue una distribuzione Beta: $[n_(i j) + alpha, n_(. .) - n_(i j) + beta]$. Dato che anche $alpha$ e $beta$ sono sconosciuti, si assume che la generazione dei pesi degli archi assuma una distribuzione ipergeometrica, in cui ogni volta che il peso di un arco incrementa di $1$ per il nodo $n$, allora si estrae e rimuove un nodo $j$ dall'insieme dei nodi (distribuiti secondo il peso $N_(i .)$ e $N_(. j)$ di ogni nodo). Così, la media $mu$ e la varianza $sigma^2$ sono definite, rispettivamente: $ E[p_(i j)] = E[N_(i j)/N_(. .)] = 1/(N_(. .))(N_(i .)N_(. j))/(N_(. .)) = mu = alpha/(alpha + beta) $ e $ v a r[p_(i j)] = 1/(N^2_(. .))(N_(i .)N_(. j)(N_(. .) - N_(i .))(N_(. .) - N_(. j)))/(N^2_(. .)(N_(. .) - 1)) = sigma^2 = (alpha beta)/((alpha + beta)^2)(alpha + beta + 1) $
che così possono essere risolte in $alpha$ e $beta$. Che permette di ricavare $V[hat(N)_(i j)]$ e, quindi, la varianza $V[tilde(L)_(i j)]$.

Infine, un arco sarà mantenuto solo se il peso è maggiore di $delta sqrt(V[tilde(L)_(i j)])$, ovvero se supera $delta$-volte la deviazione standard. Dove $delta$ è un parametro di threshold che viene passato all'algoritmo. Per maggiori informazioni, rimando al paper originale @noise-corrected-backboning.

L'algoritmo di NC, favorisce il mantenimento di connessioni tra nodi non centrali, ma sullo stesso livello di gerarchia @coscia2021atlas.

=== Spectral Analysis
La Spectral Analysis è lo studio degli autovalori ed autovettori della matrice Laplaciana di un grafo. Data una Laplacian $L$, definiamo gli autovalori $lambda$: $ lambda in sigma(L) quad sigma(L) = {lambda | det(L - lambda I) = 0} $ e gli autovettori $v$: $ v in ker(L - lambda I), quad v eq.not 0 $
Come definito sopra, il primo autovalore $lambda_0$ in una Laplacian è sempre uguale a $0$. Gli altri autovalori, invece, sono monotoni crescenti: $ 0 = lambda_0 <= lambda_1 <= ... <= lambda_n $

La spectral analysis è importante perché fornisce informazioni rilevanti sulla struttura del grafo. Può essere utilizzata per la risoluzione del graph coloring problem #footnote[aggiungere fonte ] o per effettuare una low-rank approximation (approssimazione della matrice delle adiacenze ad una matrice di rango inferiore) #footnote[aggiungere fonte ]. Inoltre, il secondo e il terzo autovettore, $v_2$ e $v_3$, vengono usati per la visualizzazione di grafi con un layout semplificato e più piacevole all'occhio umano (anche $v_4$ per la visualizzazione in tre dimensioni), come dimostrato da Hall @hall-quadratic-placement.

Uno dei suoi usi più comuni risiede nello studio del secondo autovalore $lambda_2$, ovvero il Fiedler Value, chiamato anche _connettività algebrica_.\
$lambda_2$ ha anche molte altre utilità (pag 16 del paper)

Gli autovalori e autovettori, hanno le seguenti proprietà:

+ Il vettore di tutti 1 è sempre un autovettore del primo autovalore $lambda_0$ di $L$, di valore 0;
+ L'autovalore più grande della matrice delle adiacenze è sempre compreso tra il grado medio e il grado massimo di un nodo in un grafo $G$; #footnote[aggiungere fonte /* see [9] or [10, Section 3.2] */].
+ Se $G$ è connesso, allora $lambda_1$ > $lambda_2$ e l'autovettore $v_1$ sarà positivo; #footnote[aggiungere fonte /* see [11] */].
+ La molteplicità di 0 come autovalore di $L_G$ è uguale al numero di componenti connesse di $L_G$.
+ L'autovalore maggiore di $L$ è al massimo il doppio del grado massimo in $G$;
+ $lambda_n$ = $-lambda_1$ se e solo se $G$ è un grafo bipartito #footnote[aggiungere fonte /* see [12], or [10, Theorem 3.4] */].

=== Community Discovery
Studiando una rete, è frequente che si voglia analizzare se un gruppo di nodi forma una community. Ovvero, se questi possono essere raggruppati e suddivisi in base ad una proprietà in comune. Nella nostra società, le community sono ovunque: persone che appartengono alla stessa città, allo stesso gruppo di amici o che hanno lo stesso attore preferito. Chi vive in una determinata città, sicuramente avrà molte interazioni con persone che vivono nella sua stessa città. Al contrario, ne avrà poche o nulle con chi vive in città differenti. Il ragionamento è il medesimo per le reti e la Network Science. Formalmente, una community si dice tale quando c'è una densità molto alta tra i nodi della community ed interazioni sparse con i nodi al di fuori di essa.

Lo studio e la valutazione delle community in una rete vengono detti _community discovery_. Questa pratica ha svariati casi d'uso. Ad esempio, per il _backboning_, dove si possono individuare i nodi simili tra loro e rimuoverli, lasciando solo un nodo "rappresentante", al fine di semplificare la rete, oppure per raggruppare e classificare i nodi in cluster specifici, per testare il loro comportamento al cambio di determinate condizioni della rete (ad esempio nel campo dell'advertising e del marketing).

La community discovery è un campo molto vasto: esistono svariati modi per raggruppare i nodi in comunità e nuovi metodi vengono continuamente studiati. Infatti, non esiste il metodo definitivo; tutto dipende dall'obiettivo che si vuole raggiungere. Generalmente, si dà importanza alle performance del metodo di community detection e alla sua attendibilità, misurata con la somiglianza rispetto agli altri algoritmi.

Il primo metodo trovato per effettuare community discovery è chiamato Stochastic Block Model (SBM), con la massimizzazione della _likelihood function_. Dato un SBM, ovvero un modello di generazione di grafi randomici che contiene comunità, generato con due parametri $p_(i n)$ e $p_(o u t)$, che rispettivamente sono la probabilità che un nodo interagisca con un nodo all'interno della comunità e che un nodo si connetta con un nodo all'esterno della comunità (generalmente, $p_(i n) > p_(o u t)$), si inizializzano i due parametri agli stessi valori della rete iniziale. Successivamente, si definisce la _likelihood function_: $ L_(Theta, A) = sum_(u, v in A) l_theta, A, u, v $ dove
$
  l_(theta,A, u, v) = cases(
    θ_1 - 1 arrow.double.r A_(u v) = 1 & (u, v) ∈ theta_3,
    θ_2 - 1 arrow.double.r A_(u v) = 1 & (u, v) ∉ theta_3,
    -θ_1 arrow.double.r A_(u v) = 0 & (u, v) ∈ theta_3,
    -θ_2 arrow.double.r A_(u v) = 0 & (u, v) ∉ theta_3,
  )
$
Si cerca di massimizzare la funzione, in modo tale che: $ hat(theta) = arg_(theta in Theta)max L_(theta, A) $

Infine, se, dato un SBM, $p_(o u t) > p_(i n)$, allora si possono trovare tutte le community disassortative, ovvero di nodi che legano solo con nodi che _non_ sono nella loro comunità.

Questo metodo è l'equivalente del metodo di modularity optimization @Newman_2016, di cui parleremo più avanti.

Un altro dei metodi più comuni per trovare le comunità in una rete, è quello di usare la _random walk_, ovvero partendo da un nodo casuale, esplorare casualmente uno dei suoi vicini, e così via, iterando $n$ volte. L'idea alla base è che quando con una random walk si entra in una community, allora vi rimarrà per molto tempo, dato l'elevato numero di archi all'interno della community. Al contrario, la probabilità che arrivi ad un nodo di confine e che questo poi entri in un'altra comunità, è molto bassa. Pertanto, utilizzare la tecnica delle random walk non è il metodo più efficiente. Ci riesce meglio, però, il metodo Infomap, che ha l'obiettivo di minimizzare la map equation @Rosvall2009, ovvero una codifica di una _random walk_.

Inizialmente, l'algoritmo simula una normale random walk per calcolare le frequenze di visita dei nodi. Ogni volta che esplora un nodo, gli assegna una sequenza di bit codificata con la codifica di Huffman @itwiki:147328281. Al fine di risparmiare memoria e riutilizzare gli id, in modo analogo alle vie che si ripetono in diverse città, inizia a raggruppare i nodi vicini tra loro sotto una stessa community, alla quale assegna un codice di un numero crescente di bit. In questo modo, nella codifica, quando la random walk entra in una nuova community, lo segnala scrivendo inizialmente il numero della community e successivamente il numero di ogni nodo. Quando arriva a un nodo di confine e si sposta in una nuova community, usa la codifica `1111`, che segnala il salto in una nuova community. Questo aggiunge un po' di overhead, perché in ogni community ci sono almeno 5 bit in più, ma il breakeven point si raggiunge velocemente. Il processo viene iterato molteplici volte, finché non si ottiene la lunghezza minima della codifica della random walk. Data la natura casuale delle random walk, è un algoritmo non deterministico.

Un ulteriore metodo di community detection è la _label percolation_ (o _label convergence_): partendo da un sottoinsieme di nodi a cui sono assegnate casualmente delle label, queste vengono propagate a tutti i nodi rimanenti, fino a ottenere tutti i nodi etichettati. Anche questo è un algoritmo non deterministico.

Inizialmente, a ogni nodo viene assegnata una label casuale. Successivamente, in modo iterativo, ogni nodo esplora le label dei suoi vicini e si autoassegna la label più frequente; in caso di pareggio, ne sceglie una casualmente tra le più frequenti. Si continua finché non si arriva a una convergenza in cui ogni nodo ha la stessa label della maggioranza dei suoi vicini.\ L'aspetto positivo di questo algoritmo è che è molto semplice da implementare e converge velocemente.

In più, data la natura non deterministica, multiple iterazioni dello stesso algoritmo, evidenziano diverse community structures, che possono essere aggregate tramite l'indice di similarità di Jaccard @Raghavan_2007.

Infine, la community detection può avvenire sia su reti statiche (_snapshots_ ad un determinato punto nel tempo), sia su reti dinamiche, in cui assumiamo che la rete si modifichi, si aggiungano nodi, si rimuovano archi e, di conseguenza, si modifichino le community.

Un metodo naïf di valutazione delle community nelle reti dinamiche è quello di assumere che ogni snapshot sia indipendente nel tempo e cercare indipendentemente su ogni snapshot le community. La letteratura scientifica, però, ci dice che i risultati possono essere molto diversi. Si può quindi ricorrere a una tecnica chiamata _evolutionary clustering_ @evolutionary-clustering.

Con l'evolutionary clustering, si cerca di bilanciare due obiettivi: massimizzare la qualità dello snapshot al tempo $t$, che riflette i cambiamenti più recenti, e minimizzare l'_history cost_, ovvero la distanza tra il clustering al tempo $t$ e quello al tempo $t-1$.

L'algoritmo usa un indice di similarità o una matrice delle distanze dei vari timestamps $T$, costruiti nel tempo, definita come $M_t$. Ad ogni timestamp, l'algoritmo cerca di ottimizzare la qualità dello snapshot: $ s q(C_t, M_t) - alpha dot h c (C_(t-1), C_t) $ dove $C_t$ è il clustering calcolato al tempo $t$. $s q$ è una funzione che valuta la qualità dello snapshot, $h c$ è la funzione di history cost e $alpha$ è un parametro di trade-off che stabilisce quanta importanza dare alle configurazioni passate degli snapshot.

=== Modularità
La modularità è una misura che valuta la qualità di una _community evaluation_ in una rete. Un alto grado di modularità significa che ci sarà un'alta densità tra i nodi nella stessa community e una densità minore tra un nodo in una community e uno al di fuori della comunità. Rappresenta la densità interna delle community. Ha anche lo scopo di ottimizzare la funzione di suddivisione in community, con l'obiettivo di massimizzare la modularità. Data $A$ la matrice delle adiacenze e $delta$ la funzione delta di Kronecker, che restituisce $1$ se i nodi sono nella stessa community e 0 altrimenti, la modularità è definita da: $ M = 1/(2|E|) sum_(i,j in V) \[A_(i j) - (deg(i) deg(j))/(2|E|) \] delta (c_i, c_j) $

Il dominio della modularità è definito in $[-0.5, +1]$: più il valore è basso, più c'è disassortatività nella rete. Al contrario, se tende a $+1$, la divisione delle community è ottimale. Se la modularità è uguale a 0, allora il grafo non ha alcuna struttura di community.

=== Altre proprietà

+ *Omofilia ed Eterofilia*: L'omofilia è una proprietà qualitativa che esprime quanto i nodi in una rete tendono a essere vicini tra loro quando esprimono feature simili. È uno dei fondamenti della community discovery, perché si parte dall'assunzione sociologica per cui le persone tendono a relazionarsi con persone simili (stesso genere, età simile, stesse passioni o interessi) e viene riutilizzata nello studio delle reti perché si assume che nodi con feature simili tendano a essere connessi. Questo accade sia per motivi comportamentali (l'utente in un social network ricerca solo persone o pagine che rispettano i propri interessi), sia per motivi ambientali (l'algoritmo di un social network mostra maggiormente all'utente post che potrebbero interessargli). L'eterofilia, invece, è l'esatto opposto.

+ *Assortatività e Disassortatività*: L'assortatività è una misura quantitativa per rappresentare l'omofilia. Al contrario, la disassortatività rappresenta quantitativamente l'eterofilia. L'intuizione dell'assortatività è quella di prendere feature numeriche e, data una connessione tra due nodi, stimarne la similarità (es. due nodi con valori 1 e 5 sono più simili rispetto a due nodi con valori 1 e 5000). La proprietà più comune è il grado di due nodi, in cui si assume che due nodi con grado molto alto si leghino tra loro. Ad esempio, nei social network, è più probabile che una celebrità si connetta a un'altra.

+ *Coefficiente di Clustering*: È una proprietà che misura quanto, in una rete, i nodi tendono a essere connessi tra di loro. Soprattutto nelle reti sociali, i nodi tendono ad avere un'alta densità di collegamenti. È una misura locale o globale. A livello locale, misura quanto è probabile che i vicini di un nodo tendono a formare una cricca. Dato $N$ l'insieme dei vicini di $i$ e $k_i = |N|$: $ C C_i = (|{ e_(j k) : v_j, v_k in N, e_(k j) in E }|)/(k_v\(k_v-1\)) $\ A livello globale, invece, ci si basa su triple di nodi (triangoli o triadi). Il coefficiente globale di clustering rappresenta quanti triangoli chiusi ci sono, rispetto a tutte le triadi in una rete: $ C C = (\# "triangles")/(\# "triads") $

=== Node Vector Distance
Trovare la distanza tra due nodi è un problema che in letteratura scientifica è stato abbondantemente studiato #footnote[aggiungere citazioni a paper su djikstra, bellman-ford, etc]. Grazie ad esso, la teoria dei grafi si è potuta estendere alle reti come le intendiamo comunemente, ovvero un insieme di computer collegati tra loro e che possono comunicare. Questo ha dato spazio ad internet, che ci permette di scambiare dati con computer che si trovano dall'altra parte del mondo rispetto a noi. Però, tengono conto solamente di un aspetto, ovvero di portare un dato in un nodo $i$ ad un nodo $j$. In modo binario, un dato può trovarsi in un nodo oppure in un altro, o in un qualsiasi nodo intermedio, ma non può diffondersi in modo "continuo", con una parte di informazione presente simultaneamente in più nodi, né partire da più nodi contemporaneamente.\
Tuttavia, molte situazioni del mondo reale possono essere modellate in questo modo, come la _diffusione di un virus_, la _qualità di una campagna di marketing virale_ o la _polarizzazione in un social network_, fenomeni che in ogni caso partono da uno o più nodi e si diffondono verso i nodi vicini.

L'intuizione dietro la _Node Vector Distance_ (NVD) deriva dal misurare, data una rete e due tempi $t_1$ e $t_2$, la diffusione di una proprietà di un nodo nel tempo.

Formalmente @coscia2020node, data una rete non diretta $G = (V, E)$, dove $V$ è l'insieme dei nodi ed $E$ è l'insieme degli archi, definiamo la proprietà $A$ in ogni nodo della rete, con un vettore $A$ di lunghezza $|V|$ e dominio in $[0, 1]$. Assumendo per semplicità che tra $t_1$ e $t_2$ la rete non cambi, la NVD misura la distanza percorsa e la diffusione della proprietà $A$ nel tempo, come in @nvd-diffusion-a e in @nvd-diffusion-b.

#grid(
  figure(
    diagram(
      node-stroke: .1em,
      spacing: 3em,
      node((0, 0), `1`, radius: 1em, fill: red),
      edge(``, "-"),
      node((1, 0), `2`, radius: 1em),
      edge(``, "-"),
      node((2, 0), `3`, radius: 1em),
    ),
    caption: [ $A_(t 1) = [1, 0, 0]$ ],
  ),
  <nvd-diffusion-a>,

  figure(
    diagram(
      node-stroke: .1em,
      spacing: 3em,
      node((0, 0), `1`, radius: 1em, fill: red.lighten(90%)),
      edge(``, "-"),
      node((1, 0), `2`, radius: 1em, fill: red.lighten(75%)),
      edge(``, "-"),
      node((2, 0), `3`, radius: 1em, fill: red.lighten(35%)),
    ),
    caption: [ $A_(t 2) = [0.1, 0.25, 0.65]$ ],
  ),
  <nvd-diffusion-b>,

  columns: (1fr, 1fr),
)

Esistono tre classi di soluzioni per la NVD @coscia2020node: _Generalized Euclidean_, _Shortest Path_ e _Spectral_. Ci concentreremo solo sulla prima, la _Generalized Euclidean_, in quanto quella usata durante il tirocinio.

La _Generalized Euclidean_ (GE) misura le distanze in una rete nello stesso modo in cui misurerebbe le distanze in un piano Euclideo multidimensionale. È data da: $ delta_(A_(t 1), A_(t 2)) = sqrt((A_(t 1) - A_(t 2))^T L^+(A_(t 1) - A_(t 2))) $
dove $L^+$ è la matrice Laplaciana pseudo-inversa di Moore-Penrose (non è invertibile perché è una matrice singolare), e $(A_(t 1) - A_(t 2))^T$ è la matrice trasposta della differenza della  proprietà $A$ nei tempi presi in considerazione.

== Magnetic Laplacian

https://www.perplexity.ai/search/help-me-in-understanding-this-xt4PbK9lTy2jKX66DQ5ZBw
```py
  def magnetic_laplacian(tensor, theta = np.pi / 2):
      num_nodes = tensor.edge_index.max() + 1 if tensor.edge_index.min() == 0 else tensor.edge_index.max()
      phase = torch.exp(1j * torch.as_tensor(theta, dtype = torch.cfloat)).to(device)

      H = torch.zeros(num_nodes, num_nodes, dtype = torch.cfloat).to(device)
      H[tensor.edge_index[0], tensor.edge_index[1]] = tensor.edge_attr[:,0] * phase

      H = H + H.conj().T
      H = H / 2

      D = torch.diag(torch.abs(H).sum(dim = 1))

      return D - H
```
vecchia (magari in pseudocodice, una implementazione che però abbia lo stesso stile di quella di sopra. quindi, che non chiami semplicemnete una libreria esterna):
```py
  def laplacian(tensor):
      L_ei, Lew = torch_geometric.utils.get_laplacian(tensor.edge_index, edge_weight = tensor.edge_attr[:,0])
      L = torch_geometric.utils.to_dense_adj(edge_index = L_ei, edge_attr = Lew)[0]
      return L
```

#pagebreak()

= Strumenti di Sviluppo e Dataset

== Python
Python @van1995python è un linguaggio di programmazione interpretato, orientato agli oggetti, di alto livello con semantica dinamica. Le sue strutture dati integrate di alto livello, combinate con la tipizzazione dinamica e il binding dinamico, lo rendono molto interessante per lo sviluppo rapido di applicazioni, nonché per l'uso come linguaggio di scripting o di collegamento per connettere tra loro componenti esistenti. La sintassi semplice e facile da imparare di Python enfatizza la leggibilità e quindi riduce i costi di manutenzione dei programmi.

Python supporta moduli e pacchetti, che incoraggiano la modularità dei programmi e il riutilizzo del codice. L'interprete Python e l'ampia libreria standard sono disponibili in formato sorgente o binario gratuitamente per tutte le principali piattaforme e possono essere distribuiti liberamente.

Python, grazie alla sua estesa fornitura di librerie e alla sua rapida curva di apprendimento, è il linguaggio più usato nel contesto di Data Science ed è stato usato per la scrittura del codice il cui prodotto si trova più avanti in questa tesi.

== Librerie
=== NetworkX
NetworkX @SciPyProceedings_11 è una libreria Python per la creazione, la manipolazione e lo studio della struttura, delle dinamiche e delle funzioni di reti e grafi. Fornisce strumenti per lo studio della struttura e delle dinamiche delle reti sociali, biologiche e infrastrutturali, un'interfaccia di programmazione standard e un'implementazione grafica adatta a molte applicazioni, un ambiente di sviluppo rapido per progetti collaborativi e multidisciplinari.

Supporta l'accelerazione degli algoritmi e funzionalità aggiuntive tramite backend di terze parti e offre un'interfaccia per algoritmi numerici esistenti e codice scritto in C, C++ e FORTRAN. Con NetworkX è possibile caricare e memorizzare reti in formati di dati standard e non standard, generare molti tipi di reti casuali e classiche, analizzare la struttura delle reti, costruire modelli di rete, progettare nuovi algoritmi di rete e visualizzare reti. È rilasciato con licenza BSD ed è ampiamente utilizzato nella comunità scientifica per la Network Science.

=== NumPy
NumPy @harris2020array è una libreria Python fondamentale per il calcolo scientifico, nata per supportare operazioni e funzioni complesse su matrici ed array multidimensionali. Rilasciata con licenza BSD modificata, fornisce API di alto livello per strutture dati complesse e moltissime funzioni matematiche eseguibili in modo efficiente.

Il tipo di dato principale è l'array N-dimensionale (`ndarray`), che permette di eseguire operazioni vettorizzate ad alte prestazioni. NumPy include funzioni per l'algebra lineare, la trasformata di Fourier, la generazione di numeri casuali e molte altre operazioni matematiche. Grazie alla sua implementazione in C, offre prestazioni elevate rispetto al Python puro. È alla base di molte altre librerie scientifiche Python, come SciPy, Pandas e Matplotlib, costituendo un elemento fondamentale dell'ecosistema di Data Science. La sua sintassi intuitiva e le prestazioni elevate lo rendono indispensabile per l'analisi numerica e il calcolo matriciale.

=== PyTorch
PyTorch @Ansel_PyTorch_2_Faster_2024 è una libreria Python per il Machine Learning e il Deep Learning, che fornisce API ad alto livello per costruire e addestrare reti neurali. Creato originariamente da Meta e ora parte della Linux Foundation, è open source e rilasciato con licenza BSD modificata.

Il tipo di dato fondamentale è il tensore, un array multidimensionale omogeneo simile agli array NumPy ma con funzionalità avanzate. PyTorch si distingue per il supporto nativo ai CUDA, permettendo l'accelerazione tramite GPU NVIDIA in modo trasparente. Offre un approccio di definizione dinamica dei grafi computazionali (_eager execution_), che rende il debugging più intuitivo rispetto ad altri framework. Include moduli per la costruzione di reti neurali (`torch.nn`), ottimizzatori (`torch.optim`), gestione dei dati (`torch.utils.data`) e operazioni di autograd per il calcolo automatico dei gradienti. È ampiamente utilizzato nella ricerca e nell'industria per applicazioni di computer vision, natural language processing e reinforcement learning.

=== Pandas
Pandas @The_pandas_development_team_pandas-dev_pandas_Pandas è una libreria Python open source per l'analisi e la manipolazione dei dati. Offre strutture dati ad alto livello orientate all'analisi, alla trasformazione e alla visualizzazione di dataset strutturati.

Le sue strutture dati principali sono le Series, array monodimensionali con indice associato, e i DataFrame, strutture bidimensionali simili a tabelle con righe e colonne etichettate. Sebbene internamente si basino su array NumPy, supportano anche dati non numerici come date, stringhe e categorie. Pandas fornisce funzionalità potenti per il caricamento di dati da vari formati (CSV, Excel, SQL, JSON), la pulizia dei dati (gestione valori mancanti, duplicati), operazioni di raggruppamento e aggregazione (`groupby`), join e merge tra dataset, e conversioni di tipo. La sua API intuitiva e le prestazioni elevate lo rendono uno strumento fondamentale per il data wrangling e l'analisi esplorativa dei dati nel campo della Data Science.

== Reddit
Reddit è un social network dove gli utenti possono pubblicare contenuti sotto forma di link, testo, immagini o video, e dove altri utenti possono commentare. È suddiviso in comunità chiamate subreddit, precedute dalla radice `r/` (come `r/politics` o `r/python`), che possono essere generaliste o monotematiche. Con oltre 100.000 subreddit attivi, viene definito un aggregatore di comunità.

Il sistema di raccomandazione funziona tramite upvotes e downvotes, giudizi che gli utenti registrati possono dare ai post e commenti per influenzarne la visibilità. Gli upvotes aumentano la probabilità che un contenuto sia mostrato, mentre i downvotes la riducono. Questo meccanismo determina l'ordinamento dei contenuti nelle homepage e nelle singole community.

A dicembre 2025, Reddit si posiziona nella top 10 dei siti più visitati al mondo ed è il quarto social media più usato @ViewWeb.

Per la realizzazione delle reti, viene scaricato un dump di tutti i dati pubblici di Reddit, dalla sua creazione fino al 2025 @redditSubmissions.

#pagebreak()

= Panoramica del Progetto
In questo capitolo spiegheremo il punto di partenza del progetto, descrivendone le caratteristiche, le librerie usate, le fasi per la creazione della rete e i limiti.

== Punto di Partenza
Il progetto analizza i subreddit politici nel tempo, dalla sua fondazione fino ad oggi. Analizza come le interazioni tra gli utenti siano cambiate, in quantità e qualità, come tossicità, differenza di opinioni e omofilia della rete. Si parte scaricando un dump di tutti i post di Reddit negli anni, costruendo una rete che catturi quante più interazioni possibili (i paragrafi successivi approfondiranno queste fasi nel dettaglio), per poi iniziare con le analisi vere e proprie.

Viene creata una rete diversa per ogni settimana, per visualizzarne ed analizzarne l'evoluzione nel tempo. L'assunzione alla base è che, se due nodi sono collegati da un arco, allora c'è stata un'interazione significativa tra i due utenti, nella settimana di riferimento.

== Strumenti Utilizzati
=== NetworkX
per la generazione di toy examples e per eseguire alcune operazioni sui grafi, come trovare gli lcc. nonostante non sia velocissima come libreria, è utile perché fornisce utility già pronte all'uso per maneggiare con le reti. inoltre, ha implementazioni già fatte di modelli di reti reali, che utilizzeremo nei toy examples.
=== PyTorch
usato per via dei tensori. prima di salvarli in csv, tutti i dati sono salvati come tensori. (spiegarne i vantaggi) also durante la pseudoinversione della laplacian.
=== NumPy
usati di meno, in situazioni in cui serviva usare array e operazioni con gli array
=== Pandas
usato solamente in fase finale, quando si volevano rappresentare dati per il debugging. date le sue utility già pronte e le sue API pratiche, è molto semplice eseguire operazioni di statistica di base e aggregazione dei risultati. infatti, dopo aver calcolato la polarizzazione, la mettevamo su un dataframe
== Procedura di Costruzione della Rete
È possibile suddividere questa sezione in 6 fasi:

+ *Data Filtering*: Partendo da un file `.csv` per ogni mese, si itera attraverso tutti i post e commenti, filtrando via tutti i post, poiché l'analisi è solo sui commenti. Successivamente, vengono mantenuti solamente i dati appartenenti a subreddit rilevanti (quindi che appartengono a subreddit politici degli Stati Uniti). Vengono anche rimossi tutti i commenti scritti da bot, ovvero utenti di Reddit che scrivono risposte automatiche in base a determinati triggers.

+ *Preliminary Network*: In questo passaggio, si inizia a dividere i messaggi in settimane. Vengono lasciati solamente i messaggi che hanno una lunghezza significativa (15 caratteri, in questo caso). Vengono mantenuti solamente gli utenti che hanno scambiato una quantità di messaggi pari o superiore alla media (i self-loop, quindi utenti che rispondono a se stessi, non vengono contati): $ |M_u| >= (sum_(u in U) |M|)/(|U|) $Successivamente, si crea una rete dove ogni nodo rappresenta un utente e ogni arco rappresenta un messaggio (utente $u$ risponde ad utente $u'$ o viceversa). Di conseguenza, se due utenti hanno interagito molto tra di loro, ci saranno più archi che li collegano. Maggiore è il numero di archi che li collegano, maggiore è il peso (la significatività statistica) tra loro. Infine, viene effettuato il backboning della rete, con l'obiettivo di snellirla e renderla più gestibile. Si cerca di massimizzare il numero di nodi e minimizzare il numero di archi. Viene usato il metodo di Noise-Correction, metodo che utilizza gli archi e il loro peso. Viene restituito il Largest Connected Component.

  Inoltre, al fine di anonimizzare i dati e rispettare il GDPR, viene assegnato un nuovo id a ogni utente. Si mantiene una tabella di mapping globale per rendere coerente l'`id` dell'utente tra le settimane e i mesi.

+ *Topic Detection*: Per ogni rete e per ogni messaggio di ogni rete, si utilizza il modello BERTopic @grootendorst2022bertopic per classificare automaticamente ogni messaggio con l'argomento più adatto. Ogni rete preliminare, viene divisa in due sottoinsiemi rispettivamente di allenamento (training) e di classificazione. Inizialmente, il modello viene addestrato con $4096$ messaggi per ogni settimana. Dopo il training, si iniziano ad etichettare tutti i messaggi di ogni rete. I topic vengono aggregati e, manualmente, vengono esaminati, raggruppati in macrotopic e scartati quelli non rilevanti. Infine, ad ogni messaggio viene assegnato uno dei seguenti topic:
  - _abortion_: Raggruppa temi come l'aborto, i metodi contraccettivi e i diritti riproduttivi in generale;
  - _climate_: Contiene commenti riguardo il riscaldamento globale, la deforestazione, i veicoli elettrici, lobby fossili, energie rinnovabili, etc.;
  - _gender_: Commenti riguardo il femminismo, il divario retributivo di genere, l'identità di genere, LGBTQ+, pronomi, etc.;
  - _guns_: Raggruppa temi come regole sulle armi, associazioni lobbistiche sulle armi, sparatorie di massa, suicidi, milizie, etc.;
  - _health_: Contiene commenti riguardo assistenza sanitaria, assistenza sanitaria per bambini, assicurazioni, sviluppo di farmaci, etc.;
  - _racial_justice_: Riguarda la giustizia razziale e le forze dell'ordine, in senso lato. Gli argomenti trattati includono Black Lives Matter, la polizia in generale, le richieste di defunding e gli arresti.
  - _unauthorized_immigration_: Include argomenti quali il confine degli Stati Uniti, l'espulsione o i bambini e l'immigrazione negli Stati Uniti. I post non si concentrano solo sull'immigrazione clandestina, ma possono anche trattare discussioni più ampie sugli immigrati latinoamericani.

+ *Toxicity*: Viene calcolata la tossicità di ogni messaggio, con un punteggio che varia da 0 (messaggio educato e che rispetta l'interlocutore) ad 1 (messaggio volgare, con insulti o minacce verso l'interlocutore). Viene usato il modello _Detoxify_ @Detoxify con le impostazioni di default.

+ *Stance*: Tramite un modello LLM open source, Llama 3 @llama3modelcard, viene effettuato il rilevamento dell'opinione politica che ha un messaggio. L'opinione può essere etichettata come democratica o repubblicana. Essendo una scelta binaria, diventa più semplice effettuare una classificazione. Si inizializza un'istanza di Llama con il seguente messaggio (o prompt):```txt
    You are an expert political scientist. The following message is part of the debate on {topic} in the United States. In this debate there are two sides. Side D thinks {democratic_opinion}. Side R thinks {republican_opinion}. If the message is ambiguous, it belongs to side U. Classify the following message as belonging to side D, R, or U. You can only reply with one letter between D, R, or U, no other answer is acceptable."
  ``` Ogni topic avrà un prompt con una struttura uguale, ma con il contenuto adattato ad esso. Data la natura probabilistica degli LLM, verranno restituiti i token `R` e `D`, con le rispettive probabilità. Viene assegnato il valore $-1$ per un'opinione democratica, e $+1$ per un'opinione repubblicana. Il valore finale della posizione politica del messaggio, sarà: $p(R) - p(D)$.

+ *Final Network*: Come ultimo step, vengono create le reti finali. Le reti possono essere sia per topic, sia complete. Durante la costruzione della rete, vengono raccolti gli utenti e i relativi messaggi di una settimana; i messaggi vengono raggruppati per topic e, infine, si fa una media generale rispetto alle opinioni rilevate in base ai suoi messaggi. Nel caso in cui un utente, in una settimana, non abbia scritto abbastanza commenti significativi da permettere il calcolo di un punteggio per ogni topic, il problema viene risolto tramite due strategie:
  - _rolling opinion_: assumiamo che la sua opinione durante la settimana $x$ sia simile alla sua opinione alle settimane precedenti ($x-1$, $x-2$, ..., $x-n$) e vengono quindi recuperati tutti i suoi messaggi nel dataset;
  - _zombie mode_: se un utente non ha, invece, espresso opinioni su un determinato argomento, si assume che la sua posizione politica (democratica o repubblicana) su un argomento, sia analoga anche sugli altri, determinandola con una media delle sue opinioni.

  Viene restituita la componente connessa maggiore (LCC), poiché c'è bisogno di una rete connessa con il maggior numero di nodi.

  In conclusione, viene eseguita una riduzione dei parametri tramite la Principal Component Analysis (PCA), con il fine di restituire un valore generale circa la posizione politica di un utente. In @final-network-example, un esempio di una rete finale.

  #figure(
    [immagine...],
    caption: "qui metto un'immagine di cytoscape con una rete di marzo 19, con i nodi che vanno da dems a reps con un gradiente",
  ) <final-network-example>

== Limite
parlare del fatto che il limite da cui è partito tutto è stata la questione di poter usare reti dirette invece che indirette. spiegare come mai è importante e magari anche in letteratura scientifica, mostrare i limiti delle reti non dirette. in più, spiegare che si voleva capire se la misura funzionasse e, nel caso in cui funzionasse, se da risultati diversi rispetto alla misura iniziale. quindi, se aggiungere complessità al progetto può essere utile perché ci da informazioni che prima non avevamo.

#pagebreak()

= Modifiche apportate
#quote[Descrivere le attivita svolte, riportando attivita, tempi, strumenti utilizzati, risultati conseguiti, problemi affrontati e modalita di risoluzione. Potranno essere qui descritte le attivita anche dal punto di vista strettamente tecnico, approfondendo le scelte effettuate, le motivazioni, le alternative prese in considerazione, l’uso o il possibile uso dei risultati del lavoro.]\

// Finora, il lavoro presentava un limite strutturale: le interazioni che venivano catturate, non rappresentavano la direzionalità delle interazioni. Questo vuol dire che, se utente $a$ parlava con utente $b$, per il modello, $b$ parlava anche con utente $a$. Questo però, specie nelle interazioni online, non è sempre vero, perché un utente può commentare il post/commento di un altro utente ma senza ricevere risposte a sua volta.

- Attività:
  - prima di implementare la magnetic laplacian nel codice, l'abbiamo testata con dei toy examples, per verificare (1)che fosse in grado di catturare la misura di polarizzazione (aka la diffusione di una certa stance nella rete) come la laplacian classica. quindi, che la magnetic laplacian fosse utilizzabile nella nvd e (2) che catturasse la struttura del grafo, come rappresentato nel paper.
    - i toy examples erano prima dei semplici grafi, poi siamo cresciuti con la complessità, fino a simulare delle reti più complesse (con i modelli er, scale free, etc.)
  - successivamente, abbiamo testato la magnetic laplacian anche nella sua versione signed, per capire se invece potessimo includere la tossicità, con l'assunzione che tossicità alta => interazione negativa e tossicità bassa => interazione positiva/neutra
  - dopo aver contatato e affinato il funzionamento, siamo passati alle reti reali, quindi alle reti che son state costruite e spiegate nel capitolo precedente. prima però, abbiamo adattato il codice per supportare le reti dirette. successivamente, abbiamo aggiunto il codice della funzione della magnetic laplacian:
  - e abbiamo testato la nuova funzione su tutte le reti
  - correlazione con alcuni parametri come omofilia e social balance (aka triangoli)

- Tempi: ?
- Risultati conseguiti
  - Mostrare toy examples
  - Mostrare polarization results
- Problemi affrontati
  - uno dei problemi affrontati, era dovuto alla conversione della rete da indiretta a diretta. inizialmente, con un porting naive, la rete raggiungeva una soglia di thresholding elevata e quindi, in specifiche settimane dove c'erano meno dati del solito, le reti finali venivano molto piccole. fixato sistemando la soglia di thresholding su reti dirette
    - https://github.com/demic-dev/reddit-polarization/blob/main/magnetic_laplacian.md
  - Prende più in considerazione la topologia rispetto all'opinione in sé
- Modalità di risoluzione
  - Parlare di come son stati risolti bla bla

#pagebreak()

= Presentazione dei risultati
#quote[La presentazione dei risultati dovrebbe consistere in una descrizione tecnica dei risultati raggiunti, unitamente ad un commento critico e ad un’analisi della rispondenza agli obiettivi iniziali (si consiglia per tanto di motivare la rilevanza dei risultati e l’eventuale scostamento dagli obiettivi iniziali). La sezione relativa ai risultati dovrebbe infine contenere una sintesi critica e un giudizio sull’esperienza effettuata, che renda conto di aspetti positivi e negativi per il tirocinante e per l’ente ospitante, del valore formativo, professionale e umano, e cosı via.]\
// Parlare dei risultati (+ robe che mi manderà Michele)

#pagebreak()

= Conclusioni e Sviluppi Futuri
Conclusioni bla bla...

#pagebreak()

#bibliography(
  ("./works.yaml", "./works.bib"),
  title: "Bibliografia",
  style: "american-physics-society",
)
