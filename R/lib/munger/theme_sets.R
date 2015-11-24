if (!exists("munger")) { munger <- new.env(parent=base) }
with(munger, {

  process_emissions_details_set <- function() {
    theme <- 'Emissions'; filename <- 'emissionsDetailed'
    df <- process_dimension_cols(theme, filename)
    df[['scope']] <- gsub("Scope_", "", df[['scope']]) %>% as.integer()
    df <- rename(df, zone_id = zoneID, scenario_id = scenarioID, year = time, total_emissions = Values)
    write_scenario_specific_csvs(df, theme, filename)
    NULL
  }

  process_energy_details_set <- function() {
    theme <- 'Energy'; filename <- 'energyDetailed'
    df <- process_dimension_cols(theme, filename)
    df <- rename(df, scenario_id = scenarioID, year = time, total = Values)
    write_scenario_specific_csvs(df, theme, filename)
    NULL
  }

  process_energy_by_end_use_set <- function() {
    theme <- 'Energy'; filename <- 'energyByEndUse'
    df <- process_dimension_cols(theme, filename, c('end_use', 'fuel_type'))
    df <- rename(df, scenario_id = scenarioID, year = time, total = Values)
    write_scenario_specific_csvs(df, theme, filename)
    NULL
  }

  process_energy_for_map_set <- function() {
    theme <- 'Energy'; filename <- 'energyForMap'
    df <- process_dimension_cols(theme, filename)
    df <- rename(df, scenario_id = scenarioID, zone_id = zoneID, year = time, total = Values)
    write_scenario_specific_csvs(df, theme, filename)
    NULL
  }

  process_population_by_zone_set <- function() {
    theme <- 'Demographics'; filename <- 'populationByZone'
    df <- read_theme_csv(theme, filename)
    df <- rename(df, population_context_id = popAssumptionID, zone_id = zoneID, year = time, total = Values)
    write_theme_csv(df, theme, filename)
    NULL
  }

  process_population_by_age_set <- function() {
    theme <- 'Demographics'; filename <- 'populationByAge'
    df <- process_dimension_cols(theme, filename, c('age_group'))
    df <- rename(df, population_context_id = popAssumptionID, year = time, total = Values)
    write_theme_csv(df, theme, filename)
    NULL
  }

  write_scenario_specific_csvs <- function(df, theme, filename) {
    print(scenario_ids)
    for (s_id in scenario_ids) {
      scenario_specific_df <- filter(df, scenario_id == s_id)
      scenario_specific_filename <- paste(filename, s_id, sep = '_')
      write_theme_csv(scenario_specific_df, theme, scenario_specific_filename)
    }
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
    dim_id <- paste(dimension, 'id', sep = '_')
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