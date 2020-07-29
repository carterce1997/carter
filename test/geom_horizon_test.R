
library(tidyverse)

data("EuStockMarkets")

EuStockMarkets %>%
  as_tibble() %>%
  mutate(time = 1:n()) %>%
  pivot_longer(DAX:FTSE, names_to = 'ticker', values_to = 'value') %>%
  ggplot() +
  geom_horizon(aes(x = time, y = value), bands = 2) +
  facet_grid(ticker ~ .)
