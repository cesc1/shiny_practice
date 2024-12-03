box::use(
  dplyr[filter],
  ggplot2[ggplot, aes, geom_col, geom_line, coord_cartesian,
          theme_void, theme, margin, dup_axis, scale_y_continuous, geom_rect,
          element_text],
)

#' @export
data <- readRDS("app/data/pet_data.rds")

#' @export
fix_name <- function(example_name) {
  example_name |> 
    tolower() |> 
    stringr::str_remove_all("[^ \\.-[a-zA-Z]]") |> 
    trimws()
}

#' @export
pet_type <- function(pet_data, selected_name) {
  results <- pet_data |> 
    dplyr::filter(name == selected_name)
  
  cats <- sum(results$species == "cat")
  dogs <- sum(results$species == "dog")
  p <- cats / (cats + dogs)
  
  if (is.infinite(p)) {
    type <- "name not found"
  } else if (cats > dogs) {
    type <- "cat"
  } else if (dogs > cats) {
    type <- "dog"
  } else {
    type <- "tie"
  }
  
  list(cats = cats, dogs = dogs, p = p, type = type)
}

#' @export
plot_value_basic <- function(results) {
  if (is.null(results)) {
    ggplot()
  } else {
    ggplot(data.frame(count = c(results$cats, results$dogs),
                      type = c("cats", "dogs")),
           aes(x = type, y = count)) +
      geom_col()
  }
}

#' @export
plot_value <- function(results) {
  if (is.null(results)) {
    p <- NA
  } else {
    p <- results$p
  }
  
  plot <- ggplot(data = data.frame(x = p),
                 aes(xmin = x - 0.025, xmax = x + 0.025, ymin = -0.1, ymax = 0.1)) +
    geom_line(data = rbind(data.frame(x = seq(0, 1, 0.1), y = -0.05, group = 1:11),
                           data.frame(x = seq(0, 1, 0.1), y =  0.05, group = 1:11)),
              aes(x = x, y = y, group = group),
              color = "#c0c0c0") +
    geom_line(data = rbind(data.frame(x = seq(0, 1, 0.05), y = -0.025, group = 1:21),
                           data.frame(x = seq(0, 1, 0.05), y = 0.025, group = 1:21)),
              aes(x = x, y = y, group = group),
              color = "#c0c0c0") +
    geom_line(data = data.frame(x = c(0, 1), y = c(0, 0)),
              aes(x = x, y = y),
              color = "#c0c0c0") +
    coord_cartesian(xlim = c(0, 1), ylim = c(-0.105, 0.105)) +
    theme_void() +
    theme(axis.title.y.left = element_text(angle = 90, size = 24),
          axis.title.y.right = element_text(angle = -90, size = 24),
          plot.margin = margin(12, 12, 12, 12)) +
    scale_y_continuous(name = "DOG", sec.axis = dup_axis(name = "CAT"))
  if (is.finite(p)) {
    plot <- plot + geom_rect(fill = "#FF6622", alpha = 0.8)
  }
  plot
}
