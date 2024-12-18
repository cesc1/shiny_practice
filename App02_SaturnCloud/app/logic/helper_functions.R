box::use(
  dplyr[filter],
  ggplot2[aes, coord_cartesian, geom_line, geom_rect, ggplot],
  ggplot2[dup_axis, element_text, margin, scale_y_continuous, theme, theme_void],
  glue[glue],
  shiny[HTML, tags],
  stringr[str_remove_all],
)

fix_name <- function(example_name) {
  example_name |>
    tolower() |>
    str_remove_all("[^ \\.-[a-zA-Z]]") |>
    trimws()
}

pet_type <- function(pet_data, selected_name) {
  results <- pet_data |>
    filter(name == selected_name)

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
calc_input_data <- function(data, name) {
  name_clean <- fix_name(name)
  if (nchar(name_clean) > 0) {
    result <- pet_type(data, name_clean)
    return(result)
  }
  return(NULL)
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

#' @export
create_html_output <- function(input_data, clicked_button) {
  if (is.null(input_data)) {
    return(
      tags$h3("Please select a valid name")
    )
  } else if (!is.finite(input_data$p)) {
    return(
      tags$h3("No pets in the data with that name")
    )
  } else if (input_data$type == "tie") {
    return(
      tags$h3(glue("It's a tie! ({input_data$cats} - {input_data$dogs})"))
    )
  } else {
    if (input_data$type == clicked_button) {
      value <- "correct!"
      value_style <- "correct-value"
    } else {
      value <- "incorrect."
      value_style <- "incorrect-value"
    }
    return(
      HTML(glue("<h3>{clicked_button} is <span class = '{value_style}'>{value}</span></h3>"))
    )
  }
}
