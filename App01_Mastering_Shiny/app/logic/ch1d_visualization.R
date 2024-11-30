box::use(
  shiny[...],
  vroom[vroom],
  dplyr[filter, count, left_join, mutate, sample_n],
  forcats[fct_lump, fct_infreq],
  ggplot2[ggplot, aes, geom_line, labs],
)

# Load data
#' @export
injuries <- vroom::vroom("app/data/injuries.tsv.gz")

#' @export
products <- vroom::vroom("app/data/products.tsv")

#' @export
population <- vroom::vroom("app/data/population.tsv")

#' @export
prod_codes <- stats::setNames(products$prod_code, products$title)

# Exploration

## Check one of the products
selected <- injuries |> 
  dplyr::filter(prod_code == 464)
nrow(selected)

## Do counts for location, body part and diagnosis
#' @export
create_table <- function(data, var, n = 5) {
  data |> 
    dplyr::mutate({{ var }} := forcats::fct_lump_n(
      forcats::fct_infreq({{ var }}), n = n
    )) |> 
    dplyr::count({{ var }}, wt = weight) |> 
    dplyr::mutate(n = as.integer(n))
}

# Age-sex pattern
## We adjust by injury rate
#' @export
create_summary <- function(data) {
  data |> 
    dplyr::count(age, sex, wt = weight) |> 
    dplyr::left_join(population, by = c("age", "sex")) |> 
    dplyr::mutate(rate = n / population * 1e4)  
}

#' @export
create_plot_freq <- function(summary) {
  summary |> 
    ggplot(aes(age, n, colour = sex)) +
    geom_line() +
    labs(y = "Estimated number of injuries")
}

#' @export
create_plot_rate <- function(summary) {
  summary |> 
    ggplot(aes(age, rate, colour = sex)) +
    geom_line(na.rm = TRUE) +
    labs(y = "Injuries per 10,000 people")
}

#' @export
create_narrative <- function(data, n) {
  data |> 
    dplyr::sample_n(n) |> 
    dplyr::pull(narrative)
}
