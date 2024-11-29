box::use(
  app/logic/utils[freqpoly, t_test]
)
box::use(
  shiny[moduleServer, NS],
  shiny[h2, fluidPage, fluidRow, column, numericInput, sliderInput, actionButton, textInput],
  shiny[plotOutput, verbatimTextOutput, textOutput],
  shiny[bindEvent, reactive, reactiveTimer, renderPlot, renderText, observe],
  stats[rnorm, rpois],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    h2("1. Reactive expressions"),
    fluidRow(
      column(4,
             "Distribution 1",
             numericInput(ns("n1"), label = "n", value = 1000, min = 1),
             numericInput(ns("mean1"), label = "µ", value = 0, step = 0.1),
             numericInput(ns("sd1"), label = "σ", value = 0.5, min = 0.1, step = 0.1)
      ),
      column(4,
             "Distribution 2",
             numericInput(ns("n2"), label = "n", value = 1000, min = 1),
             numericInput(ns("mean2"), label = "µ", value = 0, step = 0.1),
             numericInput(ns("sd2"), label = "σ", value = 0.5, min = 0.1, step = 0.1)
      ),
      column(4,
             "Frequency polygon",
             numericInput(ns("binwidth"), label = "Bin width", value = 0.1, step = 0.1),
             sliderInput(ns("range"), label = "range", value = c(-3, 3), min = -5, max = 5)
      )
    ),
    fluidRow(
      column(9, plotOutput(ns("hist"))),
      column(3, verbatimTextOutput(ns("ttest")))
    ),
    
    h2("2.1 Time invalidation"),
    fluidRow(
      column(3,
        numericInput(ns("lambda1_1"), label = "lambda1", value = 3),
        numericInput(ns("lambda1_2"), label = "lambda2", value = 5),
        numericInput(ns("n_pois1"), label = "n", value = 1e4, min = 0)
      ),
      column(9, plotOutput(ns("hist_pois1")))
    ),
    
    h2("2.2 On click execution"),
    fluidRow(
      column(3,
             numericInput(ns("lambda2_1"), label = "lambda1", value = 3),
             numericInput(ns("lambda2_2"), label = "lambda2", value = 5),
             numericInput(ns("n_pois2"), label = "n", value = 1e4, min = 0),
             actionButton(ns("simulate"), "Simulate!")
      ),
      column(9, plotOutput(ns("hist_pois2")))
    ),
    h2("3. Observer"),
    fluidRow(
      textInput(ns("name"), "What's your name"),
      textOutput(ns("greeting"))
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Norm
    x1 <- reactive(rnorm(input$n1, input$mean1, input$sd1))
    x2 <- reactive(rnorm(input$n2, input$mean2, input$sd2))
    output$hist <- renderPlot({
      freqpoly(x1(), x2(), binwidth = input$binwidth, xlim = input$range)
    }, res = 96)
    output$ttest <- renderText({
      t_test(x1(), x2())
    })

    # Pois timer
    timer <- reactiveTimer(1000)
    pois1_1 <- reactive({
      timer()
      rpois(input$n_pois1, input$lambda1_1)
    })
    pois1_2 <- reactive({
      timer()
      rpois(input$n_pois1, input$lambda1_2)
    })
    output$hist_pois1 <- renderPlot({
      freqpoly(pois1_1(), pois1_2(), binwidth = 1, xlim = c(0, 40))
    }, res = 96)
    
    # Pois button
    pois2_1 <- reactive(
      rpois(input$n_pois2, input$lambda2_1)
    ) |> 
      bindEvent(input$simulate)
    pois2_2 <- reactive(
      rpois(input$n_pois2, input$lambda2_2)
    ) |> bindEvent(input$simulate)
    output$hist_pois2 <- renderPlot({
      freqpoly(pois2_1(), pois2_2(), binwidth = 1, xlim = c(0, 40))
    }, res = 96)
    
    # Observer
    string <- reactive(paste0("Hello ", input$name, "!"))
    output$greeting <- renderText(string())
    observe({
      message("Greeting performed")
    }) |> 
      bindEvent(input$name)
  })
}
