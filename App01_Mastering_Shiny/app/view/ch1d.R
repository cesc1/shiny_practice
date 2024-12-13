# File imports
box::use(
  app/view/ch1d_theory,
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
      nav_panel("Theory", ch1d_theory$ui(ns("theory"))),
      widths = c(2, 10)
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ch1d_theory$server("theory")
  })
}