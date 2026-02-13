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
  depth: 3,
)
#pagebreak()

= Introduzione
#quote[Questa parte, da scrivere quando avrò finito la tesi...]

Qualcosa del tipo: in questa tesi ... Nel primo capitolo ... etc.

== NERDS: Network, Data and Society

NERDS è il gruppo di ricerca presso il quale ho svolto il mio tirocinio. È un gruppo di ricerca interdisciplinare, che studia Network Science, Intelligenza Artificiale (AI) e Computational Social Science (CSS). L'ambiente, anch'esso, è interdisciplinare: ha studenti, PhD, PostDoc e professori con background in fisica, informatica, matematica e sociologia. Si trova a Copenhagen, all'interno della IT-Universitetet i København (ITU). Gli interessi di ricerca, includono, tra i vari, anche: science of science, reti sociali, reti complesse, sostenibilità urbana, mobilità urbana ed umana, visualizzazione di dati e aspetti fondamentali dei sistemi complessi.\
Durante il mio tirocinio, sono stato affiancato dal mio professore, Michele Coscia, che durante la sua carriera ha studiato polarizzazione social networks bla bla

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

- *Social Networks*: nell'informatica, è uno degli esempi più ricorrenti. I social network sono letteralmente delle reti sociali, che modellano relazioni e interazioni tra persone. È immediato pensare alle persone come nodi di una rete e alle relazioni come archi. Instagram o Twitter sono esempi di rete diretta, poiché una persona $a$ può seguire un'altra persona $a'$, ma non è detto che $a'$ ricambi. Esiste quindi un arco diretto che parte da $a$ e arriva ad $a'$, ma non viceversa;
- *Citazioni negli articoli scientifici*: ogni volta che un articolo viene pubblicato, questo contiene $n$ citazioni verso altri articoli e si aggiunge alla rete di articoli già esistenti. Ogni articolo è quindi un nodo e una citazione è un arco che collega due nodi. Anche in questo caso, la rete è diretta;
- *Interazione Proteina-Proteina*: nella biologia, si parla di _interazione proteina-proteina_ quando due o più proteine interagiscono tra di loro per mezzo di reazioni biochimiche. Queste interazioni avvengono all'interno delle cellule di un organismo vivente. In questo contesto, i nodi sono le proteine e il risultato di una reazione porta alla creazione di un arco tra le proteine.

La Network Science è esplosa dopo la pubblicazione dell'articolo di Barabási-Albert "Emergence of Scaling in Random Networks" [Baraba_si_1999]: le reti reali complesse di grandi dimensioni non si sviluppano in modo casuale (la probabilità che un nodo $a$ abbia un arco verso un nodo $a'$ non è approssimabile casualmente, come veniva assunto nel modello _Erdős-Rényi_ [Erdos2022OnRG]), ma seguono una _power-law degree distribution_: è più probabile che nuovi nodi che entrano nella rete cerchino collegamenti con nodi che hanno già molti collegamenti. Questo fenomeno si chiama _preferential attachment_ (ad esempio, nel WWW, un nuovo sito avrà link verso siti più grandi e conosciuti). Di conseguenza, in una rete pochi nodi (detti anche _hub_) avranno un grado elevato [scale-free] e la maggior parte dei nodi avrà un grado basso.

il null model è un modello usato come benchmark rispetto ad una rete reale. è un modello che, data una rete, mantiene delle proprietà specificate (densità, degree, ...) per trovare correlazioni tra proprietà: se data una rete reale con proprietà X, accade Y, allora creiamo vari null models che incorporano la proprietà X e vediamo se la conseguenza Y rimane. se rimane, possiamo dire, con un certo grado di accuratezza, che la proprietà Y è correlata alla presenza della proprietà X.
un null model può essere randomico o generativo. il randomico più comune è ottenuto tramite il processo di rewiring, ovvero, dato un insieme di archi, questi vengono randomicamente riscritti, per preservare il grado di ogni nodo (es. A -> B e C -> D diventano A -> C e B -> D). invece, con l'approccio generativo, date delle null hypotesis che devono, alla fine, essere raggiunte e rispettate, partiamo da un subset di nodi/archi e aggiungiamo nodi/archi fin quando non raggiungiamo le ipotesi iniziali che vogliamo mantenere.

==== Laplacian
la laplacian rappresenta un grafo ed è una matrice che incorpora le informazioni di grado e topologia di un grafo. si costruisce con $L = D - A$ (spiegare come... e cosa sono). nel caso di grafi diretti, la matrice è asimmetrica e si prendono l'indegree e l'outdegree, però così facendo non è simmetrica, quindi si rende il grafo non diretto per mantere le proprietà della laplacian classica e poterla usare per i vari motivi per cui viene usata

studiando gli autovalori e gli autovettori della laplacian possiamo ottenere informazioni strutturali importanti sulla rete, specie studiando il fiedler value o lo Spectral gap. viene usata per lo spectral clustering.

also, rispetta le seguenti proprietà
- è simmetrica
- è positiva-semidefinita (tutti i suoi autovalori >= 0)
- autovalore[0] = 0
- la somma di tutte le righe o tutte le colonne = 0

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
Studiando una rete, è frequente che si voglia analizzare se un gruppo di nodi forma una community. Ovvero, se questi possono essere raggruppati e suddivisi in base ad una proprietà in comune. Nella nostra societa', le community sono ovunque: persone che appartengono alla stessa citta, allo stesso gruppo di amici o che hanno lo stesso attore preferito. Chi vive in una determinata citta', sicuramente avra' molte interazioni con persone che vivono nella sua stessa citta'. Al contrario, ne avra' poche o nulle con chi vive in citta' differenti, per forza di cose. Il ragionamento e' il medesimo per le reti e la Network Science. Formalmente, una community si dice tale quando c'e' una densità molto alta tra i nodi della community ed interazioni sparse con i nodi al di fuori di essa.

Lo studio e la valutazione delle community in una rete, viene detto _community discovery_. Questa pratica ha svariati casi d'uso. Ad esempio, per il _backboning_, dove si possono individuare i nodi simili tra loro e rimuoverli, lasciando solo un nodo "rappresentante", al fine di semplificare la rete, oppure per raggruppare e classificare i nodi in cluster specifici, per testare il loro comportamento al cambio di determinate condizioni della rete (ad esempio nel campo dell'advertising e del marketing).

La Community Discovery è un campo molto vasto, ed esistono svariati modi per raggruppare i nodi in comunità, e nuovi metodi vengono continuamente studiati. Infatti, non esiste il metodo definitivo, ma anzi tutto dipende dall'obiettivo che si vuole raggiungere. Generalmente, si da importanza alle performance del metodo di community detection e alla sua attendibilità, misurata con la somiglianza rispetto agli altri algoritmi.

il primo metodo per la community discovery è quello del stochastic block model (SBM) e della maximum likelihood function.

ovvero dato un sbm, quindi un modello per generare grafi randomici con communities e con i due parametri pin e pout (gli stessi della rete iniziale), che rispettivamente sono la probabilità che un nodo si connetta con un altro nella stessa community e la probabiltà che un nodo si connetta con un altro fuori dalla community. si cerca di massimmizzare una likelihood function, ovvero una funzione che, dati i parametri pin e pout e una funzione theta che restitusice 1 se due nodi sono nella stessa community e 0 se non (oppure è una partizione che contiene tutti i nodi in una communtiy).
cerchiamo di massimizzare questa funzione in modo tale che: $L_(Theta, A) = sum_(u, v in A) l_theta, A, u, v$

inoltre, con l'sbm se noi mettiamo pout > pin allora possiamo trovare tutte le community disassortative, ovvero i nodi che si legano solo a nodi che NON sono della loro community.

un altro modo per trovare le community in una rete è tramite le random walks. l'idea dietro è che, quando una random walk entra in una community, vi rimarrà per molto tempo, perché continuerà a viaggiare in nodi di una stessa community (è poco probabile che arrivi al node edge e che entri in un'altra community). il metodo più conosciuto che usa random walks è il metodo molto delle infomap.

la infomap sfrutta le random walk andando a tracciare tutti i nodi che ha esplorato, associando ogni nodo ad una sequenza di bit e codificandolo con il codice di huffman. per risparmiare memoria, assegnano una codifica ad ogni community e aggiungono le label della community come prefissi nella loro codifica. quando si arriva ad un nodo edge, si usa invece la sequenza di bit `1111` per segnalare che vi è un salto di community. aggiunge un po' di overhead alla modifica, però vi è un risparmio, perché le label di inizio e fine community verranno raramente usate.
la infomap ha una quality function, con l'obiettivo di minimizzare quanto più possibile la codifica del random walker

#quote[Infomap è un algoritmo di community detection che minimizza la "map equation", una funzione information-theorica che misura la lunghezza media del codice per descrivere il percorso di una random walk sul grafo. Prima di ottimizzare le comunità, simula una random walk per calcolare le frequenze di visita ergodiche dei nodi (steady-state probabilities), usate per costruire un codebook Huffman ottimale per la descrizione del flusso.]

non è deterministico.

un ulteriore metodo è quello delle label percolation oppure label convergence. ad ogni nodo viene assegnato randomicamente un colore o una label. successivamente, inizierà ad ispezionare le label/colore dei suoi vicini. dopo aver concluso, l'ispezione al tempo t1, sceglierà il colore più frequente dei suoi vicini. se c'è un pareggio, allora ne sceglierà uno tra i più frequenti, randomicamente. questa ispezione continua finché quel nodo e tutti i suoi vicini avranno un colore. è un algoritmo molto semplice che converge velocemente. anche questo non è deterministico.

la community detection può avvenire sia su reti statiche (snapshots ad un determinato tempo), sia su reti dinamiche. con reti dinamiche assumiamo che la rete nel tempo si modifichi, e con esse, le community. questo vuol dire che un nodo può cambiare community di appartenenza, può avere nuovi archi o può scomparire del tutto. un modo naive per gestire le reti dinamiche è quello di assumere che ogni snapshot sia indipendente tra di essi e quindi calcolare atomicamente le community detection. però, ricerche trovano che i risultati possono essere molto diversi. quindi, si può ricorrere ad una funzione di _evolutionary clustering_. date le community a t e a t-1 e dato un parametro $alpha$ che rappresenta, basically, quanta importanza dare a t attuale e alla similarità di (t-1) (rispettivamente alpha, (1-alpha) ). con diversi valori di alpha possiamo avere anche molto diversi valori. tutto dipende da quanta importanza vogliamo dare agli snapshot passati. $ Q = alpha ("your fav c.d. algorithm")_t + (1-alpha) J_(t-1) $
Qui, $J$ è il Jaccard index, ovvero un indice di similarità tra due insiemi.

==== Modularity
+ *Modularity*: La modularità è una misura che valuta la qualità di una _community evaluation_ in una rete. Un alto grado di modularità significa che ci sarà un'alta densità tra i nodi nella stessa community e una densità minore tra un nodo in una community e uno all'infuori della comunità. Rappresenta la densità interna delle community. Ha anche lo scopo di ottimizzare la funzione di suddivisione in community, con l'obiettivo di massimizzare la modularità. Data $A$ la matrice delle adiacenze e $delta$ la funzione delta di Kronecker, la modularità è definita da: $ M = 1/(2|E|) sum_(i,j in V) \[A_(i j) - (deg(i) deg(j))/(2|E|) \] delta (c_i, c_j) $

il dominio va da -0.5 a +1. minimo vuol dire che c'è disassortatività totale e +1 community perfetta. 0 vuol dire che il grafo non ha struttura.

questa misura ha vari problemi nella massimizzazione. durante la max, tende a convergere quando raggiunge $sqrt(|E|)$ community. a volte aggrega community che, ad interpretazione umana, sono due community diverse. inoltre, fluttuazioni random nella struttura del grafo, fanno divergere la modularità.

=== Proprietà principali
La teoria dei grafi e la network science sono altamente interconnesse. Quest'ultima usa la teoria dei grafi per rappresentare le informazioni ed eseguire algoritmi sulle sue strutture dati. Però, per facilità di comprensione, qui ci riferiremo in particolare alle proprietà che vengono studiate in reti complesse, perché danno informazioni maggiormente su scala globale, invece che locale.

+ *Distribuzione del Grado*: Nei paragrafi precedenti, abbiamo visto cosa significa il grado di un nodo in un grafo. Se accumuliamo tutti i gradi dei nodi in una rete, possiamo calcolare la probabilità, dato un nodo in un grafo, che questo abbia grado $y$: $P(deg(x) = y) = z$. La distribuzione del grado non è altro che la distribuzione delle probabilità rispetto ai gradi dei nodi nella rete. Data una rete di $n$ nodi, la probabilità che un nodo abbia grado $k$ equivale a: $ P(k) = (n_k)/n $

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
Python è un linguaggio di programmazione interpretato, orientato agli oggetti, di alto livello con semantica dinamica. Le sue strutture dati integrate di alto livello, combinate con la tipizzazione dinamica e il binding dinamico, lo rendono molto interessante per lo sviluppo rapido di applicazioni, nonché per l'uso come linguaggio di scripting o di collegamento per connettere tra loro componenti esistenti. La sintassi semplice e facile da imparare di Python enfatizza la leggibilità e quindi riduce i costi di manutenzione dei programmi.

Python supporta moduli e pacchetti, che incoraggiano la modularità dei programmi e il riutilizzo del codice. L'interprete Python e l'ampia libreria standard sono disponibili in formato sorgente o binario gratuitamente per tutte le principali piattaforme e possono essere distribuiti liberamente.

Python, grazie alla sua estesa fornitura di librerie e alla sua rapida curva di apprendimento, è il linguaggio più usato nel contesto di Data Science ed è stato usato per la scrittura del codice il cui prodotto si trova più avanti in questa tesi.

=== NetworkX
NetworkX è una libreria Python per la creazione, la manipolazione e lo studio della struttura, delle dinamiche e delle funzioni delle reti complesse. Fornisce:

- strumenti per lo studio della struttura e delle dinamiche delle reti sociali, biologiche e infrastrutturali;
- un'interfaccia di programmazione standard e un'implementazione grafica adatta a molte applicazioni;
- un ambiente di sviluppo rapido per progetti collaborativi e multidisciplinari;
- supporto per l'accelerazione degli algoritmi e funzionalità aggiuntive tramite backend di terze parti;
- un'interfaccia per algoritmi numerici esistenti e codice scritto in C, C++ e FORTRAN;

Con NetworkX è possibile caricare e memorizzare reti in formati di dati standard e non standard, generare molti tipi di reti casuali e classiche, analizzare la struttura delle reti, costruire modelli di rete, progettare nuovi algoritmi di rete, disegnare reti e molto altro ancora.

=== NumPy
NumPy è una libreria Python nata per supportare operazioni e funzioni non banali su matrici ed array multidimensionali. Ha una licenza BSD modificata.

Fornisce API di alto livello per strutture dati complesse e moltissime funzioni matematiche eseguibili ad alto livello.

=== PyTorch
PyTorch è una libreria Python per il Machine Learning, che fornisce API ad alto livello, tramite implementazioni a basso livello, algoritmi e architetture per il deep learning, come i tensori o le discese dei gradienti stocastiche. Creato originariamente da Meta, adesso appartiene alla Linux Foundation, è open source ed è rilasciato con una licenza BSD modificata.

Il tipo di dato alla base, in _pytorch_ è un tensore, ovvero un array multidimensionale omogeneo. Si differenzia rispetto a _NumPy_ grazie al suo supporto ai CUDA, rendendoli disponibili out-of-the-box per lavorare in modo distribuito sulle GPU NVIDIA.

=== Pandas
È una libreria Python open source. Anch'essa offre strutture dati ad alto livello, più orientate all'analisi dei dati, alla manipolazione e alla visualizzazione.

Le sue strutture principali sono le _Series_ e i _DataFrame_, i primi sono array monodimensionali con un indice associato; gli ultimi, sono degli array multidimensionali con un array associato.

Alla base, hanno dei NumPy arrays, ma supportano anche dati non numerici (date, stringhe).


== Reddit
Reddit è un social network, dove gli utenti possono pubblicare post sotto forma di link, testo, immagini o video e a cui gli utenti possono commentare. Reddit è suddiviso in comunità, chiamate subreddits, infatti viene anche definito un aggregatore di comunità. Ogni subreddit viene preceduto dalla radice `r/`. Possono essere generalisti (`r/all`, `r/news`, `r/italy`, ...) oppure monotematici (`r/python`, `r/universitaly`, ...). Esistono più di 100.000 subreddits.

Il sistema di raccomandazione in Reddit è gestito tramite gli upvotes e downvotes, un giudizio che gli utenti registrati possono dare ai post e ai commenti, e che significa rispettivamente "penso che questo post (o commento) debba essere mostrato di più" e "penso che questo post (o commento) debba essere mostrato di meno".

In data Dicembre 2025, è nella top 10 dei siti più visitati al mondo, ed è il quarto social media più usato @ViewWeb.

== Procedura di costruzione della rete
Per la realizzazione delle reti, viene scaricato un dump di tutti i dati pubblici di Reddit, dalla sua creazione fino al 2025 @redditSubmissions.

E' possibile suddividere questa sezione in 6 fasi:

+ *Data Filtering*: Partendo da un file `.csv` per ogni mese, si itera attraverso tutti i post e commenti, filtrando via tutti i post, perché l'analisi e' solo sui commmenti. Successivamente, vengono mantenuti solamente i dati appartenenti a subreddit rilevanti (quindi che appartengono a subreddit politici degli Stati Uniti). Vengono anche rimossi tutti i commenti scritti da bot, ovvero utenti di Reddit che scrivono risposte automatiche in base a determinati triggers.

+ *Preliminary Network*: In questo passaggio, si inizia a dividere i messaggi in settimane. Vengono lasciati solamente i messaggi che hanno una lunghezza significativa (15 caratteri, in questo caso). Vengono mantenuti solamente gli utenti che hanno scambiato solamente una quantità di messaggi nella media; (i self loop, quindi utenti che rispondono a se stessi, non vengono contati): $ |M_u| > (sum_(u in U) |M|)/(|U|) $Successivamente, si crea una rete dove ogni nodo rappresenta un utente e ogni arco rappresenta un messaggio (utente $u$ risponde ad utente $u'$ o viceversa). Di conseguenza, se due  utenti hanno interagito molto tra di loro, ci saranno più archi che li collegano. Maggiore e' il numero di archi che li collega, maggiore e' il peso (la significativita' statistica) tra loro. Infine, viene effettuato il backboning della rete, con l'obiettivo di snellirla e renderla più gestibile. Si cerca di massimizzare il numero di nodi e minimizzare il numero di archi. Viene usato il metodo di Noise-Correction, metodo che utilizza gli archi e il loro peso. Viene restituito il Largest Connected Component.

  Inoltre, al fine di anonimizzare i dati, e rendersi conforme al GDPR, viene assegnato un nuovo id all'utente. Si mantiene una tabella di mapping globale per rendere coerente l'`id` dell'utente tra le settimane e i mesi.

+ *Topic Detection*: Per ogni rete e per ogni messaggio di ogni rete, si utilizza il modello BERTopic @grootendorst2022bertopic per classificare automaticamente ogni messaggio con l'argomento più adatto. Ogni rete preliminare, viene divisa in due sottoinsiemi rispettivamente di allenamento (training) e di classificazione. Inizialmente, il modello viene addestrato con $4096$ messaggi per ogni settimana. Dopo il training, si iniziano ad etichettare tutti i messaggi di ogni rete. I topic vengono aggregati e, manualmente, vengono esaminati, raggruppati in macrotopic e scartati quelli non rilevanti. Infine, ad ogni messaggio viene assegnato uno dei seguenti topic:
  - _abortion_: Raggruppa temi come l'aborto, i metodi contraccettivi e i diritti riproduttivi in generale;
  - _climate_: Contiene commenti riguardo il riscaldamento globale, la deforestazione, i veicoli elettrici, lobby fossili, energie rinnovabili, etc.;
  - _gender_: Commenti riguardo il femminismo, il divario retributivo di genere, l'identita' di genere, LGBTQ+, pronomi, etc.;
  - _guns_: Raggruppa temi come regole sulle armi, associazioni lobbistiche sulle armi, sparatorie di massa, suicidi, milizie, etc.;
  - _health_: Contiene commenti riguardo assistenza sanitaria, assistenza sanitaria per bambini, assicurazioni, sviluppo di farmaci, etc.;
  - _racial_justice_: Riguarda la giustizia razziale e le forze dell'ordine, in senso lato. Gli argomenti trattati includono Black Lives Matter, la polizia in generale, le richieste di defunding e gli arresti.
  - _unauthorized_immigration_: Include argomenti quali il confine degli Stati Uniti, l'espulsione o i bambini e l'immigrazione negli Stati Uniti. I post non si concentrano solo sull'immigrazione clandestina, ma possono anche trattare discussioni più ampie sugli immigrati latinoamericani.

+ *Toxicity*: Viene calcolata la tossicità di ogni messaggio, con un punteggio che varia da 0 (messaggio educato e che rispetta l'interlocutore) ad 1 (messaggio volgare, con insulti o minacce verso l'interlocutore). Viene usato il modello _Detoxify_ @Detoxify con le impostazioni di default.

+ *Stance*: Tramite un modello LLM open source, Llama 3 @llama3modelcard, viene effettuato il rilevamento dell'opinione politica che ha un messaggio. L'opinione può essere etichettata come democratica o repubblicana. Essendo una scelta binaria diventa piu' semplice effettuare una classificazione. Si inizializza un'istanza di Llama con il seguente messaggio (o prompt):```txt
    You are an expert political scientist. The following message is part of the debate on {topic} in the United States. In this debate there are two sides. Side D thinks {democratic_opinion}. Side R thinks {republican_opinion}. If the message is ambiguous, it belongs to side U. Classify the following message as belonging to side D, R, or U. You can only reply with one letter between D, R, or U, no other answer is acceptable."
  ``` Ogni topic avrà un prompt con una struttura uguale, ma con il contenuto adattato ad esso. Data la natura probabilistica degli LLM, verranno restituiti i token `R` e `D`, con le rispettive probabilità. Viene assegnato il valore $-1$ per un'opinione democratica, e $+1$ per un'opinione repubblicana. Il valore finale della posizione politica del messaggio, sarà: $p(R) - p(D)$.

+ *Final Network*: Come ultimo step, vengono create le reti finali. Le reti possono essere sia per topic, sia complete. Durante la costruzione della rete, vengono raccolti gli utenti e i relativi messaggi di una settimana; i messaggi vengono raggruppati per topic e, infine, si fa una media generale rispetto alle opinioni rilevate in base ai suoi messaggi. Nel caso in cui un utente, in una settimana, non abbia scritto abbastanza commenti significativi, tali da riuscire a calcolare un punteggio rispetto alle sue opinioni per ogni topic, si risolve il problema tramite due parametri:
  - _rolling opinion_: assumiamo che la sua opinione durante la settimana $x$ sia simile alla sua opinione alle settimane precedenti ($x-1$, $x-2$, ..., $x-n$) e vengono quindi recuperati tutti i suoi messaggi nel dataset;
  - _zombie mode_: se un utente non ha, invece, espresso opinioni su un determinato argomento, si assume che la sua posizione politica (democratica o repubblicana) su un argomento, sia analoga anche sugli altri, determinandola con una media delle sue opinioni.

  Viene restituito il componente connesso maggiore (LCC), poiché c'e' bisogno di una rete connessa con il maggior numero di nodi.

  In conclusione, viene eseguita una riduzione dei parametri tramite la Principal Component Analysis (PCA), con il fine di restituire un valore generale circa la posizione politica di un utente. In @final-network-example, un esempio di una rete finale.

#figure(
  [ciao],
  caption: "qui metto un'immagine di cytoscape con una rete di marzo 19, con i nodi che vanno da dems a reps",
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
