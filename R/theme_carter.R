
library(ggplot2)

#' A simple ggplot theme.
theme_carter <- function() {

  theme_minimal() +
    theme(
      text = element_text(family = 'Helvetica Neue'),
      panel.grid.minor = element_blank()
    )

}
