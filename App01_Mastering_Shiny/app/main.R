box::use(
  app/view/ch1a,
  app/view/ch1a_ex1,
  app/view/ch1a_ex4,
  app/view/ch1a_ex5,
  app/view/ch1b,
  app/view/ch1b_ex1,
  app/view/ch1c,
  app/view/ch1d,
)
box::use(
  shiny[moduleServer, NS, fluidPage],
  bslib[navset_pill, nav_panel, nav_menu]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    navset_pill(
      nav_menu(
        "Ch1", 
        nav_panel("Theory", ch1a$ui(ns("ch1a"))),
        nav_panel("ex1", ch1a_ex1$ui(ns("ch1a_ex1"))),
        nav_panel("ex4", ch1a_ex4$ui(ns("ch1a_ex4"))),
        nav_panel("ex5", ch1a_ex5$ui(ns("ch1a_ex5")))
      ),
      nav_menu(
        "Ch2",
        nav_panel("Theory", ch1b$ui(ns("ch1b"))),
        nav_panel("ex1", ch1b_ex1$ui(ns("ch1b_ex1")))
      ),
      nav_panel("Ch3", ch1c$ui(ns("ch1c"))),
      nav_panel("Ch4", ch1d$ui(ns("ch1d")))
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ch1a$server("ch1a")
    ch1a_ex1$server("ch1a_ex1")
    ch1a_ex4$server("ch1a_ex4")
    ch1a_ex5$server("ch1a_ex5")
    ch1b$server("ch1b")
    ch1b_ex1$server("ch1b_ex1")
    ch1c$server("ch1c")
    ch1d$server("ch1d")
  })
}
