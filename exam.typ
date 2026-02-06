#set page(
  numbering: none,
  margin: (top: 3cm, bottom: 3cm, x: 3cm),
)

#align(center + horizon)[
  #image("assets/logo.jpg", width: 80%)
  #v(4em)

  #text(size: 24pt, weight: "bold")[Network Science: tra Fisica e Informatica]
  #v(2em)

  #text(size: 16pt)[Michele De Cillis - 24260A]
  #v(0.5em)
  #text(size: 16pt)[Esame di Fisica]
  #v(4em)

  #text(size: 12pt)[Anno Accademico 2025/2026]
  #v(0em)
  #text(size: 12pt)[30 Gennaio 2026]
]

#pagebreak()

#set page(numbering: "1")
#set heading(numbering: "1.", outlined: true)
#show bibliography: set heading(numbering: "1.")
#show heading.where(level: 1): set block(below: 1em) 
#show heading.where(level: 2): set block(below: 0.8em)
#show figure.caption: set text(8pt)


#outline(depth: 3, title: "Indice")

#pagebreak()

= Introduzione

Questa tesina esplora le ricche intersezioni di una recente scienza multidisciplinare: la _Network Science_. Sebbene riprenda concetti da moltissimi campi, anche molto distanti tra loro, ci concentreremo solamente sulla fisica (nello specifico, la _meccanica statistica_) e sull'informatica (nello specifico, algoritmi che fanno uso di _grafi_).\ #quote([Networks are everywhere]) @network_science è un'espressione che si legge spesso nei giornali, scientifici e non. Faremo un breve excursus su questo concetto, mostrando come alcuni contesti del mondo reale possano essere modellati attraverso reti.\ 
Faremo una breve introduzione su ciascuno dei concetti indicati sopra e, infine, come dimostrazione di quanto detto, concluderemo approfondendo un uso concreto di questi concetti, originati dalla fisica e poi applicati nell'analisi di reti complesse.

= Network Science

La Network Science è una disciplina che studia le reti complesse. È un campo multidisciplinare, poiché affonda le sue radici in: _matematica_ (teoria dei grafi), _fisica_ (meccanica statistica), _statistica_ (inferenza statistica), _sociologia_ (strutture sociali) e _informatica_ (data mining). Viene definita come #quote()[lo studio delle rappresentazioni di rete dei fenomeni fisici, biologici e sociali che portano alla creazione di modelli predittivi di tali fenomeni.] @nap11516

Le reti sono modellate mediante grafi, come vedremo in dettaglio più avanti, ma sono sempre composte da due elementi: nodi ($V$) e archi ($E$). Due nodi sono collegati se esiste un arco che parte dal primo nodo e arriva al secondo. Moltissime situazioni complesse possono essere modellate come reti:

- *Social Networks*: nell'informatica, è uno degli esempi più ricorrenti. I social network sono letteralmente delle reti sociali, che modellano relazioni e interazioni tra persone. È immediato pensare alle persone come nodi di una rete e alle relazioni come archi. Instagram o Twitter sono esempi di rete diretta, poiché una persona $a$ può seguire un'altra persona $a'$, ma non è detto che $a'$ ricambi. Esiste quindi un arco diretto che parte da $a$ e arriva ad $a'$, ma non viceversa;
- *Citazioni negli articoli scientifici*: ogni volta che un articolo viene pubblicato, questo contiene $n$ citazioni verso altri articoli e si aggiunge alla rete di articoli già esistenti. Ogni articolo è quindi un nodo e una citazione è un arco che collega due nodi. Anche in questo caso, la rete è diretta;
- *Interazione Proteina-Proteina*: nella biologia, si parla di _interazione proteina-proteina_ quando due o più proteine interagiscono tra di loro per mezzo di reazioni biochimiche. Queste interazioni avvengono all'interno delle cellule di un organismo vivente. In questo contesto, i nodi sono le proteine e il risultato di una reazione porta alla creazione di un arco tra le proteine.

La Network Science è esplosa dopo la pubblicazione dell'articolo di Barabási-Albert "Emergence of Scaling in Random Networks" @Baraba_si_1999: le reti reali complesse di grandi dimensioni non si sviluppano in modo casuale (la probabilità che un nodo $a$ abbia un arco verso un nodo $a'$ non è approssimabile casualmente, come veniva assunto nel modello _Erdős-Rényi_ @Erdos2022OnRG), ma seguono una _power-law degree distribution_: è più probabile che nuovi nodi che entrano nella rete cerchino collegamenti con nodi che hanno già molti collegamenti. Questo fenomeno si chiama _preferential attachment_ (ad esempio, nel WWW, un nuovo sito avrà link verso siti più grandi e conosciuti). Di conseguenza, in una rete pochi nodi (detti anche _hub_) avranno un grado elevato [@scale-free] e la maggior parte dei nodi avrà un grado basso.

#figure(
  image("assets/image.png", width: 70%),
  caption: [
    Distribuzione del grado in una rete creata usando il modello Barabási-Albert @scale_free_img.\
    $P(k)$: probabilità che un nodo abbia grado $k$\
    $k$: grado dei nodi
  ],
) <scale-free>

== Teoria dei Grafi
La teoria dei grafi è una branca della matematica e dell'informatica che modella situazioni o processi sotto forma di nodi (attori dell'evento) e di archi (interazioni tra i nodi). Questi vengono rappresentati discretamente come vettori e matrici #footnote[Liste e matrici di adiacenza.], il che consente di sviluppare analisi e algoritmi. I grafi si distinguono in diretti, dove gli archi hanno una direzione specifica dal nodo $a$ al nodo $a'$, e non direzionali, dove invece gli archi non hanno una direzione e quindi non è possibile distinguere il verso del collegamento tra nodo $a$ e nodo $a'$.\
Formalmente, definiamo un grafo: $G = (V, E)$
dove:
- $V = {V_1, V_2, ...}$ è un insieme di nodi
- $E subset.eq {{x, y} | x, y in V and x eq.not y}$ è un insieme di archi non diretto, *oppure*
  - $E subset.eq {{x, y} | (x, y) in V^2 and x eq.not y}$ è un insieme di archi diretto

I grafi vengono usati per modellizzare moltissime relazioni e processi in numerosi campi. Nell'informatica stessa, i grafi sono stati fondamentali per permetterci di sviluppare sistemi operativi multiutente e multiprocesso (nell'ambito della gestione delle risorse) @peterson-operating-system-concepts-1985 e per poter espandere internet globalmente e senza sosta (routing dei pacchetti) @ford-fulkerson-maximal-flow-1956 @dijkstra-note-two-problems-1959 @ford-network-flow-theory-1956.

== Meccanica Statistica

La meccanica statistica è un campo della fisica che studia il collegamento tra le singole proprietà delle particelle e i comportamenti macroscopici di un sistema, fornendo modelli probabilistici che descrivono le interazioni tra componenti elementari (particelle, molecole) e fenomeni macroscopici (deterministici, come l'acqua che passa dallo stato liquido a quello gassoso _sempre_ #footnote[A meno che non vengano cambiate le condizioni di pressione.] a 100°C).\
Dato un sistema composto da $N$ particelle, $x_i$ è lo stato della $i$-esima particella. Lo stato rappresenta una proprietà della particella (posizione, velocità, ecc.). Quindi, dato $x$ come l'insieme degli stati delle particelle, chiamiamo $H(x)$ la funzione hamiltoniana che restituisce l'energia totale del sistema. Lo stesso valore di energia totale può essere ottenuto da combinazioni diverse di microstati, ma il macrostato rimane invariato: si tratta semplicemente di diverse realizzazioni dello stesso macrostato.

La probabilità di trovare un sistema in una determinata configurazione $x$, è dato dalla distribuzione di Boltzmann: $ p(x) = 1/(Z beta) exp(- beta H(x)) $

dove $beta$ è l'inverso della temperatura e $Z(beta)$ normalizza la funzione di distribuzione, in modo tale che: $ Z = sum_i^N P(x) = 1 $
#v(3em)
La meccanica statistica è uno strumento fondamentale per studiare i sistemi complessi e, di conseguenza, ha trovato applicazione nella Network Science. Data una rete complessa, i comportamenti macroscopici corrispondono alle proprietà globali del grafo (es. l'_average degree_ oppure la _degree distribution_), mentre l'insieme di tutti i grafi possibili che rispettano quel vincolo costituisce l'insieme dei microstati.

La distribuzione di Boltzmann e la funzione Hamiltoniana di cui sopra, possono essere usate per rappresentare l'equivalente di un Exponential Random Graph (indiretto) @Park_2004:

$ H(G) = sum^N_(i=1) Theta_i X_i (G) $ e $ Z = sum_(G in cal(G))e^(-H(G)) $

dove $G$ è un grafo all'interno dell'insieme di grafi $cal(G)$ di $N$ nodi.

A livello mesoscalare, una caratteristica dei nodi ampiamente studiata è quella della community detection, ovvero come i nodi con caratteristiche simili possano essere raggruppati in partizioni. È più probabile che due nodi della stessa community si connettano tra loro rispetto a due nodi di community differenti.

Sebbene vi siano numerosissimi metodi per trovare community in una rete, il problema può essere inquadrato nell'ambito della meccanica statistica @Reichardt_2006. Le comunità vengono identificate con stati di spin #footnote[Lo spin è il momento angolare intrinseco di una particella. È matematicamente descritto come un vettore per i fotoni e come uno spinore per gli elettroni.] di un modello di Potts #footnote[Il modello di Potts è un modello matematico di meccanica statistica che generalizza il modello di Ising, usato per descrivere sistemi con “spin” che possono assumere $q$ stati distinti invece di soli due.], con uno stato per ogni community possibile.

Successivamente, viene costruita una Hamiltoniana che premia i nodi appartenenti alla stessa community e penalizza quelli di community diverse, confrontandoli con un null model graph #footnote[Un null model graph è un grafo _casuale_ che riproduce alcune proprietà specifiche di un grafo reale (es. la distribuzione del grado).].\
A questo punto, il problema diventa quello di trovare la configurazione di spin che minimizza l'energia del sistema, ovvero il ground state #footnote[Il ground state è l'autovalore minimo dell'operatore Hamiltoniano, ovvero lo stato con la minore quantità di energia possibile.] di un vetro di spin #footnote[Modello di Sherrington-Kirkpatrick (SK), un vetro di spin dove ogni spin interagisce con tutti gli altri spin del sistema tramite accoppiamenti casuali ferro e antiferromagnetici. Non esiste una configurazione unica di spin che minimizzi globalmente l'energia a causa dei conflitti tra interazioni concorrenti, con la conseguenza di avere numerosi stati con la stessa energia minima.] a raggio infinito #footnote[L'intensità media delle interazioni tra gli spin è costante, senza decadimento con la distanza.
].

Ad esempio, se $A_(i j)$ è la matrice di adiacenza e $p_(i j)$ è la probabilità di un collegamento tra $i$ e $j$ nel null model, l'energia è data da:

$ H = - sum_(i eq.not j) (A_(i j) - gamma p_(i j)) delta_(sigma_i sigma_j) $

dove $sigma$ è l'insieme degli spin state, $delta$ è il Delta di Kronecker e $gamma$ è il parametro di risoluzione, che bilancia il peso dato ai link esistenti e ai link mancanti.

Un vantaggio dell'uso di modelli generalizzati di sistemi complessi per reti reali è la possibilità di effettuare _edge inference_ nella ricostruzione di reti da dati parziali, selezionando l'insieme di microstati che presenta la maggiore corrispondenza con i vincoli noti della rete, pur massimizzando l'entropia #footnote[L'entropia misura il numero di modi diversi (microstati) in cui un sistema fisico può realizzare lo stesso stato macroscopico osservabile: $S = k ln W$. Massimizzare l'entropia significa, quindi, trovare lo stato più probabile del sistema. In questo caso, vuol dire trovare archi (microstati) che, date le proprietà di una rete (macrostati), dovrebbero esser presenti per rispettare queste proprietà.].\ Questo permette di correggere il bias e il rumore quando si effettua il backboning #footnote[Effettuare il backboning di una rete significa rimuovere connessioni e nodi non significativi, al fine di renderla più piccola e più adatta a essere elaborata e analizzata.] di una rete reale complessa @DESMARAIS20121865.

Gli strumenti della meccanica statistica sono utili anche per catturare comportamenti dinamici in una rete.\ Ad esempio, le reti possono mostrare una phase transition analoga a quelle dei sistemi fisici. Consideriamo i Giant Connected Components (GCC), ovvero sottografi che comprendono la maggior parte dei nodi in una rete: in un random graph, data la probabilità $p$ che un nodo sia connesso con un altro, al di sotto di una certa soglia di $p$ la quantità di nodi nel Largest Connected Component sarà molto bassa, ma appena superata quella soglia si forma un GCC @coscia2021atlas.

Infine, tramite modelli come l'Ising model #footnote[Il modello di Ising è un modello ideato per descrivere il magnetismo nei materiali ferromagnetici attraverso spin che assumono solo due stati discreti, +1 o -1.], viene usato per analizzare il diffondersi opinioni o di dati nella rete (ad es. la diffusione di un virus nella popolazione) @Cimini2019.

#pagebreak()

= Case Study: Magnetic Laplacian

Nella teoria dei grafi, la matrice laplaciana è uno strumento per analizzare le proprietà di un grafo. Per un grafo non diretto $G = (V, E)$, la matrice laplaciana è definita come:
$ L = D - A $
dove $D$ è la matrice dei gradi (diagonale, con $D_(i i) = "deg"(v_i)$) e $A$ è la matrice di adiacenza #footnote[ $A_(i j) = 1$ se c'è un arco tra $i$ e $j$, $A_(i j) = 0$ altrimenti.] .

Questa matrice è _simmetrica_ e _semidefinita positiva_: i suoi autovalori sono tutti reali e non negativi, permettendo l'uso di tecniche di _spectral clustering_ #footnote[L'analisi degli autovalori e autovettori della matrice laplaciana o della Similarity Matrix.] per identificare community nella rete. In particolare, il secondo autovalore più piccolo (detto _Fiedler value_ o _algebraic connectivity_) e il suo autovettore associato forniscono informazioni sulla struttura della rete.

Il problema sorge quando si vogliono analizzare _grafi diretti_. In una rete diretta, se esiste un arco da $i$ a $j$, non è detto che esista un arco da $j$ a $i$. Questo rende la matrice di adiacenza _asimmetrica_ e, di conseguenza, anche la matrice laplaciana diventa asimmetrica. Gli autovalori di una matrice asimmetrica possono essere numeri complessi, rendendo l'interpretazione più difficile.

Una soluzione banale sarebbe ignorare la direzione degli archi, simmetrizzando la matrice. Così facendo, però, si perde informazione: in molte reti reali (citazioni, follower sui social, flussi economici), la direzione è fondamentale per capire la struttura della rete.

== Origine Fisica

Nella meccanica quantistica, quando una particella carica (come un elettrone) si muove in presenza di un campo magnetico, il suo comportamento viene descritto da un operatore chiamato _hamiltoniana magnetica_. L'idea chiave è che il campo magnetico introduce una _fase complessa_ nel sistema.

Consideriamo un elettrone che si muove su un reticolo (una griglia di punti). Se non c'è campo magnetico, l'elettrone può "saltare" da un punto $i$ a un punto $j$ con una certa probabilità. In presenza di un campo magnetico, questo salto acquisisce una fase complessa $e^(i theta_(i j))$, dove $theta_(i j)$ dipende dal campo magnetico e dalla posizione dei punti.

Se l'elettrone va da $i$ a $j$, acquisisce la fase $e^(i theta_(i j))$; se va da $j$ a $i$, acquisisce la fase _coniugata_ $e^(-i theta_(i j))$. Questa asimmetria nella fase codifica una direzione, analogamente a quanto avviene in un grafo diretto.

L'operatore che descrive questo sistema si chiama _Magnetic Laplacian_. La sua proprietà fondamentale è che, nonostante introduca fasi complesse, rimane una matrice _hermitiana_ #footnote[Una matrice hermitiana è l'analogo complesso di una matrice simmetrica: $H = H^dagger$, dove $H^dagger$ è la trasposta coniugata.]. Questo garantisce che tutti gli autovalori siano reali, permettendo di usare le stesse tecniche spettrali che funzionano per grafi non diretti.

== Definizione e Proprietà

Dato un grafo diretto con pesi reali $w_(i j)$ (che può anche essere 0 se l'arco non esiste), definiamo prima la matrice di adiacenza simmetrizzata:
$ A^("sym")_(i j) = w_(i j) + w_(j i) $
e la corrispondente Laplaciana simmetrizzata:
$ L^("sym") = D^("sym") - A^("sym") $
dove $D^("sym")_(i i) = sum_j A^("sym")_(i j)$.

Per codificare la direzione degli archi, introduciamo una _matrice di fase_ Hermitiana $Gamma$, i cui elementi sono:
$ Gamma_(i j) = e^(i 2 pi q (w_(i j) - w_(j i))) $
dove $q in [0, 1]$ è un parametro chiamato "carica" (in analogia con la carica elettrica della particella nel campo magnetico). Notiamo che:
- Se $w_(i j) = w_(j i)$ (arco bidirezionale o nessun arco), allora $Gamma_(i j) = 1$
- Se $w_(i j) > w_(j i)$ (arco prevalentemente da $i$ a $j$), allora $Gamma_(i j)$ ha una fase positiva
- $Gamma_(j i) = overline(Gamma_(i j))$ (coniugato complesso), garantendo che $Gamma$ sia Hermitiana

Il _Magnetic Laplacian_ è definito come il prodotto di Hadamard #footnote[Il prodotto di Hadamard (denotato $circle.small$) è la moltiplicazione elemento per elemento tra due matrici: $(A circle.small B)_(i j) = A_(i j) dot B_(i j)$.] tra la Laplaciana simmetrizzata e la matrice di fase:
$ L^((q)) = L^("sym") circle.small Gamma $

Più esplicitamente, gli elementi della matrice sono:
$ L^((q))_(i j) = cases(
  D^("sym")_(i i) & "se" i = j,
  -(w_(i j) + w_(j i)) e^(i 2 pi q (w_(i j) - w_(j i))) & "se" i eq.not j
) $

La Magnetic Laplacian eredita le proprietà della laplaciana classica, pur codificando informazione direzionale:

+ _Hermiticità_: $L^((q))$ è hermitiana per costruzione, quindi i suoi autovalori sono reali
+ _Semidefinita positiva_: tutti gli autovalori sono $gt.eq 0$
+ _Caso limite_: per $q = 0$, si ottiene la laplaciana simmetrizzata classica (senza informazione direzionale)

La scelta del parametro $q$ è rilevante: con $q = 1/4$, una fase di $plus.minus pi/2$ corrisponde ad archi puramente unidirezionali. Valori diversi di $q$ permettono di esplorare la struttura della rete a diverse "scale di direzionalità".

L'analogia fisica ci aiuta nell'interpretazione: i nodi corrispondono a punti su un reticolo e gli archi diretti a un "campo magnetico" che influenza il movimento sulla rete. Le community corrispondono a regioni dove il "flusso" è coerente.

== Community Detection con Magnetic Eigenmaps

Gli autovettori della matrice, chiamati _magnetic eigenmaps_, incorporano informazione strutturale sulla rete. Fanuel et al. @fanuel2017magnetic propongono di usare questi autovettori per il clustering spettrale di grafi diretti.

L'algoritmo funziona così:
+ Calcolare la Magnetic Laplacian $L^((q))$ per un valore di $q$ appropriato;
+ Calcolare i primi $k$ autovettori (quelli con autovalori più piccoli);
+ Ogni nodo viene rappresentato come un punto in $CC^k$ (spazio complesso $k$-dimensionale) usando i valori degli autovettori;
+ Applicare un algoritmo di clustering (es. $k$-means adattato per numeri complessi) su questi punti.

Questo approccio è particolarmente efficace per trovare due tipi di community:
- _Community dense_: gruppi di nodi fortemente connessi tra loro (come nel caso indiretto)
- _Community di ruolo_: nodi con pattern di connessione simili, anche se non direttamente connessi (es. nodi "sorgente" che hanno molti archi uscenti vs nodi "pozzo" che hanno molti archi entranti)

== Connessione con la Meccanica Statistica

Come visto nella sezione sulla meccanica statistica, la community detection può essere formulata come un problema di minimizzazione dell'energia in un sistema di spin.

Gli autori usano la temperatura @fanuel2017magnetic (specificamente $beta = 1/T$) per controllare quali configurazioni energetiche contano in un sistema. La loro matrice di densità $p_beta$ codifica la struttura della rete a qualunque scala imponga il parametro di temperatura.

A diverse temperature, emergono strutture di community a scale diverse:
- _Bassa temperatura_ (alta $beta$): il sistema tende al ground state, evidenziando le strutture più stabili;
- _Alta temperatura_ (bassa $beta$): strutture più fini e locali diventano visibili.

La magnetic laplacian che costruiscono ha modi propri con diversi autovalori, che fungono da livelli energetici. Una funzione di partizione, normalmente usata in fisica per sommare tutti gli stati possibili pesati per energia, viene adattata qui in modo che la temperatura decida quali tratti strutturali dominano il rilevamento di comunità. L'intero apparato permette di analizzare diverse gerarchie delle comunità solo cambiando un parametro.

= Conclusioni

In questa tesina abbiamo esplorato le connessioni tra la Network Science e due dei suoi campi fondanti: la meccanica statistica e la teoria dei grafi. La prima è fondamentale per l'analisi dei sistemi complessi, permettendo di suddividere una rete in macrostati (le proprietà globali) e microstati (le proprietà locali); la seconda ci fornisce gli strumenti, sia algoritmici che strutturali, per studiare questo paradigma.

Il case study sulla Magnetic Laplacian ha mostrato come un operatore nato nella meccanica quantistica possa essere adattato per analizzare grafi diretti, mantenendo le proprietà spettrali della laplaciana classica. La fase complessa che descrive l'effetto di un campo magnetico su un elettrone diventa lo strumento per codificare la direzione di un arco.

Sia la fisica statistica che la Network Science studiano sistemi composti da molte parti interagenti, cercando di capire come comportamenti macroscopici emergano da regole locali. Gli strumenti matematici sviluppati in un contesto trovano applicazione nell'altro.

#bibliography("works.yaml", title: "Bibliografia", style: "american-physics-society")