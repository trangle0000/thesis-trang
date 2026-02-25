// Import szablonu pracy dyplomowej zgodnej z wymaganiami SGH
#import "SGH-thesis.typ": *

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
