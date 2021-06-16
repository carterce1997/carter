
library(ggplot2)

#' A simple ggplot theme.
theme_carter <- function() {

  theme_minimal() +
    theme(
      text = element_text(family = 'sans'),
      panel.grid.minor = element_blank(),
      axis.line = element_line(colour = 'gray'),
    )

}

#' A simple ggplot theme.
theme_carter2 <- function() {

  theme_minimal() +
    theme(
      text = element_text(family = 'sans'),
      panel.grid = element_blank(),
      axis.line = element_line(colour = 'gray'),
    )

}
