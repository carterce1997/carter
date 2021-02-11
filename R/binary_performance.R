
binary_performance <- function(predictions, targets, cutoff = .5, format_long = FALSE) {

  if (!is.numeric(predictions)) stop('Predictions must be numeric')
  if (!is.logical(targets)) stop('Targets must be logical')

  metrics <-
    tibble(
      predicted_labels = predictions > cutoff,
      targets = targets
    ) %>%
    summarize(
      tpr = sum(predicted_labels & targets) / sum(targets),
      tnr = sum(!predicted_labels & !targets) / sum(!targets),
      fpr = sum(predicted_labels & !targets) / sum(!targets),
      fnr = sum(!predicted_labels & targets) / sum(targets),
      auc = as.numeric(pROC::auc(targets, predictions)),
      f1 = tpr / (tpr + .5 * (fpr + fnr)),
      acc = mean(predicted_labels == targets)
    )

  if (format_long) {
    return( pivot_longer(metrics, cols = everything()) )
  } else {
    return(metrics)
  }

}
