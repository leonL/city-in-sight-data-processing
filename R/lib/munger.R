source('base.R')
source('munger/dimension_sets.R')
source('munger/theme_sets.R')
library(dplyr)

if (!exists("munger")) { munger <- new.env(parent=base) }
with(munger, {

  dimension_sets <- list()

  process_all_dimension_sets <- function() {
    for (name in names(dimension_keys)) {
      dimension_sets[[name]] <<- process_dimension_set(name)
    }
    copy_dimension_set('scenario', header = TRUE)
  }

  process_emissions_sets <- function() {
    process_emissions_details_set()
    copy_theme_set('Emissions', 'summaryData.csv');
  }

  process_energy_sets <- function() {
    return(NULL)
  }

})