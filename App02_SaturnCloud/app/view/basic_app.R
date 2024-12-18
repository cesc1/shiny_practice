box::use(
  app/view/inputs,
  app/view/outputs,
)

box::use(
  shiny[moduleServer, NS, tagList, tags],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(class = "container bg-light my-5 py-3",
      tags$div(class = "row",
        inputs$ui(ns("inputs")),
        outputs$ui(ns("outputs"))
      )
    )
  )
}

#' @export
server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    in_data <- inputs$server("inputs", data)
    outputs$server("outputs",
                   in_data$input_data,
                   in_data$clicked_button)
  })
}
