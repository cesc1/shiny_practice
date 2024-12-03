box::use(
  dplyr[across, everything, filter, mutate],
  stringr[str_detect, str_remove_all],
  vroom[cols, col_character, vroom],
)


# Data source
url <- "https://saturn-public-data.s3.us-east-2.amazonaws.com/pet-names/seattle_pet_licenses.csv"

# Download
raw_data <- url |> 
  vroom::vroom(
    col_types = vroom::cols(.default = vroom::col_character()),
    col_select = c(name = `Animal's Name`,
                   species = `Species`)
)

# Transform
data <- raw_data |> 
  dplyr::mutate(across(everything(), ~ tolower(.x))) |> 
  dplyr::filter(
    !is.na(name),
    !is.na(species),
    name != "",
    !stringr::str_detect(name, "[^\\.-[a-zA-Z]]"),
    species %in% c("cat", "dog")
  )

saveRDS(data, "app/data/pet_data.rds")