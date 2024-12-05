box::use(
  app/view/basic_app,
  app/view/theme[my_theme, font_parkinsans, load_favicon],
)
box::use(
  shiny[bootstrapPage, moduleServer, NS],
  htmltools[tags],
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  bootstrapPage(
    theme = my_theme,
    tags$head(
      font_parkinsans(),
      load_favicon()
    ),
    basic_app$ui(ns("basic_app"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    basic_app$server("basic_app")
  })
}
