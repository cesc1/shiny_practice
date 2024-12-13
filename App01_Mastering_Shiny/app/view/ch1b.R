# File imports
box::use(
  app/view/ch1b_theory,
  app/view/ch1b_ex1,
)
# Package imports
box::use(
  shiny[moduleServer, NS, tagList],
  bslib[navset_pill_list, nav_panel],
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    navset_pill_list(
      nav_panel("Theory", ch1b_theory$ui(ns("theory"))),
      nav_panel("Exercice 1", ch1b_ex1$ui(ns("ex1"))),
      widths = c(2, 10)
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ch1b_theory$server("theory")
    ch1b_ex1$server("ex1")
  })
}