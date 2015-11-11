source('lib/munger.R', chdir=TRUE)

munger$process_all_dimension_sets()
munger$process_emissions_sets()
munger$process_energy_sets()