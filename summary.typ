// Page setup
#set page(
  paper: "a4",
)
#set page(footer: context [
  #counter(page).display(
    page => text(size: 12pt)[#page],
  )
])

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
#set heading(numbering: "1.")

// Link setup
#show link: underline

// Bibliography setup
#show bibliography: set heading(numbering: "1.")

#set text(12pt)

#set align(center)

#set text(size: 20pt)

#smallcaps[Improving Estimation of Polarization in Online Discourse]

#set text(size: 14pt)
#smallcaps[
  Michele De Cillis - 24260A

  September 01, 2025 - December 23, 2025
]

#set align(left)
#set text(12pt)

= Host organization of the internship
I pursued my internship at NERDS, a multidisciplinary research group focusing on computational social science, artificial intelligence, urban mobility, and data analysis located at Copenhagen, inside IT University of Copenhagen. Specifically, I worked with my co-supervisor, Professor Michele Coscia, who throughout his academic career has extensively studied complex networks, developing new methods to analyze and manipulate them, including the _node vector distance_ and _noise corrected backboning_.

= Initial context
Upon my arrival, the project I joined relied on a dataset containing data from the social network Reddit, which was used to generate, week by week, a network of users and their meaningful interactions. On this network, filtered to include only political discussions, various sociological analyses were performed, such as calculating polarization, measuring toxicity, estimating the political spectrum of various users, analyzing dissent, and so on. The project is divided into several phases, ranging from data processing (network construction and property extraction for each node) to the actual analysis.

= Project goals
I joined the project with the goal of expanding and improving it in specific stages of the pipeline, whether in data processing or network analysis. After careful consideration and agreement with the professor, we decided to focus on the imporovement of the calculation of polarization. The initial objective was, therefore, to transform the original networks into directed ones and then compute polarization on them. The ultimate aim was first to see if this new measure made sense, and then to check if adding directionality could uncover patterns and information that were previously hidden.

= Description of the work done
During the first few weeks, I thoroughly studied the project to decide which aspect to intervene on; I thus conducted a careful literature review regarding network science, polarization calculation, _node vector distance_, and Laplacian matrices.

Subsequently, we chose to calculate the _node vector distance_ using the _magnetic Laplacian_, an operator which include the directionality of a network, to study the behavior of this operator. At first, various toy examples were created to empirically verify the results and ensure that the properties of the measure were consistent with the original operator we took inspiration from (its undirected counterpart, based on the classic Laplacian matrix). These small test graphs were specially structured to present asymmetries in topology and edge distribution. Doing so, it was possible to compare the two methods and verify that the new operator could actually capture dynamics that were invisible in undirected analysis.

Finally, after confirming the proper functioning of the operator, we converted the real networks from the Reddit dataset into directed networks. This step required fixing some issues with _backboning_ (where thresholds ended up being excessively high due to directionality). Once the technical hitches were resolved, we calculated the new weekly polarization; besides the score itself, we also correlated it to other graph properties, such as _social balance_ and the type of local interactions of each node (analyzing the formation of directed triangles and comparing them with the political spectrum of the users involved).

= Technologies involved
During the internship, I primarily used Python, a very versatile high-level programming language perfect for handling and manipulating huge amounts of data. Along with Python, I worked with several well-known libraries:

- _NetworkX_: used to create networks and operate on them topologically (for instance, calculating the _Largest Connected Component_ or cliques). Throughout this internship, it was fundamental for quickly building and testing toy examples.
- _PyTorch_: although it is a framework dedicated to Machine/Deep Learning models, I employed it specifically for its tensors. Its highly efficient, multidimensional array-based data structures proved essential for loading data from massive real-world networks.
- _NumPy_: an absolute must in Python, it proved invaluable because of its outstanding computational efficiency in mathematical operations, largely thanks to its C implementation of arrays (_ndarray_).
- _Pandas_: an essential library for data analysis and manipulation tasks. It allowed me to easily extract summaries and statistics from the obtained results which, combined with the plotting library _Matplotlib_, greatly simplified the visual generation of reports.

= Skills acquired and results achieved
- What results have been to achieve compared to the initial goals?\
  The initial goal was somewhat less ambitious: it only consisted of implementing the new operator and comparing its outputs with real-world events for each topic, just to make sure it was at least as comprehensive as its undirected variant. However, thanks to the promising results seen during the analysis of toy examples, we realized that the true strength of this metric was its ability to detect asymmetric interactions in networks, dynamics that are increasingly common across social networks. Practically speaking, in networks where a small, very extreme community unilaterally interacts with a larger, less polarized one that has many internal connections, the measured polarization begins to rise noticeably. A typical example of this behavior involves _troll armies_. Analyzing and isolating such behavior is a standout feature of this operator, something we simply could not highlight without adding directionality to the networks.

- What lessons were learned from this experience?\
  Personally, this experience made me fully grasp the difficulty of tackling complex problems. With numerous variables at play, it is surprisingly easy to obtain diametrically opposed results depending on the chosen parameters or the research questions being asked. This made me realize the value of a multidisciplinary team: only through the collaboration of experts across different fields can meaningful and sound results be achieved.

  Methodologically, I learned what it truly means to study a problem in depth. I carefully combed through scientific literature to figure out which papers were actually valuable and which were merely "noise". Given the overwhelming volume of information and the scarcity of resources (time, funding and energy), the ability to discern reliable sources became crucial. Furthermore, I experienced firsthand the importance of the phrase "_correlation is not causation_": it is incredibly easy to mistake mere coincidence for a solid scientific finding. While I observed correlations during my work -and part of my results are based on them-, I am perfectly aware that the results currently hold only empirical value. Nevertheless, they lay the groundwork for further research using more formally defined approaches. I must admit that the experience also sparked in me a deep curiosity regarding the underlying mathematics of these networks, a topic I hope to explore further during my academic career.

  From a strictly technical perspective, I was able to apply field knowledge of graph theory acquired during algorithmic courses, successfully implementing some highly advanced network science theorems and metrics. I learnt what it means to study the theory during courseworks and then apply it while working.

- What challenges were encountered? Which ones were resolved and which were not? Why?\
  Throughout the internship I encountered several issues. A major one cropped up during the backboning phase on real-world networks: including directionality caused the _threshold_ values (i.e. the minimum expected value of each node's degree relative to the entire network's average) to diverge and this ended up yielding microscopic final networks. To solve this, we employed a workaround: we chose to treat the network as undirected strictly within the backboning algorithm. This choice was purely practical. For efficiency purposes, we were using a cache file containing attributes of each message (political leaning, topics, toxicity score, etc.) computed in a prior phase of the project. If we had rewritten the dynamics for backboning, we would have had to re-run the entire original pipeline beforehand. Thus, we concluded that simply trimming the "excess edges" by viewing tie robustness as a bidirectional parameter wasn't a problem, and it didn't compromise the subsequent stages.

  On the other hand, an unresolved issue stems from methodological and mathematical roots. We tested our polarization operator solely empirically using toy examples, confirming that the observed behaviors plausibly aligned with our assumptions. While the results are excellent and encouraging, the operator still lacks a formal mathematical study to clearly establish its limits and theoretical solidity. This missing piece, however, presents itself as the key opportunity for future expansion of the work.

#bibliography(
  "./works.bib",
  title: [
    Bibliography

    #v(-0.6em)
    #text(size: 12pt, weight: "medium")[
      This section contains only the most important bibliography, which was primarily used during the work. However, the complete bibliography can be found in the thesis.
    ]
    #v(1em)
  ],
  style: "american-physics-society",
)

#text(fill: white, size: 0pt)[
  @coscia2021atlas, @Fanuel_2017, @coscia2020node, @noise-corrected-backboning
]
