
library(ggplot2)

geom_horizon <-  function(mapping = NULL, data = NULL, show.legend = TRUE, inherit.aes = TRUE, na.rm = TRUE, bands = NULL, bandwidth = NULL, ...) {

  list(
    layer(
      data = data,
      mapping = mapping,
      stat = "horizon",
      geom = GeomHorizon,
      position = 'identity',
      show.legend = show.legend,
      inherit.aes = inherit.aes,
      params = list(bandwidth = bandwidth, bands = bands, na.rm = na.rm, ...)
    )
  )

}


GeomHorizon <- ggproto(
  "GeomHorizon",
  GeomArea,
  required_aes = c("x", "y"),
  default_aes = plyr::defaults(
    aes(fill=NA, size = 0.15, linetype = 1, alpha = NA, colour = "gray20"),
    ggplot2::GeomArea$default_aes
  ),
  draw_key = ggplot2::draw_key_rect
)


stat_horizon <- function(mapping = NULL, data = NULL, geom = "horizon", show.legend = TRUE, inherit.aes = TRUE, na.rm = TRUE, bandwidth = NULL, bands = NULL, ...) {

  list(
    layer(
      stat = StatHorizon,
      data = data,
      mapping = mapping,
      geom = geom,
      position = 'identity',
      show.legend = show.legend,
      inherit.aes = inherit.aes,
      params = list(bandwidth = bandwidth, bands = bands, na.rm = na.rm, ...)
    )
  )

}

#' @rdname geom_horizon
#' @keywords internal
#' @export
StatHorizon <- ggproto(
  "StatHorizon",
  Stat,
  required_aes = c("x", "y"),
  default_aes = aes(fill=..band..),
  setup_params = function(data, params) {

    # calculating a default bandwidth
    if (is.null(params$bandwidth) & is.null(params$bands)) {

      message('Using default of 3 bands')
      params$bandwidth <- diff(range(data$y, na.rm = TRUE)) / 3

    } else if (is.null(params$bandwidth)) {

      params$bandwidth <- diff(range(data$y, na.rm = TRUE)) / params$bands

    }

    params$n_min_y <- min(data$y, na.rm = TRUE)

    params

  },

  compute_group = function(data, scales, bandwidth, bands, n_min_y) {

    # calculating the band in which the values fall
    data$fillb <- ((data$y - n_min_y) %/% bandwidth) + 1

    # calculating the banded y value
    orig_y <- data$y
    orig_fill_b <- data$fillb

    data$y <- data$y - (bandwidth * (data$fillb - 1)) - n_min_y

    fill_bands <- sort(unique(data$fillb))

    # for each band, calculating value at a particular x
    banded_data <- lapply(

      fill_bands,

      function(i_fill_band) {

        df_banded_data <- data[data$fillb == i_fill_band,]

        df_banded_data_high <- data[data$fillb > i_fill_band,]

        if (nrow(df_banded_data_high) > 0) {
          df_banded_data_high$y <- bandwidth
          df_banded_data_high$fillb <- i_fill_band
        }

        df_banded_data_low <- data[data$fillb < i_fill_band,]

        if (nrow(df_banded_data_low) > 0) {
          df_banded_data_low$y <- 0
          df_banded_data_low$fillb <- i_fill_band
        }

        data <- rbind(
          rbind(df_banded_data, df_banded_data_low),
          df_banded_data_high
        )

        data$fillb <- data$fillb * bandwidth

        data$band <- i_fill_band
        data$group <- i_fill_band

        return(data)

      }

    )

    data <- do.call(rbind, banded_data)

    return(data)

  }

)
