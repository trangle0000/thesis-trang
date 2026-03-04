rm(list = ls())

library(dplyr)

n <- 15
d <- tibble(
  "Id" = 1:n,
  "Indepented values" = round(rnorm(n), 2),
  "Explained variable" = round(1 + `Indepented values` + rnorm(n), 2),
  "Class" = ifelse(`Explained variable` > 1 + `Indepented values`, "High result", "Low result")
)

data.table::fwrite(x = d, file = "../main/tabs/tab-1.csv")
