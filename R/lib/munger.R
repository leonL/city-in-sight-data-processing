source('base.R')
source('munger/dimension_sets.R')
source('munger/theme_sets.R')
library(dplyr, quietly=TRUE, warn.conflicts=FALSE)

if (!exists("munger")) { munger <- new.env(parent=base) }
with(munger, {

  dimension_sets <- list()
  scenario_ids <- NULL

  process_all_dimension_sets <- function() {
    for (name in names(dimension_keys)) {
      dimension_sets[[name]] <<- process_dimension_set(name)
    }
    scenarios_df <- process_scenario_set()
    scenario_ids <<- scenarios_df$scenarioID
    NULL
  }

  process_emissions_sets <- function() {
    theme <- 'Emissions';
    create_theme_directory(theme)
    process_emissions_details_set()
    copy_theme_set(theme, 'summaryData')
    NULL
  }

  process_energy_sets <- function() {
    theme <- 'Energy';
    create_theme_directory(theme)
    process_energy_details_set()
    process_energy_by_end_use_set()
    process_energy_for_map_set()
    process_energy_sankey()
    copy_theme_set(theme, 'summaryData')
    NULL
  }

  process_demographics_sets <- function() {
    theme <- 'Demographics';
    create_theme_directory(theme)
    process_population_by_age_set()
    process_household_totals()
    NULL
  }
})