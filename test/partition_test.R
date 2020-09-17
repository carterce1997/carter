
library(dplyr)

devtools::load_all()

data(iris)

df <-
  iris %>%
  partition(.proportions = list(train = .7, validate = .15, test = .16), .across_groups = c(Species))

df %>%
  filter(.partition == 'train')
