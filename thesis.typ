#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

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
  depth: 2,
)
#pagebreak()

= Introduzione
#quote[Questa parte, da scrivere quando avrò finito la tesi...]

Qualcosa del tipo: in questa tesi vedremo etc... Nel primo capitolo ... etc.

== NERDS: Network, Data and Society
NERDS è il gruppo di ricerca presso il quale ho svolto il mio tirocinio. È un gruppo di ricerca interdisciplinare, che studia Network Science, Intelligenza Artificiale (AI) e Computational Social Science (CSS). L'ambiente, anch'esso, è interdisciplinare: ha studenti, PhD, PostDoc e professori con background in fisica, informatica, matematica e sociologia. Si trova a Copenhagen, all'interno della IT-Universitetet i København (ITU). Gli interessi di ricerca, includono, tra i vari, anche: science of science, reti sociali, reti complesse, sostenibilità urbana, mobilità urbana ed umana, visualizzazione di dati e aspetti fondamentali dei sistemi complessi.

== Computational Social Science
Le Scienze Sociali Computazionali (o Computational Social Science, CSS), è una scienza che studia le scienze sociali classiche (sociologia, antropologia, economia e scienze politiche) mediante l'uso di strumenti odierni per studiarle con approcci innovativi e su larga scala.\
La CSS, utilizza due approcci principali: uno _empirico_, che fa leva su big data per generalizzare problemi e restituire analisi ed inferenze utili per affrontare la ricerca, e uno _scientifico_, che permette di creare modelli e simulazioni di certi fenomeni. Inoltre, negli ultimi anni, grazie all'esplosione dell'intelligenza artificiale, strumenti come il Natural Language Processing (NLP) o i più recenti Large Language Model (LLM) hanno accelerato la ricerca, grazie alla loro capacità di annotare dati con accuratezza più alta rispetto ad un umano non esperto; di conseguenza, è diventato possibile automatizzare tali task che altrimenti avrebbero richiesto una elevata quantità di tempo #footnote[Annotare manualmente milioni di dati può compromettere la fattibilità di un progetto @Sylolypavan2023-ov.] o di denaro #footnote[Servizi come Amazon Mechanical Turk (https://www.mturk.com/) possono essere costosi per laboratori con fondi limitati.]. Nei capitoli successivi, porteremo un esempio concreto di annotazioni automatiche tramite modelli NLP prima e LLM dopo, che hanno avuto un'utilità enorme nel progetto, per classificare la tossicità e l'opinione politica dei messaggi inviati dagli utenti. Mostreremo anche un test per misurare l'attendibilità dei modelli utilizzati.

In questa tesi useremo un approccio empirico della CSS; analizzeremo i dati di una rete sociale (Reddit) per stabilirne la polarizzazione politica. Nei capitoli successivi, introdurremmo quindi il concetto di polarizzazione (a livello sociologico) e la Network Science, una scienza che studia le reti complesse.

== Obiettivi della tesi

Il lavoro iniziale fa un'analisi estesa sui subreddit (ovvero comunità, ne parleremo in dettaglio nel capitolo successivo) politici di Reddit, mostrando come sono cambiati negli anni, la distribuzione di democratici e repubblicani e di come è cambiata l'opinione degli utenti nel tempo su sette argomenti (_aborto_, _cambiamenti climatici_, _identità di genere_, _controllo delle armi_, _sanità_, _razzismo_ e _immigrazione_), che sono diventati sempre più divisivi nel dibattito pubblico. Analizza anche le polarizzazioni ideologiche e affettive di questa rete sociale, fenomeni che hanno portato gli utenti di Reddit ad interagire solamente con utenti con idee affine alle loro.
\ Questo studio è incentrato sul contesto statunitense, poiché più del 50% degli utenti che visita il sito ogni giorno è statunitense e abbiamo a disposizione una grande quantità di dati da analizzare.

Una rete è formata da un insieme di nodi, che rappresenta l'insieme degli utenti, e un insieme di archi, che dimostra che due utenti hanno avuto un'interazione significativa tra di loro.

Il limite del progetto, era quello di rappresentare le reti come reti non dirette, perdendo quindi la direzionalità dell'informazione. Quindi, il mio lavoro si inserisce in un'espansione del progetto iniziale, ovvero il supporto delle reti dirette e, successivamente, analizzare se i nuovi risultati sono, per primo, attendibili e congruenti a quanto dovrebbero; secondo, se ci possono essere utili per conoscere meglio la rete iniziale, dandoci informazioni che prima non avevamo.
\ Il mio lavoro si concentra maggiormente nel calcolo della polarizzazione, usando un nuovo metodo che consente di calcolare la matrice Laplaciana su reti dirette. In più, proveremo ad estendere il calcolo anche su reti con segno. L'euristica è che, se un messaggio supera una certa tossicità, allora l'interazione tra due utenti è considerata negativa, e quindi ha un punteggio diverso. Intuitivamente, ci aspettiamo che la polarizzazione ideologica aumenti.

In sintesi, vogliamo capire se ha senso aggiungere complessità supportando le reti dirette, oppure se con le reti non dirette riusciamo ad avere un'approssimazione che ci soddisfa.

Solitamente, nella Network Science, vengono preferite reti semplici, quindi non dirette, poiché è complicato adattare tutte le misure su reti dirette, e in alcuni casi non è proprio possibile. L'obiettivo finale è quello di aggiungere un tassello in più nel grande puzzle della generalizzazione e comprensione dei sistemi complessi.

#pagebreak()

= Descrizione delle attivita preliminari
#quote[Descrivere brevemente le attivita preliminari svolte, quali studio e analisi di soluzioni esistenti, studio delle tecnologie utilizzate nel seguito del lavoro.]\
In questo capitolo ...

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

La teoria dei grafi è una branca della matematica e dell'informatica che modella situazioni o processi sotto forma di nodi (attori dell'evento) e di archi (interazioni tra i nodi).

Un grafo viene distinto in diretto o indiretto. Un grafo si dice diretto (anche chiamato _digraph_) quando gli archi che collegano i nodi hanno una direzione. Altrimenti, viene detto indiretto.

Formalmente, definiamo un grafo: $ G = (V, E) $
dove:
- $V = {V_1, V_2, ...}$ è un insieme di nodi
- $E subset.eq {{x, y} | x, y in V and x eq.not y}$ è un insieme di archi non diretto, *oppure*
- $E subset.eq {{x, y} | (x, y) in V^2 and x eq.not y}$ è un insieme di archi diretto

Questi possono essere rappresentati, come struttura dati, con una lista delle adiacenze o una matrice delle adiacenze. La prima, contiene una lista dei nodi dove l'indice $i$ della lista contiene il nodo $i$ e a cui corrispondono tutti gli archi che partono dal nodo $i$ e arrivano al nodo $i'$. Richiede $Theta(V + E)$ spazio di memoria.

La matrice delle adiacenze $M$, invece, si usa una matrice $N times N$, dove $N$ è il numero dei nodi e, $M_(i j) = 0$ se non vi è alcun arco tra $i$ e $j$, $M_(i j) = w$ se vi è un arco che collega $i$ e $j$ di peso $w$. Richiede $Theta (V^2)$ spazio di memoria.

I grafi vengono usati per modellizzare moltissime relazioni e processi in numerosi campi. Nell'informatica stessa, i grafi sono stati fondamentali per permetterci di sviluppare sistemi operativi multiutente e multiprocesso (nell'ambito della gestione delle risorse) e per poter espandere internet globalmente e senza sosta (routing dei pacchetti).

=== Proprietà principali

Di seguito riportiamo alcune proprietà principali dei grafi, che vengono usati sia nella SMA, ma anche in tutti i campi di applicazione descritti sopra.

+ *Grado*: Il grado di un nodo è il numero di archi di un nodo. Definita come: $ deg(x) $ Nel caso dei digraph, si distingue il $deg_(i n) (x)$ e $deg_(o u t) (x)$, rispettivamente il numero di archi entranti e il numero di archi uscenti.

+ *Cammino*: Un cammino è una sequenza di nodi $v_1, v_2, ..., v_n$ tale che due nodi consecutivi nella sequenza, siano adiacenti: $ w = {v_1, v_2, ..., v_n } $

+ *Percorsi*: Un percorso è un cammino dove tutti i nodi nella sequenza, sono distinti: $ p_1 = { w_1, w_2 in w | w_1 eq.not w_2 } $

+ *Cicli*: Un ciclo è un percorso dove il nodo di partenza e di arrivo sono uguali:$ p_2 = { (i, e_1), (e_1, e_2), ..., (e_n, i) } $

+ *Cricca*: Una cricca è una partizione di un grafo $G$ tale che, per ogni coppia di nodi della partizione, esiste un arco che li collega. $ c = { i,j in V | (e_i, e_j) exists in E or (e_j, e_i) exists in E } $

+ *Componenti Connesse*: Abbiamo una componente connessa di un grafo $G$ se qualsiasi coppia di nodi è connessa da cammini e se non è parte di un sottografo connesso più grande.

+ *Distanza*: La distanza tra due nodi equivale al numero di archi in un cammino minimo che li connette.

+ *Diametro*: Il diametro di un grafo è anche detto _longest shortest path_, ovvero la massima distanza tra due nodi di un grafo.

+ *Alberi*: Un albero è un grafo indiretto dove ogni vertice è connesso esattamente da un percorso.

+ *Grafi Bipartiti*: Un grafo si dice bipartito se può essere diviso in due sottoinsiemi disgiunti $G'$ e $G''$, dove ogni arco di $G'$ connette i nodi di $G''$.

+ *Densità*: La densità in un grafo indica quanto questo è connesso. Se ogni nodo è connesso ad un altro, avremo un grafo completo. Al contrario, un grafo con pochi archi rispetto ai nodi, è detto sparso. Per un grafo indiretto, la densità viene definita: $ d = (2 * |E|)/(|V|(|V|-1)) $

== Network Science

La Network Science è una scienza che studia le reti complesse. È un campo multidisciplinare, poiché affonda le sue radici in: _matematica_ (teoria dei grafi), _fisica_ (meccanica statistica), _statistica_ (inferenza statistica), _sociologia_ (strutture sociali) e _informatica_ (data mining). Viene definita come #quote()[lo studio delle rappresentazioni di rete dei fenomeni fisici, biologici e sociali che portano alla creazione di modelli predittivi di tali fenomeni.] [nap11516]

Moltissime situazioni complesse possono essere modellate come reti:

- *Social Networks*: nell'informatica, è uno degli esempi più ricorrenti. I social network sono letteralmente delle reti sociali, che modellano relazioni e interazioni tra persone. È immediato pensare alle persone come nodi di una rete e alle relazioni come archi. Instagram o Twitter sono esempi di rete diretta, poiché una persona $a$ può seguire un'altra persona $è$, ma non è detto che $a'$ ricambi. Esiste quindi un arco diretto che parte da $a$ e arriva ad $a'$, ma non viceversa;
- *Citazioni negli articoli scientifici*: ogni volta che un articolo viene pubblicato, questo contiene $n$ citazioni verso altri articoli e si aggiunge alla rete di articoli già esistenti. Ogni articolo è quindi un nodo e una citazione è un arco che collega due nodi. Anche in questo caso, la rete è diretta;
- *Interazione Proteina-Proteina*: nella biologia, si parla di _interazione proteina-proteina_ quando due o più proteine interagiscono tra di loro per mezzo di reazioni biochimiche. Queste interazioni avvengono all'interno delle cellule di un organismo vivente. In questo contesto, i nodi sono le proteine e il risultato di una reazione porta alla creazione di un arco tra le proteine.

La Network Science è esplosa dopo la pubblicazione dell'articolo di Barabási-Albert "Emergence of Scaling in Random Networks" [Baraba_si_1999]: le reti reali complesse di grandi dimensioni non si sviluppano in modo casuale (la probabilità che un nodo $a$ abbia un arco verso un nodo $è$ non è approssimabile casualmente, come veniva assunto nel modello _Erdős-Rényi_ [Erdos2022OnRG]), ma seguono una _power-law degree distribution_: è più probabile che nuovi nodi che entrano nella rete cerchino collegamenti con nodi che hanno già molti collegamenti. Questo fenomeno si chiama _preferential attachment_ (ad esempio, nel WWW, un nuovo sito avrà link verso siti più grandi e conosciuti). Di conseguenza, in una rete pochi nodi (detti anche _hub_) avranno un grado elevato [scale-free] e la maggior parte dei nodi avrà un grado basso.

---

La teoria dei grafi e la network science sono altamente interconnesse. Quest'ultima usa la teoria dei grafi per rappresentare le informazioni ed eseguire algoritmi sulle sue strutture dati. Però, per facilità di comprensione, qui ci riferiremo in particolare alle proprietà che vengono studiate in reti complesse, perché danno informazioni maggiormente su scala globale, invece che locale.

=== Distribuzione di grado
Nei paragrafi precedenti, abbiamo visto cos'è il grado di un nodo in un grafo. Se accumuliamo tutti i gradi dei nodi in una rete, possiamo calcolare la probabilità, dato un nodo in un grafo, che questo abbia grado $y$: $P(deg(x) = y) = z$. La distribuzione del grado non è altro che la distribuzione delle probabilità rispetto ai gradi dei nodi nella rete. Data una rete di $n$ nodi, la probabilità che un nodo abbia grado $k$ equivale a: $ P(k) = (n_k)/n $

=== Matrice Laplaciana
La matrice Laplaciana $L$, anche detta Laplacian, è una matrice che rappresenta le informazioni topologiche di un grafo o di una rete. Dato un grafo indiretto $G = (V, E)$, da cui si ricava la matrice delle adiacenze $A_G$ e la matrice di grado $D_G$, la matrice Laplaciana $L_G$ si ottiene sottraendo la matrice di grado dalla matrice delle adiacenze: $ L_G = D_G - A_G $
$L_G$, di dimensioni $|V|times|V|$, è simmetrica e la somma di tutte le righe e colonne è uguale a $0$: $ sum_(i = 0 in |V|) L_(i j) = 0 sum_(j = 0 in |V|) L_(j i) = 0 $
In un grafo diretto, invece, la matrice Laplacian utilizza l'indegree matrix oppure l'outdegree matrix, rispettivamente $D_(G_(i n))$ e $D_(G_(o u t))$. Pertanto, non è simmetrica e, di conseguenza, invalida le proprietà della Laplacian che vedremo nei prossimi paragrafi. Quindi, solitamente, questa viene simmetrizzata oppure si tratta il grafo come un grafo indiretto.

Una matrice Laplaciana rispetta sempre le seguenti proprietà:
- È simmetrica: $L_(i j) = L_(j i)$;
- È positiva semidefinita, ovvero tutti gli autovalori $lambda_1, lambda_2, ... lambda_n >=0$;
- $lambda_0 = 0$
- $sum_(i = 0 in |V|) L_(i j) = 0$; $sum_(j = 0 in |V|) L_(j i) = 0$

La matrice Laplacian ha numerose applicazioni nella teoria dei grafi e nella network science. Lo studio dei suoi autovalori ed autovettori permette di svolgere la _spectral analysis_, che fornisce informazioni importanti sulla struttura della rete, o per la community evaluation. Permette di calcolare la node distance vector, ovvero la diffusione di una proprietà di un nodo all'interno della rete @node-distance-vector. Inoltre, trova moltissime applicazioni nella fisica, campo da cui è nata, per modellizzare matematicamente reti elettriche @doyle2000randomwalkselectricnetworks. Viene anche usata per trovare il numero di Spanning Tree in un grafo, in tempo polinomiale @kirchoff-theory.

Esitono diverse declinazioni della Laplacian, ognuna adattata a diversi usi. Ad esempio, c'è la laplaciana normalizzata, una matrice che normalizza il grado dei nodi, in cui ci siano alcuni nodi con un grado alto e la maggior parte con un grado basso, come nel caso delle scale-free network. Esiste la matrice Laplacian costruita tramite la matrice delle incidenze (una matrice che codifica le relazioni tra i nodi e gli archi), usata per reti con gli archi pesati. Infine, abbiamo la _magnetic laplacian_, una matrice che rappresenta un grafo diretto, trattando le direzioni degli archi come una fase in un piano complesso. La approfondiremo nei capitoli successivi, poiché parte centrale del progetto di tesi.

=== Null Model
Il _null model_ è un modello di rete che viene usato come benchmark rispetto ad una rete reale. Viene generato randomicamente partendo da delle proprietà di una rete reale (ad es. la densità, la distribuzione di grado, l'assortatività, ...). Viene usato per isolare uno specifico comportamento di una rete ad un ristretto gruppo di proprietà, generando casualmente delle reti che hanno quelle singole proprietà. Inoltre, può essere usato per trovare correlazioni tra proprietà su reti particolari: se data una rete reale con proprietà $X$ (es. average degree = 4), accade $Y$ (es. l'omofilia cresce), allora verranno generate delle reti randomiche con proprietà $X$ (average degree = 4) per verificare la presenza di $Y$.

Un null model può essere randomico o generativo @Váša2022. Il modello randomico è il più comune, solitamente si ottiene tramite il metodo di rewiring, dove, dato un insieme di archi, questi vengono casualmente riscritti, per preservare il grado di ogni nodo. In @rewiring-null-model un esempio. Invece, con l'approccio generativo, date delle ipotesi nulle che devono essere raggiunte, si preleva una partizione della rete iniziale e si aggiungono nuovi nodi e archi finché non si raggiungono le ipotesi nulle definite inizialmente e che si vogliono mantenere.

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
aaaa
=== Spectral Analysis
La Spectral Analysis è lo studio degli autovalori ed autovettori della matrice Laplaciana di un grafo. Data una Laplacian $L$, definiamo gli autovalori $lambda$: $ lambda in sigma(L) quad sigma(L) = {lambda | det(L - lambda I) = 0} $ e gli autovettori $v$: $ v in ker(L - lambda I), quad v eq.not 0 $
Come definito sopra, il primo autovalore $lambda_0$ in una Laplacian è sempre uguale a $0$. Gli altri autovalori, invece, sono monotoni crescenti: $ 0 = lambda_1 <= lambda_2 <= ... <= lambda_n $

La spectral analysis è importante perché fornice informazioni importanti sulla struttura del grafo. Può essere utilizzata per la risoluzione del graph coloring problem #footnote[fonte] o per effettuare una low-rank approximation (approssimazione della matrice delle adiacenze ad una matrice di rango inferiore) #footnote[fonte]. Inoltre, l'uso del secondo e terzo autovettore $v_2$ e $v_3$, vengono usati per la visualizzazione di grafi con un layout semplificato e più piacevole all'occhio umano (anche $v_4$ per visualizzarlo in tre dimensioni), come dimostrato da Hall @hall-quadratic-placement.

Uno dei suoi usi più comuni invece risiede nello studio del secondo autovalore $lambda_2$, ovvero il Fiedler Value, chiamato anche _connettività algebrica_.\
lambda_2 ha anche molte altre utilità (pag 16 del paper)

Gli autovalori e autovettori, hanno le seguenti proprietà:

+ Il vettore di tutti 1 è sempre un autovettore del primo autovalore $lambda_1$ di $L$, di valore 0;
+ L'autovalore più grande della matrice delle adiacenze, è sempre compreso tra il grado medio e il grado massimo di un nodo in un grafo $G$; #footnote[see [9] or [10, Section 3.2]].
+ Se $G$ è connesso, allora $lambda_1$ > $lambda_2$ e l'autovettori $v_1$ sarà positivo; #footnote[see [11]].
+ The multiplicity of 0 as an eigenvalue of $L_G$ is equal to the number of connected components of $L_G$.
+ L'autovalore maggiore di $L$ è al massimo il doppio del grado massimo in $G$;
+ $lambda_n$ = -$lambda_1$ se e solo se $G$ è un grafo bipartito #footnote[see [12], or [10, Theorem 3.4]].

=== Community Discovery
Studiando una rete, è frequente che si voglia analizzare se un gruppo di nodi forma una community. Ovvero, se questi possono essere raggruppati e suddivisi in base ad una proprietà in comune. Nella nostra societè, le community sono ovunque: persone che appartengono alla stessa citta, allo stesso gruppo di amici o che hanno lo stesso attore preferito. Chi vive in una determinata città, sicuramente avrà molte interazioni con persone che vivono nella sua stessa città. Al contrario, ne avrà poche o nulle con chi vive in città differenti, per forza di cose. Il ragionamento è il medesimo per le reti e la Network Science. Formalmente, una community si dice tale quando c'è una densità molto alta tra i nodi della community ed interazioni sparse con i nodi al di fuori di essa.

Lo studio e la valutazione delle community in una rete, viene detto _community discovery_. Questa pratica ha svariati casi d'uso. Ad esempio, per il _backboning_, dove si possono individuare i nodi simili tra loro e rimuoverli, lasciando solo un nodo "rappresentante", al fine di semplificare la rete, oppure per raggruppare e classificare i nodi in cluster specifici, per testare il loro comportamento al cambio di determinate condizioni della rete (ad esempio nel campo dell'advertising e del marketing).

La Community Discovery è un campo molto vasto, ed esistono svariati modi per raggruppare i nodi in comunità, e nuovi metodi vengono continuamente studiati. Infatti, non esiste il metodo definitivo, ma anzi tutto dipende dall'obiettivo che si vuole raggiungere. Generalmente, si da importanza alle performance del metodo di community detection e alla sua attendibilità, misurata con la somiglianza rispetto agli altri algoritmi.

Il primo metodo trovato per effettuare Community Discovery è chiamato Stochastic Block Model (SBM), con la massimizzazione della _likelihood function_. Dato un SBM, ovvero un modello di generazione di grafi randomici che contiene comunità, generato con due parametri $p_(i n)$ e $p_(o u t)$, che rispettivamente sono la probabilità che un nodo interagisca con un nodo all'interno della comunità e che un nodo si connetta con un nodo all'esterno della comunità (generalmente, $p_(i n) > p_(o u t)$), si inizializzano i due parametri agli stessi valori della rete iniziale. Successivamente, si definisce la _likelihood function_: $ L_(Theta, A) = sum_(u, v in A) l_theta, A, u, v $ dove
$
  l_(theta,A, u, v) = cases(
    θ_1 - 1 "if" A_(u v) = 1 & (u, v) ∈ theta_3,
    θ_2 - 1 "if" A_(u v) = 1 & (u, v) ∉ theta_3,
    -θ_1 "if" A_(u v) = 0 & (u, v) ∈ theta_3,
    -θ_2 "if" A_(u v) = 0 & (u, v) ∉ theta_3,
  )
$
Si cerca di massimizzare la funzione, in modo tale che: $ hat(theta) = arg_(theta in Theta)max L_(theta, A) $

Infine, se, dato un SBM, $p_(o u t) > p_(i n)$, allora si possono trovare tutte le community disassortative, ovvero di nodi che legano solo con nodi che _non_ sono nella loro comunità.

Questo metodo è l'equivalente del metodo di modularity optimization @Newman_2016, che definiremo più avanti.

Un altro dei metodi più comuni per trovare le comunità in una rete, è quello di usare la _random walk_, ovvero partendo da un nodo casuale, esplorare casualmente uno dei suoi vicini, e così via, iterando $n$ volte. L'idea alla base è che quando con una random walk si entra in una community, allora vi rimarrà per molto tempo, dato l'elevato numero di archi all'interno della community. Al contrario, la probabilità che arrivi ad un nodo di confine e che questo poi entri in un'altra comunità, è molto bassa. Per tanto, utilizzare la tecnica delle random walk non è la più efficiente. Ci riesce bene, però, il metodo delle Infomap, che ha l'obiettivo di minimizzare la map equation @Rosvall2009, ovvero una codifica di una _random walk_.

Inizialmente, l'algoritmo simula una normale random walk, per calcolare le frequenze di visita dei nodi. Ogni volta che esplora un nodo, gli assegnerà una sequenza di bit codificata con la codifica di Huffman @itwiki:147328281. Al fine di risparmiare memoria e riutilizzare gli id, in modo analogo alle vie, che si ripetono in varie città, inizierà a raggruppare i nodi vicini tra loro sotto una stessa community, al quale assegnerà un numero di bit crescente. In questo modo, nella codifica, quando entrerà in una nuova community, lo segnalerà scrivendo inizialmente il numero della community, e successivamente il numero di ogni nodo. Quando arriva ad un nodo di confine e si sposta in una nuova community, allora userà la codifica `1111`, che segnala il salto in una nuova community. Aggiunge un po' di overhead, perché in ogni community ci saranno almeno 5 bit in più, ma il breakeven point si raggiunge velocemente. Questo processo viene iterato molteplici volte, finché non si ottiene la lunghezza minima della codifica del random walker. Data la natura randomica delle random walk, è un algoritmo non deterministico.

Un ulteriore metodo di community detection è ottenuto tramite il metodo di _label percolation_, oppure _label convergence_, che, partendo da un subset di nodi a cui sono assegnate randomicamente delle label, queste vengono propagate a tutto il resto dei nodi, fino ad avere tutti i nodi etichettati. Anch'esso è un algoritmo non deterministico.

Inizialmente, ad ogni nodo viene assegnata una label casuale. Successivamente, in modo iterativo, inizierà ad esplorare le label dei suoi nodi vicini. Questo, si autoassegnerà la label più frequente tra i suoi vicini e, in caso di pareggio, ne sceglierà una casualmente, pescando dai più frequenti. Si continua finché non si arriva ad una convergenza in cui ogni nodo ha la stessa label della maggioranza dei suoi vicini.\ L'aspetto positivo di questo algoritmo è che è molto semplice da implementare e converge velocemente.

In più, data la natura non deterministica, multiple iterazioni dello stesso algoritmo, evidenziano diverse community structures, che possono essere aggregate tramite l'indice di similarità di Jaccard @Raghavan_2007.

Infine, la community detection può avvenire sia su reti statiche (_snapshots_ ad un determinato punto nel tempo), sia su reti dinamiche, in cui assumiamo che la rete si modifichi, si aggiungano nodi, si rimuovano archi e, di conseguenza, si modifichino le community.

Un metodo naif di valutazione delle community nelle reti dinamiche, è quello di assumere che ogni snapshot sia indipendente nel tempo, e cercare indipendentemente su ogni snapshot, le community. La letteratura scientifica però, ci dice che i risultati possono essere molto diversi. Si può, quindi, ricorrere ad una tecnica chiamata _evolutionary clustering_ @evolutionary-clustering.

Con l'evolutionary clustering, si cerca di bilanciare due obiettivi: massimizzare la qualità dello snapshot al tempo $t$, che riflette i cambiamenti più recenti, e minimizzare l'_history cost_, ovvero la distanza tra il clustering al tempo $t$ e quello al tempo $t-1$.

L'algoritmo usa un indice di similarità o una matrice delle distanze dei vari timestamps $T$, costruiti nel tempo, definita come $M_t$. Ad ogni timestamp, l'algoritmo cerca di ottimizzare la qualità dello snapshot: $ s q(C_t, M_t) - alpha dot h c (C_(t-1), C_t) $ dove $C_t$ è il clustering calcolato al tempo $t$. $s q$ è una funzione che valuta la qualità dello snapshot, $h c$ è la funzione di history cost e $alpha$ è un parametro di trade-off che stabilisce quanta importanza dare alle configurazioni passate degli snapshot.

=== Modularity
La modularità è una misura che valuta la qualità di una _community evaluation_ in una rete. Un alto grado di modularità significa che ci sarà un'alta densità tra i nodi nella stessa community e una densità minore tra un nodo in una community e uno all'infuori della comunità. Rappresenta la densità interna delle community. Ha anche lo scopo di ottimizzare la funzione di suddivisione in community, con l'obiettivo di massimizzare la modularità. Data $A$ la matrice delle adiacenze e $delta$ la funzione delta di Kronecker, la modularità è definita da: $ M = 1/(2|E|) sum_(i,j in V) \[A_(i j) - (deg(i) deg(j))/(2|E|) \] delta (c_i, c_j) $

Il dominio di esistenza della modularità è definito in $[-0.5, +1]$: più è basso, più c'è disassortatività nella rete. Al contrario, se tende a $+1$, la divisione delle community è ottimale. Se la modularità è uguale a 0, allora il grafo non ha alcuna struttura.

=== Altre proprietà

+ *Omofilia ed Eterofilia*: L'omofilia è una proprietà qualitativa che esprime quanto dei nodi in una rete sono vicini tra di loro se esprimono features simili. È uno dei metodi di community discovery, perché si parte dall'assunzione sociologica in cui le persone tendono a relazionarsi con persone simili tra di loro (stesso genere, età simile, stesse passioni o interessi) e si riusa nello studio delle reti perché si assume che nodi con features simili, tendano ad essere connessi. Questo accade sia per motivi comportamentali (l'utente in un social network ricerca solo persone/pagine che rispettano i propri interessi), sia per motivi ambientali (l'algoritmo di un social network mostra all'utente maggiormente post che potrebbero interessargli). L'eterofilia, invece, è l'esatto opposto.

+ *Assortatività e Disassortatività*: L'assortatività è una misura quantitativa per rappresentare l'omofilia. Al contrario, la disassortatività rappresenta l'eterofilia. L'intuizione dell'assortatività è quella di prendere features numeriche e, data una connessione tra due nodi, stimarne la similarità (es. due nodi con valore 1 e 5 sono più vicini rispetto a due nodi con valore 1 e 5000). La proprietà più comune è il grado di due nodi, in cui si assume che due nodi con grado molto alto, si leghino tra loro. Ad esempio, nei social networks, è più probabile che una celebrità si connetta ad un'altra.

+ *Coefficiente di Clustering*: È una proprietà che misura quanto, in una rete, i nodi tendono a essere connessi tra di loro. Soprattutto nelle reti sociali, i nodi tendono ad avere un'alta densità di collegamenti. È una misura locale o globale. A livello locale, misura quanto è probabile che i vicini di un nodo tendono a formare una cricca. Dato $N$ l'insieme dei vicini di $i$ e $k_i = |N|$: $ C C_i = (|{ e_(j k) : v_j, v_k in N, e_(k j) in E }|)/(k_v\(k_v-1\)) $\ A livello globale, invece, ci si basa su triple di nodi (triangoli o triadi). Il coefficiente globale di clustering rappresenta quanti triangoli chiusi ci sono, rispetto a tutte le triadi in una rete: $ C C = (\# "triangles")/(\# "triads") $

=== Node Vector Distance
Trovare la distanza tra due nodi è un problema che in letteratura scientifica è stato abbondantemente studiato. Grazie ad esso, la teoria dei grafi si è potuta estendere alle reti come le intendiamo comunemente, ovvero un insieme di computer collegati tra loro e che possono comunicare. Questo ha dato spazio ad internet, che ci permette di scambiare dati con computer che si trovano dall'altra parte del mondo rispetto a noi.

Le misure comuni di distanza, però, tengono conto solamente di un aspetto, ovvero di portare un dato in un nodo $i$ ad un nodo $j$. In modo binario, un dato può essere in un nodo oppure nell'altro, oppure in un qualsiasi nodo intermedio, non può diffondersi in modo "continuo", dove una parte di informazione si trova sia in un nodo, che nell'altro.\
Però, molte situazioni del mondo reale possono essere modellizzate in questo modo:

- *Diffusione di un virus*:
- *Qualità di una campagna di marketing virale*:
- *Polarizzazione in un social network*:

L'intuizione dietro la Node Distance deriva dal misurare, data una rete e due tempi $t_1$ e $t_2$, la diffusione di una proprietà di un nodo nel tempo.

Formalmente, data una rete non diretta $G = (V, E)$, dove $V$ è l'insieme dei nodi ed $E$ è l'insieme degli archi, assumiamo che la proprietà $A$ sia diffusa tra i nodi della rete, in modo tale che $sum_(i=0)^(|V|) A_i = 1$. Assumiamo anche che la rete non cambi, tra $t_1$ e $t_2$.

Tramite la NVD, misuriamo la diffusione della proprietà $A$ tra i nodi:

#figure(
  diagram(
    node-stroke: .1em,
    spacing: 3em,
    node((0, 0), `1`, radius: 1em, fill: red),
    edge(``, "-"),
    node((1, 0), `2`, radius: 1em),
    edge(``, "-"),
    node((2, 0), `3`, radius: 1em),
    // ---------------------------------------
    node((3, 0), `1`, radius: 1em, fill: red.lighten(90%)),
    edge(``, "-"),
    node((4, 0), `2`, radius: 1em, fill: red.lighten(75%)),
    edge(``, "-"),
    node((5, 0), `3`, radius: 1em, fill: red.lighten(35%)),
  ),
  caption: [$A = [1, 0, 0]$ (sx). $A = [0.1, 0.25, 0.65]$ (dx)],
)

Concretamente, esistono quattro classi di soluzione per poter calcolare la NVD:

+ *Generalized Euclidean*:
+ *Shortest-Path*:
+ *Spectral*:
+ *Adaptions of NVD-Algorithms*:

== Python
Python @van1995python è un linguaggio di programmazione interpretato, orientato agli oggetti, di alto livello con semantica dinamica. Le sue strutture dati integrate di alto livello, combinate con la tipizzazione dinamica e il binding dinamico, lo rendono molto interessante per lo sviluppo rapido di applicazioni, nonché per l'uso come linguaggio di scripting o di collegamento per connettere tra loro componenti esistenti. La sintassi semplice e facile da imparare di Python enfatizza la leggibilità e quindi riduce i costi di manutenzione dei programmi.

Python supporta moduli e pacchetti, che incoraggiano la modularità dei programmi e il riutilizzo del codice. L'interprete Python e l'ampia libreria standard sono disponibili in formato sorgente o binario gratuitamente per tutte le principali piattaforme e possono essere distribuiti liberamente.

Python, grazie alla sua estesa fornitura di librerie e alla sua rapida curva di apprendimento, è il linguaggio più usato nel contesto di Data Science ed è stato usato per la scrittura del codice il cui prodotto si trova più avanti in questa tesi.

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

== Procedura di costruzione della rete
Per la realizzazione delle reti, viene scaricato un dump di tutti i dati pubblici di Reddit, dalla sua creazione fino al 2025 @redditSubmissions.

è possibile suddividere questa sezione in 6 fasi:

+ *Data Filtering*: Partendo da un file `.csv` per ogni mese, si itera attraverso tutti i post e commenti, filtrando via tutti i post, perché l'analisi è solo sui commmenti. Successivamente, vengono mantenuti solamente i dati appartenenti a subreddit rilevanti (quindi che appartengono a subreddit politici degli Stati Uniti). Vengono anche rimossi tutti i commenti scritti da bot, ovvero utenti di Reddit che scrivono risposte automatiche in base a determinati triggers.

+ *Preliminary Network*: In questo passaggio, si inizia a dividere i messaggi in settimane. Vengono lasciati solamente i messaggi che hanno una lunghezza significativa (15 caratteri, in questo caso). Vengono mantenuti solamente gli utenti che hanno scambiato solamente una quantità di messaggi nella media; (i self loop, quindi utenti che rispondono a se stessi, non vengono contati): $ |M_u| > (sum_(u in U) |M|)/(|U|) $Successivamente, si crea una rete dove ogni nodo rappresenta un utente e ogni arco rappresenta un messaggio (utente $u$ risponde ad utente $u'$ o viceversa). Di conseguenza, se due  utenti hanno interagito molto tra di loro, ci saranno più archi che li collegano. Maggiore è il numero di archi che li collega, maggiore è il peso (la significativitè statistica) tra loro. Infine, viene effettuato il backboning della rete, con l'obiettivo di snellirla e renderla più gestibile. Si cerca di massimizzare il numero di nodi e minimizzare il numero di archi. Viene usato il metodo di Noise-Correction, metodo che utilizza gli archi e il loro peso. Viene restituito il Largest Connected Component.

  Inoltre, al fine di anonimizzare i dati, e rendersi conforme al GDPR, viene assegnato un nuovo id all'utente. Si mantiene una tabella di mapping globale per rendere coerente l'`id` dell'utente tra le settimane e i mesi.

+ *Topic Detection*: Per ogni rete e per ogni messaggio di ogni rete, si utilizza il modello BERTopic @grootendorst2022bertopic per classificare automaticamente ogni messaggio con l'argomento più adatto. Ogni rete preliminare, viene divisa in due sottoinsiemi rispettivamente di allenamento (training) e di classificazione. Inizialmente, il modello viene addestrato con $4096$ messaggi per ogni settimana. Dopo il training, si iniziano ad etichettare tutti i messaggi di ogni rete. I topic vengono aggregati e, manualmente, vengono esaminati, raggruppati in macrotopic e scartati quelli non rilevanti. Infine, ad ogni messaggio viene assegnato uno dei seguenti topic:
  - _abortion_: Raggruppa temi come l'aborto, i metodi contraccettivi e i diritti riproduttivi in generale;
  - _climate_: Contiene commenti riguardo il riscaldamento globale, la deforestazione, i veicoli elettrici, lobby fossili, energie rinnovabili, etc.;
  - _gender_: Commenti riguardo il femminismo, il divario retributivo di genere, l'identitè di genere, LGBTQ+, pronomi, etc.;
  - _guns_: Raggruppa temi come regole sulle armi, associazioni lobbistiche sulle armi, sparatorie di massa, suicidi, milizie, etc.;
  - _health_: Contiene commenti riguardo assistenza sanitaria, assistenza sanitaria per bambini, assicurazioni, sviluppo di farmaci, etc.;
  - _racial_justice_: Riguarda la giustizia razziale e le forze dell'ordine, in senso lato. Gli argomenti trattati includono Black Lives Matter, la polizia in generale, le richieste di defunding e gli arresti.
  - _unauthorized_immigration_: Include argomenti quali il confine degli Stati Uniti, l'espulsione o i bambini e l'immigrazione negli Stati Uniti. I post non si concentrano solo sull'immigrazione clandestina, ma possono anche trattare discussioni più ampie sugli immigrati latinoamericani.

+ *Toxicity*: Viene calcolata la tossicità di ogni messaggio, con un punteggio che varia da 0 (messaggio educato e che rispetta l'interlocutore) ad 1 (messaggio volgare, con insulti o minacce verso l'interlocutore). Viene usato il modello _Detoxify_ @Detoxify con le impostazioni di default.

+ *Stance*: Tramite un modello LLM open source, Llama 3 @llama3modelcard, viene effettuato il rilevamento dell'opinione politica che ha un messaggio. L'opinione può essere etichettata come democratica o repubblicana. Essendo una scelta binaria diventa più semplice effettuare una classificazione. Si inizializza un'istanza di Llama con il seguente messaggio (o prompt):```txt
    You are an expert political scientist. The following message is part of the debate on {topic} in the United States. In this debate there are two sides. Side D thinks {democratic_opinion}. Side R thinks {republican_opinion}. If the message is ambiguous, it belongs to side U. Classify the following message as belonging to side D, R, or U. You can only reply with one letter between D, R, or U, no other answer is acceptable."
  ``` Ogni topic avrà un prompt con una struttura uguale, ma con il contenuto adattato ad esso. Data la natura probabilistica degli LLM, verranno restituiti i token `R` e `D`, con le rispettive probabilità. Viene assegnato il valore $-1$ per un'opinione democratica, e $+1$ per un'opinione repubblicana. Il valore finale della posizione politica del messaggio, sarà: $p(R) - p(D)$.

+ *Final Network*: Come ultimo step, vengono create le reti finali. Le reti possono essere sia per topic, sia complete. Durante la costruzione della rete, vengono raccolti gli utenti e i relativi messaggi di una settimana; i messaggi vengono raggruppati per topic e, infine, si fa una media generale rispetto alle opinioni rilevate in base ai suoi messaggi. Nel caso in cui un utente, in una settimana, non abbia scritto abbastanza commenti significativi, tali da riuscire a calcolare un punteggio rispetto alle sue opinioni per ogni topic, si risolve il problema tramite due parametri:
  - _rolling opinion_: assumiamo che la sua opinione durante la settimana $x$ sia simile alla sua opinione alle settimane precedenti ($x-1$, $x-2$, ..., $x-n$) e vengono quindi recuperati tutti i suoi messaggi nel dataset;
  - _zombie mode_: se un utente non ha, invece, espresso opinioni su un determinato argomento, si assume che la sua posizione politica (democratica o repubblicana) su un argomento, sia analoga anche sugli altri, determinandola con una media delle sue opinioni.

  Viene restituito il componente connesso maggiore (LCC), poiché c'è bisogno di una rete connessa con il maggior numero di nodi.

  In conclusione, viene eseguita una riduzione dei parametri tramite la Principal Component Analysis (PCA), con il fine di restituire un valore generale circa la posizione politica di un utente. In @final-network-example, un esempio di una rete finale.

#figure(
  [ciao],
  caption: "qui metto un'immagine di cytoscape con una rete di marzo 19, con i nodi che vanno da dems a reps con un gradiente",
) <final-network-example>

#pagebreak()

= Modifiche apportate

#quote[Descrivere le attivita svolte, riportando attivita, tempi, strumenti utilizzati, risultati conseguiti, problemi affrontati e modalita di risoluzione. Potranno essere qui descritte le attivita anche dal punto di vista strettamente tecnico, approfondendo le scelte effettuate, le motivazioni, le alternative prese in considerazione, l’uso o il possibile uso dei risultati del lavoro.]\

// Finora, il lavoro presentava un limite strutturale: le interazioni che venivano catturate, non rappresentavano la direzionalità delle interazioni. Questo vuol dire che, se utente $a$ parlava con utente $b$, per il modello, $b$ parlava anche con utente $a$. Questo però, specie nelle interazioni online, non è sempre vero, perché un utente può commentare il post/commento di un altro utente ma senza ricevere risposte a sua volta.

- Tempi: ?
- Strumenti utilizzati:
  - NetworkX
  - pytorch
  - numpy
  - pandas(?)
  - magnetic Laplacian
    - `playground.ipynb`
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
Parlare dei risultati (+ robe che mi manderè Michele)

#pagebreak()

= Conclusioni e Sviluppi Futuri
Conclusioni bla bla...

#pagebreak()

#bibliography(
  ("./works.yaml", "./works.bib"),
  title: "Bibliografia",
  style: "american-physics-society",
)
