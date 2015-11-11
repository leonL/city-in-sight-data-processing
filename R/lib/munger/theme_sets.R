if (!exists("munger")) { munger <- new.env(parent=base) }
with(munger, {

  process_emissions_details_set <- function() {
    theme <- 'Emissions'; filename <- 'emissionsDetailed.csv'
    df <- process_dimension_cols(theme, filename)
    df[['scope']] <- gsub("Scope_", "", df[['scope']]) %>% as.integer()
    write_theme_csv(df, theme, filename)
    NULL
  }

  process_energy_details_set <- function() {
    theme <- 'Energy'; filename <- 'energyDetailed.csv'
    df <- process_dimension_cols(theme, filename)
    write_theme_csv(df, theme, filename)
    NULL
  }

  process_energy_by_end_use_set <- function() {
    theme <- 'Energy'; filename <- 'energyByEndUse.csv'
    df <- process_dimension_cols(theme, filename, c('end_use', 'fuel_type'))
    write_theme_csv(df, theme, filename)
    NULL
  }

  process_dimension_cols <- function(theme, filename, dimensions = c('sector', 'fuel_type')) {
    df <- read_theme_csv(theme, filename)
    for (dimension in dimensions) {
      df <- replace_dimension_col_with_id_col(df, dimension, dimension_sets[[dimension]][['key']])
    }
    return(df)
  }

  replace_dimension_col_with_id_col <- function(df, dimension, dimension_levels) {
    dim_id <- paste(dimension, 'ID', sep = '')
    dim_key <- dimension_keys[[dimension]]
    df[[dim_id]] <-
      factor(df[[dim_key]], dimension_levels) %>% as.integer()
    df <- df[, names(df) != dim_key]
    return(df)
  }

  copy_theme_set <- function(theme, filename) {
    df <- read_theme_csv(theme, filename)
    write_theme_csv(df, theme, filename)
    return(NULL)
  }

})