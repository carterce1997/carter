
devtools::load_all()

ToothGrowth %>%
  count_percent(supp)

ToothGrowth %>%
  count_percent(dose)

ToothGrowth %>%
  count_percent(supp, dose)

ToothGrowth %>%
  count_percent(dose, .group_var = supp)
