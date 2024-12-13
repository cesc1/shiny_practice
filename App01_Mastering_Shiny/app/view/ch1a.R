# File imports
box::use(
  app/view/ch1a_theory,
  app/view/ch1a_ex1,
  app/view/ch1a_ex4,
  app/view/ch1a_ex5,
)
# Package imports
box::use(
  shiny[moduleServer, NS, tagList],
  bslib[navset_pill_list, nav_panel]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    navset_pill_list(
      nav_panel("Theory", ch1a_theory$ui(ns("theory"))),
      nav_panel("Exercice 1", ch1a_ex1$ui(ns("ex1"))),
      nav_panel("Exercice 4", ch1a_ex4$ui(ns("ex4"))),
      nav_panel("Exercice 5", ch1a_ex5$ui(ns("ex5"))),
      widths = c(2, 10)
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ch1a_theory$server("theory")
    ch1a_ex1$server("ex1")
    ch1a_ex4$server("ex4")
    ch1a_ex5$server("ex5")
  })
}