
library(glue)

m <- function(msg, header = NULL) {

  if (is.null(header))
    formatted <-
      glue::glue('[ {Sys.time()} ] {msg}\n\n')
  else
    formatted <-
      glue::glue('[ {header} {Sys.time()} ] {msg}\n\n')

  cat(formatted)

  cat()

}
