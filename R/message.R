
library(glue)
library(log4r)

m <- function(msg, header = NULL, log_file = NULL) {

  current_time <- Sys.time()

  if (!is.null(log_file)) {
    logger <- logger(appenders = file_appender(log_file))
    info(logger, msg)
  }

  if (is.null(header))
    formatted <-
      glue::glue('[ {current_time} ] {msg}\n\n')
  else
    formatted <-
      glue::glue('[ {header} {current_time} ] {msg}\n\n')

  cat(formatted)

  cat()

}
