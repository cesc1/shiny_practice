box::use(
  # Basic
  shiny[moduleServer, NS, tagList],
  # UI input
  shiny[textInput, numericInput, textOutput],
  # Server
  shiny[renderText],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    textInput(ns("name"), "What's your name?"),
    numericInput(ns("age"), "How old are you?", value = NA),
    
    textOutput(ns("greeting"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$greeting <- renderText({
      paste0("Hello ", input$name,
             ", do you really have ", input$age, " years old?")
    })
  })
}
