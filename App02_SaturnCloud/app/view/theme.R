box::use(
  bslib[bs_add_rules, bs_theme],
  glue[glue],
  sass[sass_file],
  shiny[HTML],
)

# Load bslib basic theme and primary variable
#' @export
my_theme <- bs_theme(primary = "#FF6622") |>
  bs_add_rules(sass_file("app/styles/main.scss"))

# Font type
#' @export
font_parkinsans <- function() {
  HTML('
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href=
"https://fonts.googleapis.com/css2?family=Parkinsans:wght@300..800&display=swap"
rel="stylesheet">')
}

# Favicon
#' @export
load_favicon <- function() {
  HTML('
<link rel="icon" type="image/png" href="/favicon-96x96.png" sizes="96x96" />
<link rel="icon" type="image/svg+xml" href="/favicon.svg" />
<link rel="shortcut icon" href="/favicon.ico" />
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
<link rel="manifest" href="/site.webmanifest" />')
}

# textInput with full width
#' @export
textinput_max_width <- function(id) {
  HTML(glue('
<div class="form-group shiny-input-container w-100">
  <label class="control-label" id="{id}-label" for="{id}">Pet name</label>
  <input id="{id}" type="text" class="shiny-input-text form-control" value=""/>
</div>'))
}
