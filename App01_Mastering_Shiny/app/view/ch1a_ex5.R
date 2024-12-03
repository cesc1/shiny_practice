box::use(
  # Basic
  shiny[moduleServer, NS, tagList],
  # UI input
  shiny[selectInput],
  # UI output
  shiny[verbatimTextOutput, plotOutput],
  # Server
  shiny[reactive, renderPrint, renderPlot],
  # Other
  ggplot2[economics, faithfuld, seals]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  datasets <- c("economics", "faithfuld", "seals")
  ui <- tagList(
    selectInput(ns("dataset"), "Dataset", choices = datasets),
    verbatimTextOutput(ns("summary")),
    plotOutput(ns("plot"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    dataset <- reactive({
      get(input$dataset, "package:ggplot2")
    })
    output$summary <- renderPrint({
      summary(dataset())
    })
    output$plot <- renderPlot({
      plot(dataset())
    }, res = 96)
  })
}
