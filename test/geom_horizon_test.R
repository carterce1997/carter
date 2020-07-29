
library(tidyverse)

data("EuStockMarkets")

df <-
  EuStockMarkets %>%
  as_tibble() %>%
  mutate(time = 1:n()) %>%
  pivot_longer(DAX:FTSE, names_to = 'ticker', values_to = 'value')

df$value[sample(1:nrow(df))[1:10]] <- NA

df %>%
  ggplot() +
  geom_horizon(aes(x = time, y = value), bands = 2) +
  facet_grid(ticker ~ .)
