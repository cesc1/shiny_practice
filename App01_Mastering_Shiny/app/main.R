box::use(
  app/view/ch1a,
  app/view/ch1b,
  app/view/ch1c,
  app/view/ch1d,
)
box::use(
  shiny[moduleServer, NS, fluidPage],
  bslib[navset_pill, nav_panel],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    navset_pill(
      nav_panel("Ch1", ch1a$ui(ns("ch1a"))),
      nav_panel("Ch2", ch1b$ui(ns("ch1b"))),
      nav_panel("Ch3", ch1c$ui(ns("ch1c"))),
      nav_panel("Ch4", ch1d$ui(ns("ch1d")))
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ch1a$server("ch1a")
    ch1b$server("ch1b")
    ch1c$server("ch1c")
    ch1d$server("ch1d")
  })
}
