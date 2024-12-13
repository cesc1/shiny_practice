box::use(
  shiny[moduleServer, NS, tagList, observe],
  shiny[h2, textInput, sliderInput, selectizeInput, updateSelectizeInput],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    h2("Box with placeholder"),
    textInput(ns("name"), label = "", value = "Your name"),
    
    h2("Time slider"),
    sliderInput("date_slide", "Deliver date", 
                min = as.Date("16/09/2020", "%d/%m/%y"),
                max = as.Date("23/09/2020", "%d/%m/%y"),
                value = as.Date("17/09/2020", "%d/%m/%y"),
                timeFormat = "%F"),
    
    h2("Animated slider"),
    sliderInput("slide1", "Animated slider", 
                min = 0,
                max = 100,
                value = 50,
                step = 5,
                animate = TRUE),
    
    h2("Long selectable, using server-side selectize"),
    selectizeInput(ns("long_box"), "Choose an item:", 
                   choices = NULL,
                   multiple = FALSE)
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    updateSelectizeInput(
      session,
      inputId = "long_box",
      choices = 0:1000,
      server = TRUE
    )
  })
}
