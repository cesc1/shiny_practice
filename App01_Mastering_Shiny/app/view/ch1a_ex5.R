box::use(
  app/data/load_ggplot_data[economics, faithfuld, seals],
)
box::use(
  # Basic
  shiny[moduleServer, NS, tagList],
  # UI input
  shiny[selectInput],
  # UI output
  shiny[verbatimTextOutput, plotOutput],
  # Server
  shiny[reactive, renderPrint, renderPlot],
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
      if (input$dataset == "economics") {
        economics
      } else if (input$dataset == "faithfuld") {
        faithfuld
      } else {
        seals
      }
    })
    output$summary <- renderPrint({
      summary(dataset())
    })
    output$plot <- renderPlot({
      plot(dataset())
    }, res = 96)
  })
}
