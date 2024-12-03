box::use(
  app/logic/helper_functions[data, pet_type, fix_name,
                             plot_value_basic, plot_value],
  app/view/theme[my_theme],
)

box::use(
  shiny[bootstrapPage, moduleServer, NS, h1, h3, HTML],
  shiny[bootstrapPage, titlePanel,
        sidebarPanel, mainPanel],
  #UI
  shiny[div, textInput, actionButton, plotOutput, uiOutput],
  # Server
  shiny[isolate, reactive, reactiveVal, observe, 
        renderPlot, renderUI, bindEvent],
  glue[glue]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  bootstrapPage(
    theme = my_theme,
      div(class = "container bg-light my-5 py-3",
          div(class = "row",
              div(class = "col-6",
                  textInput(ns("name"), "Pet name"),
                  div(class = "d-grid gap-2",
                      actionButton(ns("guess_cat"), "Guess Cats", class = "btn-primary text-white"),
                      actionButton(ns("guess_dog"), "Guess Dogs", class = "btn-primary text-white")
                  )
              ),
              div(class = "col-6",
                  plotOutput(ns("plot")),
                  uiOutput(ns("text"))
              ),
          ),
      )  
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Load data
    results <- reactive({
      selected_name <- fix_name(input$name)
      if (nchar(selected_name) > 0) {
        pet_type(data, selected_name)
      } else {
        NULL
      }
    }) |> 
      bindEvent(input$guess_cat, input$guess_dog)
    
    # Know what button is pressed
    guess <- reactiveVal(label = "guess")
    observe(guess("cat")) |> 
      bindEvent(input$guess_cat)
    observe(guess("dog")) |> 
      bindEvent(input$guess_dog)

    output$plot <- renderPlot({
      plot_value(results())
    })
    
    output$text <- renderUI({
      if(is.null(results())) {
        h3("Please select a valid name")
      } else if (!is.finite(results()$p)) {
        h3("No pets in the data with that name")
      } else {
        if (results()$type == guess()) {
          value <- "correct!"
          value_style <- "correct-value"
        } else {
          value <- "incorrect."
          value_style <- "incorrect-value"
        }
        HTML(glue::glue("<h3>{guess()} is <span class = '{value_style}'>{value}</span></h3>"))
      } 
    })
  })
}
