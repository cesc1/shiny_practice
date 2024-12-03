box::use(
  bslib[bs_theme, bs_add_rules],
  sass[sass_file],
)

#' @export
my_theme <- bslib::bs_theme(primary = "#FF6622") |> 
  bslib::bs_add_rules(sass::sass_file("app/styles/main.scss"))
