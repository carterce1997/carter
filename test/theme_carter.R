
library(tidyverse)

devtools::load_all()

iris %>%
  janitor::clean_names() %>%
  ggplot() +
  geom_point(aes(x = sepal_length, y = sepal_width, color = species)) +
  ggtitle('Iris') +
  theme_carter2()
