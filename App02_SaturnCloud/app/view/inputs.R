# File imports
box::use(
  app/logic/helper_functions[calc_input_data],
  app/view/theme[textinput_max_width],
)
# Package imports
box::use(
  shiny[actionButton, tags],
  shiny[bindEvent, observe, reactive, reactiveVal],
  shiny[moduleServer, NS, tagList],
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(class = "col-6",
      textinput_max_width(ns("name")),
      tags$div(class = "d-grid gap-2",
        actionButton(ns("guess_cat"), "Guess Cats", class = "btn-primary text-white"),
        actionButton(ns("guess_dog"), "Guess Dogs", class = "btn-primary text-white")
      )
    )
  )
}

#' @export
server <- function(id, data) {
  stopifnot(is.data.frame(data))

  moduleServer(id, function(input, output, session) {
    input_data <- reactive(
      calc_input_data(data, input$name)
    ) |>
      bindEvent(input$guess_cat, input$guess_dog)

    clicked_button <- reactiveVal(label = "guess")
    observe(clicked_button("cat")) |> bindEvent(input$guess_cat)
    observe(clicked_button("dog")) |> bindEvent(input$guess_dog)
    list(
      input_data = input_data,
      clicked_button = clicked_button
    )
  })
}
