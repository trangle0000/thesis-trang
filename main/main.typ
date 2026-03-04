// Import szablonu pracy dyplomowej zgodnej z wymaganiami SGH
#import "SGH-thesis.typ": *
#import "@preview/callisto:0.2.4"


// ustawienie kolorowania tabel
#show: sgh_stripped_tables

// zmiana wielkość czcionki w tabelach
#show table.cell: set text(size: 9pt)

// ----------------------------------------------------------------------------

#show: sgh.with(
  author: "Thi van Trang",
  student_id: "140036",
  title: "Process Intelligence with Python Language",
  advisor: "dr hab. Michała Ramsza",
  advisor_department: "Institute of Mathematical Economics",
  year: "2026",
  studies: "mgr",
  program: "Advanced Analysis -- Big Data",
  language: "en"
)

#table_of_contents()

= Introduction

= The mathematics of process mining

// TODO: Here we will have everything that's related to mathematics and to process mining that is related to every single tool that we're going to use in Python.

// - Explain the data and do a little bit of exploratory data analysis.





= The tools available in Python

// TODO: Here, incorporate the sarv of the tools that you've done in the quarto file.

= Worked examples

== Introductory synthetic example

// TODO: This is the synthetic example where you create this synthetic data, a very simple table with the data.

== Sepsis: the case study

// TODO: First, you need to describe the source of the data and the format and structure of the data.

// TODO: Now you need to describe the statistical properties of the data. So this is like the exploratory data analysis. Probably this should be another Jupyter notebook.

// TODO: Describe what is the purpose of this example. So how we get the process structure from the data, why this is important, what we can get from it and so on. So describe what this example is all about.

// TODO: Just do the example. So here is going to be all the steps necessary to produce the results.

#callisto.render(
  nb: json("code/example-01-BPI-2019.ipynb"))

// TODO: Discussion of the results that you get from this implementation of examples. So what we get, what is the information from this stuff that we get and similar things. Also here we need to have connections to the mathematics that is described before.


== Some other examples

// TODO: Here will be some other example. 

= Conclusions

// To be written at the end.

#list_of_sources("refs.bib")

#list_of_figures()

#list_of_tables()

/* 
#pagebreak()
#heading("Appendix A: List of non-beings", numbering: none)
*/

#sgh_summary[
  This work analyzes the ... This needs to be written after the whole paper is ready.
]
