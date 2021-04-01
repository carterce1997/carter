
filter_when <- function(.data, .condition, ...) {

  if (.condition)
    return(filter(.data, ...))
  else
    return(.data)

}
