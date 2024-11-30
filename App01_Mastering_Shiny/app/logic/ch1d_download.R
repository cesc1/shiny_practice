download <- function(name) {
  
  url <- "https://raw.github.com/hadley/mastering-shiny/main/neiss/"
  download.file(paste0(url, name), paste0("app/data/", name), quiet = TRUE)
}

download_files <- function() {
  download("injuries.tsv.gz")
  download("population.tsv")
  download("products.tsv")
}
