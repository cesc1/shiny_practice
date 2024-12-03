box::use(
  app/view/basic_app,
)
box::use(
  shiny[moduleServer, NS],
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  basic_app$ui(ns(id)) 
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    basic_app$server(id)
  })
}
