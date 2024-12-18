box::use(
  dplyr[across, everything, filter, mutate],
  stringr[str_detect],
  vroom[col_character, cols, vroom],
)


# Data source
url <- "https://saturn-public-data.s3.us-east-2.amazonaws.com/pet-names/seattle_pet_licenses.csv"

# Download
raw_data <- url |>
  vroom(
    col_types = cols(.default = col_character()),
    col_select = c(name = `Animal's Name`,
                   species = `Species`)
  )

# Transform
data <- raw_data |>
  mutate(across(everything(), ~ tolower(.x))) |>
  filter(
    !is.na(name),
    !is.na(species),
    name != "",
    !str_detect(name, "[^\\.-[a-zA-Z]]"),
    species %in% c("cat", "dog")
  )

saveRDS(data, "app/data/pet_data.rds")
