box::use(
  app/view/basic_app,
  app/view/theme[font_parkinsans, load_favicon, my_theme],
)
box::use(
  htmltools[tags],
  shiny[bootstrapPage, moduleServer, NS],
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
    data <- readRDS("app/data/pet_data.rds")
    basic_app$server("basic_app", data)
  })
}
