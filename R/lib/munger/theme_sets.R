if (!exists("munger")) { munger <- new.env(parent=base) }
with(munger, {

  process_emissions_details_set <- function() {
    theme <- 'Emissions'; filename <- 'emissionsDetailed.csv'
    df <- read_theme_csv(theme, filename)
    df <- replace_dimension_col_with_id_col(df, 'sector', dimension_sets[['sector']][['key']])
    df <- replace_dimension_col_with_id_col(df, 'fuel_type', dimension_sets[['fuel_type']][['key']])
    df[['scope']] <- gsub("Scope_", "", df[['scope']]) %>% as.integer()
    write_theme_csv(df, theme, filename)
    return(NULL)
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