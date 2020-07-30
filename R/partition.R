
library(dplyr)

make_partitions <- function(.length, .proportions) {

  partitions <-
    sample(names(.proportions), size = .length, replace = TRUE, prob = .proportions)

  return(partitions)

}


partition <- function(.data, .proportions = NULL, .across_groups = NULL, .drop_incomplete = FALSE) {

  .proportions <-
    unlist(.proportions)

  if (length(.proportions) == 0)
    return(.data)

  if (sum(.proportions) != 1) {
    warning(glue::glue("Proportions {paste(.proportions, collapse = ', ')} do not add up to 1. Normalizing to a sum of 1."), call. = FALSE)

    .proportions <-
      .proportions / sum(.proportions)
  }

  .across_groups <-
    enquo(.across_groups)

  .across_groups_cols <-
    names(tidyselect::eval_select(.across_groups, .data))

  partitioned_data <-
    .data %>%
    group_by_at(.across_groups_cols) %>%
    mutate(
      .partition = make_partitions(n(), .proportions)
    ) %>%
    ungroup()

  incomplete_groups <-
    partitioned_data %>%
    group_by_at(.across_groups_cols) %>%
    summarize(.complete = setequal(.partition, names(.proportions))) %>%
    ungroup() %>%
    filter(!.complete)

  num_incomplete_groups <-
    nrow(incomplete_groups)

  if (num_incomplete_groups > 0) {

    if(.drop_incomplete) {
      warning(glue::glue('{num_incomplete_groups} groups were not completely partitioned. Use .drop_incomplete = FALSE to keep incompletely partitioned groups.'), call. = FALSE)

      partitioned_data <-
        partitioned_data %>%
        anti_join(incomplete_groups, by = .across_groups_cols)

    } else {
      warning(glue::glue('{num_incomplete_groups} groups are not completely partitioned. Use .drop_incomplete = TRUE to drop these groups.'), call. = FALSE)
    }

  }

  partition_summary <-
    partitioned_data %>%
    count(partition = .partition, name = 'count') %>%
    mutate(
      proportion = count / sum(count),
      target_proportion = .proportions[partition]
    ) %>%
    select(-count)

  cat('\nPartition summary:\n')
  print(partition_summary)
  cat('\n')

  return(partitioned_data)

}







