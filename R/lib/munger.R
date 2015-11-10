source('base.R')
library(dplyr)

munger <- new.env(parent=base)
with(munger, {

  dimension_sets <- list()

  process_all_dimension_sets <- function() {
    for (name in names(dimension_keys)) {
      dimension_sets[[name]] <<- process_dimension_set(name)
    }
  }

  process_dimension_set <- function(dimension) {
    df <- read_dimensions_csv(dimension)
    df <- select(df, V1); colnames(df) <- c('key')

    df$name <- gsub("_", " ", df$key)
    df['id'] <- 1:nrow(df)

    write_dimensions_csv(df, dimension)
    return(df)
  }

  process_emissions_details_set <- function() {
    theme <- 'Emissions'; filename <- 'emissionsDetailed.csv'
    df <- read_theme_csv(theme, filename)
    df <- replace_dimension_col_with_id_col(df, 'sector')
    df <- replace_dimension_col_with_id_col(df, 'fuel_type')
    df[['scope']] <- gsub("Scope_", "", df[['scope']]) %>% as.integer()
    write_theme_csv(df, theme, filename)
  }

  replace_dimension_col_with_id_col <- function(df, dimension) {
    dim_id <- paste(dimension, 'ID', sep = '')
    dim_key <- dimension_keys[[dimension]]
    df[[dim_id]] <-
      factor(df[[dim_key]], dimension_sets[[dimension]][['key']]) %>% as.integer()
    df <- df[, names(df) != dim_key]
    return(df)
  }

})