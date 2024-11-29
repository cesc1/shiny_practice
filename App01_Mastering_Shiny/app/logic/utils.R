box::use(
  ggplot2[ggplot, aes, geom_freqpoly, coord_cartesian],
  stats[t.test],
)

#' @export
freqpoly <- function(x1, x2, binwidth = 0.1, xlim = c(-3, 3)) {
  df <- data.frame(
    x = c(x1, x2),
    g = c(rep("x1", length(x1)), rep("x2", length(x2)))
  )
  
  ggplot2::ggplot(df, ggplot2::aes(x, colour = g)) +
    ggplot2::geom_freqpoly(binwidth = binwidth, size = 1) +
    ggplot2::coord_cartesian(xlim = xlim)
}

#' @export
t_test <- function(x1, x2) {
  test <- stats::t.test(x1, x2)
  
  sprintf(
    "p value: %0.3f\n[%0.2f, %0.2f]",
    test$p.value, test$conf.int[1], test$conf.int[2]
  )
}