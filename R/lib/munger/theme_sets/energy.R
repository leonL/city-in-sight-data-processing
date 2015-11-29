if (!exists("munger")) { munger <- new.env(parent=base) }
with(munger, {

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

  process_energy_sankey <- function() {
    theme <- 'Energy'; filename <- 'energySankey'
    df <- process_sankey_target_and_source_cols(theme, filename)
    df <- rename(df, scenario_id = scenarioID, year = time, total = Values)
    write_theme_csv(df, theme, filename)
    NULL
  }

  process_sankey_target_and_source_cols <- function(theme, filename) {
    df <- read_theme_csv(theme, filename)
    df <- filter(df, source != target)
    df <-  mutate(df, target_type = unlist(dimension_keys_inverted[target_type], use.names = FALSE),
                      source_type = unlist(dimension_keys_inverted[source_type], use.names = FALSE))
    for (key in dimension_keys_inverted) {
      print(key)
      lookup_table <- dim_key_id_lookup_tables()[[key]]
      source_rows <- df$source_type == key
      target_rows <- df$target_type == key
      df$source_id[source_rows] <- lookup_table[df$source[source_rows]]
      df$target_id[target_rows] <- lookup_table[df$target[target_rows]]
    }
    df <- select(df, -c(source, target))
    return(df)
  }
})