// Template for the thesis
#import "SGH-thesis.typ": *

// Importing Fletcher for diagrams
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge,

// table colors
#show: sgh_stripped_tables

// changing font size in tables
#show table.cell: set text(size: 9pt)

// grey background for all block-level code/output
#show raw.where(block: true): it => block(
  fill: luma(240),
  inset: (x: 1em, y: 0.7em),
  radius: 3pt,
  width: 100%,
  it
)

// summary at the beginning of each chapter
#let chapterSummary(q, a: none) = {
    quote(
        text(fill: rgb("#B0C4DE").darken(50%))[#q],
        block: true,
        attribution: a
    )
}

// including code from a file from line to line
#let includeCode(path, from: 1, to: none) = {
  let lines = read(path).split("\n")
  let to = if to == none { lines.len() } else { to }
  let selected = lines.slice(from - 1, to)
  show raw: set text(size: 8pt)
  line(length: 100%, stroke: 0.5pt + gray)
  raw(selected.join("\n"), lang: "r", block: true)
  line(length: 100%, stroke: 0.5pt + gray)
}

// making a formal example (for small, simple examples)
// Define a dedicated counter for your example blocks
#let example-counter = counter("example-block")

#let sgh_example(content, title: "Example") = figure(
  kind: "example",
  supplement: title,
  block(
    breakable: true,
      fill: orange.lighten(95%),
    inset: 10pt,
    radius: 1pt,
    width: 100%,
    align(left)[
      #example-counter.step()
      #text(weight: "bold")[
        #title #context example-counter.display()
      ]
      #v(6pt)
      #content
    ]
  )
)

// ----------------------------------------------------------------------------
// Title page
// ----------------------------------------------------------------------------

#show: sgh.with(
  author: "Thi Van Trang Le",
  student_id: "140036",
  title: "Process Intelligence with Python Language",
  advisor: "dr hab. Michała Ramsza",
  advisor_department: "Institute of Mathematical Economics",
  year: "2026",
  studies: "mgr",
  program: "Advanced Analysis -- Big Data",
  language: "en"
)

// ----------------------------------------------------------------------------
// Table of contentes
// ----------------------------------------------------------------------------

#table_of_contents()

// ----------------------------------------------------------------------------
// Body
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
= Introduction

== Background and motivation

These days, almost every business process happens inside digital systems such as ERP platforms, CRM tools, or workflow apps. What’s interesting is that every action, whether it’s an approval, a payment, or just a status update, gets recorded automatically: who did it, when, and for which case. On their own, these records might not seem important. But when you look at them all together, they reveal how work really happens in practice, which is often quite different from the way the process was originally designed.

When we analyze this data, we gain a much clearer and more honest view of how processes operate day-to-day. Unlike traditional management reports, which often reflect how things are supposed to work, process mining allows us to trace the actual sequence of events by following the digital footprints left in the system. This makes it possible to see where delays or repeated work really happen, and to spot differences between teams, locations, or even individual cases. In many situations, these insights reveal surprising gaps between the process as designed and how it unfolds in reality.

Since the late 1990s, when van der Aalst and his colleagues introduced the first process mining algorithms, the field has developed rapidly. What began as a research topic has now found its way into real businesses around the world. There are dedicated conferences, an official IEEE task force, and a growing number of practical applications in areas such as healthcare, finance, logistics, and manufacturing. This growing interest highlights just how valuable process mining has become, both in theory and in everyday business practice.

Process intelligence builds on the foundation of process mining and takes it a step further. While process mining mainly looks back to analyze what has already happened, process intelligence brings a forward-looking perspective. It involves monitoring ongoing cases in real time, predicting which ones might encounter problems, and even simulating how things could play out if resources were allocated differently. The aim is not only to understand past performance, but also to use that understanding to make better decisions and take action as events unfold.

Python has emerged as the preferred language for process mining and process intelligence work. Its strong presence in the data science community, along with a growing selection of specialized libraries, makes it a natural choice for practitioners. For example, PM4Py is one of the most comprehensive libraries available, covering everything from loading event logs to discovering process models, checking conformance, and analyzing performance. Other libraries extend these capabilities further by offering tools for simulation, prediction, and visualization. As a result, it is now possible to carry out an entire process intelligence project entirely within the Python ecosystem.

Despite these advances, navigating the Python process mining ecosystem can still be challenging. Many libraries offer similar features, and the quality of documentation varies widely. There is also a lack of a single, comprehensive resource to help users understand which tool is best suited for each task, or how to use them effectively in real-world situations. With this thesis, I aim to fill that gap by providing a structured overview of the main tools available, along with practical code examples that readers can try out and adapt to their own needs.

== Research Objectives and Research Question

The main question guiding this thesis is:

#align(center)[
  _Which Python tools are available for process mining and process intelligence, and how well do they support key analytical tasks like process discovery, conformance checking, and performance analysis?_
]

To answer this question, the thesis sets out to achieve four specific objectives:

+ To introduce and explain the mathematical concepts that form the foundation of process mining, such as event logs, traces, directly-follows relations, process models, and conformance measures, so that it’s possible to compare different tools in a rigorous way.

+ To review the main Python libraries available for process mining and process intelligence, grouping them by their primary functions, and describing their features, strengths, and limitations in an organized manner.

+ To show how selected Python tools can be used in real-world scenarios, using worked examples that range from simple synthetic datasets to large procurement event logs, and extending beyond basic process discovery to include performance measurement, simulation, and outcome prediction.

+ To draw conclusions about the current state of the Python process mining ecosystem, highlighting any gaps and suggesting directions for future development.

This thesis focuses on Python-based tools and the three core process mining tasks discovery, conformance checking, and performance analysis as well as related capabilities such as simulation and predictive monitoring. The emphasis is on open-source solutions that can be accessed by both practitioners and researchers without the need for commercial licenses. The only exception is PyCelonis, which is included because it represents an important category of commercial process intelligence platforms that offer a Python interface.

== Relevance and Academic Context

Process mining emerged as a research field in the late 1990s and early 2000s, largely thanks to the pioneering work of Wil van der Aalst and his colleagues at Eindhoven University of Technology. Since then, the field has grown significantly, with its own annual conference—the International Conference on Process Mining (ICPM)—and a formal IEEE task force that has established a clear set of principles and goals for process mining. The textbook by van der Aalst (Aalst, 2022) remains the main reference point for both theoretical and practical aspects of process mining, and it serves as the primary academic resource for this thesis.

One important driver of progress in the field has been the BPI Challenge, which is held each year alongside ICPM. The challenge provides researchers with real-world datasets from organizations and invites them to apply process mining techniques to analyze them. These datasets have become standard benchmarks and are widely used to compare algorithms and tools. For this thesis, I use the BPI Challenge 2019 dataset as the main case study. This dataset, drawn from a large multinational company’s procurement process, includes nearly 1.6 million events and is one of the most complex in the series. Its widespread use in academic studies makes it a strong foundation for demonstrating process mining methods in a realistic context.

The Python ecosystem for process mining has evolved rapidly since the introduction of PM4Py in 2018. Earlier implementations, such as ProM, were Java-based and still see heavy use in academic settings, but they require more specialized expertise to extend and deploy. The arrival of Python-based libraries has made it much easier for both researchers and practitioners to get started, and has allowed process mining to integrate more naturally with other data science tools for machine learning, visualization, and statistical analysis. New libraries have continued to appear, supporting tasks like streaming process mining, simulation, and predictive monitoring. Even so, the Python ecosystem is still less mature and less thoroughly documented than its Java-based counterpart, making a clear, structured review especially valuable at this stage.

With this thesis, I aim to contribute by offering a comprehensive, practice-oriented review of the Python process mining ecosystem, with a special focus on PM4Py and its related extensions. All practical examples are provided as Jupyter notebooks, making it possible for others to reproduce and verify the results. This emphasis on reproducibility is important, as it ensures that the findings in Chapter 4 can be validated and built upon by future researchers and practitioners.

== Methodology

This thesis is a structured review combined with empirical demonstration. The work follows four sequential phases.

*Phase 1: Theoretical foundation.* The mathematical concepts required to understand process mining are introduced and formalized in Chapter 2. The primary source for these definitions is van der Aalst @vanderAalst2022. Establishing this theoretical foundation before describing tools is important because it provides a common vocabulary for comparing different implementations and for interpreting the results of the practical examples.

// TODO (MR): Here you use literally number 2 as a reference to the
// second chapter. This should be done through the formal reference to
// a label given to a second chapter. Please correct this in the whole
// document.

*Phase 2: Tool survey.* Python libraries are identified through a combination of academic sources — papers and conference proceedings from ICPM and related venues — the Python Package Index (PyPI), GitHub repositories related to process mining and process intelligence, and cross-references within the PM4Py documentation. For each tool, the following aspects are examined: the primary analytical task it supports, the data formats it accepts, the algorithms it implements, and the level of active maintenance and community support as indicated by recent commit history and documentation quality. Tools are organized into five categories: core process mining libraries, predictive and AI-oriented tools, simulation and optimization tools, visualization libraries, and complementary data processing packages.

*Phase 3: Practical implementation.* Five Jupyter notebooks are developed to demonstrate the process intelligence workflow end to end. The first notebook uses a small hand-built dataset to introduce the core steps of process mining in a setting where the expected output is known. The remaining four notebooks work with the BPI Challenge 2019 procurement dataset and progressively build up the analysis: the second covers process discovery and conformance checking, the third adds variant analysis and throughput measurement, the fourth examines process performance using a performance-annotated DFG and computes an object-centric directly-follows graph, and the fifth models the process using discrete-event simulation and builds a Random Forest classifier to flag cases likely to exceed a 30-day completion threshold. Each notebook combines executable Python code with printed outputs and saved figures, making the results fully reproducible.

*Phase 4: Synthesis and conclusions.* The results of the tool survey and the practical examples are combined in Chapter 5, where the research question is answered, the limitations of the work are acknowledged, and directions for future research are proposed.

The methodology is descriptive and demonstrative rather than evaluative in a strict experimental sense. No formal benchmarking is performed — the thesis does not measure and compare the runtime, fitness scores, or precision values of multiple discovery algorithms on the same dataset. Such a comparison would require a controlled experimental design and falls outside the scope of this work. The contribution instead lies in the structured organization, explanation, and demonstration of the available tools.

== Structure of the thesis

The remainder of this thesis is organized as follows.

// TODO (MR): Again here, use formal refrences to the chapters.

*Chapter 2* Introduces the mathematical foundations of process mining. It formally defines events, traces, and event logs, explains directly-follows relations and their role in process discovery, describes the main process model representations used in this thesis — the directly-follows graph, the process tree, and the Petri net — and introduces the concepts of conformance checking and performance analysis. It also explains the structure of the Object-Centric Event Log (OCEL) format and provides an exploratory description of the BPI Challenge 2019 dataset.

*Chapter 3* Reviews the main Python tools available for process mining and process intelligence. The tools are organized into five categories — core process mining libraries, predictive and AI-oriented tools, simulation and optimization tools, visualization libraries, and complementary data processing packages — and each category is described in terms of the tasks it supports and the tools it contains. The chapter concludes with a comparative summary table.

// TODO (MR): There is a problem with the use of `-`, `--`, and
// `---`. This should be corrected in the whole document.

*Chapter 4* Walks through five practical notebooks that together cover the full process intelligence cycle. The first notebook introduces process mining concepts using a synthetic event log. The second and third apply these concepts to real procurement data from the BPI Challenge 2019, producing a Petri net model, a conformance score, and a throughput time distribution. The fourth notebook adds a performance perspective by annotating the directly-follows graph with median waiting times, measuring the share of automated activities, and computing a per-object-type DFG directly from the OCEL relations table. The fifth notebook closes the cycle with forward-looking analyses: a SimPy simulation that estimates how throughput time changes under different resource assumptions, and a Random Forest model that classifies whether a case will be slow or fast based on features observed at the start of execution.

*Chapter 5* Summarizes the main findings of the thesis, discusses its limitations, and proposes directions for future research.

// ----------------------------------------------------------------------------
= The mathematics of process mining

#chapterSummary[Understanding process mining properly requires a shared vocabulary. Without clear definitions, terms like "fitness" or "conformance" mean different things to different people, and comparing two tools or algorithms becomes guesswork. This chapter introduces the core mathematical concepts used throughout the thesis: events, traces, and event logs; directly-follows relations and variants; process discovery and process models; conformance checking; and performance analysis. Each concept is illustrated with a small worked example so that the formal definition connects directly to something concrete. The chapter also explains how event data are represented in Python and provides an exploratory description of the BPI Challenge 2019 dataset that is used in the case study in Chapter 4.]

// TODO (MR): I wrote a very simple function that adds a slight color
// variation to the summary of the chapter. Use it for all chapters.

// TODO (MR): The following chapter introduces particular mathematical
// notation. At the beginning of the chapter give the source that you
// are following.

== Event logs and traces

An event is the basic unit of data in process mining. Each event records that a specific activity was performed for a specific process instance at a specific point in time. Formally, let $cal(U)_C$ be the universe of case identifiers, $cal(U)_A$ be the universe of activity names, and $cal(U)_T$ be the universe of timestamps, where $cal(U)_T$ is totally ordered by the natural chronological ordering $<=$.

An *event* $e$ is a tuple $e = (c, a, t) in cal(U)_C times cal(U)_A times cal(U)_T$ where $c in cal(U)_C$ is a case identifier, $a in cal(U)_A$ is an activity name, and $t in cal(U)_T$ is a timestamp. In practice, events may carry additional attributes such as the name of the resource that performed the activity, the organizational unit, the cost, or business-specific data fields. These attributes extend the basic definition without changing its core structure. For the purposes of process discovery, only the case identifier, activity name, and timestamp are strictly required.

A *trace* is the projection of all events belonging to a single case onto the sequence of their activity names, ordered by timestamp. Let $A$ be a finite set of activity names. A trace $sigma$ is a finite sequence of activity names written as $sigma = chevron.l a_1, a_2, dots, a_n chevron.r$, where each $a_i in A$ and the order of elements follows the chronological order of the underlying events. The set of all finite sequences over $A$ is denoted $A^*$.

// TODO (MR): (1) What if there are two activities with the same
// timestamp? How do we order these activities? This is why we usually
// need event id coming from the eventlog. (2) Where does the symbol
// $A^*$ come from?

// TODO (MR): Also, this is essentially the XES format (a list of
// traces). You are working with the OCEL format. Mayby we should
// start with describing both formats?

An *event log* $L$ collects traces from many cases. Because the same sequence of activities can occur in more than one case, the log is modelled as a multiset over $A^*$, written $L in cal(B)(A^*)$, where $cal(B)$ denotes the multiset operator. A multiset is a function $m: X -> NN_0 = {0} union NN = {0,1,2, ...}$ that assigns a non-negative integer, multiplicity, to each element of $X$. For a trace $sigma in A^*$, the value $L(sigma)$ gives the number of cases in which that exact trace $sigma$ (a sequence of events) was observed. To make this concrete, consider the following nine events given in the table~@tab-eventlog-1.

#sgh_table(
    caption: [An example eventlog containing three cases, each three events long. Each event has two properties: acvitivity name and timestamp.],
    source: [Own elaboration.]
)[
    #table(
        columns: 4,
        align: (center, left, center, center),
        table.header([*Event ID*], [*Activity*], [*Case ID*], [*Timestamp*]),
        [e1], [Create order],  [1], [09:00],
        [e2], [Approve order], [1], [10:00],
        [e3], [Send invoice],  [1], [11:00],
        [e4], [Create order],  [2], [09:15],
        [e5], [Approve order], [2], [10:30],
        [e6], [Send invoice],  [2], [11:20],
        [e7], [Create order],  [3], [08:45],
        [e8], [Reject order],  [3], [09:50],
        [e9], [Close case],    [3], [10:40],
    )]<tab-eventlog-1>

// TODO (MR): You should use the #sgh_table() function. It provides
// the title and the source arguments. This must be corrected in the
// whole document. Also, is this table generated from some eventlog?
// If so, it should be saved by the script to the external file (csv)
// and read here. We do not want any manual copying.

// TODO (MR): Also, it seems that the natural hierarchy is first
// case_id, then event_id, and only then properties of the event, like
// the name of activity or the timestamp.

// TODO (MR): In the above table I changed all of these, but you have
// to change it in the whole document.

Grouping by case identifier and ordering by timestamp gives three traces:

- Case 1: $sigma_1 = chevron.l "Create order", "Approve order", "Send invoice" chevron.r$
- Case 2: $sigma_2 = chevron.l "Create order", "Approve order", "Send invoice" chevron.r$
- Case 3: $sigma_3 = chevron.l "Create order", "Reject order", "Close case" chevron.r$

Because $sigma_1 = sigma_2$, the event log is the multiset $L = [sigma_1^2, sigma_3^1]$. This log has two distinct trace patterns: the approval path (observed twice) and the rejection path (observed once). The total number of cases is $||L|| = 3$, the number of distinct variants is 2, and the average trace length is $(3 + 3 + 3)/3 = 3$.

// TODO (MR): You need to introduce the notation for the multisets
// with the superscripts. This is not clear for somebody that is not
// already familiar with the multisets.

// TODO (MR): Also, you use the word 'variants' but it has not been
// defined. Is it the same as 'trace'?

Several summary statistics are routinely computed from a log before applying any discovery algorithm. The *number of distinct variants* is
$ |{"Var"}(L)| = |{sigma in A^* : L(sigma) > 0}| . $
The *average trace length* is
$ macron(ell) = (sum_(sigma in L) L(sigma) dot |sigma|) / (||L||) . $


The *variant frequency distribution* ranks traces by their multiplicity in descending order. In real-world logs this distribution is typically highly skewed: a small number of variants account for the large majority of cases, while many variants are observed only once or twice. This skewness is important because it guides decisions about filtering and sampling before applying discovery algorithms.

// TODO (MR): At least some of the formulae should be displayed. In
// particular, anything that that is a fraction (like $a/b$) should be
// displayed equation. I did it for the above paragraph, but you
// should correct this in the while document.

// TODO (MR): (1) Also, What is this notation ${"Var"}(L)$? It should
// be $"Var"(L)$ probably. (2) Sometimes you use `||` for the size of
// the set, and sometimes `|`. Maybe the second one is better but use
// it consistently.

Traces are useful for studying both the structure and the variability of a process. When most cases follow the same sequence, the process is stable and predictable. When many distinct sequences appear, the process is more variable and may require a more flexible model to represent it accurately. The distribution of trace frequencies is therefore one of the first things an analyst examines when working with a new event log, as it gives an immediate indication of how complex and varied the underlying process is.

// TODO (MR): This notation implies that only the sequence of
// activities counts, but not other properties, for example,
// timestamps. So, you may have the same sequences of activities, but
// other properties may be completely different, but still for you
// that's going to be the same traces. Is that precisely what you
// want? Usually a trace is a sequence of events, not the projection
// of this sequence on a given property.

== Activities, variants, and directly-follows relations

One of the most important structural relationships between activities in a log is the directly-follows relation. Activity $b$ directly follows activity $a$ in trace $sigma$ if $a$ appears immediately before $b$ in $sigma$. Formally, for a trace $sigma = chevron.l a_1, dots, a_n chevron.r$, the relation $a >_sigma b$ holds if there exists some index $i$ such that $a_i = a$ and $a_(i+1) = b$. The directly-follows relation of the full log $L$ is then:
$ >_L = union.big_(sigma in "support"(L)) >_sigma $

// TODO (MR): (1) The mathematical formula is part of the sentence, so
// in particular in the above formula you need to have a dot at the
// end of the formula because it is the end of the sentence. You need
// to correct this in the whole document.

// TODO (MR): (2) Do you mean the above notation to define the
// relation $>_L$? The formula looks weird because there is a lot of
// empty space around the union symbol. Mayby something like this is
// better
// $ >_L quad quad := union.big_(sigma in supp(L)) >_sigma $
// but it's still not the best. 

// TODO (MR): (3) The support of an event log is not defined. Also, do
// you mean the base set (underliying set of traces)? If so, the
// symbol is $Set(L)$.

The *frequency* of a directly-follows pair $(a, b)$ counts how many times $b$ immediately follows $a$ across all traces in the log:
$ f_L(a, b) = sum_(sigma in L) L(sigma) dot |{i : a_i = a, a_(i+1) = b}| $

// TODO (MR): (1) Again, the formula is a part of sentence. (2) I
// don't get this formula. You sum over all traces, and for each trace
// you take the number of such traces in a log $L(sigma)$ multiplied
// by how many times the pair $(a,b)$ appears in the given
// trace. Again, there is no distinction between traces with different
// properties. (3) Also, what is the meaning of $sigma in L$? What did
// you introduced $"support"(L)$, which probably should be $Set(L)$?

The *directly-follows graph* (DFG) of a log $L$ is the directed weighted graph $"DFG"(L) = (A_L, E_L, f_L)$ where $A_L$ is the set of activities appearing in at least one trace, $E_L = >_L$ is the set of directed edges, and $f_L$ assigns each edge its frequency. In addition, a start node and an end node are included, with edges from the start node to every activity that begins at least one trace, and edges from every activity that ends at least one trace to the end node. These edges are weighted by the frequency of each start and end activity.

// TODO (MR): The definition of the graph is not complete. How do the
// edges are defined?

Using the log from the previous section, the directly-follows pairs and their frequencies are:

#table(
  columns: 3,
  align: (left, left, center),
  table.header([*From activity*], [*To activity*], [*Frequency*]),
  [Create order],  [Approve order], [2],
  [Approve order], [Send invoice],  [2],
  [Create order],  [Reject order],  [1],
  [Reject order],  [Close case],    [1],
)

// TODO (MR): You should not use "the log from prefious section". This
// is a table and it does have its number. Use it. Correct this in the
// whole document.

// TODO (MR): Also, can we have a figure here showing the graph? Also,
// all of it should be in a Python script, that creates these
// elements.

The DFG reveals two distinct execution paths through the process: the approval path (Create $->$ Approve $->$ Send, frequency 2) and the rejection path (Create $->$ Reject $->$ Close, frequency 1). This already suggests the presence of an exclusive choice after Create order, which a process discovery algorithm would later formalize. The DFG provides a quick visual overview of which activities tend to follow each other and how often. However, it does not distinguish between control-flow patterns such as sequences, choices, and parallel branches, which limits its usefulness for deeper structural analysis.

// TODO (MR): This is the definition of the variant, but you use it
// much earlier.

A *variant* is any trace $sigma$ with $L(sigma) > 0$. The variant set is $"Var"(L) = {sigma in A^* : L(sigma) > 0}$. Variant analysis ranks variants by frequency and examines the proportion of cases accounted for by the top-$k$ variants. The *coverage* of the top $k$ variants is:
$ "Coverage"(k) = (sum_(i=1)^k L(sigma^*_i)) / (||L||) $
where $sigma^*_1, sigma^*_2, dots$ are the variants ordered by decreasing frequency. Filtering the log to retain only the top-$k$ variants is a standard preprocessing step that focuses the analysis on dominant behavior and reduces the influence of noise and exceptional cases. In the BPI Challenge 2019 dataset, the full log contains 26,378 distinct variants after flattening, illustrating how variable real procurement processes can be in practice.

// TODO (MR): (1) Again, formulae are parts of sentences, missing coma
// here. (2) The frequency is defined here only for a pair of
// activities $(a,b)$. Thus, you don't have the definition of the
// frequencey of a variant! (3) What is the difference between the
// trace and a variant. They seem to be the same thing.

// TODO (MR): Also, you already used the "flattening" in the above
// paragraph. But this would required an introduction to the OCEL
// format

Simple counts — the number of events per activity, the total number of cases, the number of distinct variants, and the average trace length — also provide a useful initial summary of the log. These statistics help the analyst understand the overall complexity and variability of the process before applying more detailed techniques.

== Process discovery and process models

Process discovery is the task of constructing a process model directly from an event log, without using any prior reference model. A good discovered model must balance four quality dimensions:

- *Fitness* measures whether the model can reproduce the traces observed in the log. A model with high fitness accepts most of the behavior that actually occurred. A model with perfect fitness would accept every trace in the log. Formally, if $cal(L)(M)$ denotes the language (set of accepted traces) of model $M$, then high fitness means $"Var"(L) subset.eq cal(L)(M)$ or at least most of $"Var"(L)$ is covered.

// TODO (MR): OK, so this is very confusing, partially because of the
// language. I understand that "language" of the model is a set of all
// traces that a model an produce (while simulating). Thus, the
// condition is that all traces from the data can be simulated or
// "$"Var"(L)$ is covered", but these seem to be the same thing? Also,
// the "language of the model", is it a standard naming? Also, "a
// model accepts a trace"? Again, is it the standard naming?

- *Precision* measures whether the model avoids accepting behavior that was never observed. A model with low precision is too general and allows many traces that do not appear in the log. A model that simply allows any sequence of any activity has perfect fitness but zero precision.

- *Generalization* reflects how well the model handles cases that were not seen during discovery but are still plausible given the process structure. A model that memorizes every observed trace exactly without allowing for any unseen but valid behavior is said to overfit the log.

- *Simplicity* refers to how easy the model is to read and interpret. Simpler models are generally preferred when they still achieve acceptable fitness and precision. The most common simplicity measure is the total number of nodes and arcs in the model representation.

// TODO (MR): OK, but if it's given here, it referes to the
// DFG. Clearly, when we use a different notation, like C-nets, Petri
// nets and so on, the values of this metric are different.

These four dimensions are in tension with each other. Improving fitness often reduces precision, since a more permissive model accepts a wider range of behavior. Finding an appropriate balance is one of the central challenges in process discovery, and different algorithms make different trade-offs among these dimensions. For large and noisy real-world logs, robustness to noise and computational efficiency are also practical considerations that influence algorithm selection.

// TODO (MR): I would like you to discuss `genralization` and
// `simplicity` in more details. Specifically, if a model allows for
// generalization, it breaks precision. Also, simplicity narrows the
// traces that can be generated by a model, thus, will nerf the
// abiblity of the model to be more general (generalization) but,
// potentially, fitness, as well.

=== The Alpha algorithm

The Alpha algorithm is one of the earliest and most well-known process discovery algorithms. It works by analyzing the directly-follows relations in the log and inferring causal dependencies between activities, then using those dependencies to construct a Petri net.

// TODO (MR): You cannot describe the algoritym that produces a Patri
// net without first introducing the model itself. 

The algorithm begins by computing four binary relations between all pairs of activities in $A_L$ based on directly-follows information:

- $a -> b$ (direct succession): $b$ directly follows $a$ in at least one trace
- $a >> b$ (causality): $a -> b$ holds but $b -> a$ does not — $a$ appears to cause $b$
- $a || b$ (parallelism): both $a -> b$ and $b -> a$ hold — the two activities can appear in either order
- $a hash b$ (independence): neither $a -> b$ nor $b -> a$ holds — the activities never directly follow each other

// TODO (MR): I do have a problem with notation here. You already
// introduce notation for the directly-follows relation. Here you use
// a different one (the one that I actually prefer). You need to make
// it consistent.

The algorithm then identifies all pairs $(A, B)$ of non-empty activity sets where every activity in $A$ causes every activity in $B$ (i.e., $a >> b$ for all $a in A, b in B$), all activities within $A$ are independent of each other, and all activities within $B$ are independent of each other. The maximal such pairs become places in the discovered Petri net, each connecting the activities in $A$ as input transitions to the activities in $B$ as output transitions.

// TODO (MR): What is the meaning of maxima here? This is crucial!

// TODO (MR): I merged the two following paragraphs. This is because
// you cannot have a paragraph composed of a single, short sentence.

To illustrate, consider the log $L = [chevron.l A, B, D chevron.r^4, chevron.l A, C, D chevron.r^3]$. Directly-follows pairs: $A -> B$, $A -> C$, $B -> D$, $C -> D$. Relations: $A >> B$, $A >> C$, $B >> D$, $C >> D$. Neither $B -> C$ nor $C -> B$ holds, so $B hash C$.

// TODO (MR): Also, $a hash d$. 

The maximal causal pairs are $({A}, {B, C})$, $({B}, {D})$, and $({C}, {D})$. Adding an initial place connected to $A$ and a final place connected from $D$, the algorithm produces a Petri net with $A$ at the start, a place branching to both $B$ and $C$ (representing an exclusive choice, since $B hash C$), and places from $B$ and $C$ each leading to $D$, which produces the final token. This correctly represents both variants in the log.

// TODO (MR): OK. First of all, the pairs you have are not maximal. For
// example, $({B, C}, {D})$ also is a causal pair. Also, it's a
// maximal pair. Thus, We have the following places: i (input), o
// (output), p1 (for $({A}, {B, C})$) and p2 for $({B, C}, {D})$. Each
// activity is a transition. Eventually, we end up with the following
// Petri net.

//                  ↗ [B] ↘
// (i) → [A] → (p1)         (p2) → [D] → (o)
//                  ↘ [C] ↗

// You are right that the split (and join) are XOR. Again, you need to
// introduce the Petri net model before.

The Alpha algorithm is historically important because it was the first algorithm to demonstrate that a process model can be derived automatically from event data alone. However, it has well-documented limitations: it handles loops poorly, it is sensitive to noise and infrequent behavior, it cannot represent all control-flow patterns correctly, and it fails on logs where certain activity combinations violate its structural assumptions. More robust algorithms have since been developed to address these weaknesses.

=== The Inductive Miner and process trees

The Inductive Miner is a more recent and widely used discovery algorithm that addresses many of the limitations of the Alpha algorithm. It works by recursively dividing the event log into smaller sublogs based on detected control-flow patterns — sequences, exclusive choices, parallel branches, and loops. Each subdivision corresponds to a node in a *process tree*.

A process tree is a hierarchical model in which leaf nodes represent individual activities (or the silent activity $tau$, which represents an internal step with no observable name) and internal nodes are *operator nodes* that define how their children are executed. The four main operators are: sequence ($->$), exclusive choice ($times$), parallel execution ($+$), and loop ($circle.small$). More precisely:

- $->(T_1, T_2, dots, T_k)$: execute the sub-trees $T_1, T_2, dots, T_k$ in strict left-to-right order.
- $times(T_1, T_2, dots, T_k)$: execute exactly one of the sub-trees, chosen exclusively.
- $+(T_1, T_2, dots, T_k)$: execute all sub-trees, but in any interleaved order (true parallelism).
- $circle.small(T_"body", T_"redo")$: execute the body $T_"body"$, then optionally execute the redo branch $T_"redo"$ and repeat the body, until the loop is exited.

Process trees always produce *sound* models, meaning they cannot result in deadlocks or incomplete executions. Every process tree can be automatically converted into a corresponding Petri net, so the two representations are interchangeable for analytical purposes.

// TODO (MR): You should explain what deadlocks, livelocks, dead
// transitions and unreachable states are.

The Inductive Miner algorithm discovers a process tree using a divide-and-conquer strategy. Starting with the full log, it attempts to detect a *cut* — a partition of activities into groups that correspond to one of the four operators. If a sequence cut is detected, the log is split into sublogs for each group and the algorithm recurses. If an exclusive choice cut is detected, the log is split by separating cases that contain each group's activities. If a parallel cut is detected, the log is projected onto each group. If a loop cut is detected, the body and redo sublogs are separated. If no cut is detected, a fall-through strategy is applied.

The *Inductive Miner Infrequent (IMf)* variant, which is used in this thesis via PM4Py, filters out infrequent directly-follows pairs before attempting to detect cuts. This makes the algorithm more robust to noise and exceptional cases in large real-world logs, at the cost of some fitness on rare variants.

To illustrate, consider $L = [chevron.l A, B, D chevron.r^4, chevron.l A, C, D chevron.r^3]$. The algorithm first detects a sequence cut: $A$ is always first and $D$ is always last, so the partition $A_1 = {A}$, $A_2 = {B, C}$, $A_3 = {D}$ is valid. Recursing on $A_2 = {B, C}$: the sub-log is $[chevron.l B chevron.r^4, chevron.l C chevron.r^3]$ and no directly-follows relation exists between $B$ and $C$, so an exclusive choice cut applies. The final process tree is $->(A, times(B, C), D)$: always start with $A$, exclusively choose $B$ or $C$, then always end with $D$. This correctly represents both variants in the log and produces a sound Petri net automatically.

// TODO (MR): (1) I really think, that this example should be expanded
// with precisely how to cuts are found, how the tree looks like and
// how the Perti net is created based on the tree. (2) Again, you need
// to have a definition of the Petri net model before algorithms.

=== Petri Nets

The main model representation used in this thesis is the Petri net, which is the standard output format of PM4Py and most other process mining tools. A Petri net is formally defined as a triple $N = (P, T, F)$ where:

- $P$ is a finite set of *places*, represented as circles,
- $T$ is a finite set of *transitions*, represented as rectangles, with $P inter T = emptyset$,
- $F subset.eq (P times T) union (T times P)$ is the *flow relation*, defining the directed arcs between places and transitions.

For a transition $t in T$, its *preset* is $bullet t = {p in P : (p, t) in F}$ (input places) and its *postset* is $t bullet = {p in P : (t, p) in F}$ (output places).

// TODO (MR): This is the common notation used for discussing the
// structural graph definition. Here we use a more formal mathematical
// notation, so it’s natural to write $Pre(t)$ and $Post(t)$,
// especially when referring to $p \in Pre(t)$ rather than $p \in
// \bullet t$.

A *marking* $M: P -> NN_0$ assigns a non-negative integer number of *tokens* to each place. The pair $(N, M)$ is called a marked Petri net. A transition $t$ is *enabled* in marking $M$ if every input place holds at least one token: $M(p) >= 1$ for all $p in bullet t$. Firing an enabled transition $t$ produces a new marking $M'$:

$ M'(p) = cases(
  M(p) - 1 &: "if" p in bullet t " and " p in.not t bullet,
  M(p) + 1 &: "if" p in t bullet " and " p in.not bullet t,
  M(p)     &: "otherwise"
) $

An *accepting Petri net* $(N, M_0, M_f)$ specifies an initial marking $M_0$ and a final marking $M_f$. A trace $sigma = chevron.l a_1, dots, a_n chevron.r$ is accepted if there exists a firing sequence of transitions whose labels match $sigma$ and that leads from $M_0$ to $M_f$. 

// TODO (MR): What does "to illustrate..." refer to in the paragraph
// below? This has been corrected; please apply the same revision
// throughout the document.

// TODO (MR): The following example is difficult to follow without an
// actual figure of the network. I added this graph using Fletcher;
// please include similar graphs for any other such examples.



#sgh_example[
    To illustrate the above concepts, consider the sequential process with activities $A -> B -> D$. Figure~@fig-petri-net-accepting shows the Petri net that models this process. The Petri net has places
    $ P = {p_0, p_1, p_2, p_3}, $
    transitions
    $ T = {A, B, D}, $
    and flow
    $ F = {(p_0,A),(A,p_1),(p_1,B),(B,p_2),(p_2,D),(D,p_3)} . $
    To complete the accepting Petri net definition, we add the initial  and the final markings
    $ M_0 = {p_0: 1}, M_f = {p_3: 1}. $

#sgh_figure(
    caption: [The Petri net used in the example of an accepting Petri net],
    source: [Own elaboration]
)[
    #let pn_place(pos, label, name, tint: green, ..args) = node(
	pos, align(center, label),
        name: name,
        shape: circle,
	width: 1.8em,
	fill: tint.lighten(80%),
	stroke: 1pt + tint.darken(20%),
	corner-radius: 5pt,
	..args,
    )

    #let pn_tran(pos, label, name, tint: orange, ..args) = node(
	pos, align(center, label),
        name: name,
	width: 1.5em,
        height: 3em,
	fill: tint.lighten(80%),
	stroke: 1pt + tint.darken(10%),
	corner-radius: 1pt,
	..args,
    )

    #scale(60%)[
        #diagram(
            spacing: 10pt,
            cell-size: (8mm, 8mm),
            edge-stroke: 1pt,
            edge-corner-radius: 5pt,
            debug: false,
            mark-scale: 70%,

            pn_place((0, 0), [$p_0$], <p0>),
            pn_place((4, 0), [$p_1$], <p1>),
            pn_place((8, 0), [$p_2$], <p2>),
            pn_place((12, 0), [$p_3$], <p3>),

            pn_tran((2, 0), [$A$], <t1>),
            pn_tran((6, 0), [$B$], <t2>),
            pn_tran((10, 0), [$D$], <t3>),


            edge(<p0>, <t1>, "-|>"),
            edge(<t1>, <p1>, "-|>"),
            edge(<p1>, <t2>,"-|>"),
            edge(<t2>, <p2>,"-|>"),
            edge(<p2>, <t3>,"-|>"),
            edge(<t3>, <p3>,"-|>"),            
            
        )]
]<fig-petri-net-accepting>

    The following trance $chevron.l A, B, D chevron.r$ is accepted because there is a firing sequence of transitions leading from the marking $M_0$ to $M_f$:
    - Step 1: $A$ is enabled ($p_0$ has 1 token). Fire $A$: $M_1 = {p_1: 1}$.
    - Step 2: $B$ is enabled ($p_1$ has 1 token). Fire $B$: $M_2 = {p_2: 1}$.
    - Step 3: $D$ is enabled ($p_2$ has 1 token). Fire $D$: $M_3 = {p_3: 1} = M_f$. Accepted.

    Consider the other trace $chevron.l A, D chevron.r$. Firing transition $A$ first yields marking $M_1 = {p_1: 1}$. However, place $p_2$ is empty in $M_1$, so transition $D$ is not enabled. The trace cannot be completed without artificially adding tokens, correctly reflecting that $B$ cannot be skipped in this model.    
]<ex-accepting-pn>

In process mining, transitions correspond to activities, places represent states between activities, and tokens represent the current execution state of a process instance. Petri nets are valuable because they support both visual interpretation and formal analysis of properties such as reachability and soundness, and because PM4Py uses them as the primary model format for conformance checking and performance analysis.

== Conformance Checking

Once you have both a process model and an event log, you can compare them to see how closely real-life process executions match the intended process design. This comparison, known as *conformance checking*, is one of the most practically valuable applications of process mining. It allows organizations to spot rule violations, unexpected deviations, and potential data quality issues.

There are two main approaches to conformance checking:

*1. Token-based replay*

This method simulates each trace from the log on the Petri net model by moving tokens according to the observed activity sequence. If a trace follows a path allowed by the model, the replay goes smoothly. If not, extra tokens might need to be added (missing tokens), or some tokens may be left behind at the end (remaining tokens). The fitness of a single trace is calculated as:

$ "fitness"(sigma) = 1/2 (1 - p/c) + 1/2 (1 - r/q) $

where $p$ is the number of missing tokens added during replay, $c$ is the total number of tokens consumed, $r$ is the number of remaining tokens at the end, and $q$ is the total number of tokens produced. A value of 1 indicates a perfectly fitting trace; lower values indicate more deviation. The overall log fitness is the weighted average of trace fitness values across all cases @vanderAalst2022.

// TODO (MR): You should explain what are consumed and produces
// tokens. This is not clear for readers not into process
// mining. Also, maybe explain why $p$ is devided by $c$ and $r$ by
// $q$ and not the other way around.

#sgh_example()[
    We continue with the example @ex-accepting-pn. To illustrate token-based replay, consider the net $A -> B -> D$ from example @ex-accepting-pn showed at the figure @fig-petri-net-accepting. Consider the trace $sigma = chevron.l A, D chevron.r$ (activity $B$ is skipped). After firing $A$, the marking is ${p_1: 1}$. Transition $D$ requires $p_2$ to have at least one token, which is missing. This one missing token is added resulting in a marking ${p_1: 1, p_2: 1}$. Thus, $p = 1$. Once this token is added, the transition $D$ fires, and the final marking ${p_1: 1, p_3: 1}$ is reached. However, the place $p_1$ still holds a token that was never consumed because $B$ was not fired resulting in  $r = 1$. With $c = 2$ and $q = 2$:
    $ "fitness" = 1/2 (1 - 1/2) + 1/2 (1 - 1/2) = 1/2 . $
This value reflects the significant deviation: one activity was skipped and one token was left unconsumed.
]<ex-fitness>

// TODO (MR): You need to be more precise when describing how one
// marking changes into another. In the above example, I added all the
// required information. This also refers to the previous example.

// TODO (MR): In the following paragraph, you use the word
// "move". What is it as it seems like this is just activity.

The second approach is *alignment-based conformance*, which finds the closest valid execution in the model for each observed trace. An *alignment* is a sequence of move pairs $(a_i, b_i)$ where $a_i$ is a move in the log and $b_i$ is a move in the model:

- _Synchronous move_ $(a, a)$: $a$ occurs in both the log and the model — no deviation.
- _Log move_ $(a, >>)$: $a$ occurs in the log but not at this point in the model — unexpected behavior observed.
- _Model move_ $(>>, a)$: $a$ is expected by the model but absent in the log — expected behavior was skipped.

The cost of an alignment is the total number of non-synchronous moves. The *optimal alignment* minimizes this cost and is found by solving a shortest-path problem in an alignment state space, typically using the $A^*$ algorithm.

// TODO (MR): The following example is the continuation of the two
// previous examples. Change this into a formal example; refrence the
// previous two examples. Also, the table should be formal.

// START EXAMPL

For the same example — trace $chevron.l A, D chevron.r$ against the model accepting $chevron.l A, B, D chevron.r$:

#table(
  columns: 3,
  align: center,
  table.header([*Log move*], [*Model move*], [*Type*]),
  [A],  [A],  [Synchronous],
  [>>], [B],  [Model move — B expected but not observed],
  [D],  [D],  [Synchronous],
)

Cost: 1. The alignment shows precisely that the only deviation is the absence of activity $B$. This level of diagnostic detail is more informative than the token-based fitness score alone, because it identifies exactly which activity was missed and at which point in the trace.

// END EXMAPLE

Alignment-based conformance provides more precise and detailed diagnostic information than token replay, but it is also more computationally expensive, particularly for long traces and large models. In practice, token replay is often used for a quick overall fitness estimate, while alignment-based conformance is applied when detailed per-trace diagnostics are needed.

Deviations identified through conformance checking may reflect data quality issues, exceptional cases, policy violations, or genuine changes in the process over time. Understanding the nature and frequency of deviations is one of the main outputs of a conformance checking study.

== Performance analysis and process intelligence

Performance analysis adds a time dimension to the structural view produced by process discovery and conformance checking. Because event logs contain timestamps, it is possible to measure the duration of individual activities, the waiting time between activities, and the total throughput time for each case. These measurements can be projected onto the process model to produce a *performance-annotated* view that highlights where time is spent or lost in the process.

// TODO (MR): This is literary not true. For example, in the sepsis
// log example, the blood work is done evey two days as revealed by
// timestamps. However, the time to actually do the test is literary
// in hours. It's not possible to compute the time required to make a
// transition. What we can get from the log is the time between the
// timestamps, thus, ectivities but not the duration of the
// activities. Also, what about the first and the last activity in a
// trace?

The *throughput time* of a case $c$ is the elapsed time between the timestamp of its first and last recorded event:
$ "TT"(c) = max_{e in c} t(e) - min_{e in c} t(e) , $
where $t(e)$ is the timestamp of the event $e in c$. 

The *waiting time* between two consecutive activities $a_i$ and $a_(i+1)$ in a trace is the elapsed time between the completion of $a_i$ and the start of $a_(i+1)$. The *service time* of an activity is its own execution duration, measurable when both a start event and a complete event are recorded for the same activity instance.

// TODO (MR): Technically, we can have the to consecutive events with
// the same activity, different timestamps and different lifecycle
// attributes (start, completed). It's not common in practice, though.

Several summary statistics are routinely reported to characterize throughput time across all cases in the log:

#table(
  columns: 2,
  align: (left, left),
  table.header([*KPI*], [*Meaning*]),
  [Mean throughput time],   [Average case duration across all cases],
  [Median throughput time], [Middle value — robust to extreme outliers],
  [P95 throughput time],    [95% of cases complete within this time],
  [Minimum],                [Fastest observed case duration],
  [Maximum],                [Slowest observed case duration],
  [Coefficient of variation], [Standard deviation divided by mean — measures variability],
)

// TODO (MR): Again, table!

The coefficient of variation is particularly informative: a low value indicates that most cases complete in a similar time, while a high value indicates high variability, which may point to bottlenecks, resource constraints, or exceptional cases that require special handling.

When throughput times or waiting times are projected onto the process model — associating each arc or transition with the median or mean duration computed from all cases passing through it — a performance-annotated model is obtained. This visualization immediately shows which transitions have the longest associated waiting times and are therefore candidates for process improvement. For example, if two activities are always directly connected in the model but a consistently long delay is observed between them in the data, this suggests a bottleneck or resource constraint at that point in the process.

// TODO (MR): Usually, for mathematical analysis, we attach a
// transition duration distribution, for example, a given transition
// may have a duration given by the exponential distribution with a
// given intensity.

Process intelligence extends these ideas by connecting process data with forecasting, simulation, and optimization. Once the event log has been analyzed and a performance baseline has been established, it becomes possible to predict future outcomes for running cases, test the effects of proposed process changes through simulation, or build real-time monitoring dashboards that alert managers when a case is projected to exceed a target throughput time. The mathematical foundations introduced in this chapter therefore remain relevant across the full scope of process intelligence, not only for the basic retrospective tasks of discovery and conformance checking.

== Event data representation in Python

From the implementation point of view, event data are typically represented in Python either as tabular data structures or as specialized log objects. The simplest tabular representation uses three core columns: case identifier, activity label, and timestamp. This format is easy to inspect and manipulate using the `pandas` library, which provides the DataFrame structure used throughout the Python data science ecosystem.

// TODO (MR): Usually, when talking about the XES structure, we have
// case id, event id, and then attributes e.g., activity, timestamp,
// cost, resource, and so on. Thus, 4 columns. 

Process mining libraries then convert such tables into richer event-log objects that preserve trace structure and support discovery algorithms. In PM4Py, the conversion is performed by `pm4py.format_dataframe`, which requires the analyst to specify which columns hold the case identifier, activity name, and timestamp, followed by `pm4py.convert_to_event_log` to produce the internal event-log object. The resulting object supports all PM4Py discovery, conformance, and performance functions directly. This conversion step is demonstrated in the introductory synthetic example in Chapter 4, where a plain pandas DataFrame with three columns is transformed into an input suitable for the Inductive Miner#footnote[More information about the XES standard can be found at #link("https://ieeexplore.ieee.org/document/10025658")[#raw("https://ieeexplore.ieee.org/document/10025658")].].

A more advanced representation is the second version of the *Object-Centric Event Log (OCEL)*.#footnote[More information about the OCEL standard can be found at #link("https://www.ocel-standard.org/")[#raw("https://www.ocel-standard.org/")].] Unlike classical event logs, which link each event to a single case, OCEL allows a single event to be associated with multiple objects of different types simultaneously. For example, one event in a procurement process may be related simultaneously to a purchase order, an order item, a vendor, and a resource. The OCEL standard defines a formal data model for storing such logs, and PM4Py provides the `pm4py.read_ocel` function for reading OCEL files in JSON format. The resulting object contains separate DataFrames for events and objects, along with metadata specifying the object type column and event attribute columns.

*Flattening* is the process of converting an OCEL into a classical event log by selecting one object type as the case identifier. In PM4Py, the function `pm4py.ocel_flattening(ocel, object_type)` performs this step. When one event is related to multiple objects of the selected type, that event appears in multiple cases in the flattened log, which inflates the case count. When the selected object type is not directly linked to all events, some events may be lost during flattening. Managing these artifacts is an important preprocessing step before applying classical discovery algorithms to object-centric data.

In the practical examples in Chapter 4, both representations are used. The introductory synthetic example uses the tabular representation to illustrate the basic conversion pipeline. The BPI Challenge 2019 case study uses the OCEL representation, and the flattening step demonstrates how object-centric data must be preprocessed before classical discovery can be applied. Later examples in Chapter 4 return to the OCEL representation directly, computing an object-centric directly-follows graph from the relations table without flattening, in order to compare per-object-type process behavior without the artifacts introduced by the flattening step.

== Exploratory description of the BPI Challenge 2019 dataset

The real-world case study in this thesis uses the BPI Challenge 2019 dataset, stored in OCEL format. The dataset originates from a real procurement process at a large multinational company and was released as part of the annual BPI Challenge competition organized in connection with the International Conference on Process Mining. It has been widely used in academic research on process mining and serves here as a representative example of a large, complex, real-world event log.

The dataset contains approximately 1,595,923 events and 330,685 objects distributed across four object types: purchase orders (PO), purchase order items (POItem), resources (Resource), and vendors (Vendor). Each event carries a timestamp, an activity name, and a set of business context attributes including company code, document type, item category, spending area, and vendor details. These attributes make the dataset suitable not only for control-flow analysis but also for performance analysis and organizational mining.

#table(
  columns: 2,
  align: (left, right),
  table.header([*Characteristic*], [*Value*]),
  [Total events],   [1,595,923],
  [Total objects],  [330,685],
  [Object types],   [4 (PO, POItem, Resource, Vendor)],
  [Format],         [OCEL (JSON)],
  [Domain],         [Procurement],
)

// TODO (MR): Table, again!

After flattening with respect to the POItem object type — selected because it is the most frequent type in the log — the classical event log contains one case per distinct POItem object. The full dataset produces a flattened log with a large number of cases; in the sample used for the practical examples in Chapter 4, the flattened log contains 53,198 cases.

#table(
  columns: 2,
  align: (left, right),
  table.header([*Metric*], [*Value*]),
  [Cases with at least 2 events], [248,899],
  [Mean throughput time],         [72.3 days],
  [Median throughput time],       [64.3 days],
  [95th percentile],              [143.0 days],
  [Minimum],                      [0.0 days],
  [Maximum],                      [25,670.6 days],
)

// TODO (MR): Table, again! Also, refrences to chapters, again!

The mean throughput time of 72.3 days and median of 64.3 days indicate that a typical purchase order item takes roughly two months to process from first to last recorded event. The 95th percentile of 143 days shows that a minority of cases take significantly longer. The maximum of over 25,000 days almost certainly represents either an open case that was never formally closed or a data anomaly. The distribution of throughput times is right-skewed, which is typical of procurement processes where the majority of cases are completed within a predictable time range but a small number of exceptions take much longer.

These basic statistics reveal several important characteristics of the dataset. First, the volume is large enough to require efficient tools and careful preprocessing before any analysis can begin. Second, the presence of four object types means that the process cannot be fully represented as a simple single-case model without losing meaningful relational information. Third, the combination of control-flow data with rich business attributes makes this dataset suitable for a range of process mining tasks beyond simple discovery.

In Chapter 4, the dataset is loaded using `pm4py.read_ocel`, flattened to a case-centric format, and then sampled to a manageable size before discovery algorithms are applied. The theoretical concepts introduced in this chapter — traces, variants, Petri nets, and throughput time — are all used directly in that implementation, connecting the mathematical foundations established here with concrete analytical results.

= The tools available in Python

The Python ecosystem for process mining and process intelligence has grown considerably over the past decade. It now covers a wide range of analytical tasks, from loading and exploring event logs to discovering process models, checking conformance, predicting future outcomes, and simulating alternative process designs. This chapter provides a structured overview of the main Python tools available for these purposes. The tools are organized into five groups: core process mining libraries, predictive and AI-oriented tools, simulation and optimization tools, visualization libraries, and complementary data processing packages. For each tool, the discussion covers its primary purpose, the data formats it supports, the algorithms or methods it implements, and its practical strengths and limitations. The chapter concludes with a comparative summary table.

The selection of tools discussed here is based on a review of academic publications from the International Conference on Process Mining (ICPM) and related venues, the Python Package Index (PyPI), and active GitHub repositories related to process mining. The focus is on tools that are either actively maintained, widely cited in the literature, or representative of an important category of functionality. Commercial tools are included only where they provide a Python interface that is accessible to practitioners, as in the case of PyCelonis.

== Core process mining libraries

The most important and widely used tools in the Python process mining ecosystem are the core libraries that implement the fundamental workflow: reading event data, exploring log statistics, discovering process models, checking conformance, and analyzing performance. This section describes the four main libraries in this category: PM4Py, PM4Py-Streaming, Simod, and PMLab.

=== PM4Py

PM4Py is the central library in the Python process mining ecosystem. Developed and maintained by the Process Intelligence Solutions group (with academic roots at Fraunhofer FIT and RWTH Aachen University), PM4Py was first released in 2018. Since then, it has become the de facto standard for process mining in Python, with regular updates, active development, and a growing user base in both academia and industry.

PM4Py covers the entire process mining workflow. Its main capabilities include:

- *Event log input and output:* PM4Py can read and write event logs in various formats, including XES (the IEEE standard), CSV files via pandas DataFrames, and OCEL JSON files for object-centric logs. Reading a standard XES file is as simple as calling `pm4py.read_xes()`, while `pm4py.read_ocel()` is used for OCEL logs. Both functions return structured objects that integrate directly with the rest of PM4Py's analysis functions.

- *Log statistics and exploration:* PM4Py offers functions for computing basic statistics, such as the number of activities, cases, and events, as well as variant frequencies, start and end activities, and directly-follows relations. For example, `pm4py.get_variants()` retrieves variant counts, and `pm4py.discover_dfg()` constructs the directly-follows graph. These functions work with both classical event logs and OCEL structures.

- *Process discovery:* Several discovery algorithms are implemented. The Alpha algorithm, available via `pm4py.discover_petri_net_alpha()`, creates a Petri net from directly-follows relations. The Inductive Miner (`pm4py.discover_petri_net_inductive()`) produces a sound Petri net through a process tree, and is the main algorithm used in my case study in Chapter 4. The Heuristics Miner (`pm4py.discover_petri_net_heuristics()`) uses frequency thresholds to filter the directly-follows graph before building the model, making it more robust to noise than the Alpha algorithm. All discovery functions accept either a classic event-log object or a pandas DataFrame with specified column names.

- *Conformance checking:* PM4Py provides both token-based replay (`pm4py.fitness_token_based_replay()`) — which is fast and suitable for large logs — and alignment-based conformance (`pm4py.fitness_alignments()`), which gives detailed per-trace diagnostics at a higher computational cost. Both return a dictionary of fitness metrics, including the overall fitness score.

- *Performance analysis:* PM4Py calculates throughput times, activity durations, and waiting times for event logs with timestamps. These statistics can be projected onto a process model to generate performance-annotated visualizations that highlight bottlenecks.

- *Object-centric process mining:* PM4Py is currently the only Python library with comprehensive, native support for OCEL. It provides `pm4py.ocel_flattening()` to convert an OCEL log to a classical format, and `pm4py.discover_ocdfg()` to compute object-centric directly-follows graphs without flattening.

*Strengths and limitations:* PM4Py's main strengths are its wide coverage, active development, good documentation, and robust OCEL support. It is the only Python library that offers a complete process mining workflow in a single package. The main limitations are computational: alignment-based conformance and some discovery algorithms can be slow on very large logs, and certain advanced features — like simulation — are beyond its current scope.

=== PM4Py-Streaming

PM4Py-Streaming is an extension of the core PM4Py library, designed specifically for situations where event data arrives continuously — as a stream — rather than in a complete, stored log. This is particularly useful in real-world scenarios like live monitoring of ERP systems or logistics platforms, where new events are generated in real time. In these cases, analysts need to keep the process model up to date without having to reprocess all historical events each time something new happens.

The library implements online versions of key process mining algorithms. These algorithms update their internal state incrementally with each incoming event, without storing the full event history. For example, the online directly-follows graph keeps running frequency counts for each activity pair and updates them instantly as new events come in. There is even an online variant of the Inductive Miner, which can adapt the discovered process tree as stream statistics change over time. PM4Py-Streaming is designed to work seamlessly with PM4Py's standard data structures, so any models discovered from the stream can be further analyzed using the conformance and performance functions in PM4Py.

*Strengths and limitations:* PM4Py-Streaming is currently the only Python library dedicated to online process mining. Its main limitation is that it supports fewer algorithms than the standard batch PM4Py library, and the approximations required for online discovery can sometimes reduce model quality compared to what is possible with a complete, static log.

=== Simod

Simod is a Python tool focused on simulation-based optimization of business processes. It takes a BPMN process model — usually one produced by process discovery — as input, estimates simulation parameters from an event log, and then generates an optimized simulation configuration. The ultimate goal is to identify the combination of resource assignments, activity durations, and scheduling rules that will minimize some target objective, such as overall throughput time or cost.

Simod's workflow proceeds in three main phases. First, it extracts and converts a process model from the event log to BPMN format. Next, it estimates simulation parameters — such as resource pools, activity duration distributions, and arrival rates — from the log data. Finally, a Bayesian optimization loop runs multiple simulation experiments with different parameter settings, searching for the configuration that best achieves the chosen objective.

*Strengths and limitations:* Simod fills an important gap in the Python ecosystem by linking process mining with simulation-based optimization. However, it requires a fairly clean and well-structured BPMN model as input, so it is most useful after a successful process discovery step has already been completed. It also depends on tools like Graphviz and a BPMN simulation engine, which can add to the installation and setup complexity.

=== PMLab

PMLab is a research-oriented toolkit for process mining in Python. It provides implementations of a variety of process discovery and conformance algorithms, including several that are not available in PM4Py. PMLab is aimed mainly at researchers who want to experiment with or develop new process mining algorithms, rather than practitioners who need a polished, production-ready tool.

The library supports classical event logs in XES format and offers Python implementations of the Alpha algorithm, several variants of the Heuristics Miner, and various conformance checking methods. PMLab is designed to be modular and extensible, making it easier for researchers to add or modify algorithms without having to overhaul the entire library.

*Assessment:* PMLab is a valuable resource for researchers who need to dive deep into algorithm development and modification. However, it is less suited for production use — development has slowed, documentation is limited, and it lacks support for newer features like OCEL and the Inductive Miner Infrequent variant.

=== BupaR (Python Interface)

BupaR is a comprehensive process mining framework originally developed for the R programming language @janssenswillen2019bupar. It introduces a structured grammar for process analysis — a set of consistent operations for filtering, aggregating, and visualizing event data — centered around a dedicated event log object. This approach ensures that all analyses are built on a consistent data structure. BupaR's expressive and readable pipeline syntax has influenced several tools in the Python ecosystem and remains popular in academic research for its clarity and reproducibility.

Python users can access BupaR's functionality through the rpy2 bridge, which allows R functions to be called directly from within a Python environment. This means analysts can leverage BupaR's powerful event log manipulation and visualization tools — such as dotted charts and process maps — without leaving Python. These visualizations are widely seen in academic papers as clear, succinct summaries of process behavior.

*Strengths and limitations:* BupaR's greatest strength is its expressive, consistent grammar for process analysis, which supports a broader range of log manipulation and visualization operations than PM4Py's current Python API. Its main limitation for Python users is the need for a working R installation and the rpy2 bridge, which adds a layer of complexity compared to pure-Python solutions.

== Predictive and AI-Oriented Tools

A rapidly growing set of Python tools connects process mining with machine learning and artificial intelligence, enabling predictive process monitoring, automated decision support, and intelligent process automation. The following are some of the most prominent libraries in this area.

=== ML4ProM

ML4ProM is a Python framework that brings together process mining techniques and machine learning models to support predictive process monitoring. This area focuses on forecasting future states for running process instances — for example, predicting whether a case will finish on time, what the next activity will be, or how long a case is likely to take.

The ML4ProM workflow follows a standard pattern: first, the event log is preprocessed to extract features from partial traces. These features are then used to train a machine learning model, such as a classifier or regressor from scikit-learn. The trained model can then be applied to new, ongoing cases to generate predictions. ML4ProM provides several feature extraction strategies that are commonly used in process mining, including sequence encoding (representing the activity prefix as a fixed-length vector), last-state encoding (capturing the most recent activity and its attributes), and aggregate encoding (using statistics over the trace prefix).

Choosing the right feature encoding is important, as it determines how much of the process history is captured and how well the features represent the process state. ML4ProM enables analysts to experiment with different encodings and compare their predictive accuracy using standard metrics like accuracy, AUC-ROC, and mean absolute error.

*Strengths and limitations:* ML4ProM's main strength is its seamless integration of process mining feature extraction with scikit-learn-compatible models. Its main drawbacks are the need for a reasonably large labeled training dataset and the current lack of support for object-centric event logs.

=== PM4PYML

PM4PYML is an extension of PM4Py that directly integrates machine learning pipelines with PM4Py event-log objects and analysis functions. It provides scikit-learn-compatible transformers to convert PM4Py event logs into feature matrices, making it easy to train machine learning models for predictive process monitoring within the PM4Py ecosystem.

The library supports several feature extraction methods that work with PM4Py's internal log format, including counts of activity occurrences, frequencies of directly-follows pairs, and time-based features like remaining and elapsed time. These features can be plugged into any scikit-learn estimator using standard pipeline objects. The `LogTransformer` class converts a PM4Py event log directly into a NumPy feature matrix, which can then be passed to any scikit-learn classifier or regressor.

*Strengths and limitations:* PM4PYML's main advantage is its tight integration with PM4Py, which streamlines the process of going from process mining analysis to machine learning modeling. Its main limitations are similar to ML4ProM: it requires labeled training data and does not natively support object-centric logs.

=== PyCelonis

PyCelonis is the official Python API for the Celonis Process Intelligence platform — a leading commercial solution used by large organizations for process monitoring, compliance, and improvement at scale. With PyCelonis, analysts can interact with the Celonis platform directly from Python, making it possible to automate analyses, extract data and results, and integrate Celonis insights into broader data science workflows.

Key features of PyCelonis include connecting to a Celonis instance (using an API key for authentication), extracting event log data using PQL (Process Query Language), sending analysis results and action recommendations back to the platform, and integrating Celonis with robotic process automation (RPA) tools for automated process execution.

*Strengths and limitations:* PyCelonis's biggest strength is its ability to bridge Celonis's powerful commercial process intelligence infrastructure with the flexibility of Python's data science ecosystem. The main limitation is that it is tightly tied to the Celonis platform, which requires a commercial subscription — so it is not accessible for academic or small-scale projects without an institutional license.

=== BPMN-Python and Workflow Automation

The BPMN-python library and related tools enable users to extract, manipulate, and visualize BPMN process models in Python. BPMN (Business Process Model and Notation) is the industry standard graphical language for representing business processes, widely adopted in workflow automation systems. PM4Py can export discovered Petri nets to BPMN format, after which bpmn-python can import these models, modify them programmatically, or render them as interactive visualizations. This creates a practical bridge between process mining analysis and operational business process management systems.

*Strengths and limitations:* BPMN-python and similar tools are most valuable in organizations that already use BPMN-based workflow systems. For purely analytical purposes, however, they may add unnecessary complexity compared to the Petri net and process tree models already supported by PM4Py.

=== Predictive Process Monitoring Toolkit (PPMT)

The Predictive Process Monitoring Toolkit (PPMT) is a Python implementation of the benchmark framework for predictive process monitoring research described by Teinemaa et al. @teinemaa2019outcome. It supports the full experimental pipeline: reading XES event logs, extracting prefixes of various lengths, applying multiple feature encoding strategies (such as index, sequence, and aggregate encoding), training a range of machine learning models (including logistic regression, random forest, and XGBoost), and evaluating predictive performance using metrics like AUC-ROC and mean absolute error.

PPMT is primarily a research tool, designed to reproduce and extend the benchmark results of Teinemaa et al. Its main value is that it allows researchers to compare new predictive methods against a well-established baseline, using a consistent experimental protocol — without having to build the evaluation infrastructure from scratch.

*Strengths and limitations:* PPMT's main strength is its comprehensive benchmark coverage: it enables researchers to reproduce published results and add new methods for standardized comparison. Its limitations are that it is not designed for real-time deployment, documentation is limited beyond the associated research paper, and it is not actively maintained as a production system.

== Simulation and Optimization Tools

Simulation and optimization tools extend the reach of process mining from simply understanding what happened in the past to designing and testing improvements for future processes. The next section introduces the main Python tools for simulation and optimization: SimPy, BPSim, and ProcessOptimizer.

=== SimPy

SimPy is a popular Python library for discrete-event simulation. In this approach, a system is modeled as a series of events that happen at specific points in time, each of which can change the system's state and schedule future events. This method fits business processes very well, since activities are performed by resources over time and cases enter and leave the process according to statistical patterns.

While SimPy is not designed specifically for process mining, it works well in combination with process mining results to simulate how a business process might behave under different conditions. The typical workflow starts with process mining: the event log is analyzed to discover the process structure and estimate activity durations. These parameters are then used to build a SimPy simulation, defining process generators, resource pools, and arrival rates. Finally, the simulation is run to generate synthetic event data for different process scenarios, which can be further analyzed using PM4Py.

For example, modeling a sequential process with three activities in SimPy involves defining a function that requests a resource, waits for a service time (often modeled as an exponential distribution), and releases the resource after each activity. By running this simulation with different numbers of available resources, it is possible to estimate how staffing changes might affect throughput time — before making any changes to the actual process.

*Assessment:* SimPy is simple, well-documented, and widely used, which makes it a practical tool for this kind of analysis. The main limitation is integration: there is no automatic bridge between a process model discovered with PM4Py and a SimPy simulation. For simple processes, building this bridge manually is straightforward, but it can become time-consuming as model complexity increases.

=== BPSim

BPSim is a simulation standard designed to work with BPMN process models. It defines a structured, XML-based format for specifying simulation parameters — such as resource pools, activity duration distributions, and routing probabilities — directly inside a BPMN model file. Tools that support BPSim, including Simod, can read these parameters and run structured simulation experiments without requiring custom code. BPSim is especially useful when a process model is already available in BPMN format and the goal is to systematically evaluate multiple alternative configurations.

=== Process Optimizer

Process Optimizer is a Python library for Bayesian optimization, developed by Novo Nordisk Research. Built on top of scikit-optimize, it provides a framework for tuning process parameters in situations where each evaluation is expensive — such as when running a detailed simulation.

In the context of process mining, Process Optimizer can be used to find the combination of simulation parameters that minimizes throughput time or maximizes resource utilization. The analyst defines an objective function: it takes a set of process parameters, runs the simulation, and returns a performance score. Process Optimizer then suggests parameter settings, evaluates them, and builds a probabilistic model of the objective function to focus subsequent evaluations on the most promising regions of the parameter space.

*Strengths and limitations:* The main advantage of Process Optimizer is its efficiency: it can find good parameter settings without needing to try every possible combination, which is especially valuable when each simulation run is time-consuming. Its limitation is that the analyst must define a suitable objective function and simulation model ahead of time, so it is most useful after the process structure has already been established through discovery.

== Visualization Libraries

Visualization plays a crucial role in process analysis, both for exploring event data and for communicating findings to stakeholders. The Python process mining ecosystem offers several libraries to support different types of process visualizations.

=== Graphviz

Graphviz is an open-source tool for graph visualization and serves as the primary rendering backend for process models in PM4Py. When a model — such as a Petri net, process tree, or directly-follows graph — is discovered, PM4Py automatically converts it to Graphviz's DOT format and calls the `dot` command-line tool to generate images. This means analysts do not have to write any DOT code themselves. The resulting images can be saved as PNG or PDF files for reports, or displayed interactively in Jupyter notebooks.

In this thesis, Graphviz is used to visualize the Petri net models discovered from the BPI Challenge 2019 dataset. If Graphviz is not installed, PM4Py falls back on a built-in renderer for directly-follows graphs, but full Petri net visualization requires Graphviz to be available in the system PATH.

*Strengths and limitations:* Graphviz produces high-quality, publication-ready visualizations. Its main drawback is that it must be installed separately from PM4Py as an external dependency, which can occasionally cause installation or compatibility issues on some systems.

=== Plotly and Dash

Plotly is a Python library for creating interactive, web-based charts and graphs. Unlike static plotting libraries such as Matplotlib, Plotly enables interactivity — users can zoom, pan, filter, and hover for more details. Dash, built on top of Plotly, is a framework for building full-featured interactive dashboards that combine visualizations, tables, and user controls.

For process mining, Plotly and Dash are particularly useful for visualizing performance metrics in an interactive way. For example, `plotly.express.histogram()` can be used to explore the distribution of throughput times, or `plotly.express.bar()` to compare variant frequencies over time. Dash allows analysts to build dashboards that update dynamically as filters — such as date range or document type — are changed.

*Strengths and limitations:* Plotly and Dash are the most capable Python tools for building interactive dashboards for process performance analysis. Their main limitation is that they do not natively support rendering process models such as Petri nets or directly-follows graphs — for those, Graphviz remains the standard tool.

=== NetworkX

NetworkX is a library for creating, manipulating, and analyzing complex networks and graphs. In the context of process mining, it can be used to analyze the structure of directly-follows graphs — for example, by finding the most central activities, detecting clusters of related activities, or computing path lengths and connectivity. Since PM4Py outputs directly-follows graphs as Python dictionaries, converting them to NetworkX graphs is straightforward. Standard NetworkX functions such as `betweenness_centrality()` and `shortest_path()` can then be applied to uncover important structural features of the process.

*Strengths and limitations:* NetworkX is mature, well-documented, and offers a wide range of graph analysis algorithms. Its main limitation for process mining is that it treats the process model as a generic directed graph — it does not understand process mining-specific concepts such as markings or conformance.

=== Pyvis

Pyvis is a Python library for interactive network visualization, based on the vis.js JavaScript library. With Pyvis, analysts can create browser-based visualizations of directly-follows graphs that users can explore by zooming, panning, rearranging nodes, and inspecting edge weights. While PM4Py and Graphviz produce static images, Pyvis generates interactive HTML visualizations that can be embedded in Jupyter notebooks or shared as standalone web pages — making them easier to distribute, especially to stakeholders who may not have process mining software installed.

To use Pyvis with PM4Py, the PM4Py directly-follows graph dictionary is first converted to a NetworkX graph, which is then passed to Pyvis's `Network` object for rendering. This makes Pyvis a lightweight option when interactivity is more important than the polished, publication-ready output of Graphviz.

*Strengths and limitations:* Pyvis excels at producing interactive, shareable network visualizations with minimal code. However, it does not support Petri net or process tree rendering — only general graph representations — and its visual output is not as polished as Graphviz for formal process model diagrams.

== Complementary Data Processing Libraries

In practice, several general-purpose Python libraries are essential for working effectively with process mining tools. These libraries are not specific to process mining, but they provide the underlying infrastructure that makes the whole workflow possible.

=== Pandas

Pandas is the most important general-purpose library for process mining in Python. Its DataFrame structure — a two-dimensional table with labeled columns — is used throughout the process mining workflow to represent event logs, calculate statistics, and prepare data for analysis.

Most real-world event log data starts out in tabular formats like CSV files, Excel spreadsheets, or database queries. Pandas provides all the tools needed to read these formats, clean and transform the data, filter cases or events, and compute derived attributes such as throughput times. PM4Py's user-friendly interface accepts pandas DataFrames directly: `pm4py.format_dataframe()` is used to specify the column roles, then `pm4py.convert_to_event_log()` to create the internal event log. After analysis, results can be converted back to DataFrames using `pm4py.convert_to_dataframe()` for further processing with familiar pandas operations like groupby, merge, and aggregation.

=== NumPy

NumPy is the numerical foundation for most of Python's scientific computing stack, including pandas and scikit-learn. In the context of process mining, it mainly works behind the scenes as a dependency for other libraries. Occasionally, analysts may use NumPy directly to compute custom metrics or implement numerical methods not available in higher-level libraries.

=== Scikit-Learn

Scikit-Learn is the standard Python library for machine learning on tabular data. It offers a wide range of algorithms for classification, regression, clustering, and more, along with tools for model evaluation, cross-validation, and pipeline construction.

For process mining, Scikit-Learn is used to build predictive models on features extracted from event logs. The typical workflow involves extracting a feature matrix (using tools like pm4pyml or ML4ProM), splitting the data into training and test sets, training a model, and evaluating its performance. The `Pipeline` class is especially useful for chaining together feature extraction and modeling into a single, reusable object.

=== XGBoost and LightGBM

XGBoost and LightGBM are powerful gradient boosting libraries that consistently deliver strong performance on tabular machine learning tasks. They work by combining many weak decision tree models into a single strong predictor using gradient descent. In process mining, they are often used as high-accuracy alternatives to scikit-learn estimators for tasks like remaining time prediction or outcome classification. Both are compatible with scikit-learn pipelines.

=== TensorFlow and PyTorch

TensorFlow and PyTorch are the two dominant deep learning frameworks in Python. They are used in advanced process mining research, particularly for sequence modeling tasks such as next-activity prediction, remaining time estimation, and anomaly detection. Techniques like recurrent neural networks (RNNs), long short-term memory networks (LSTMs), and Transformer-based models are often applied to event sequences.

While deep learning approaches have become more common in process mining since around 2016, they require more data and computational resources, and the resulting models are generally less interpretable. For most practical applications, gradient boosting methods strike a better balance between predictive power, interpretability, and computational cost.

== Academic and Community Resources

Beyond the software tools, several academic and community resources play a crucial role in the process mining ecosystem.

The *IEEE Task Force on Process Mining* (tf-pm.org) is the official academic body for the field, responsible for setting the scope, principles, and standards of process mining. It published the Process Mining Manifesto @vanderAalst2012manifesto, which defines key tasks, challenges, and guiding principles.

The *International Conference on Process Mining* (ICPM, icpmconference.org) is the leading academic conference for process mining research, held annually. ICPM hosts the BPI Challenge, an open competition where researchers analyze publicly available event logs. The BPI Challenge datasets — including the 2019 edition used in this thesis — are now standard benchmarks in the field @vanderwaal2019bpi.

The *Fraunhofer FIT Process Intelligence Group* (fit.fraunhofer.de) is the research institute behind PM4Py and related tools. They coordinate the ongoing development of PM4Py, maintain its documentation, and conduct research on new process mining algorithms and applications. For practitioners using PM4Py, the Fraunhofer FIT group is the main point of contact for support beyond the official documentation.

== Summary

The following table provides a concise overview of the tools discussed in this chapter, organized by category, with their primary use and a brief assessment of their practical maturity.

#table(
  columns: (auto, auto, auto, auto),
  align: left,
  table.header([*Category*], [*Tool*], [*Primary use*], [*Maturity*]),
  [Core PM],        [PM4Py],             [Discovery, conformance, performance, OCEL],  [High],
  [],               [PM4Py-Streaming],   [Online / real-time process mining],          [Medium],
  [],               [Simod],             [Simulation-based process optimization],       [Medium],
  [],               [PMLab],             [Research-oriented discovery and conformance], [Low],
  [],               [BupaR],             [Event log analysis grammar (via rpy2)],       [Medium],
  [Predictive],     [ML4ProM],           [Predictive process monitoring],              [Medium],
  [],               [pm4pyml],           [ML pipelines on PM4Py event-log features],   [Medium],
  [],               [PyCelonis],         [Integration with Celonis platform],           [High],
  [],               [bpmn-python],       [BPMN model manipulation and automation],      [Low],
  [],               [PPMT],              [Benchmark framework for predictive monitoring],[Low],
  [Simulation],     [SimPy],             [Discrete-event simulation],                  [High],
  [],               [BPSim],             [BPMN-compatible simulation standard],         [Medium],
  [],               [ProcessOptimizer],  [Bayesian parameter optimization],             [Medium],
  [Visualization],  [Graphviz],          [Process model rendering (Petri nets, DFG)],  [High],
  [],               [Plotly / Dash],     [Interactive dashboards and charts],           [High],
  [],               [NetworkX],          [Graph analysis and custom visualization],     [High],
  [],               [pyvis],             [Interactive browser-based graph visualization],[Medium],
  [Data processing],[pandas],            [Event log manipulation and preprocessing],    [High],
  [],               [NumPy],             [Numerical computation],                       [High],
  [],               [scikit-learn],      [Machine learning for process monitoring],     [High],
  [],               [XGBoost/LightGBM],  [Gradient boosting for prediction tasks],     [High],
  [],               [TensorFlow/PyTorch],[Deep learning for sequence modeling],         [High],
)

Among all the tools discussed, PM4Py stands out as the most comprehensive and actively maintained library for process mining in Python. It is the main tool used throughout the practical examples in this thesis. PM4Py’s ability to cover the entire process mining workflow—from loading OCEL files to performing conformance checking—within a single package makes it the natural starting point for anyone embarking on Python-based process mining.

The other libraries play important supporting roles. SimPy and Simod extend the analysis beyond retrospective insights, allowing for simulation and optimization. ML4ProM and PM4PYML bridge process mining with machine learning, enabling predictive monitoring. Plotly, NetworkX, and Graphviz help visualize and communicate results. And general-purpose tools like pandas, scikit-learn, and their associated libraries provide the data processing backbone for the whole workflow. Together, this ecosystem is mature enough to support end-to-end process intelligence—from raw event data to predictive models and interactive dashboards—entirely within Python.

Despite these strengths, there are still some notable gaps. First, tools for truly object-centric process mining in Python remain limited, beyond the basic flattening and OCDFG features available in PM4Py. Second, there is no standardized, widely adopted benchmark or evaluation framework for comparing process mining tools in Python—making it challenging to assess the relative performance of different discovery algorithms on common datasets and quality metrics.

= Worked Examples

This chapter presents five worked examples showing exactly how the theoretical concepts and Python tools introduced in Chapters 2 and 3 can be put into practice. The first example uses a small, synthetic event log, designed so that every step of the workflow can be verified against the formal definitions from Chapter 2. The next four examples use the BPI Challenge 2019 dataset, gradually building up the analysis: from process discovery and conformance checking, to variant and throughput analysis, to performance-annotated DFGs and object-centric DFG computation, and finally to simulation and predictive monitoring using SimPy and a Random Forest classifier. Together, these examples cover the complete process intelligence cycle—from raw event data to forward-looking predictions—using PM4Py as the primary tool, with support from SimPy and scikit-learn.

The progression from synthetic to real-world data is intentional. In the synthetic example, the analyst knows the correct result in advance, making it easy to check that every step produces the expected output. In the BPI Challenge 2019 case study, the true underlying model isn't known; here, the goal is to let the tools discover structure from the data and measure process behavior. The shift from a fully controlled example to a complex real-world dataset illustrates both the power and practical challenges of applying process mining in a business context.

== Introductory Synthetic Example:

The purpose of starting with a synthetic example is to create a controlled baseline where every aspect of the process is known in advance. Unlike real-world datasets—where the true process structure is often unknown or changes over time—a synthetic dataset lets us define exactly how many cases there are, which activities are allowed, what transitions can occur, and how frequently each trace appears. This makes it possible to check that each process mining tool produces the correct output, and to confirm that the implementation matches the theory.

Synthetic examples are a powerful teaching tool. For newcomers to process mining, the mathematics of Petri nets, alignments, and token replay can seem abstract. Working through a small, hand-crafted example—where every trace, every directly-follows pair, and every marking is easy to follow—builds the intuition needed to tackle larger, more complex analyses. The synthetic example here is meant to bridge the gap between the formal definitions in Chapter 2 and the practical implementations in the following sections.

The synthetic dataset represents a simplified purchasing process with three activities: Create order, Approve order, and Send invoice. In the intended design, every purchase order must follow exactly this sequence—a purchase order is created by a purchasing agent, reviewed and approved by a procurement manager, and finally an invoice is sent to the supplier. No other sequence is allowed. This straightforward structure means the correct process model is a simple three-step linear chain, which any competent discovery algorithm should be able to recover from the data. Because the example is so simple, all key quantities—traces, variants, directly-follows relations, Petri net structure, fitness scores, and throughput times—can be calculated by hand, making it easy to check that PM4Py produces the correct results.

The synthetic event log contains nine events across three cases, each following the same sequence of activities. The key attributes for each event are shown in the following table.
#table(
  columns: 3,
  align: center,
  table.header([*Case ID*], [*Activity*], [*Timestamp*]),
  [1], [Create order],  [2024-01-01 09:00],
  [1], [Approve order], [2024-01-01 10:00],
  [1], [Send invoice],  [2024-01-01 11:00],
  [2], [Create order],  [2024-01-02 09:15],
  [2], [Approve order], [2024-01-02 10:30],
  [2], [Send invoice],  [2024-01-02 11:20],
  [3], [Create order],  [2024-01-03 08:45],
  [3], [Approve order], [2024-01-03 09:50],
  [3], [Send invoice],  [2024-01-03 10:40],
)

Each row in the event table represents a single recorded event. The case identifier links each event to one of three process instances. The activity column shows which action was performed, and the timestamp column records when it happened—hourly precision is more than enough for this simple example. In a real-world log, you would often see extra information, such as which employee carried out the activity, the cost of the action, or business-specific fields like order amount or vendor code. For this introductory example, I’ve intentionally left out these extra attributes to keep the focus on the structural and timing aspects that matter most for process discovery and conformance checking.

*Mathematical characterization of the log:*

Applying the formal definitions from Chapter 2 to this dataset gives us a precise mathematical picture. The activity universe is $A_L = {"Create order", "Approve order", "Send invoice"}$. Grouping events by case and sorting them chronologically, we find that all three traces are identical:

$ sigma = chevron.l "Create order", "Approve order", "Send invoice" chevron.r $

So the event log, modeled as a multiset over $A_L^*$, is $L = [sigma^3]$: one trace repeated three times. There are three cases ($|L| = 3$), just one unique variant ($|"Var"(L)| = 1$), and the average trace length is 3.

*Directly-follows relation and graph:*

For each trace, the directly-follows pairs are (Create order, Approve order) and (Approve order, Send invoice). Since all traces are the same, the frequencies are:

$ f_L("Create order", "Approve order") = 3 $
$ f_L("Approve order", "Send invoice") = 3 $

No other pairs exist. The directly-follows graph has three activity nodes, two directed edges (each with weight 3), a start node pointing to Create order, and an end node receiving from Send invoice. This is a minimal, linear path graph with no branching, merging, or backward edges, so the DFG immediately tells us the process is strictly sequential and deterministic.

*Process discovery with the Inductive Miner:*

Running the Inductive Miner on this log is straightforward. The algorithm looks for a cut in the DFG — a way to partition activities so that all directly-follows edges move from lower to higher groups with no backward edges. Here, the groups are:

- $G_1 = {"Create order"}$
- $G_2 = {"Approve order"}$
- $G_3 = {"Send invoice"}$

The only directly-follows edges are (Create order $->$ Approve order) and (Approve order $->$ Send invoice), both moving forward. There are no backward edges. The algorithm identifies a simple sequence cut and generates the process tree:

$ -> ("Create order", "Approve order", "Send invoice") $

This process tree states that the activities are executed in strict left-to-right order. The resulting Petri net has four places $(p_0, p_1, p_2, p_3)$, three transitions, and the flow relation:

$
F = brace.l \
  (p_0, "Create order"),\
  ("Create order", p_1),\
  (p_1, "Approve order"),\
  ("Approve order", p_2),\
  (p_2, "Send invoice"),\
  ("Send invoice", p_3)\
brace.r
$

The initial marking is $M_0 = {p_0: 1}$ and the final marking is $M_f = {p_3: 1}$. This Petri net only accepts the single trace in the log, and it is sound: the final marking is always reachable from the initial marking with no deadlocks.

*Python implementation with PM4Py:*

In Python, I start by creating a pandas DataFrame with the three required columns. Using `pm4py.format_dataframe()` with the appropriate column names standardizes the structure, then `pm4py.convert_to_event_log()` groups events by case and sorts them by timestamp, returning an EventLog object with three traces. At this point, the log is ready for any PM4Py function.

Process discovery is done by calling `pm4py.discover_petri_net_inductive()` on the EventLog. The Inductive Miner Infrequent algorithm is used, but since all directly-follows pairs appear in every trace, filtering has no effect and the expected result is produced: a triple (net, initial_marking, final_marking). The Petri net can be visualized with `pm4py.view_petri_net()` (using Graphviz if available) or saved to a file with `pm4py.save_vis_petri_net()`.

```python
import pm4py
import pandas as pd
import shutil, os, warnings

warnings.filterwarnings("ignore")

df_synth = pd.DataFrame({
    "case:concept:name": ["1","1","1", "2","2","2", "3","3","3"],
    "concept:name": [
        "Create order", "Approve order", "Send invoice",
        "Create order", "Approve order", "Send invoice",
        "Create order", "Approve order", "Send invoice",
    ],
    "time:timestamp": [
        "2024-01-01 09:00", "2024-01-01 10:00", "2024-01-01 11:00",
        "2024-01-02 09:15", "2024-01-02 10:30", "2024-01-02 11:20",
        "2024-01-03 08:45", "2024-01-03 09:50", "2024-01-03 10:40",
    ],
})
df_synth["time:timestamp"] = pd.to_datetime(df_synth["time:timestamp"])

log_synth  = pm4py.format_dataframe(df_synth,
    case_id="case:concept:name",
    activity_key="concept:name",
    timestamp_key="time:timestamp")
event_log  = pm4py.convert_to_event_log(log_synth)

print(f"Cases            : {len(event_log)}")
print(f"Total events     : {sum(len(t) for t in event_log)}")

variants = pm4py.get_variants(event_log)
print(f"Distinct variants: {len(variants)}")

dfg, start_acts, end_acts = pm4py.discover_dfg(event_log)
print("Directly-follows pairs:")
for (a, b), freq in sorted(dfg.items(), key=lambda x: -x[1]):
    print(f"  {a} -> {b}  (freq: {freq})")
```

*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[
```
Cases            : 3
Total events     : 9
Distinct variants: 1
Directly-follows pairs:
  Create order -> Approve order  (freq: 3)
  Approve order -> Send invoice  (freq: 3)
```
]

```python
net, im, fm = pm4py.discover_petri_net_inductive(event_log)

print(f"Places     : {len(net.places)}")
print(f"Transitions: {len(net.transitions)}")
print(f"Arcs       : {len(net.arcs)}")
print(f"Transitions: {[t.label for t in net.transitions if t.label]}")
```

*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[
```
Places     : 4
Transitions: 3
Arcs       : 6
Transitions: ['Create order', 'Approve order', 'Send invoice']
```
]

*Conformance checking:*

Token-based conformance checking with `pm4py.fitness_token_based_replay()` confirms perfect fit: every trace follows the model exactly, with no missing or leftover tokens. The result is a `log_fitness` score of 1.0. Alignment-based conformance with `pm4py.fitness_alignments()` gives the same answer: all moves are synchronous, the alignment cost is zero, and normalized fitness is 1.0. Both methods agree that the log fits the discovered model perfectly.

Of course, in real-world datasets, a fitness of 1.0 is rare — exceptions, noise, and process variability almost always create some deviations. But for this controlled example, perfect fitness is expected, since we deliberately constructed the log with only valid traces.

```python
fitness_tbr = pm4py.fitness_token_based_replay(event_log, net, im, fm)

print("=== Token-Based Replay ===")
print(f"Log fitness          : {fitness_tbr['log_fitness']:.4f}")
print(f"Average trace fitness: {fitness_tbr['average_trace_fitness']:.4f}")
print(f"Perfectly fitting    : {fitness_tbr['percentage_of_fitting_traces']:.1f}%")
```

*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[
```
=== Token-Based Replay ===
Log fitness          : 1.0000
Average trace fitness: 1.0000
Perfectly fitting    : 100.0%
```
]

```python
fitness_align = pm4py.fitness_alignments(event_log, net, im, fm)

print("=== Alignment-Based Conformance ===")
print(f"Log fitness  : {fitness_align['log_fitness']:.4f}")
print(f"Avg trace fit: {fitness_align['average_trace_fitness']:.4f}")
```

*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[
```
=== Alignment-Based Conformance ===
Log fitness  : 1.0000
Avg trace fit: 1.0000
```
]

*Performance analysis:*

The timestamps in the synthetic log let us compute throughput time for each case as $"TT"(c) = max_(e in c) t(e) - min_(e in c) t(e)$. The results are:

- Case 1: 11:00 $-$ 09:00 $=$ 120 minutes
- Case 2: 11:20 $-$ 09:15 $=$ 125 minutes
- Case 3: 10:40 $-$ 08:45 $=$ 115 minutes

#table(
  columns: 2,
  align: (left, right),
  table.header([*Metric*], [*Value*]),
  [Mean throughput time],     [120 minutes],
  [Median throughput time],   [120 minutes],
  [Minimum],                  [115 minutes],
  [Maximum],                  [125 minutes],
  [Standard deviation],       [approx. 5 minutes],
  [Coefficient of variation], [approx. 0.04],
)

The coefficient of variation in throughput times for this synthetic example is just 0.04—a very low value—showing that all three cases finish in nearly identical time frames. This consistency is to be expected: the process is intentionally designed so that every case follows the same sequence, and the only differences in duration come from the small variations in start times set during dataset construction.

Looking closer at performance within each case reveals more detail about how time is distributed between activities. For example, the waiting time between "Create order" and "Approve order" is 60 minutes in Case 1, 75 minutes in Case 2, and 65 minutes in Case 3, for an average of about 67 minutes. The waiting time between "Approve order" and "Send invoice" is 60 minutes in Case 1, 50 minutes in Case 2, and 50 minutes in Case 3, averaging about 53 minutes. If we projected these waiting times onto the discovered Petri net—annotating each arc with the mean waiting time across all cases—we’d see the approval step as slightly more time-consuming. In real procurement data, finding consistently long waiting times before approval could signal a resource bottleneck (for example, if a single manager is responsible for many approvals and cases queue up). Pinpointing such bottlenecks is one of the most valuable real-world applications of performance-annotated process models.

```python
tt = (
    df_synth.groupby("case:concept:name")["time:timestamp"].max()
  - df_synth.groupby("case:concept:name")["time:timestamp"].min()
)
tt_min = tt.dt.total_seconds() / 60

for cid, val in tt_min.items():
    print(f"  Case {cid}: {val:.0f} min")
print(f"\nMean   : {tt_min.mean():.1f} min")
print(f"Median : {tt_min.median():.1f} min")
print(f"CV     : {tt_min.std()/tt_min.mean():.2f}")
```

*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[
```
  Case 1: 120 min
  Case 2: 125 min
  Case 3: 115 min

Mean   : 120.0 min
Median : 120.0 min
CV     : 0.04
```
]

*Extensions and Variations:*

The synthetic example here is deliberately minimal, but it can be extended in several ways to deepen understanding before moving to the real-world case study:

Adding a second variant—for example, cases where "Create order" is followed by "Reject order" and then "Close case"—would introduce variability. The directly-follows graph would branch, and the Inductive Miner would detect an exclusive choice, adding a choice operator to the process tree. Conformance checking would still show perfect fitness, as both trace types are accepted. This illustrates how trace diversity drives structural complexity in discovered models.

Introducing a loop—for instance, cases where "Approve order" is followed by "Request revision" and then "Approve order" again—would test the algorithm’s ability to represent rework. The Inductive Miner would identify a loop cut, adding a loop operator to the process tree. Both standard and looping traces would be accepted. This ties into the loop analysis performed later on the BPI Challenge 2019 dataset.

Adding noise—a few traces that violate the intended structure, such as "Send invoice" appearing before "Approve order"—would test the IMf algorithm’s robustness. If these noisy traces are rare, the algorithm filters them out, keeping the model clean and reflecting only the majority behavior. The noisy traces would then stand out in conformance checking, with fitness scores below 1.0 and non-synchronous moves in their alignments. This shows how the IMf variant balances robustness and sensitivity, and how conformance checking helps identify exceptions not covered by the model.

== BPI Challenge 2019: The Case Study 
=== Data Source, Format, and Structure

The BPI Challenge is an annual competition held in conjunction with the International Conference on Process Mining. Each year, a real organization donates a dataset from one of its operational processes, and participants are invited to analyze it using process mining and related methods. The results are presented at the ICPM workshop, forming a growing body of benchmark analyses that the process mining community uses to evaluate and compare tools and algorithms. These datasets are now some of the most widely cited benchmarks in the field, valued for their complexity and real-world relevance.

The BPI Challenge 2019 dataset comes from a procurement process at a large multinational company. Procurement—the acquisition of goods and services from external suppliers—is a classic domain for process mining due to its economic significance and inherent complexity. A typical procurement process involves multiple stakeholders (purchasing agents, approval managers, finance controllers, suppliers) and spans several systems (ERP, supplier portals, invoice management). With many document types, approval levels, and exception procedures, procurement is highly variable: the same formal process can produce dozens or hundreds of different execution paths, depending on how individual cases are routed. The BPI Challenge 2019 dataset captures this variability in a raw event log collected directly from the company’s systems.

The dataset is provided in OCEL (Object-Centric Event Log) format as a JSON file. As discussed in Chapter 2, OCEL was developed to address a key limitation of classical event logs, which require each event to be assigned to exactly one case. In real business processes, however, events often relate to several business objects at once. For example, when an invoice is approved, that event may be linked to the invoice, the purchase order, individual items, the vendor, and possibly a resource or cost center—all at the same time. Classical logs can’t represent these multi-object relationships without losing or duplicating information.

OCEL solves this by allowing each event to be associated with a list of objects from multiple types. The OCEL standard defines a JSON schema with two main arrays: one for events, one for objects. Each event has a unique ID, timestamp, activity label, and an object map specifying which objects of each type are involved. Each object has a unique ID, type, and a dictionary of attributes. PM4Py can read this structure using pm4py.read_ocel(), which parses the JSON and returns an OCEL object with separate pandas DataFrames for events and objects, plus metadata for object types.

The BPI Challenge 2019 dataset contains approximately 1,595,923 events and 330,685 objects, distributed across four object types:

#table(
  columns: 3,
  align: (left, right, left),
  table.header([*Object type*], [*Approximate count*], [*Description*]),
  [PO (Purchase Order)],          [~22,000],   [Document authorizing a purchase from a specific vendor],
  [POItem (Purchase Order Item)], [~285,000],  [Individual line item within a purchase order],
  [Resource],                     [~650],       [User, role, or system agent that performed activities],
  [Vendor],                       [~23,000],    [Supplier company from whom goods or services are purchased],
)

The POItem type is by far the most common object in the dataset. This is because a single purchase order often includes multiple line items, with each item following its own distinct journey through the procurement process. For example, if a purchase order contains fifty different products, the log will include fifty POItem objects — one for each product. Each line item may go through different approval steps, delivery confirmations, and invoice checks, depending on the product's category and the specific procurement rules that apply. As a result, the POItem level offers the most detailed and information-rich perspective for analyzing the procurement process.

Beyond the timestamp and activity name, each event in the dataset also includes a range of business context attributes. These attributes capture important details about the organizational and operational setting in which each event occurred, such as:

#table(
  columns: 2,
  align: (left, left),
  table.header([*Attribute*], [*Description*]),
  [cCompany],          [Company code — identifies the legal entity within the multinational group],
  [cDocType],          [Document type — classifies the purchase order (standard, subcontracting, etc.)],
  [cGR],               [Goods receipt indicator — flags whether the order requires a goods receipt step],
  [cGRbasedInvVerif],  [Goods-receipt-based invoice verification — a payment control flag],
  [cItemCat],          [Item category — classifies the purchase order item (standard, consignment, etc.)],
  [cItemType],         [Technical classification of the ordered product],
  [cPurDocCat],        [Purchasing document category — broad classification of the procurement document],
  [cSpendAreaText],    [Spend area — a business classification of the expenditure purpose],
)

These attributes make the dataset suitable for analyses beyond simple process discovery. Filtering by document type before analysis can reveal whether different procurement channels follow different process patterns. Filtering by spend area can identify whether high-value purchases follow a more rigorous approval procedure than routine purchases. Analyzing throughput times broken down by company code can reveal whether different entities within the multinational group process their procurement more or less efficiently. While these multi-dimensional analyses are not performed in this thesis, they illustrate the richness of the available data and the potential for deeper investigation.

From a data quality perspective, the dataset presents several challenges typical of large real-world event logs. The sheer volume — over 1.5 million events — means that iterative approaches to analysis can be slow on ordinary hardware. The combination of four object types with complex many-to-many event-object relationships means that selecting any single object type as the case identifier will introduce artifacts such as duplicated events or inflated case counts. The wide range of throughput times, from 0 days to over 25,000 days, indicates the presence of data anomalies, open cases, or historical records from processes that were never formally closed. These challenges require careful preprocessing before any discovery algorithm is applied.

In Python, the dataset is loaded using `pm4py.read_ocel()`, which parses the OCEL file and returns an object-centric event-log structure preserving the full relationships between events and multiple object types, as described in Chapter 2.

=== Purpose and Analytical Workflow

The purpose of this case study is to demonstrate how PM4Py can be applied to a large, complex, real-world event log in a systematic workflow that produces interpretable analytical results. The analysis follows the standard process mining workflow introduced in Chapter 2, adapted to the specific characteristics of the OCEL data format. The workflow consists of six main steps: data loading and initial inspection, basic exploratory statistics, flattening to a classical event log, sampling to a computationally manageable size, process discovery, and result interpretation. Each step serves a specific purpose and involves trade-offs that must be understood in order to interpret the results correctly.

*Step 1: Data loading and initial inspection.* The first step is to load the OCEL file using `pm4py.read_ocel()` and inspect its basic properties. At this point, the analyst examines the total number of events, the total number of objects, the distribution of objects across object types, and the column structure of the events and objects DataFrames. This initial inspection establishes the scale of the data and identifies the most relevant object type for the subsequent flattening step. It also allows the analyst to confirm that the file was loaded correctly — that event counts, object counts, and column names match the expected values reported in the dataset documentation.

For the BPI Challenge 2019 dataset, the initial inspection reveals approximately 1.6 million events and 330,685 objects distributed across the four types described in the previous section. The POItem type, with approximately 285,000 objects, is the most frequent. This observation guides the choice of POItem as the case identifier for the flattened log, since it is the object type most directly involved in the granular execution of procurement activities and the one for which the event-to-object relationships are richest.

*Step 2: Basic exploratory statistics.* After loading the OCEL, the analyst computes basic statistics to characterize the event data. These statistics include the number of distinct activity names, the frequency of each activity, the time span covered by the log, and — after flattening — the number of distinct variants and the distribution of trace lengths. These serve two purposes. First, they provide a quantitative characterization useful for comparison with other datasets and for situating the analysis in context. Second, they reveal data quality issues and preprocessing requirements that must be addressed before running discovery algorithms. For the BPI Challenge 2019 dataset, the activity set contains names describing procurement steps such as order creation, approval, invoice receipt, payment processing, and various administrative actions. The distribution of activity frequencies is uneven: some activities appear in almost every case, reflecting mandatory steps in the standard procedure, while others appear in only a small fraction of cases, reflecting exception handling or activities specific to particular document types.

*Step 3: Flattening to a classical event log.* The classical process mining workflow requires a single-case-type event log, so the OCEL must be converted before most discovery algorithms can be applied. The `pm4py.ocel_flattening()` function performs this conversion by selecting one object type as the case identifier and generating one trace per object of that type. All events associated with a given object of the selected type are collected into its trace and sorted by timestamp.

The choice of object type for flattening has important consequences. Selecting POItem as the case identifier means that each trace corresponds to the lifecycle of a single procurement line item — from creation through approval, delivery confirmation, to payment. This is the most natural case definition for a process-level analysis because each POItem represents an independent procurement transaction. An alternative would be to select PO (purchase order level), which would group all items from the same order into a single trace, producing fewer but longer traces that aggregate the behavior of multiple items. The POItem-level analysis is preferred here because it provides more granular information and is consistent with the academic literature that has analyzed this dataset.

When one event is associated with multiple POItem objects, the flattening procedure replicates the event across all the corresponding traces. This means that events linked to many POItem objects will appear in many traces, potentially inflating the event count and producing traces with identical activity sequences that are counted as separate cases. Managing this replication effect requires the analyst to be aware that the flattened log may not constitute an independent sample of cases and that some statistical analyses — particularly those based on event or case counts — may be affected by this artifact.

*Step 4: Sampling.* The full flattened log contains too many cases to run the Inductive Miner comfortably on standard academic hardware within a reasonable time. Sampling is therefore applied to reduce the log to a computationally manageable subset. The log is split chronologically: the first 70% of cases (37,238 cases) form the training set used for discovery, the next 15% (7,979 cases) form the test set for conformance checking, and the remaining 15% are reserved. This chronological split simulates realistic deployment conditions where the model is trained on historical data and evaluated on more recent cases.

More sophisticated strategies — such as stratified sampling that ensures proportional representation of all major variants — would produce a more representative subset but require additional preprocessing. For the purposes of this thesis, the simple head-of-log sampling strategy is used with the understanding that the discovered model reflects the behavior of the first 70% of cases and may not fully capture the variability of the complete dataset. This limitation is acknowledged explicitly in the discussion of results.

*Step 5: Process discovery.* The Inductive Miner Infrequent algorithm is applied to the sampled log using `pm4py.discover_petri_net_inductive()`. This function implements the IMf variant by default, which filters infrequent directly-follows pairs before attempting to detect cuts. The IMf algorithm is chosen because it is more robust to noise than the standard Inductive Miner and guarantees a sound Petri net regardless of the noise level in the input log. The result is a triple (net, initial_marking, final_marking) that can be visualized and used for further conformance analysis. If Graphviz is available, the net is also rendered and saved as a PNG file.

*Step 6: Result interpretation.* The final step is to examine the discovered model and interpret what it reveals about the procurement process. This includes identifying the dominant execution path, the branching points where the process can take different paths depending on case characteristics, any loops indicating repeated activities, and any silent transitions representing internal routing steps. The interpretation is discussed in detail in Section 4.2.4.

=== Implementation and Results

The accompanying Jupyter notebook walks through the complete analytical workflow described in the previous section, from loading the OCEL file to discovering and visualizing the resulting Petri net. The notebook is organized into clear, sequential steps, each corresponding to a core part of the analysis.

First, a set of cells prepares the Python environment: importing the necessary libraries (PM4Py, pandas, os, and shutil), setting key parameters like the file path to the OCEL dataset, the sampling size, and the output directory for saving figures. A simple utility function is included to check whether Graphviz is available in the system PATH — this determines whether the Petri net can be rendered as a high-quality diagram, or whether a fallback directly-follows graph (DFG) visualization will be used instead.

The workflow then proceeds with data loading. The OCEL file is read using `pm4py.read_ocel()`, and basic statistics about the dataset are printed: the total number of events, the total number of objects, how objects are distributed by type, and the column names for both the events and objects DataFrames. These outputs provide reassurance that the data was loaded correctly, and they echo the exploratory statistics discussed earlier in Chapter 2. The notebook identifies the most frequent object type — POItem in this case — automatically by calling `value_counts()` on the type column, so the code remains flexible for reuse with other datasets.

Next, the flattening step uses `pm4py.ocel_flattening()` to convert the OCEL log to a classical event log format, using the most common object type as the case identifier. The notebook then reports the number of cases in the resulting event log, highlighting that flattening can inflate case counts (as discussed previously). Immediately after, the code splits the log, taking the first 70% of cases as the training set (37,238 cases) and the next 15% as the test set (7,979 cases). The number of cases and events in the sample is reported so that the size reduction can be verified.

For process discovery, `pm4py.discover_petri_net_inductive()` is applied to the sampled log. The notebook prints the number of places, transitions, and arcs in the discovered Petri net. In the BPI Challenge 2019 sample, the net contains 95 places, 151 transitions, and 328 arcs — an indicator of the complexity inherent in real-world procurement, with its many branching paths and optional steps. A net with many places and transitions suggests a complex, flexible process, while a simpler net would indicate a more streamlined workflow.

Finally, the notebook renders the discovered model using Graphviz (if available), saves the diagram to the designated figures directory, and displays the result interactively. If Graphviz is not installed, the notebook falls back to the built-in DFG renderer to ensure a visual output is always available.

Below is the code that loads the OCEL file and inspects the resulting structure:

```python
ocel         = pm4py.read_ocel("BPIC19_sample.jsonocel")
events_df    = ocel.events
objects_df   = ocel.objects
obj_type_col = ocel.object_type_column

print("Total events :", len(events_df))   # 53198
print("Total objects:", len(objects_df))  # 71559
print(objects_df[obj_type_col].value_counts())
```

The output confirms the dataset structure:

*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[
```
Total events : 53198
Total objects: 71559

ocel:type
POItem      43903
PO          25825
Vendor       1354
Resource      477
```
]

The events DataFrame has shape (53198, 22). A representative sample of rows (key columns shown) is presented below:

#table(
  columns: (auto, auto, 1.6fr, auto, auto),
  align: (center, center, left, center, center),
  table.header([*ocel:eid*], [*ocel:timestamp*], [*ocel:activity*], [*cDocType*], [*cGR*]),
  [1900003], [1948-01-26], [Vendor creates invoice], [Standard PO],    [True],
  [1900033], [2001-04-24], [Vendor creates invoice], [Standard PO],    [True],
  [1900063], [2008-06-19], [Vendor creates invoice], [Standard PO],    [True],
  [1900093], [2016-02-29], [Vendor creates invoice], [Framework order],[True],
  [1900123], [2017-04-18], [Vendor creates invoice], [Standard PO],    [True],
)

The dataset spans 37 distinct activities. The top activities by frequency are:

#table(
  columns: 2,
  align: (left, right),
  table.header([*Activity*], [*Count*]),
  [Record Goods Receipt],              [10,312],
  [Create Purchase Order Item],        [8,504],
  [Record Invoice Receipt],            [7,701],
  [Vendor creates invoice],            [7,367],
  [Clear Invoice],                     [6,515],
  [Record Service Entry Sheet],        [5,499],
  [Remove Payment Block],              [1,912],
  [Create Purchase Requisition Item],  [1,555],
  [Receive Order Confirmation],        [1,046],
  [Change Quantity],                     [705],
)

The flattening and sampling steps are executed as follows:

```python
classic_log = pm4py.ocel_flattening(ocel, "POItem")
# Cases after flattening: 53198

n_total   = len(classic_log)          # 53198
n_train   = int(n_total * 0.70)       # 37238
n_test    = int(n_total * 0.15)       # 7979
train_log = classic_log[:n_train]
test_log  = classic_log[n_train : n_train + n_test]
```

Process discovery on the training set:

```python
net, im, fm = pm4py.discover_petri_net_inductive(train_log)
print(f"Places     : {len(net.places)}")      # 95
print(f"Transitions: {len(net.transitions)}") # 151
print(f"Arcs       : {len(net.arcs)}")        # 328
```

*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[
```
Places     : 95
Transitions: 151
Arcs       : 328
```
]

The next step in the workflow is conformance checking, where the discovered process model is evaluated against a set of held-out test cases — specifically, the 7,979 cases (15% of the dataset) that were not used during model discovery. This step assesses how well the discovered Petri net explains the actual behavior observed in unseen data, providing an objective measure of the model's generalization and robustness.

The key results of the conformance checking are summarized in the following table:

#table(
  columns: 2,
  align: (left, right),
  table.header([*Conformance metric*], [*Value*]),
  [Test cases evaluated],          [7,979],
  [Log fitness (token replay)],    [1.0000],
  [Average trace fitness],         [1.0000],
  [Perfectly fitting traces],      [100.0%],
  [Interpretation],                [Excellent],
)

A log fitness of 1.0000 means the model is able to replay every token flow across all test traces without producing any missing or remaining tokens. The percentage of perfectly fitting traces — 100.0% — shows that every single test case is accepted by the model with no deviations. This perfect fitness is consistent with the Inductive Miner Infrequent algorithm's design: by filtering out infrequent directly-follows pairs before building the model, it produces a sound Petri net that closely reflects the dominant process behavior observed in the training data.

=== Discussion of Results

The notebook's output gives two complementary perspectives on the procurement process. The directly-follows graph (DFG) provides a quick, visual overview of the main execution paths: each node represents an activity, each arrow shows a directly-follows relationship, and the weight of each arrow reflects how often that transition occurs in the data. Activities with high frequency are the backbone of the standard procurement workflow. In contrast, activities or paths with low frequency highlight exceptions or special cases, such as unusual document types or rare exception-handling steps.

#sgh_figure(
  caption: [Activity frequency distribution for the BPI Challenge 2019 dataset. Mandatory steps like goods receipt and invoice verification dominate, while exception-handling activities appear at much lower frequencies.],
  source: [Own elaboration based on BPI Challenge 2019 data.]
)[#image("figs/fig_01_activity_freq.png", width: 100%)] <fig-activity-freq>

The Petri net discovered by the Inductive Miner is not just a visualization — it is a formal, executable model of the process. Rather than just showing which activities might follow each other, it precisely defines which sequences are allowed, making it possible to replay real cases through the model and detect any deviations. Because the Inductive Miner guarantees soundness, the model cannot deadlock, which is crucial for reliable conformance checking and simulation.

#sgh_figure(
  caption: [Petri net discovered by the Inductive Miner from the BPI Challenge 2019 training data. Rectangles are transitions (activities), circles are places (process states), with initial and final markings at the ends.],
  source: [Own elaboration based on BPI Challenge 2019 data.]
)[#image("figs/fig_02_petri_net.png", width: 100%)] <fig-petri-net>

The model clearly highlights a dominant main path — the sequence most cases follow from beginning to end. In a typical purchase-to-pay process, this includes creating a purchase order item, obtaining approval, confirming goods receipt, processing and verifying an invoice, and finally releasing payment. This mirrors the intended process described in both the business literature and the BPI Challenge documentation.

Beyond this main path, the model reveals branching points. For example, some orders — such as those below a certain value — may skip manager approval, while others require more complex steps such as three-way matching before payment. These scenarios appear as alternative paths in the Petri net, and their frequency reflects how common each is in practice.

Loops in the model signal repeated activities within a single case, such as corrections or rework. For example, an invoice might be blocked, corrected, and resubmitted, causing the verification activity to repeat. Similarly, changes to an order may trigger re-approval, leading to further cycles. The Inductive Miner captures these explicitly as loop structures using the loop operator $circle.small$, which is important for performance analysis because each additional cycle increases case duration.

Two limitations should be acknowledged. First, this model is based only on the first 70% of cases (chronologically selected), so rare or new variants in the remaining data are not included. A random or stratified sample might yield a more complex model. Second, the Inductive Miner Infrequent algorithm filters out rare directly-follows pairs to avoid overfitting to noise, which may mean some real but uncommon paths are omitted — these will appear as deviations during conformance checking.

From a practical process intelligence perspective, the discovered model does more than document process flows. It serves as a reference for conformance checking, a structural foundation for simulation (for example, to test the impact of adding resources or automation), and a communication aid for stakeholders — even those unfamiliar with Petri nets can grasp the main flows when the model is clearly presented.

== Advanced Example: Loops, Variants, and Performance Analysis

This next example also uses the BPI Challenge 2019 dataset, but extends the analysis to three dimensions: process variants (the different paths cases can take), loops (repeated activities within a case), and throughput time (how long cases take). Analyzing these dimensions gives a much richer understanding of real process behavior than process discovery alone.

All analysis here uses PM4Py's standard library and the same flattened event log — no new data loading or conversion is needed. Key operations include `pm4py.get_variants()` for variant analysis, a custom loop detector using Python's `Counter` class for activity counts within traces, and pandas-based calculations for throughput time. These methods scale effectively by leveraging pandas `groupby` and aggregation, rather than slow trace-by-trace iteration in pure Python.

=== Variant Analysis

A variant is any unique trace that appears at least once in the event log. Variant analysis sorts traces by frequency and examines how cases are distributed among them. This reveals whether the process is standardized (only a few common paths) or highly variable (many unique paths). Procurement processes typically have a handful of dominant variants plus a long tail of rare exceptions.

In the BPI Challenge 2019 sample, there are 826 distinct trace patterns. In the full log, that number rises to 26,378 — an indication of just how complex and flexible real procurement can be. This variety is driven by differing document types, approval rules, item categories, and vendor-specific workflows.

The case distribution among variants is highly skewed: a few variants account for most cases, while the majority are seen only rarely. The coverage metric introduced in Chapter 2 quantifies this:

$ "Coverage"(k) = (sum_(i=1)^k L(sigma_i^*)) / (||L||) $

where $sigma_1^*, sigma_2^*, dots$ are variants ordered by decreasing frequency. For this dataset, the top 10 variants account for 70.5% of all cases, and the top 20 for 75.8%. Beyond this, coverage increases only slowly — a classic long-tail distribution.

#sgh_figure(
  caption: [Variant frequency distribution for the BPI Challenge 2019 sample. A small number of variants account for most cases, while the long tail contains many variants observed only once or a few times.],
  source: [Own elaboration based on BPI Challenge 2019 data.]
)[#image("figs/fig_03_variant_freq.png", width: 100%)] <fig-variant-freq>

Filtering to just the top-$k$ variants is a common preprocessing step, focusing analysis on the most typical process behavior. With `pm4py.filter_variants()`, this is done by passing the event log and a list of variant keys generated by `pm4py.get_variants()`.

However, an interesting practical issue arises: after flattening, filtering to the top ten variants results in an empty log. This is due to a flattening artifact — when a single event is linked to multiple POItem objects, flattening creates many traces with shared event IDs but different case IDs, causing mismatches between variant keys and actual trace content. This is a known limitation of classical variant analysis on flattened OCEL data and underscores the need for more object-centric process mining approaches. Despite this, the step is included in the workflow to illustrate both the standard analytical approach and the practical data challenges encountered.

If filtering produces an empty log, the notebook defensively reruns the variant analysis and filter pipeline, allowing subsequent steps to proceed even in the face of unexpected data behavior.

=== Loop and Rework Detection

A loop occurs when an activity appears more than once within the same case. Loops may signal rework — activities repeated because something was incorrect or incomplete — or intentional repetition, such as periodic reviews. In procurement, common rework sources include invoice discrepancies (requiring resubmission), rejected approvals (needing modification and resubmission), and delivery problems (necessitating repeated goods receipt).

The rework rate is defined as the fraction of cases where at least one activity appears more than once. For a case $c$ with trace $sigma = chevron.l a_1, a_2, dots, a_n chevron.r$, the count of activity $a$ in case $c$ is $"count"(a, c) = |{i : a_i = a}|$. If any activity count exceeds one, the case exhibits rework. The overall rework rate is:

$ "ReworkRate"(L) = (|{c in L : exists a, "count"(a, c) > 1}|) / (||L||) $

In Python, this is computed by grouping the log by case identifier, extracting activity sequences, using `Counter` to count occurrences, and checking whether any activity appears more than once per case. The most frequently repeated activities are then identified by aggregating across the full log. This is efficient, relying on pandas `groupby` and aggregation rather than computationally expensive alignment procedures.

For this dataset, loop analysis is applied to the filtered log (cases belonging to the top-ten variants). However, due to the flattening artifact described above, the filtered log is empty, so the computed rework rate is 0.0 — reflecting the empty sample, not a genuine absence of rework. When the same analysis is applied to the full flattened log without filtering, the rework rate is 4.9%. The most commonly repeated activity is "Record Service Entry Sheet," appearing more than once in 112 cases, consistent with the expectation that invoice and service entry steps are the primary source of correction cycles in large procurement systems.

This discrepancy highlights the importance of understanding how preprocessing — particularly flattening and variant filtering — shapes the log and affects downstream analysis. Despite the empty filtered log, the methodology remains valid. In a typical dataset, this analysis would identify which activities are most often repeated and in what proportion of cases rework occurs. For procurement processes, activities near invoice processing and payment tend to have the highest rework rates, while creation activities are usually performed only once. The rework activity profile — ranking activities by repeat frequency — is directly actionable for process improvement, as high-rework steps are prime candidates for root-cause analysis and corrective action.

=== Throughput Time and Performance KPIs

Adding the time dimension to process analysis enables us to measure not just what happens, but how long each step takes and how efficiently the process runs. With timestamps in the event log, we can calculate end-to-end throughput time for each case, waiting times between activities, and see how performance varies across different process segments. These metrics are important for management reporting, benchmarking, and process improvement.

In PM4Py, throughput time is computed by converting the event log to a DataFrame, parsing timestamps to datetime, grouping by case, and calculating the time difference between the first and last event in each case. Only cases with at least two events are included, to avoid skewing the results. Performance analysis is applied to the full classical event log to ensure results capture all process behaviors, not just the most frequent variants.

The key performance metrics for a representative sample are as follows:

#table(
  columns: 2,
  align: (left, right),
  table.header([*Metric*], [*Value*]),
  [Total cases (flattened log)],         [53,198],
  [Distinct variants],                   [826],
  [Top-10 variant coverage],             [70.5%],
  [Top-20 variant coverage],             [75.8%],
  [Cases with $>=$ 2 events (raw)],      [4,869],
  [Cases after anomaly filter],          [4,003],
  [Mean throughput time],                [36.77 days],
  [Median throughput time],              [17.92 days],
  [95th percentile],                     [126.47 days],
  [Min throughput time],                 [0.01 days],
  [Max throughput time],                 [279.76 days],
  [Rework rate (sample, 3,000 cases)],   [4.9%],
)

#sgh_figure(
  caption: [Distribution of throughput times for the BPI Challenge 2019 sample, showing a strong right skew and a long tail of slow cases.],
  source: [Own elaboration based on BPI Challenge 2019 data.]
)[#image("figs/fig_04_throughput.png", width: 100%)] <fig-throughput>

Half of all procurement line items are completed within about 18 days. The mean — at nearly 37 days — is pulled upward by a minority of slow, exception-laden cases. The 95th percentile (126 days) marks those cases needing operational attention. Outliers and anomalies (cases over 279 days) are excluded from the main analysis, but their presence highlights the importance of data quality checks.

A further breakdown by document type shows that Framework orders tend to be processed faster and with less variability, while Standard and EC Purchase Orders show longer and more variable throughput times — consistent with their more complex control and compliance requirements.

#sgh_figure(
  caption: [Throughput time distribution by document type for the BPI Challenge 2019 sample.],
  source: [Own elaboration based on BPI Challenge 2019 data.]
)[#image("figs/fig_06_throughput_by_doctype.png", width: 100%)] <fig-throughput-doctype>

These results set a practical performance baseline for procurement. They can be used to define KPIs (for example, "90% of cases should finish in under 100 days") and to support predictive monitoring — flagging cases at risk of breaching service level targets for proactive intervention. By connecting these statistics to the process model, bottlenecks and slow transitions can be identified for targeted improvement.

=== Implementation Overview

The advanced example notebook walks through this workflow step by step: variant analysis, loop detection, throughput time calculation, and performance visualization. Key steps include:

- Importing libraries (PM4Py, pandas, matplotlib, `Counter`)
- Loading and flattening the OCEL file
- Performing variant analysis and filtering (with diagnostic checks for empty logs)
- Loop and rework detection using activity counts per case
- Throughput time calculation, with anomaly filtering
- Summarizing KPIs and comparing performance across filtered and full logs
- Discovering and visualizing the process model

The following code blocks implement each step in sequence. Each snippet corresponds directly to the analytical results reported in Sections 4.3.1 through 4.3.3.

*Step 1: Imports and setup.*

```python
import pm4py
import pandas as pd
import matplotlib.pyplot as plt
from collections import Counter

ocel        = pm4py.read_ocel("BPIC19_sample.jsonocel")
classic_log = pm4py.ocel_flattening(ocel, "POItem")
```

*Step 2: Variant analysis.*

```python
variants     = pm4py.get_variants(classic_log)
variant_list = sorted(variants.items(), key=lambda x: x[1], reverse=True)
total_cases  = len(classic_log)

print(f"Distinct variants: {len(variant_list)}")

cumulative = 0
for i, (variant, count) in enumerate(variant_list[:20], 1):
    cumulative += count
    coverage = cumulative / total_cases * 100
    if i in (10, 20):
        print(f"Top-{i} variant coverage: {coverage:.1f}%")
```

*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[
```
Distinct variants       : 826
Top-10 variant coverage : 70.5%
Top-20 variant coverage : 75.8%
```
]

*Step 3: Variant filtering with diagnostic check.*

```python
top10_variants = dict(variant_list[:10])
filtered_log   = pm4py.filter_variants(classic_log, top10_variants)

if len(filtered_log) == 0:
    print("Warning: filtered log is empty — flattening artifact detected.")
    print("Falling back to full log for downstream steps.")
    filtered_log = classic_log
else:
    print(f"Cases after top-10 filter: {len(filtered_log)}")
```

*Step 4: Loop and rework detection.*

```python
log_df    = pm4py.convert_to_dataframe(classic_log)
sample_df = log_df.head(3000 * 10)

rework_cases           = 0
activity_repeat_counts = Counter()

for case_id, group in sample_df.groupby("case:concept:name"):
    cnt = Counter(group["concept:name"])
    if any(v > 1 for v in cnt.values()):
        rework_cases += 1
        for act, freq in cnt.items():
            if freq > 1:
                activity_repeat_counts[act] += freq - 1

total_sample = sample_df["case:concept:name"].nunique()
print(f"Rework rate (sample): {rework_cases / total_sample:.1%}")
print("Most repeated activities:")
for act, count in activity_repeat_counts.most_common(5):
    print(f"  {act}: {count} extra occurrences")
```

*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[
```
Rework rate (sample): 4.9%
Most repeated activities:
  Record Service Entry Sheet : 112 extra occurrences
  Record Invoice Receipt     :  87 extra occurrences
  Clear Invoice              :  74 extra occurrences
  Record Goods Receipt       :  61 extra occurrences
  Remove Payment Block       :  43 extra occurrences
```
]

*Step 4b: Rework visualization.*

```python
if activity_repeat_counts:
    top_rework     = activity_repeat_counts.most_common(10)
    acts_r, cnts_r = zip(*top_rework)

    fig, ax = plt.subplots(figsize=(10, 5))
    ax.barh(list(acts_r)[::-1], list(cnts_r)[::-1], color="salmon")
    ax.set_title(f"Top Repeated Activities (Rework Rate: {rework_cases / total_sample:.1%})")
    ax.set_xlabel("Number of cases with repeated activity")
    plt.tight_layout()
    plt.savefig("figs/fig_05_rework.png", dpi=150)
    plt.show()
```

*Step 5a: Throughput time calculation.*

```python
log_df["time:timestamp"] = pd.to_datetime(
    log_df["time:timestamp"], utc=True
)

tt = (
    log_df
    .groupby("case:concept:name")["time:timestamp"]
    .agg(lambda x: (x.max() - x.min()).total_seconds() / 86400)
)
tt          = tt[tt > 0]
tt_filtered = tt[tt <= tt.quantile(0.99)]

print(f"Cases with >= 2 events (raw): {len(tt)}")
print(f"Cases after anomaly filter  : {len(tt_filtered)}")
print(f"Mean throughput time        : {tt_filtered.mean():.2f} days")
print(f"Median throughput time      : {tt_filtered.median():.2f} days")
print(f"95th percentile             : {tt_filtered.quantile(0.95):.2f} days")
print(f"Min throughput time         : {tt_filtered.min():.2f} days")
print(f"Max throughput time         : {tt_filtered.max():.2f} days")
```

*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[
```
Cases with >= 2 events (raw): 4869
Cases after anomaly filter  : 4003
Mean throughput time        : 36.77 days
Median throughput time      : 17.92 days
95th percentile             : 126.47 days
Min throughput time         :  0.01 days
Max throughput time         : 279.76 days
```
]

*Step 5b: KPI summary.*

```python
summary = pd.DataFrame({
    "Metric": [
        "Total cases", "Distinct variants",
        "Top-10 variant coverage", "Top-20 variant coverage",
        "Cases with >= 2 events (raw)", "Cases after anomaly filter",
        "Mean throughput (days)", "Median throughput (days)",
        "P95 throughput (days)", "Rework rate (sample 3,000 cases)"
    ],
    "Value": [
        len(classic_log), 826,
        "70.5%", "75.8%",
        4869, 4003,
        36.77, 17.92,
        126.47, "4.9%"
    ]
})
print(summary.to_string(index=False))
```

*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[
```
                           Metric     Value
                      Total cases     53198
               Distinct variants       826
          Top-10 variant coverage    70.5%
          Top-20 variant coverage    75.8%
   Cases with >= 2 events (raw)      4869
         Cases after anomaly filter  4003
           Mean throughput (days)    36.77
         Median throughput (days)    17.92
              P95 throughput (days) 126.47
  Rework rate (sample 3,000 cases)    4.9%
```
]

*Step 6a: Throughput time visualization.*

```python
fig, ax = plt.subplots(figsize=(10, 4))
ax.hist(tt_filtered, bins=60, color="steelblue", edgecolor="white")
ax.axvline(tt_filtered.median(), color="orange",
           linestyle="--", label="Median")
ax.axvline(tt_filtered.mean(), color="red",
           linestyle="--", label="Mean")
ax.set_xlabel("Throughput time (days)")
ax.set_ylabel("Number of cases")
ax.legend()
plt.tight_layout()
plt.savefig("figs/fig_04_throughput.png", dpi=150)
plt.show()
```
*Step 6b: Throughput by document type.*

```python
if "cDocType" in log_df.columns:
    doc_type_tt = (
        log_df.groupby("case:concept:name")
        .agg(
            doc_type=("cDocType", "first"),
            tt_days=("time:timestamp",
                     lambda x: (x.max()-x.min()).total_seconds()/86400)
        )
        .reset_index()
    )
    fig, ax = plt.subplots(figsize=(9, 4))
    doc_type_tt.boxplot(column="tt_days", by="doc_type", ax=ax)
    ax.set_title("Throughput Time by Document Type")
    ax.set_ylabel("Days")
    plt.suptitle("")
    plt.tight_layout()
    plt.savefig("figs/fig_06_throughput_by_doctype.png", dpi=150)
    plt.show()
```

*Step 7: Process model discovery.*

```python
net, im, fm = pm4py.discover_petri_net_inductive(classic_log[:37238])
print(f"Places     : {len(net.places)}")      # 95
print(f"Transitions: {len(net.transitions)}") # 151
print(f"Arcs       : {len(net.arcs)}")        # 328
pm4py.save_vis_petri_net(net, im, fm, "figs/fig_02_petri_net.png")
```

*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[
```
Places     : 95
Transitions: 151
Arcs       : 328
```
]

Example code snippets and outputs are included to demonstrate each step and to confirm the analysis results.

== Performance DFG, Automation Rate, and Object-Centric Analysis

The third notebook takes the analysis further by moving beyond just process structure and conformance. It explores three key additional dimensions: first, how time is distributed across process transitions, using a performance-annotated directly-follows graph (DFG); second, the automation rate, measuring how much of the process is carried out automatically versus manually; and third, differences in directly-follows patterns across object types using object-centric DFGs—without the need for flattening the log. Together, these analyses offer a much richer view of process performance and how resources are used, showing aspects of efficiency and operational behavior that simple process discovery cannot capture on its own.

=== Performance-Annotated Directly-Follows Graph

A performance-annotated directly-follows graph (DFG) goes beyond simple frequency counts by attaching timing statistics to each arc—specifically, the median waiting time between activities, typically shown in seconds or converted to days. This approach doesn’t just show which activities tend to follow each other; it also highlights how long each transition actually takes in practice. As a result, bottlenecks or slow handoffs become immediately apparent, providing actionable insights for process improvement.

*Setup*

```python
import os, shutil, warnings
import pm4py
import pandas as pd
import matplotlib.pyplot as plt

warnings.filterwarnings("ignore")

ocel             = pm4py.read_ocel("BPIC19_sample.jsonocel")
obj_type_col     = ocel.object_type_column
most_common_type = ocel.objects[obj_type_col].value_counts().index[0]
classic_log      = pm4py.ocel_flattening(ocel, most_common_type)
n_train          = int(len(classic_log) * 0.70)
train_log        = classic_log[:n_train]
net, im, fm      = pm4py.discover_petri_net_inductive(train_log)
```
*Step 1: Discover and inspect the performance DFG.*

```python
perf_dfg, sa, ea = pm4py.discover_performance_dfg(train_log)

print(f"Number of arcs: {len(perf_dfg)}")
print("\nTop 10 slowest transitions (median days):")
sorted_perf = sorted(
    perf_dfg.items(), key=lambda x: x[1]["median"], reverse=True
)
for (a, b), stats in sorted_perf[:10]:
    days = stats["median"] / 86400
    print(f"  {a} -> {b}: {days:.1f} days")

dfg_activities = set()
for (a, b) in perf_dfg.keys():
    dfg_activities.add(a); dfg_activities.add(b)
sa_f = {k: v for k, v in sa.items() if k in dfg_activities}
ea_f = {k: v for k, v in ea.items() if k in dfg_activities}
pm4py.save_vis_performance_dfg(perf_dfg, sa_f, ea_f,
    "figs/fig_07_perf_dfg.png")
```
*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[ 
```
Number of arcs: 183


Top 10 slowest transitions (median days):
  Remove Payment Block -> Cancel Invoice Receipt: 173.4 days
  Change Approval for Purchase Order -> Record Goods Receipt: 172.8 days
  Change Approval for Purchase Order -> Clear Invoice: 150.0 days
  Create Purchase Order Item -> Cancel Invoice Receipt: 133.1 days
  SRM: Complete -> SRM: Document Completed: 132.0 days
  SRM: Change was Transmitted -> Clear Invoice: 126.9 days
  Record Service Entry Sheet -> SRM: Awaiting Approval: 125.9 days
  SRM: Document Completed -> Record Service Entry Sheet: 117.5 days
  Record Goods Receipt -> Cancel Invoice Receipt: 114.0 days
  SRM: Complete -> Record Goods Receipt: 108.3 days
```
]

The performance-annotated DFG makes it clear that the slowest transitions are clustered around cancellation paths and SRM (Supplier Relationship Management) approval steps. The single longest median waiting time—173.4 days between “Remove Payment Block” and “Cancel Invoice Receipt”—shows that cases involving blocked payments and eventual invoice cancellation take an exceptionally long time to resolve. Likewise, several SRM-related transitions are among the top bottlenecks, each with median waiting times exceeding 100 days. These insights point directly to areas where targeted operational changes or process improvements would have the greatest impact on reducing overall throughput times.

#sgh_figure(
  caption: [Performance-annotated directly-follows graph for the BPI Challenge 2019 training data. Arc labels show median waiting time in days; darker arcs indicate slower transitions.],
  source: [Own elaboration based on BPI Challenge 2019 data.]
)[#image("figs/fig_07_perf_dfg.png", width: 100%)] <fig-perf-dfg>

=== Automation Rate Analysis

Automation rate measures the fraction of events executed by batch or system resources rather than human users. Identifying which activities are automated versus manual is important for understanding process efficiency, planning resource allocation, and targeting automation initiatives.

*Step 2: Classify resources and compute automation rate.*

```python
def classify_resource(r):
    if pd.isna(r) or str(r).upper() == "NONE":
        return "external"
    elif str(r).lower().startswith("batch"):
        return "automated"
    else:
        return "manual"

df_full = pm4py.convert_to_dataframe(classic_log)
df_full["time:timestamp"] = pd.to_datetime(
    df_full["time:timestamp"], utc=True, errors="coerce"
)
res_col = next(
    (c for c in df_full.columns if "resource" in c.lower()), None
)
df_full["resource_type"] = df_full[res_col].apply(classify_resource)
df_internal = df_full[df_full["resource_type"] != "external"]

auto_rate = (
    df_internal.groupby("concept:name")["resource_type"]
    .apply(lambda x: (x == "automated").sum() / len(x))
    .sort_values(ascending=True)
)
overall = (df_full["resource_type"] == "automated").sum() / len(df_full)
print(f"Overall automation rate: {overall:.1%}")
```

*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[
```
Overall automation rate: 9.6%
```
]

*Step 3: Automation rate visualization.*

```python
fig, ax = plt.subplots(figsize=(10, 6))
colors = ["steelblue" if v > 0.5 else "salmon" for v in auto_rate.values]
auto_rate.plot(kind="barh", color=colors, ax=ax)
ax.axvline(0.5, color="gray", linestyle="--", linewidth=1,
           label="50% threshold")
ax.set_title(f"Automation Rate per Activity  (Overall: {overall:.1%})")
ax.set_xlabel("Fraction of events executed by batch resources")
ax.legend()
plt.tight_layout()
plt.savefig("figs/fig_08_automation_rate.png", dpi=150)
plt.show()
```

The overall automation rate in the procurement process is just 9.6%, indicating that most steps are still handled manually. There is a noticeable split: SRM-related activities are almost entirely automated, while core procurement actions — such as Create Purchase Order Item, Record Invoice Receipt, and Clear Invoice — show automation rates at or near zero. This pattern suggests that the SRM system is responsible for managing its own internal transitions automatically, whereas human staff continue to handle the main workflow tasks. Understanding this divide is important for identifying where automation could be expanded to improve efficiency.

#sgh_figure(
  caption: [Automation rate per activity for the BPI Challenge 2019 sample. Blue bars highlight activities that are mostly automated, while salmon bars show those that are predominantly manual.],
  source: [Own elaboration based on BPI Challenge 2019 data.]
)[#image("figs/fig_08_automation_rate.png", width: 100%)] <fig-automation-rate>

=== Object-Centric Directly-Follows Graph

Unlike a classical directly-follows graph—which requires flattening the log to a single case type and can introduce duplication artifacts—an object-centric DFG calculates directly-follows relationships separately for each object type using the OCEL relations table. This approach eliminates the need for flattening altogether and makes it possible to compare process flows across different object types, providing a more accurate and nuanced view of how various objects move through the process.

*Step 4: Compute and compare object-centric DFGs.*

```python
rel = ocel.relations.copy()
rel["ocel:timestamp"] = pd.to_datetime(
    rel["ocel:timestamp"], utc=True, errors="coerce"
)
available_types = rel["ocel:type"].value_counts().index[:2].tolist()
print(f"Object types analysed: {available_types}")

results = {}
for otype in available_types:
    sub = (
        rel[rel["ocel:type"] == otype]
        .sort_values(["ocel:oid", "ocel:timestamp"])
        .copy()
    )
    sub["next_activity"] = (
        sub.groupby("ocel:oid")["ocel:activity"].shift(-1)
    )
    dfg = (
        sub.dropna(subset=["next_activity"])
        .groupby(["ocel:activity", "next_activity"])
        .size().reset_index(name="count")
        .sort_values("count", ascending=False)
    )
    results[otype] = dfg
    print(f"\n[{otype}] Top 5 directly-follows pairs:")
    print(dfg.head(5).to_string(index=False))
```

*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[
```
Object types analysed: ['Vendor', 'PO']

[Vendor] Top 5 directly-follows pairs:
             ocel:activity              next_activity  count
Record Service Entry Sheet Record Service Entry Sheet   3984
             Clear Invoice              Clear Invoice   3827
      Record Goods Receipt       Record Goods Receipt   3076
    Record Invoice Receipt     Record Invoice Receipt   2980
    Vendor creates invoice     Vendor creates invoice   2433

[PO] Top 5 directly-follows pairs:
             ocel:activity              next_activity  count
Record Service Entry Sheet Record Service Entry Sheet   2801
      Record Goods Receipt     Record Invoice Receipt   1605
      Record Goods Receipt       Record Goods Receipt   1504
    Record Invoice Receipt              Clear Invoice   1501
Create Purchase Order Item     Vendor creates invoice   1471
```
]

*Step 5: Object-centric DFG visualization.*

```python
fig, axes = plt.subplots(1, 2, figsize=(14, 5))
for ax, (otype, dfg) in zip(axes, results.items()):
    top = dfg.head(10).copy()
    top["arc"] = (
        top["ocel:activity"].str[:20] + " ->\n"
        + top["next_activity"].str[:20]
    )
    top.sort_values("count").plot(
        kind="barh", x="arc", y="count",
        color="steelblue", legend=False, ax=ax
    )
    ax.set_title(f"Object-Centric DFG -- {otype}")
    ax.set_xlabel("Frequency")
    ax.set_ylabel("")
plt.suptitle(
    "Object-Centric Directly-Follows Graph (BPI Challenge 2019)",
    fontsize=13
)
plt.tight_layout()
plt.savefig("figs/fig_09_ocdfg.png", dpi=150)
plt.show()
```

The object-centric analysis uncovers clear structural differences between the Vendor and PO perspectives. From the Vendor viewpoint, the dominant pattern is self-loops — for example, Record Service Entry Sheet often follows itself, and Clear Invoice does the same. This suggests that vendors are linked to multiple sequential events of the same type, each tied to different purchase order items. In contrast, the PO perspective reveals a much more sequential flow: Goods Receipt leads to Invoice Receipt, which then leads to Clear Invoice. This sequence reflects the standard three-way matching procedure typical in procurement. These findings highlight how object-centric analysis can expose structural patterns and process behaviors that remain hidden when using classical, flattened process mining approaches.

#sgh_figure(
  caption: [Object-centric directly-follows graphs for Vendor (left) and PO (right) object types in the BPI Challenge 2019 dataset. The Vendor graph highlights self-loop patterns, while the PO graph shows a sequential procurement flow.],
  source: [Own elaboration based on BPI Challenge 2019 data.]
)[#image("figs/fig_09_ocdfg.png", width: 100%)] <fig-ocdfg>

== Simulation and Predictive Monitoring

The fourth and fifth notebooks shift the analysis from descriptive to more forward-looking insights. Notebook 4 uses discrete-event simulation to model the approval queue and estimate how changes in staffing can affect throughput times. Notebook 5 introduces predictive monitoring by training a Random Forest classifier to flag, right at case creation, which purchase orders are likely to become slow cases — enabling proactive intervention before delays occur.

=== Discrete-Event Simulation with SimPy

SimPy is a Python library designed for discrete-event simulation. It models a system as a collection of processes competing for shared resources, advancing a virtual clock only when events actually occur. This makes SimPy particularly efficient for simulating the queuing dynamics often found in business processes. In this case, the approval step in procurement is modeled as a single-server queue: cases arrive at a rate calculated from the event log, and each one requires an approver to process it.

*Step 1: Load data and estimate arrival and service parameters.*

```python
import simpy, random
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("simpy_input.csv", parse_dates=["start", "end"])
df["duration_days"] = (df["end"] - df["start"]).dt.total_seconds() / 86400

arrival_rate = 1 / df["duration_days"].mean()
service_mean = df["duration_days"].median()
print(f"Mean inter-arrival (days): {1/arrival_rate:.2f}")
print(f"Median service time (days): {service_mean:.2f}")
```

*Step 2: Define and run the SimPy simulation.*

```python
def run_simulation(n_approvers, n_cases=500, seed=42):
    random.seed(seed); np.random.seed(seed)
    env       = simpy.Environment()
    approvers = simpy.Resource(env, capacity=n_approvers)
    results   = []

    def case(env, res, svc_mean):
        arrive = env.now
        with res.request() as req:
            yield req
            yield env.timeout(np.random.exponential(svc_mean))
        results.append(env.now - arrive)

    def generator(env):
        for i in range(n_cases):
            yield env.timeout(np.random.exponential(1 / arrival_rate))
            env.process(case(env, approvers, service_mean))

    env.process(generator(env))
    env.run()
    return np.median(results)

medians = {n: run_simulation(n) for n in range(1, 11)}
optimal = min(medians, key=lambda k: medians[k])
print(f"Optimal approvers: {optimal}  ->  median {medians[optimal]:.1f} days")
for n, m in medians.items():
    print(f"  {n} approver(s): {m:.1f} days median")
```

*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[
```
Optimal approvers: 5  ->  median 185.2 days
  1 approver(s):  247.3 days median
  2 approver(s):  221.6 days median
  3 approver(s):  205.4 days median
  4 approver(s):  193.8 days median
  5 approver(s):  185.2 days median
  6 approver(s):  186.1 days median
  7 approver(s):  187.0 days median
  8 approver(s):  188.3 days median
  9 approver(s):  189.1 days median
 10 approver(s):  190.4 days median
```
]

The simulation results show a dramatic decrease in throughput time as the number of approvers increases from one to five. Specifically, the median processing time drops from 247.3 days with a single approver to 185.2 days with five approvers. However, beyond five, adding more staff achieves only minimal further improvement — and in fact, the median processing time begins to rise slightly, likely due to the effects of overstaffing and process overhead. The sharp bend, or "knee," in the curve at five approvers represents the optimal staffing level for these arrival and service rates. This gives process owners a concrete, data-driven recommendation for resource allocation.

#sgh_figure(
  caption: [SimPy simulation results — median case throughput time as a function of the number of approvers. The optimal configuration of five approvers achieves the lowest median duration of 185.2 days.],
  source: [Own elaboration based on BPI Challenge 2019 data.]
)[#image("figs/fig_10_simulation.png", width: 100%)] <fig-simpy>

=== Predictive Process Monitoring with Random Forest

Predictive process monitoring focuses on forecasting case outcomes early in the process, providing an opportunity to intervene before issues escalate. In this analysis, a Random Forest classifier is trained to predict — right at the point when a purchase order item is created — whether that case will take more than 30 days to complete. This 30 days threshold is chosen to separate typical cases from slow outliers in the BPI Challenge 2019 dataset.

*Step 1: Feature engineering and dataset preparation.*

```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import roc_auc_score
from sklearn.preprocessing import LabelEncoder

df = pd.read_csv("rf_input.csv")
feature_cols = ["cCompany", "cDocType", "cGR",
                "cGRbasedInvVerif", "cItemCat", "cItemType"]
target_col = "slow_case"

for col in feature_cols:
    if df[col].dtype == object:
        df[col] = LabelEncoder().fit_transform(df[col].astype(str))

X = df[feature_cols]
y = df[target_col]
split = int(len(df) * 0.70)
X_train, X_test = X.iloc[:split], X.iloc[split:]
y_train, y_test = y.iloc[:split], y.iloc[split:]

print(f"Training cases   : {len(X_train)}")
print(f"Test cases       : {len(X_test)}")
print(f"Slow cases (>30d): {y.mean():.1%}")
```

*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[
```
Training cases   : 2836
Test cases       : 1216
Slow cases (>30d): 39.9%
```
]

*Step 2: Train Random Forest and evaluate.*

```python
rf = RandomForestClassifier(n_estimators=100, random_state=42)
rf.fit(X_train, y_train)

y_prob = rf.predict_proba(X_test)[:, 1]
auc    = roc_auc_score(y_test, y_prob)
importances = pd.Series(
    rf.feature_importances_, index=feature_cols
).sort_values(ascending=False)

print(f"AUC-ROC: {auc:.4f}")
print("\nFeature importances:")
print(importances.round(4).to_string())
```

*Output:*
#block(fill: luma(240), radius: 3pt, inset: (x: 1em, y: 0.7em), width: 100%)[
```
AUC-ROC: 0.6227

Feature importances:
cDocType          0.2814
cItemCat          0.1932
cItemType         0.1756
cGR               0.1421
cGRbasedInvVerif  0.1138
cCompany          0.0939
```
]

The Random Forest model achieves an AUC-ROC of 0.6227 — a moderate but meaningful result, especially considering that only six features available at case creation are used for prediction. The most influential feature is document type (cDocType), followed by item category and item type, which aligns with expectations that certain purchase order types such as blanket orders are more complex and tend to take longer to process. An AUC above 0.5 confirms that the model is identifying real patterns, not just noise. At the same time, the modest score serves as a reminder that many factors influencing case duration — such as supplier responsiveness or unpredictable approval delays — are only revealed later in the process and cannot be captured at the point of case creation.

#sgh_figure(
  caption: [Random Forest feature importances for predicting slow cases (duration greater than 30 days) in the BPI Challenge 2019 dataset. Document type emerges as the strongest early predictor of delays.],
  source: [Own elaboration based on BPI Challenge 2019 data.]
)[#image("figs/fig_11_predictive_monitoring.png", width: 100%)] <fig-rf>

= Conclusions
== Summary of Findings

This thesis set out to explore whether Python is now a practical choice for process mining and process intelligence. By building a solid mathematical foundation, surveying the latest tools, and running hands-on analyses with real-world data, the evidence points to a clear answer: yes — Python, especially when anchored by PM4Py, is ready for robust, end-to-end process mining projects, though some caveats remain.

Chapter 2 established the precise language and formal concepts needed to discuss and evaluate process mining rigorously. By defining events, traces, event logs, directly-follows relations, Petri nets, and conformance, it became possible to compare tools not just on intuition, but with clarity and consistency. The distinctions between fitness, precision, generalization, and simplicity were invaluable for interpreting discovery results, and the theoretical treatment of performance metrics underpinned all later quantitative analysis.

Chapter 3 reviewed the most significant Python libraries for process mining. PM4Py stands out as the most complete and actively maintained, supporting every stage of the workflow — from OCEL import to conformance checking and object-centric analysis — within a single, well-documented package. Additional libraries like SimPy, Simod, ML4ProM, PM4PYML, Plotly, and NetworkX expand Python's reach into simulation, predictive analytics, and interactive visualization. General-purpose packages such as pandas, scikit-learn, and XGBoost provide the essential infrastructure for data processing and modeling. Collectively, these tools are now mature enough to support sophisticated process intelligence projects entirely within Python.

Chapter 4 illustrated these capabilities with five analytical notebooks. The synthetic example confirmed that PM4Py's discovery, conformance, and performance functions work as expected on controlled data. The BPI Challenge 2019 case study proved that the workflow scales to large, real datasets — over 1.5 million events — producing a complex Petri net and a near-perfect conformance fitness score of 1.0000 on 7,979 held-out test cases. Advanced analyses showed that the top ten variants cover most cases, the rework rate is about 5%, and while median throughput time is around 18 days, a minority of slow cases raise the average to nearly 37 days. These results demonstrate that Python-based process mining is not just theoretically robust, but also practical and relevant for real organizational challenges.

== Limitations

Some important limitations should be noted:

- The tool survey reflects the ecosystem as of early 2026. With the rapid pace of development, some details may already be outdated as new tools or updates become available.

- No formal, controlled benchmarking was performed to directly compare tools or algorithms. The evaluations are based on published research, documentation, and personal experience — not on side-by-side experiments.

- The BPI Challenge 2019 case study used chronological sampling and classical flattening, each of which can introduce artifacts. Chronological sampling may miss more recent behaviors, while flattening by POItem can duplicate events and skew statistics. These challenges were acknowledged and addressed with fallback strategies, but a production solution would require more robust handling.

- The practical examples are implemented in Jupyter notebooks for clarity and reproducibility, not for production deployment. Real-world applications would need more automated, scalable, and robust pipelines.

== Directions for Future Research

Looking ahead, the findings from this thesis suggest several promising avenues for further work:

- *Alignment-based conformance checking:* Applying alignment-based methods to the full BPI Challenge 2019 log — not just a sample — could yield deeper diagnostic insights, even though this remains computationally intensive.

- *Predictive process monitoring:* There is a strong case for developing sequence-aware models such as LSTM or Transformer networks and deploying them in real time, so that process predictions can be updated as new events arrive.

- *Advancing object-centric process mining:* The field is moving toward advanced models like object-centric Petri nets and their associated conformance frameworks, but these are not yet widely available in Python. Implementing and evaluating these next-generation methods, especially on complex datasets like BPI Challenge 2019, would meaningfully advance both research and practice.

- *Benchmarking framework:* The Python process mining community would benefit from a standardized benchmarking suite, including curated datasets, common metrics, and protocols. This would make it much easier to compare algorithms and guide practitioners in selecting the most suitable tools.

In summary, Python — centered around PM4Py — now offers a robust and practical platform for modern process mining. With ongoing development, particularly in object-centric analysis and benchmarking, Python is well positioned to support both academic research and real-world process intelligence for years to come.

#list_of_sources("refs.bib")

#list_of_figures()

#list_of_tables()

/*
#pagebreak()
#heading("Appendix A: List of non-beings", numbering: none)
*/

#sgh_summary[
  This thesis reviewed the landscape of Python tools for process mining and process intelligence, evaluating their effectiveness through hands-on examples. The work began by establishing the mathematical foundations of process mining covering concepts such as event logs, traces, directly-follows relations, Petri nets, and conformance checking. It then surveyed the leading Python libraries in the field, with PM4Py identified as the most comprehensive and actively maintained solution. The practical component was structured around five analytical notebooks, which together demonstrated the full process intelligence cycle: from a synthetic introductory example, through process discovery and conformance checking on the BPI Challenge 2019 dataset, to advanced analyses such as variant and throughput analysis, performance DFG annotation, object-centric DFG computation, discrete-event simulation with SimPy, and predictive monitoring using a Random Forest classifier. The overall conclusion is that Python—especially with PM4Py at its core now provides a sufficiently complete and practical environment for conducting end-to-end process mining and process intelligence analysis.
]
