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

})