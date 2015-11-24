if (!exists("munger")) { munger <- new.env(parent=base) }
with(munger, {

  process_dimension_set <- function(dimension) {
    df <- read_dimensions_csv(dimension)
    df <- select(df, V1); colnames(df) <- c('key')

    if (dimension == 'age_group') {
      df$name <- gsub("_", " - ", df$key)
      groups_with_words <- grepl('[[:alpha:]]', df$name)
      df$name[groups_with_words] <- sapply(df$name[groups_with_words], function(raw_name) {
        digit_index <- regexpr('[[:digit:]]', raw_name)
        word <- paste(toupper(substr(raw_name, 1, 1)), substr(raw_name, 2, digit_index - 1), sep = "")
        digit <- substr(raw_name, digit_index, nchar(raw_name))
        paste(word, digit)
      })
    } else {
      df$name <- gsub("_", " ", df$key)
    }
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