box::use(
  app/view/ch1a,
  app/view/ch1a_ex1,
  app/view/ch1a_ex4,
  app/view/ch1a_ex5,
)
box::use(
  shiny[moduleServer, NS],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  ch1a_ex5$ui(ns(id))
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
  ch1a_ex5$server(id)
  })
}
