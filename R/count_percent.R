
count_percent <- function(.data, ..., .group_var = NULL, name = NULL) {

  .group_var <- enquo(.group_var)

  if (rlang::quo_is_null(.group_var)) {

    if (is.null(name)) name <- 'n'

    .data %>%
      mutate(n_total = n()) %>%
      group_by(...) %>%
      summarize(
        !!name := n() / unique(n_total)
      ) %>%
      ungroup()

  } else {

    if (is.null(name)) name <- 'n'

    .data %>%
      group_by(!!.group_var) %>%
      mutate(
        n_total = n()
      ) %>%
      ungroup() %>%
      group_by(!!.group_var, ...) %>%
      summarize(
        !!name := n() / unique(n_total)
      ) %>%
      ungroup()

  }

}
