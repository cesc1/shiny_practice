box::use(
  shiny[fluidPage, moduleServer, NS],
  shiny[reactive, renderPrint, renderTable,
        selectInput, tableOutput, verbatimTextOutput],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    selectInput(ns("dataset"), label = "Dataset", choices = ls("package:datasets")),
    verbatimTextOutput(ns("summary")),
    tableOutput(ns("table"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Reactive expression
    dataset <- reactive({
      get(input$dataset, "package:datasets")
    })

    output$summary <- renderPrint({
      summary(dataset())
    })

    output$table <- renderTable({
      dataset()
    })
  })
}
