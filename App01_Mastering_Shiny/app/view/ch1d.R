box::use(
  app/logic/ch1d_visualization[
    injuries, prod_codes, create_table, create_summary,
    create_plot_freq, create_plot_rate, create_narrative
  ],
)
box::use(
  shiny[moduleServer, NS],
  # Layout
  shiny[fluidPage, fluidRow, column],
  # UI
  shiny[selectInput, tableOutput, plotOutput, actionButton, textOutput],
  # Server
  shiny[reactive, renderTable, renderPlot, renderText, bindEvent],
  dplyr[pull]
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  fluidPage(
    fluidRow(
      column(8,
        selectInput(ns("code"), "Product", choices = prod_codes)
      ),
      column(2,
        selectInput(ns("y_axis"), "Y axis", c("rate", "freq"))
      )
    ),
    fluidRow(
      column(4, tableOutput(ns("diag"))),
      column(4, tableOutput(ns("body_part"))),
      column(4, tableOutput(ns("location")))
    ),
    fluidRow(
      column(12, plotOutput(ns("age_sex")))
    ),
    fluidRow(
      column(2, actionButton(ns("story"), "Tell me a story")),
      column(10, textOutput(ns("narrative")))
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Data
    selected <- reactive(injuries |> dplyr::filter(prod_code == input$code))
    
    # Tables
    output$diag <- renderTable(selected() |> create_table(diag), width = "100%")
    output$body_part <- renderTable(selected() |> create_table(body_part), width = "100%")
    output$location <- renderTable(selected() |> create_table(location), width = "100%")
    
    # Plots
    data_plot <- reactive(selected() |> create_summary())
    output$age_sex <- renderPlot({
      if(input$y_axis == "freq") {
        data_plot() |>  
          create_plot_freq()
      } else {
        data_plot() |>  
          create_plot_rate()
      }
    })
    
    # Story
    narrative_sample <- reactive({
      create_narrative(selected(), 1)
    }) |> 
      bindEvent(input$story, selected())
    
    output$narrative <- renderText(narrative_sample())
  })
}
