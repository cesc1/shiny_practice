box::use(
  # Basic
  shiny[moduleServer, NS, tagList],
  # UI input
  shiny[sliderInput],
  # UI output
  shiny[textOutput],
  # Server
  shiny[reactive, renderText],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    sliderInput(ns("x"),
                label = "If x is",
                min = 1,
                max = 50,
                value = 30),
    sliderInput(ns("y"),
                label = "and y is",
                min = 1,
                max = 50,
                value = 5),
    "then, (x * y) is", textOutput(ns("product")),
    "and, (x * y) + 5 is", textOutput(ns("product_plus5")),
    "and, (x * y) + 5 is", textOutput(ns("product_plus10"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    product <- reactive({
      input$x * input$y
    })
    
    output$product <- renderText({
      product()
    })
    output$product_plus5 <- renderText({
      product() + 5
    })
    output$product_plus10 <- renderText({
      product() + 10
    })
  })
}
