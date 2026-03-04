#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/subpar:0.2.2" as subpar: grid as subpar-grid

// Page setup
#set page(
  paper: "a4",
  margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in),
)

// Font and text setup
#set text(
  font: "New Computer Modern",
  size: 12pt,
  lang: "en",
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

#set math.equation(numbering: "(1)")
#show figure.caption: set text(10pt)

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
  image("images/logo.jpg")
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
      *Supervisor:*\
      #relatore

      #if correlatore != none [
        \
        *Co-supervisor:*\
        #correlatore
      ]
    ],
    [
      *Thesis by:*\
      #author\
      Student ID: #matricola
    ],
  )

  v(1fr)

  // Academic year
  text(size: 14pt)[
    Academic Year #anno
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
  // dept: [Bachelor's Degree in Computer Science],
  dept: [BACHELOR'S DEGREE IN COMPUTER SCIENCE],
  anno: [2024-2025],
  matricola: [24260A],
  relatore: [Prof.ssa Elena CASIRAGHI],
  correlatore: [Prof. Michele COSCIA],
)

#set page(numbering: "i")
#counter(page).update(1)

#prefacesection("")[
  #align(right)[
    #text(size: 14pt, style: "italic")[dedicated to ...]
  ]
]


// #show outline.entry: it => {
//   block([
//     *Debug:* #repr(it) \
//     #it
//   ])
// }
// #show outline.entry: it => text(
//   [
//     #it.indented(
//       it.prefix(),
//       it.body()
//         // + sym.space
//         + box(width: 1fr, it.fill)
//         // + sym.space
//         + it.page(),
//     )],
// )

#outline(
  title: [Table of Contents],
  depth: 2,
)

#outline(
  title: [List of Figures],
  target: figure.where(kind: image),
)

#pagebreak()

= Introduction
#quote[This section, to be written when the thesis is finished...]

Something like: in this thesis we will see etc... In the first chapter ... etc.

== NERDS: Network, Data and Society
NERDS is the research group where I carried out my internship. It is an interdisciplinary research group studying Network Science, Artificial Intelligence (AI) and Computational Social Science (CSS). The environment is also interdisciplinary: it has students, PhD candidates, PostDocs and professors with backgrounds in physics, computer science, mathematics and sociology. It is located in Copenhagen, at the IT-Universitetet i København (ITU). Research interests include, among others: science of science, social networks, complex networks, urban sustainability, urban and human mobility, data visualization and fundamental aspects of complex systems.

== Computational Social Science
Computational Social Science (CSS) is a science that studies classical social sciences (sociology, anthropology, economics and political science) through the use of modern tools to explore them with innovative approaches and at large scale.\
CSS uses two main approaches: an _empirical_ one, which leverages big data to generalize problems and return useful analyses and inferences for research, and a _scientific_ one, which allows the creation of models and simulations of certain phenomena. Furthermore, in recent years, thanks to the explosion of artificial intelligence, tools such as Natural Language Processing (NLP) or the more recent Large Language Models (LLMs) have accelerated research, thanks to their ability to annotate data with higher accuracy than a non-expert human; consequently, it has become possible to automate such tasks that would otherwise have required a large amount of time #footnote[Manually annotating millions of data points can compromise the feasibility of a project @Sylolypavan2023-ov.] or money #footnote[Services such as Amazon Mechanical Turk (https://www.mturk.com/) can be costly for laboratories with limited funding.]. In subsequent chapters, we will provide a concrete example of automatic annotations using NLP models first and LLMs later, which proved very useful in the project for classifying the toxicity and political opinion of messages sent by users. We will also show a test to measure the reliability of the models used.

In this thesis we will use an empirical CSS approach; we will analyze data from a social network (Reddit) to determine its political polarization. In the following chapters, we will therefore introduce the concept of polarization (at a sociological level) and Network Science, a science that studies complex networks.

== Thesis Objectives

The initial work performs an extensive analysis of Reddit's political subreddits (i.e., communities, which we will discuss in detail in the next chapter) over time, showing how they have changed over the years, the distribution of Democrats and Republicans, and how users' opinions have changed over time on seven topics (_abortion_, _climate change_, _gender identity_, _gun control_, _healthcare_, _racism_ and _immigration_), which have become increasingly divisive in the American public debate. It also analyzes the ideological and affective polarization of this social network, phenomena that have led Reddit users to interact only with users who share similar ideas.\
This study focuses on the American context, since more than 50% of users who visit the site daily are American and we have a large amount of data available to analyze.

A network is formed by a set of nodes, representing users, and a set of edges, indicating that two users have had a significant interaction with each other.

The limitation of the initial project was representing networks as undirected networks, thus losing the directionality of information. My work is therefore part of an expansion of the initial project, namely the support of directed networks and, subsequently, the analysis of the new results to verify whether they are, first of all, reliable and consistent with what would be expected and, secondly, whether they can be useful to better understand the initial network, giving us information that we did not have before.\
My work focuses mainly on computing polarization, using a new method that allows the Laplacian matrix to be computed on directed networks. Furthermore, we will try to extend the computation to signed networks as well: the heuristic is that, if a message exceeds a certain toxicity level, then the interaction between two users is considered negative, and therefore has a different score. Intuitively, we expect ideological polarization to increase.

In summary, we want to understand whether it makes sense to add complexity by supporting directed networks, or whether with undirected networks we can obtain a satisfactory approximation.

Usually, in Network Science, simple (undirected) networks are preferred, since it is complicated to adapt all measures to directed networks and, in some cases, it is not even possible. The ultimate goal is to add another piece to the great puzzle of generalization and understanding of complex systems.

#pagebreak()

= State of the Art

== Social Network Analysis
Social Network Analysis (SNA) is not a proper theory, but rather a general strategy for analyzing social structures. It originated well before computer science, in the field of sociology, with the aim of studying people's behavior based on the context they are in. The relationships between the "actors" of a network are the priority; nonetheless, the individual properties of an actor are necessary to analyze social phenomena.

Thanks to the large-scale diffusion of technology and the increasing performance of computers, SNA has found a synergy with computer science. Currently, SNA focuses on the study of social networks such as Facebook, Twitter (X) and Reddit, among the main ones, given the large amount of data available.\
The increasing performance of computers has helped SNA by providing a mathematical and practical tool for carrying out analyses. By modeling networks through graph theory (borrowed from algebra), computer science has provided the ability to run complex algorithms on large networks with thousands or millions of nodes in relatively little time.

Another aspect of SNA is the study of how social structures influence a person's behavior. Two types of SNA are distinguished: ego network analysis, in which an "_ego node_" is identified in a network and all properties of that network restricted to adjacent nodes, up to a certain degree, are studied @coscia2021atlas; and global network analysis, where instead a single node is not considered but one tries to study all relationships between participants in the network.

=== Polarization

Polarization refers to the tendency of a group to make more divisive and extreme decisions compared to the individual initial opinions of its members. It also refers to the phenomenon whereby members of a group reinforce their opinions after having a discussion on a given topic.

It is an important phenomenon in social psychology and is found in many contexts. Discussion of polarization began in the 1960s, when the "risky-shift" @myers1976group was studied, i.e., the tendency of a group to make riskier decisions compared to the same individual decisions made by each member of that group.\
In more recent years, the internet and social media have brought a new context in which to study polarization. Researchers have demonstrated how, through social networks, episodes of polarization can occur even when people are not physically close.

For the purposes of this thesis and internship, we will specifically discuss political polarization, a phenomenon in which a person's — or a party's — political opinions diverge from the center, reaching extreme positions. We can therefore say that there is little or no intersection between the positions of the parties considered. Academics distinguish it into _ideological polarization_, i.e., the differences between political positions, and _affective polarization_.

*Ideological Polarization*: refers to the increase in the difference between individuals' political positions and, consequently, reduced dialogue.

*Affective Polarization*: measures a person's aversion to interacting with people with different political ideas.

Initially they were measured with surveys @measure-affective-pol, where people answered questions about attitudes toward opposing parties, but also about behaviors they would engage in toward people from an opposing party (would they be friends? would they be happy to have them as neighbors?). Nowadays, it is possible to measure polarization also by analyzing social networks @hohmann2025estimating, which, unlike surveys, measure behaviors that have actually occurred, and at large scale.

Within the thesis, we will analyze and quantify only ideological polarization, through the _node vector distance_ measure.

== Graph Theory

Graph theory is a branch of mathematics and computer science that models situations or processes in the form of nodes (actors of the event) and edges (interactions between nodes).

A graph is said to be directed (also called a _digraph_) when the edges connecting the nodes have a direction; otherwise, it is called undirected.

Formally, we define a graph: $ G = (V, E) $
where:
- $V = {V_1, V_2, ...}$ is a set of nodes
- $E subset.eq {{x, y} | x, y in V and x eq.not y}$ is a set of undirected edges, *or*
- $E subset.eq {{x, y} | (x, y) in V^2 and x eq.not y}$ is a set of directed edges

These can be represented, as data structures, with an adjacency list or an adjacency matrix. The adjacency list associates with each node $i$ the list of all nodes $i'$ toward which an edge exists. It requires $Theta(V + E)$ memory space.

The adjacency matrix $M$, instead, uses an $N times N$ matrix, where $N$ is the number of nodes: $ M = cases(
  M_(i j) = 0 arrow.double.r exists.not (i, j) in E,
  M_(i j) = w arrow.double.r exists (i, j) in E
) $

where $w$ is the weight of edge $(i, j)$. It requires $Theta (V^2)$ memory space.

Graphs are used to model a great many relationships and processes in numerous fields. In computer science itself, graphs have been fundamental in allowing us to develop multi-user and multi-process operating systems (in the context of resource management) and to expand the internet globally and continuously (packet routing) #footnote[add citations].

=== Main Properties

Given an undirected graph $G = (V, E)$ and a directed graph $G_1 = (V, E_1)$, they exhibit the following properties:

+ *Degree*: The degree of a node is the number of edges incident to it. Given a node $x in V$, it is defined as: $ deg(x) $ In the case of digraphs, the $deg_(i n) (x)$ and $deg_(o u t) (x)$ are distinguished, respectively the number of incoming and outgoing edges.

+ *Walk*: A walk is a sequence of nodes $v_1, v_2, ..., v_n$ such that two consecutive nodes in the sequence are adjacent: $ w = {v_1, v_2, ..., v_n } $

+ *Paths*: A path is a walk where all nodes in the sequence are distinct: $ p_1 = { w_1, w_2 in w | w_1 eq.not w_2 } $

+ *Cycles*: A cycle is a path where the starting and ending nodes are the same:$ p_2 = { (i, e_1), (e_1, e_2), ..., (e_n, i) } $

+ *Clique*: A clique is a partition of a graph $G$ such that, for every pair of nodes in the partition, there exists an edge connecting them. $ c = { i,j in V | (e_i, e_j) exists in E or (e_j, e_i) exists in E } $

+ *Connected Components*: A connected component of a graph $G$ is a subgraph in which any pair of nodes is connected by a walk and which is not part of a larger connected subgraph.

+ *Distance*: The distance between two nodes equals the number of edges in a shortest walk connecting them.

+ *Diameter*: The diameter of a graph is also called the _longest shortest path_, i.e., the maximum distance between two nodes in a graph.

+ *Trees*: A tree is an undirected graph where every pair of vertices is connected by exactly one path.

+ *Bipartite Graphs*: A graph is said to be bipartite if it can be divided into two disjoint subsets $G'$ and $G''$, where every edge of $G'$ connects nodes of $G''$.

+ *Density*: The density of a graph indicates how connected it is. If every node is connected to all others, we have a complete graph. Conversely, a graph with few edges relative to nodes is called sparse. For an undirected graph, density is defined as: $ d = (2 * |E|)/(|V|(|V|-1)) $

== Network Science

Network Science is a science that studies complex networks. It is a multidisciplinary field because it has its roots in _mathematics_ (graph theory), _physics_ (statistical mechanics), _statistics_ (statistical inference), _sociology_ (social structures) and _computer science_ (data mining). It is defined as #quote()[the study of network representations of physical, biological and social phenomena leading to predictive models of these phenomena.] @nap11516

Many complex situations can be modeled as networks:

- *Social Networks*: in computer science, this is one of the most recurring examples. Social networks are literally social networks, modeling relationships and interactions between people. It is immediate to think of people as nodes of a network and relationships as edges. Instagram or Twitter are examples of directed networks, since a person $a$ can follow another person $a'$, but it is not necessarily the case that $a'$ reciprocates. There is therefore a directed edge starting from $a$ and arriving at $a'$, but not vice versa;
- *Citations in scientific articles*: every time an article is published, it contains $n$ citations to other articles and is added to the network of already existing articles. Each article is therefore a node and a citation is an edge connecting two nodes. In this case too, the network is directed;
- *Protein-Protein Interaction*: in biology, _protein-protein interaction_ occurs when two or more proteins interact with each other through biochemical reactions. These interactions take place inside the cells of a living organism. In this context, the nodes are the proteins and the result of a reaction leads to the creation of an edge between the proteins.

Network Science exploded after the publication of the Barabási-Albert paper "Emergence of Scaling in Random Networks" @Barabasi1999Emergence: large real-world complex networks do not develop randomly (the probability that a node $a$ has an edge toward a node $a'$ cannot be approximated as random, as was hypothesized in the _Erdős-Rényi_ model @ErdosRenyi2022OnRandomGraphs), but follow a _power-law degree distribution_: it is more likely that new nodes entering the network seek connections with nodes that already have many connections. This phenomenon is called _preferential attachment_ (for example, on the WWW, a new website will have links to larger and more well-known sites). Consequently, in a network few nodes (also called _hubs_) will have a high degree and most nodes will have a low degree.

Graph theory and Network Science are highly interconnected. The latter uses graph theory to represent information and run algorithms on its data structures. However, for ease of understanding, in the following paragraphs we will refer in particular to properties that are useful in Network Science.

=== Degree Distribution
The degree distribution is the probability distribution of the degrees of nodes in the network. Given a network of $n$ nodes, the probability that a node has degree $k$ is: $ P(k) = (n_k)/n $

=== Laplacian Matrix
The Laplacian matrix $L$, also called the Laplacian, is a matrix that represents the topological information of a graph or a network. Given an undirected graph $G = (V, E)$, from which the adjacency matrix $A_G$ and the degree matrix $D_G$ are derived, the Laplacian matrix $L_G$ is obtained by subtracting the degree matrix from the adjacency matrix: $ L_G = D_G - A_G $
L_G$, of dimensions $|V|times|V|$, is symmetric and the sum of all rows and columns equals $0$: $ sum_(i = 0 in |V|) L_(i j) = 0 $ and $ sum_(j = 0 in |V|) L_(j i) = 0 $
In a directed graph, instead, the Laplacian matrix uses either the indegree matrix or the outdegree matrix, respectively $D_(G_(i n))$ and $D_(G_(o u t))$. Therefore, it is not symmetric and, consequently, invalidates the properties of the Laplacian that we will see in the following paragraphs and that give the measure its purpose. Thus, it is usually symmetrized or the graph is treated as an undirected graph.

A Laplacian matrix always satisfies the following properties:
- It is symmetric: $L_(i j) = L_(j i)$;
- It is positive semidefinite, i.e., all eigenvalues $lambda_1, lambda_2, ... lambda_n >=0$;
- $lambda_0 = 0$;
- The sum of all rows is $0$: $sum_(i = 0 in |V|) L_(i j) = 0$;
- The sum of all columns is $0$: $sum_(j = 0 in |V|) L_(j i) = 0$

The Laplacian matrix has numerous applications in graph theory and network science. The study of its eigenvalues and eigenvectors allows performing _spectral analysis_, which provides important information about the network structure, or for _community evaluation_. It allows computing the _node distance vector_, i.e., the diffusion of a node property within the network @node-distance-vector. Furthermore, it finds many applications in physics, the field from which it originated, to mathematically model electrical networks @doyle2000randomwalkselectricnetworks. It is also used to find the number of Spanning Trees in a graph in polynomial time @kirchoff-theory.

There are several variants of the Laplacian, each adapted to different uses. For example, there is the normalized Laplacian, a matrix that normalizes node degrees, useful when there is a marked inequality in node degrees, as in scale-free networks. There is also the Laplacian matrix constructed through the incidence matrix (a matrix that encodes the relationships between nodes and edges), used for weighted-edge networks. Finally, we have the _magnetic Laplacian_, a matrix representing a directed graph by treating edge directions as a phase in a complex plane. We will explore it in the following paragraphs, as it is a central part of the thesis project.

=== Null Model
The _null model_ is a network model that is used as a benchmark against a real network. It is randomly generated starting from some properties of a real network (e.g., density, degree distribution, assortativity, ...). It is used to attribute a specific behavior of a network to a restricted group of properties, randomly generating networks that have those individual properties. Furthermore, it can be used to find correlations between properties on particular networks: if given a real network with property $X$ (e.g., average degree = 4), $Y$ occurs (e.g., homophily increases), then random networks with property $X$ (average degree = 4) will be generated to verify the presence of $Y$.

A null model can be random or generative @Váša2022. The random model is the most common: it is usually obtained through the rewiring method, where, given a set of edges, these are randomly rewritten while preserving the degree of each node. An example is shown in @rewiring-null-model. Instead, with the generative approach, given null hypotheses that must be met, a partition of the initial network is taken and new nodes and edges are added until the initially defined null hypotheses are reached.

#figure(
  diagram(
    node-stroke: .1em,
    spacing: 3em,
    node((0, 0), `A`, radius: 1em),
    edge(``, "-", stroke: 0.1em),
    node((1, 0), `B`, radius: 1em),
    edge(``, "-", stroke: 0.1em),
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
  caption: [Above: before rewiring. Below: after rewiring],
) <rewiring-null-model>

=== Generative Network Models <H-graph-generative-model>
Generative network models are stochastic mathematical models designed to simulate the formation of complex networks. There are several models, depending on the research objective and the analysis to be performed. Like _null models_, they are used to test and generalize properties and mechanisms of a real network on random networks. Among the best known models are:

+ *Stochastic Block Model*: a generative graph model that tends to create graphs whose nodes are grouped into communities @HOLLAND1983109. Given $n$ the number of nodes, $k$ the number of communities, and a matrix $P = k times k$ of probabilities. The matrix $P$ represents the probability that two nodes from different communities are connected by an edge;
+ *Barabási-Albert*: a model that generates scale-free networks @Barabasi1999Emergence, with properties analogous to real networks, such as _preferential attachment_. The algorithm accepts a parameter $n$, i.e., the number of nodes, and a parameter $m$, i.e., the number of edges connecting to an already existing node of higher degree;
+ *Erdős-Rényi*: a model for random network generation, given a probability $p$ and $n$ nodes, each node connects to another with probability $p$ @ErdosRenyi2022OnRandomGraphs;
+ *Watts-Strogatz*: a generative model that overcomes the limitations of the Erdős-Rényi model, as it favors the generation of hubs, as in the Barabási-Albert model. Each node has a very small average shortest path. Given a parameter $beta in [0, 1]$ and $k$ the number of neighbors of each node, arranged in a ring topology, each edge is redirected to another node with probability $beta$ @Watts1998;

=== Backboning
Real networks are full of noise, i.e., edges and nodes that have no statistical significance and can contaminate results. It is therefore necessary to use a method to remove the noise from the network and keep only the significant elements. This technique is called _backboning_. It arises from the need to keep only the relevant structures and hierarchies in a network, so that it is easier to analyze and also more computationally economical.

With backboning, a global focus is maintained, to highlight the _highways_ of a network, i.e., those paths that are important for circulating information. Backboning has a function analogous to _Principal Component Analysis_ in statistics.

There are various backboning algorithms, depending on the phenomena to be highlighted and subsequently analyzed. Some algorithms consist of: finding the _minimum spanning tree_ @backbone-tree-filter, using a _disparity filter_ @backbone-tree-filter, deriving the _salience skeleton_ @Grady2012 or the _noise correction_ method @noise-corrected-backboning. In this thesis we will only explore the last method, as it is the one used in this project.

The Noise-Correction (NC) algorithm @noise-corrected-backboning is based on the assumption that each edge is an interaction between nodes. If an edge is to be retained, it must reach or exceed a certain threshold of statistical significance.

Given a graph $G=(V, E, N)$, where $V$ is the set of nodes, $E$ is the set of edges and $N$ is the set of weights and $N subset.eq RR$, with $N_(i .) = sum_(i in E) N_(i j)$ and $N_(. j) = sum_(i in E) N_(i j)$ and therefore $N_(. .) = sum_(i, j in E) N_(i j)$, the _Noise-Correction_ algorithm defines a measure called _lift_ $L_(i j)$, which represents how much the weight of an edge deviates from the expected value of a random null model: $ L_(i j) = hat(N)_i / (E[N]_(i j)) $with $E[N_(i j)]$ the expected weight for a pair of nodes $(i, j)$: $ E[N_(i j)] = hat(N)_(i \.)(hat(N)_(\. j))/(hat(N)_(. .)) $
$L_(i j)$ measures how high the weight of an edge between nodes $i$ and $j$ is relative to the expected value: $ L_(i j) = cases(
  = 1 arrow.double.r "weight equal to expected",
  > 1 arrow.double.r "weight greater than expected",
  > 0 and < 1 arrow.double.r "weight less than expected"
) $
then, it is subsequently centered at $0$, which we will call $tilde(L)_(i j)$ (this measure is also called the _score_).

Subsequently, the variance is computed using the delta method on the previously obtained values: $ v a r[tilde(L)_(i j)] = v a r[hat(N)_(i j)] ((2(kappa + hat(N)_(i j) (d kappa)/(d hat(N)_(i j))))/(k hat(N)_(i j) + 1 )^2) $where $v a r[hat(N)_(i j)]$ is the variance of a Binomial distribution: $ v a r [N_(i j)] = N_(. .)hat(P)_(i j) (1 - hat(P)_(i j)) $
and $kappa$: $ kappa = 1/(E[N_(i j)]) $ and: $ (d kappa)/(d hat(N)_(i j)) = 1/(hat(N)_(i .)hat(N)_(. j)) - hat(N)_(. .) (hat(N)_(i .) + hat(N)_(. j))/((hat(N)_(i .) hat(N)_(. j))^2) $

since real networks are sparse and it is difficult to accurately estimate $hat(P)_(i j)$, it is assumed that $hat(P)_(i j)$ uses a Bayesian framework following a Beta distribution: $[n_(i j) + alpha, n_(. .) - n_(i j) + beta]$. Since $alpha$ and $beta$ are also unknown, it is assumed that the generation of edge weights follows a hypergeometric distribution, in which each time the weight of an edge increases by $1$ for node $n$, then a node $j$ is drawn and removed from the set of nodes (distributed according to the weight $N_(i .)$ and $N_(. j)$ of each node). Thus, the mean $mu$ and variance $sigma^2$ are defined, respectively: $ E[p_(i j)] = E[N_(i j)/N_(. .)] = 1/(N_(. .))(N_(i .)N_(. j))/(N_(. .)) = mu = alpha/(alpha + beta) $ and $ v a r[p_(i j)] = 1/(N^2_(. .))(N_(i .)N_(. j)(N_(. .) - N_(i .))(N_(. .) - N_(. j)))/(N^2_(. .)(N_(. .) - 1)) = sigma^2 = (alpha beta)/((alpha + beta)^2)(alpha + beta + 1) $
which can thus be solved for $alpha$ and $beta$. This allows deriving $v a r[hat(N)_(i j)]$ and, therefore, the variance $v a r[tilde(L)_(i j)]$.

Finally, an edge will be retained only if the weight is greater than $delta sqrt(v a r[tilde(L)_(i j)])$, i.e., if it exceeds $delta$ times the standard deviation. Where $delta$ is a threshold parameter passed to the algorithm. For more information, I refer to the original paper @noise-corrected-backboning.

The NC algorithm favors the retention of connections between non-central nodes, but at the same hierarchy level @coscia2021atlas.

=== Spectral Analysis
Spectral Analysis is the study of the eigenvalues and eigenvectors of the Laplacian matrix of a graph. Given a Laplacian $L$, we define the eigenvalues $lambda$: $ lambda in sigma(L) quad sigma(L) = {lambda | det(L - lambda I) = 0} $ and the eigenvectors $v$: $ v in ker(L - lambda I), quad v eq.not 0 $
As defined above, the first eigenvalue $lambda_0$ in a Laplacian is always equal to $0$. The other eigenvalues, instead, are monotonically increasing: $ 0 = lambda_0 <= lambda_1 <= ... <= lambda_n $

Spectral analysis is important because it provides relevant information about the structure of the graph. It can be used for solving the graph coloring problem #footnote[add source] or for performing a low-rank approximation (approximation of the adjacency matrix to a lower-rank matrix) #footnote[add source]. Furthermore, the second and third eigenvectors, $v_2$ and $v_3$, are used for visualizing graphs with a simplified and more visually appealing layout (also $v_4$ for three-dimensional visualization), as demonstrated by Hall @hall-quadratic-placement.
One of its most common uses lies in the study of the second eigenvalue $lambda_2$, the Fiedler Value, also called _algebraic connectivity_.\
$lambda_2$ has many other utilities as well (p. 16 of the paper)

The eigenvalues and eigenvectors have the following properties:

+ The all-ones vector is always an eigenvector of the first eigenvalue $lambda_0$ of $L$, of value 0;
+ The largest eigenvalue of the adjacency matrix is always between the average degree and the maximum degree of a node in a graph $G$; #footnote[add source /* see [9] or [10, Section 3.2] */].
+ If $G$ is connected, then $lambda_1$ > $lambda_2$ and the eigenvector $v_1$ will be positive; #footnote[add source /* see [11] */].
+ The multiplicity of 0 as an eigenvalue of $L_G$ equals the number of connected components of $L_G$.
+ The largest eigenvalue of $L$ is at most twice the maximum degree in $G$;
+ $lambda_n$ = $-lambda_1$ if and only if $G$ is a bipartite graph #footnote[add source /* see [12], or [10, Theorem 3.4] */].

=== Community Discovery
When studying a network, it is common to want to analyze whether a group of nodes forms a community, i.e., whether they can be grouped and subdivided based on a common property. In our society, communities are everywhere: people who belong to the same city, the same group of friends, or who have the same favorite actor. Someone living in a particular city will certainly have many interactions with people living in that same city. On the contrary, they will have few or none with people living in different cities. The same reasoning applies to networks and Network Science. Formally, a community is said to exist when there is a very high density among the nodes of the community and sparse interactions with nodes outside it.

The study and evaluation of communities in a network is called _community discovery_. This practice has various use cases. For example, for _backboning_, where similar nodes can be identified and removed, leaving only one "representative" node, in order to simplify the network, or to group and classify nodes into specific clusters, to test their behavior when certain network conditions change (for example in the field of advertising and marketing).

Community discovery is a very broad field: there are many ways to group nodes into communities and new methods are continuously being studied. In fact, there is no definitive method; everything depends on the objective one wants to achieve. Generally, importance is given to the performance of the community detection method and its reliability, measured by similarity to other algorithms.

The first method found for community discovery is called the Stochastic Block Model (SBM), with the maximization of the _likelihood function_. Given an SBM, i.e., a random graph generation model containing communities, generated with two parameters $p_(i n)$ and $p_(o u t)$, which are respectively the probability that a node interacts with a node within the community and that a node connects to a node outside the community (generally, $p_(i n) > p_(o u t)$), the two parameters are initialized to the same values as the initial network. Subsequently, the _likelihood function_ is defined: $ L_(Theta, A) = sum_(u, v in A) l_theta, A, u, v $ where
$
  l_(theta,A, u, v) = cases(
    θ_1 - 1 arrow.double.r A_(u v) = 1 & (u, v) ∈ theta_3,
    θ_2 - 1 arrow.double.r A_(u v) = 1 & (u, v) ∉ theta_3,
    -θ_1 arrow.double.r A_(u v) = 0 & (u, v) ∈ theta_3,
    -θ_2 arrow.double.r A_(u v) = 0 & (u, v) ∉ theta_3,
  )
$
One tries to maximize the function, such that: $ hat(theta) = arg_(theta in Theta)max L_(theta, A) $

Finally, if, given an SBM, $p_(o u t) > p_(i n)$, then all disassortative communities can be found, i.e., communities of nodes that only link with nodes that are _not_ in their community.

This method is the equivalent of the modularity optimization method @Newman_2016, which we will discuss later.

Another of the most common methods for finding communities in a network is the use of the _random walk_, i.e., starting from a random node, randomly exploring one of its neighbors, and so on, iterating $n$ times. The underlying idea is that when a random walk enters a community, it will remain there for a long time, given the high number of edges within the community. Conversely, the probability that it reaches a boundary node that then enters another community is very low. Therefore, using the random walk technique is not the most efficient method. The Infomap method, however, does it better, with the goal of minimizing the map equation @Rosvall2009, i.e., an encoding of a _random walk_. 

Initially, the algorithm simulates a normal random walk to compute the visit frequencies of nodes. Every time it explores a node, it assigns a bit sequence encoded with Huffman coding @itwiki:147328281. In order to save memory and reuse IDs, analogously to street names that repeat in different cities, it begins grouping neighboring nodes together under the same community, to which it assigns a code of an increasing number of bits. In this way, in the encoding, when the random walk enters a new community, it signals this by first writing the community number and then the number of each node. When it reaches a boundary node and moves to a new community, it uses the code `1111`, which signals the jump to a new community. This adds some overhead, because in each community there are at least 5 extra bits, but the breakeven point is reached quickly. The process is iterated multiple times until the minimum length encoding of the random walk is obtained. Due to the random nature of random walks, it is a non-deterministic algorithm.

A further community detection method is _label percolation_ (or _label convergence_): starting from a subset of nodes to which labels are randomly assigned, these are propagated to all remaining nodes until all nodes are labeled. This is also a non-deterministic algorithm.

Initially, each node is assigned a random label. Subsequently, iteratively, each node explores the labels of its neighbors and self-assigns the most frequent label; in case of a tie, it randomly chooses one of the most frequent ones. This continues until convergence is reached, where each node has the same label as the majority of its neighbors.\
The positive aspect of this algorithm is that it is very simple to implement and converges quickly.

Furthermore, due to the non-deterministic nature, multiple iterations of the same algorithm reveal different community structures, which can be aggregated through the Jaccard similarity index @Raghavan_2007.

Finally, community detection can occur both on static networks (_snapshots_ at a given point in time) and on dynamic networks, in which we assume that the network changes, nodes are added, edges are removed and, consequently, communities change.

A naïve method for evaluating communities in dynamic networks is to assume that each snapshot is independent over time and to search for communities independently in each snapshot. However, the scientific literature tells us that the results can be very different. One can therefore resort to a technique called _evolutionary clustering_ @evolutionary-clustering.

With evolutionary clustering, one tries to balance two objectives: maximizing the quality of the snapshot at time $t$, which reflects the most recent changes, and minimizing the _history cost_, i.e., the distance between the clustering at time $t$ and that at time $t-1$.

The algorithm uses a similarity index or a distance matrix of the various timestamps $T$, built over time, defined as $M_t$. At each timestamp, the algorithm tries to optimize the quality of the snapshot: $ s q(C_t, M_t) - alpha dot h c (C_(t-1), C_t) $ where $C_t$ is the clustering computed at time $t$. $s q$ is a function that evaluates the quality of the snapshot, $h c$ is the history cost function and $alpha$ is a trade-off parameter that establishes how much importance to give to past snapshot configurations.

=== Modularity
Modularity is a measure that evaluates the quality of a _community evaluation_ in a network. A high degree of modularity means that there will be a high density among nodes in the same community and a lower density between a node in a community and one outside the community. It represents the internal density of communities. It also has the purpose of optimizing the community partition function, with the goal of maximizing modularity. Given $A$ the adjacency matrix and $delta$ the Kronecker delta function, which returns $1$ if nodes are in the same community and 0 otherwise, modularity is defined by: $ M = 1/(2|E|) sum_(i,j in V) \[A_(i j) - (deg(i) deg(j))/(2|E|) \] delta (c_i, c_j) $
The domain of modularity is defined in $[-0.5, +1]$: the lower the value, the more disassortativity there is in the network. Conversely, if it tends toward $+1$, the division of communities is optimal. If modularity equals 0, then the graph has no community structure.

=== Other Properties

+ *Homophily and Heterophily*: Homophily is a qualitative property that expresses how much nodes in a network tend to be close to each other when they express similar features. It is one of the foundations of community discovery, because it starts from the sociological assumption that people tend to relate to similar people (same gender, similar age, same passions or interests) and is reused in the study of networks because it is assumed that nodes with similar features tend to be connected. This happens both for behavioral reasons (the user in a social network seeks only people or pages that match their interests) and for environmental reasons (the algorithm of a social network shows the user posts that might interest them more). Heterophily, on the other hand, is the exact opposite.

+ *Assortativity and Disassortativity*: Assortativity is a quantitative measure to represent homophily. Conversely, disassortativity quantitatively represents heterophily. The intuition of assortativity is to take numerical features and, given a connection between two nodes, estimate their similarity (e.g., two nodes with values 1 and 5 are more similar than two nodes with values 1 and 5000). The most common property is the degree of two nodes, in which it is assumed that two nodes with a very high degree link together. For example, in social networks, it is more likely that a celebrity connects to another.

+ *Clustering Coefficient*: It is a property that measures how much, in a network, nodes tend to be connected to each other. Especially in social networks, nodes tend to have a high density of connections. It is a local or global measure. At the local level, it measures how likely the neighbors of a node are to form a clique. Given $N$ the set of neighbors of $i$ and $k_i = |N|$: $ C C_i = (|{ e_(j k) : v_j, v_k in N, e_(k j) in E }|)/(k_v\(k_v-1\)) $
 At the global level, instead, it is based on triples of nodes (triangles or triads). The global clustering coefficient represents how many closed triangles there are, relative to all triads in a network: $ C C = (\# "triangles")/(\# "triads") $

=== Node Vector Distance <H-node-vector-distance>
Finding the distance between two nodes is a problem widely studied in the scientific literature #footnote[add citations to papers on Dijkstra, Bellman-Ford, etc.]. Thanks to it, graph theory was able to extend to networks as we commonly understand them, i.e., a set of computers connected to each other capable of communicating. This made possible the development of the internet, which allows us to exchange data with computers on the other side of the world.

However, this approach considers only one aspect: transporting data from a node $i$ to a node $j$. In a binary manner, data can be in one node or another, or in any intermediate node, but cannot spread "continuously", with a portion of information simultaneously present in multiple nodes, nor can it start from multiple nodes simultaneously.\
Yet, many real-world situations follow precisely this second pattern, such as _virus diffusion_, _the quality of a viral marketing campaign_ or _polarization in a social network_: phenomena that start from one or more nodes and propagate toward neighboring nodes.

The intuition behind _Node Vector Distance_ (NVD) is to measure, given a network and two instants $t_1$ and $t_2$, the diffusion of a node property over time.

Formally @coscia2020node, given an undirected network $G = (V, E)$, where $V$ is the set of nodes and $E$ is the set of edges, we define the property $A$ on each node of the network through a vector $A$ of length $|V|$ and domain in $[0, 1]$. Assuming for simplicity that between $t_1$ and $t_2$ the network does not change, the NVD measures the distance traveled and the diffusion of property $A$ over time, as illustrated in @nvd-diffusion-a and @nvd-diffusion-b.

#subpar-grid(
  figure(
    diagram(
      node-stroke: .1em,
      spacing: 3em,
      node((0, 0), `1`, radius: 1em, fill: red),
      edge(``, "-"),
      node((1, 0), `2`, radius: 1em),
      edge(``, "-"),
      node((2, 0), `3`, radius: 1em),
      edge(``, "-"),
      node((3, 0), `4`, radius: 1em),
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
  caption: [Diffusion of property $A$ in graph $G$.],
)

There are three classes of solutions for NVD @coscia2020node: _Generalized Euclidean_, _Shortest Path_ and _Spectral_. We will focus only on the first, the _Generalized Euclidean_, as it is the one used during the internship.

The _Generalized Euclidean_ (GE) measures distances in a network in the same way they would be measured in a multidimensional Euclidean space. It is defined by: $ delta_(A_(t 1), A_(t 2)) = sqrt((A_(t 1) - A_(t 2))^T L^dagger(A_(t 1) - A_(t 2))) $
where $L^dagger$ is the Moore-Penrose pseudo-inverse Laplacian matrix (the Laplacian is not invertible as it is a singular matrix), and $(A_(t 1) - A_(t 2))^T$ is the transpose of the difference vector of property $A$ between the two considered instants.

In the scientific literature, this measure has been used to quantify ideological polarization in a social network @ideological-polarization-quantifying, where property $A$ represents the political opinion of each user, expressed as a continuous value from $-1$ to $+1$ (from Democrat to Republican), and decomposed into $A^+$ and $A^-$. 

Respectively, $A^+ = cases(
  a_i arrow.double.r a_i >= 0, 0 arrow.double.r a_i < 0
)$ and $A^- = cases(|a_i| arrow.double.r a_i < 0, 0 arrow.double.r a_i >= 0)$, so that the polarization is given by: $ delta_(A) = sqrt((A^+ - A^-)^T L^dagger (A^+ - A^-) $.

This measure represents the distance between two randomly selected nodes, weighted by the extremity of their opinions. Consequently, a network composed of nodes with moderate opinions ($0 <= overline(A) <= |0.1|$) will exhibit lower polarization than the same network with nodes holding extreme opinions ($overline(A) >= |0.8|$).

== Magnetic Laplacian
The Magnetic Laplacian, or _Magnetic Laplacian_, has its roots in quantum physics. Analogous to the magnetic Schrödinger operator @cmp-1104270832, it was created to model the behavior of particles in an electromagnetic field, incorporating a phase factor that rotates the classical Laplacian matrix @krejcirik2013magneticlaplacianshrinkingtubular.

By analogy, the complex phase associated with particles can be interpreted as the direction of edges in a graph.

Given a directed graph $G = (V, E)$, we define $w_s (i, j)$ the symmetrized weight of the edge from node $i$ to node $j$: $ w_s (i, j) = (w(i, j) + w(j, i))/2 $
The phase is given by $e^(i theta a(i, j))$, where $theta$ is a parameter and $a(i, j)$ is defined as: $ a(i, j) = cases(
  1 arrow.double.r (i, j) in E,
  -1 arrow.double.r (j, i) in E,
  0 arrow.double.r (i, j) and (j, i) in E
) $

We also define $psi(i): V -> CC$, a function that associates a complex number to each node. The operator $hat(cal(L))_(a, theta)$ is then defined as @Fanuel_2017: $ hat(cal(L))_(a, theta) psi(i) = sum_j w_s (i, j) (psi(i) - e^(i theta a(i, j)) psi(j)) $

The behavior of the Laplacian depends on the parameter $theta$, which represents the electric charge of the particle. For $theta = 0$, the classical Laplacian defined in previous chapters is obtained: $L = D - A = hat(cal(L))_(a, 0) = hat(cal(L))_(0, theta)$. Since the same dynamics recur when $theta = theta + 2 pi$, the parameter $theta$ can be interpreted as an angle @Fanuel_2017. As $theta$ varies, the Laplacian highlights different structures in the network, as described in @theta-comparison.

#align(center, [
  #figure(
    table(
      columns: (auto, auto),
      inset: 8pt,
      align: horizon,
      table.header([Theta], [Highlighted structure]),
      [#(2 * calc.pi * 0)], [Analogous to classical Laplacian],
      [$pi/2$], [2, 4, 3-cycles],
      [$2/3 pi$], [2, 3-cycles],
      [$4/5 pi$], [3-cycles],
      [$pi$],
      [Signed Laplacian\
        $a(i, j) = 0 arrow.double.r +$\
        $a(i, j) in {-1, 1} arrow.double.r -$
      ],
    ),
  ) <theta-comparison>
])

The Magnetic Laplacian has found application in community evaluation for directed graphs @Fanuel_2017, in spectral analysis @Fabila_Carrasco_2022 and, as we will see in the following chapters, in the computation of the Node Vector Distance on directed graphs.

For example, given a simple directed graph as in @direct-triangle, computing the classical Laplacian matrix is equivalent to treating the graph as undirected, obtaining: $ mat(
  2, -1, -1;
  -1, 2, -1;
  -1, -1, 2;
) $
The magnetic Laplacian matrix with $theta = pi/2$, instead, is:$ mat(
  1, -1/2i, +1/2i;
  1/2i, 1, -1/2i;
  -1/2i, 1/2i, 1;
) $

#figure(
  diagram(
    node-stroke: .1em,
    spacing: 3em,
    node((0, 0), `1`, radius: 1em),
    edge((0, 0), (1, 0), ``, "-|>")...

#align(center, [
  #figure(
    image("images/19-04.png"),
    caption: "Visualization of an undirected network of the last week of January 2019",
  ) <final-undirected-network-example>
])