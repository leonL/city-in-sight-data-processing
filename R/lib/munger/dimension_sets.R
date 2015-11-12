if (!exists("munger")) { munger <- new.env(parent=base) }
with(munger, {

  process_dimension_set <- function(dimension) {
    df <- read_dimensions_csv(dimension)
    df <- select(df, V1); colnames(df) <- c('key')

    df$name <- gsub("_", " ", df$key)
    df['id'] <- 1:nrow(df)

    write_dimensions_csv(df, dimension)
    return(df)
  }

  copy_dimension_set <- function(dimension, header = FALSE) {
    df <- read_dimensions_csv(dimension, header)
    write_dimensions_csv(df, dimension)
    return(df)
  }

})