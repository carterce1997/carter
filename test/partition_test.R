
library(dplyr)

devtools::load_all()

data(iris)

df <-
  iris %>%
  partition(.proportions = list(train = .99, test = .1), .across_groups = c())

df <-
  iris %>%
  partition(.proportions = list(train = .7, validate = .15, test = .15), .across_groups = c(Species))
