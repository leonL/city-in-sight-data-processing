if (!exists("munger")) { munger <- new.env(parent=base) }
with(munger, {

  process_population_by_age_set <- function() {
    theme <- 'Demographics'; filename <- 'populationByAge'
    df <- process_dimension_cols(theme, filename, c('age_group'))
    df <- rename(df, population_context_id = popAssumptionID, year = time, total = Values)
    write_theme_csv(df, theme, filename)
    NULL
  }

  process_household_totals <- function() {
    theme <- 'Demographics'; filename <- 'householdsTotal'
    df <- read_theme_csv(theme, filename)
    df <- rename(df, population_context_id = popAssumptionID, year = time, total = Values)
    write_theme_csv(df, theme, filename)
    NULL
  }

  process_population_by_zone_set <- function() {
    theme <- 'Demographics'; filename <- 'populationByZone'
    df <- read_theme_csv(theme, filename)
    df <- rename(df, population_context_id = popAssumptionID, zone_id = zoneID, year = time, total = Values)
    write_theme_csv(df, theme, filename)
    NULL
  }

})