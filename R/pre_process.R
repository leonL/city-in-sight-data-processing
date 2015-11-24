source('lib/munger.R', chdir=TRUE)

if (!is.na(commandArgs(TRUE)[1])) {
  k$set_data_path(commandArgs(TRUE)[1])
}

munger$process_all_dimension_sets()
munger$process_emissions_sets()
munger$process_energy_sets()
munger$process_demographics_sets()