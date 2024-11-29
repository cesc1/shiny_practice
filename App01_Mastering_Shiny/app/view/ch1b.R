box::use(
  shiny[moduleServer, NS],
  shiny[fluidPage, h2, textInput, passwordInput, textAreaInput],
  shiny[numericInput, sliderInput],
  shiny[dateInput, dateRangeInput],
  shiny[selectInput, radioButtons, checkboxGroupInput],
  shiny[fileInput, actionButton, icon],
  
  shiny[textOutput, verbatimTextOutput],
  shiny[tableOutput, plotOutput],
  
  
  shiny[renderText, renderPrint],
  shiny[renderTable, renderPlot],
  
  datasets[state.name, mtcars],
  utils[head],
  DT[dataTableOutput, renderDT]
)

#' @export
ui <- function(id) {
  animals <- c("dog", "cat", "mouse")
  ns <- NS(id)
    fluidPage(
      h2("1. Text boxes:"),
      textInput(ns("text_short"), "Short text"),
      passwordInput(ns("text_password"), "Hidden text"),
      textAreaInput(ns("text_long"), "Long text", rows = 3),
     
      h2("2. Numeric inputs:"),
      numericInput(ns("num"), "Number one", value = 0, min = 0, max = 100),
      sliderInput(ns("num2"), "Number two", value = 50, min = 0, max = 100),
      sliderInput(ns("num3"), "Range", value = c(40, 60), min = 0, max = 100),
      
      h2("3. Dates:"),
      dateInput("date1", "Date single"),
      dateRangeInput("date2", "Date range"),
      
      h2("4. Choice boxes:"),
      selectInput("box1", "Box states", state.name),
      radioButtons("box2", "Box animals", animals),
      selectInput("box3", "Box states multiple", state.name, multiple = TRUE),
      checkboxGroupInput("box4", "Box animals multiple", animals),
      
      h2("5. Files:"),
      fileInput("upload", NULL),
      
      h2("Buttons:"),
      actionButton("button1", "Button 1", class = "btn-info"),
      actionButton("button2", "Button 2", class = "btn-danger", 
                   icon = icon("cocktail")),
      
      h2("Output text:"),
      textOutput(ns("text")), # paired with renderText
      verbatimTextOutput(ns("code")), # paired with renderPrint

      h2("Tables:"),
      tableOutput(ns("table1")), # paired with renderTable
      dataTableOutput(ns("table2")), # paired with renderDataTable
      
      h2("Plots:"),
      plotOutput(ns("plot"), width = "500px"),
    )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$text <- renderText("Hello friend!")
    output$code <- renderPrint("Hello friend!")
    
    output$table1 <- renderTable(head(mtcars))
    output$table2 <- renderDT(mtcars, options = list(pageLength = 5))
    
    output$plot <- renderPlot(plot(1:5), res = 96)
  })
}
