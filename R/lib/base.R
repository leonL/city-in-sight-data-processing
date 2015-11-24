# Constants & Config

k <- new.env()
with(k, {

  dimension_keys <- list(
    end_use='aggStationaryEndUse',
    sector='aggSubSectorsEnr',
    fuel_type='fuelTypeAgg',
    scenario='scenarioLookup',
    age_group='ageGroup'
  )

  set_data_path <- function(municipality_name) {
    data_path <<- paste('..', 'data', municipality_name, sep = '/')
  }; data_path <- '../data/test'

  # data subpaths dynamically defined to handle intial changes to data_path (e.g. for tests)
  data_src_path <- function() {
    if (is.null(src_path)) {
      src_path <<- paste(data_path, 'source', sep = '/')
    }
    return(src_path)
  }; src_path <- NULL

  data_output_path <- function() {
    if (is.null(output_path)) {
      output_path <<- paste(data_path, 'output', sep = '/')
    }
    return(output_path)
  }; output_path <- NULL
})

# Input & Output helpers

io <- new.env(parent=k)
with(io, {

  read_dimensions_csv <- function(dimension, header = FALSE) {
    filename <- paste(dimension_keys[dimension], 'csv', sep = '.')
    file <- paste(data_src_path(), filename, sep = '/')
    flog.info("Reading %s ...", file)
    read.csv(file, header = header, skip = 4, stringsAsFactors = FALSE)
  }

  write_dimensions_csv <- function(df, dimension) {
    filename <- paste(dimension, 'csv', sep = '.')
    file <- paste(data_output_path(), filename, sep = '/')
    flog.info("Writing %s ...", file)
    write.csv(df, file = file, row.names = FALSE)
    return(NULL)
  }

  read_theme_csv <- function(theme, filename) {
    file <- paste(data_src_path(), theme, filename, sep = '/')
    file <- paste(file, 'csv', sep = '.')
    flog.info("Reading %s ...", file)
    read.csv(file, skip = 4, stringsAsFactors = FALSE)
  }

  create_theme_directory <- function(theme) {
    path <- paste(data_output_path(), theme, sep = '/')
    dir.create(path)
  }

  write_theme_csv <- function(df, theme, filename) {
    file <- paste(data_output_path(), theme, filename, sep = '/')
    file <- paste(file, 'csv', sep = '.')
    flog.info("Writing %s ...", file)
    write.csv(df, file = file, row.names = FALSE)
    return(NULL)
  }
})

# Utility functions
util <- new.env(parent=io)

# Base enviroment
base <- new.env(parent=util)

# Logging...

library(futile.logger, quietly=TRUE, warn.conflicts=FALSE)