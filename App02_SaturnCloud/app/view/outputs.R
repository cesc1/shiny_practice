# File imports
box::use(
  app/logic/helper_functions[create_html_output, plot_value],
)
# Package imports
box::use(
  shiny[is.reactive, plotOutput, renderPlot, renderUI, req, uiOutput],
  shiny[moduleServer, NS, tagList, tags],
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(class = "col-6",
      plotOutput(ns("plot")),
      uiOutput(ns("text"))
    )
  )
}

#' @export
server <- function(id, input_data, clicked_button) {
  stopifnot(is.reactive(input_data))
  stopifnot(is.reactive(clicked_button))

  moduleServer(id, function(input, output, session) {
    output$plot <- renderPlot({
      plot_value(input_data())
    })

    output$text <- renderUI({
      req(input_data())
      create_html_output(input_data(), clicked_button())
    })
  })
}
