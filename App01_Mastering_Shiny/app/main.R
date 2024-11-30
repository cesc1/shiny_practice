box::use(
  app/view/ch1a,
  app/view/ch1a_ex1,
  app/view/ch1a_ex4,
  app/view/ch1a_ex5,
  app/view/ch1b,
  app/view/ch1b_ex1,
  app/view/ch1c,
  app/view/ch1d,
)
box::use(
  shiny[moduleServer, NS],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  ch1d$ui(ns(id))
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
  ch1d$server(id)
  })
}
