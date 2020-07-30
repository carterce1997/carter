
split_data <- function(x, train_valid_test_proportion) {

  num_observations <- nrow(x)

  partition <- sample(c(1,2,3), size = num_observations, replace = TRUE, prob = train_valid_test_proportion)

  train_filter <-
    partition == 1

  validate_filter <-
    partition == 2

  test_filter <-
    partition == 3

  train <-
    x[train_filter, ]

  validate <-
    x[validate_filter,]

  test <-
    x[test_filter, ]

  return(list(train = train, validate = validate, test = test))

}

split_into_train_validate_test <- function(x, across_categories = NULL, train_validate_test_proportion = c(.7, .15, .15)) {

  if (is.null(across_categories)) {

    return(split_data(x, train_validate_test_proportion))

  } else {

    train <- validate <- test <- NULL

    for (category in across_categories) {

      for (level in unique(x[[category]])) {

        x_category <- x[x[[category]] == level, ]
        category_train_test <- split_data(x_category, train_validate_test_proportion)

        if (nrow(category_train_test$train) > 0 & nrow(category_train_test$validate) > 0 & nrow(category_train_test$test) > 0) {

          train <-
            rbind(train, category_train_test$train)

          validate <-
            rbind(validate, category_train_test$validate)

          test <-
            rbind(test, category_train_test$test)

        }

      }

    }

    return(list(train = train, validate = validate, test = test))

  }

}
