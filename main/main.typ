// Import szablonu pracy dyplomowej zgodnej z wymaganiami SGH
#import "SGH-thesis.typ": *
#import "@preview/callisto:0.2.4"


// ustawienie kolorowania tabel
#show: sgh_stripped_tables

// zmiana wielkość czcionki w tabelach
#show table.cell: set text(size: 9pt)

// ----------------------------------------------------------------------------

#show: sgh.with(
  author: "Name & Family Name",
  student_id: "112358",
  title: "Process mining",
  advisor: "dr hab. Michała Ramsza",
  advisor_department: "Instytut Ekonomii Matematycznej",
  year: "2026",
  studies: "mgr",
  program: "Advanced Analysis -- Big Data",
  language: "en"
)

#table_of_contents()

= Introduction

I type something here. This is inline mathematics $f(x) = sin(x^2) + log(1 + y^2 + x^2)$. This is the displayed mathemathics
$
  EE(X) &= integral_(-oo)^(oo) x f(x) d x \
  &= integral_(-oo)^(oo) x d F_X (x) \
  &= integral_(-oo)^(oo) x d mu_X (x) .\
$<eq-mean-value>

This is a reference to the equation @eq-mean-value. This is a citatation @benaim2003. I can also cite like this #cite(<benaim2003>, form: "prose"). 

#sgh_table(
  caption: [The data that were exported directly from a Python script and I can easily read this into the file and create a table.],
  source: [Own elaboration]
)[
  #let data = csv("tabs/tab-1.csv")
  #let dataHead = data.at(0)
  #let dataValues = data.slice(1)
  #table(
    columns: (1fr, 1fr, 1fr, 1fr),
    ..dataHead,
    ..dataValues.flatten()
  )  
]<tab-first-table>

This is a refrence to table @tab-first-table. And this is a reference to figure @fig-first-petri-net. 

#sgh_figure(
  caption: [This is an example caption for some figure.],
  source: [This is where I put the source of the figure. If this is a figure that I generated I can put my own elaboration or some our own computation something like this.]
)[
  #image("/code/fig1.png", width: 80%)
]<fig-first-petri-net>

// To be written at the end.



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
