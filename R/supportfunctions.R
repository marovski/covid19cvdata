#' Method to extract siglum
#'
#' This function allows to extract the island siglum
#' @param l for dataframe specific column
#' @keywords get.ilha
#' @return the altered dataframe
#' @examples
#' lapply(covid19cv$local,get.ilha)
#' @export
get.ilha <- function(l) {
  split.location <-
    tryCatch(
      paste0(substr(l, 1, 1),
             substr(l, 5, 5))

      ,

      error = function(e)
        return(c(NA, NA))
    )
  clean.location <- gsub("^ ", " ", split.location)
  if (length(clean.location) > 2) {
    return(c(NA, NA))
  }
  else {
    return(clean.location)
  }
}
#'Get lat and long of the places in Cabo Verde
#'
#' This function allows to obtain the lat and lon of places in openstreetmaps API
#' @param x for dataframe
#' @param place for the address
#' @keywords get.geocode
#' @return the altered dataframe with long and lat columns
#' @examples
#' get.geocode(covid19cv,covid19cv$cidade)
#' @export
get.geocode <- function(x, place) {
  nrow <- nrow(x)
  counter <- 1
  x$long[counter] <- 0
  x$lat[counter] <- 0

  while (counter <= nrow) {
    CityName <-
      gsub(' ', '%20', x[[place]][counter]) #remove space for URLs
    print(CityName)
    CountryCode <- "CV"
    url <- paste(
      "http://nominatim.openstreetmap.org/search?city="
      ,
      CityName
      ,
      "&countrycodes="
      ,
      CountryCode
      ,
      "&limit=9&format=json"
      ,
      sep = ""
    )


    y <- RJSONIO::fromJSON(url)


    if (is.vector(y)) {
      x$long[counter]  <- y[[1]]$lon
      x$lat[counter]  <- y[[1]]$lat
    }
    counter <- counter + 1
  }

  return (x)
}

#' Reverse lat and long into island long name
#'
#' This function allows to extract the island name with reverse geocode
#' @param x for the dataframe
#' @keywords geo.reverse
#' @return the altered dataframe with island name
#' @examples
#' geo.reverse(covid19cv)
#' @export
geo.reverse <- function(x) {
  nrow <- nrow(x)
  counter <- 1
  x$nome_ilha[counter] <- 0

  while (counter <= nrow) {
    url <-
      paste(
        "http://nominatim.openstreetmap.org/reverse?format=json&limit=9&lat=",
        x$lat,
        "&lon=" ,
        x$long,
        "&country_code=cv",
        sep = ""
      )

    print(url)

    y <- RJSONIO::fromJSON(url)

    if (is.vector(y)) {
      x$nome_ilha[counter] <- y[[1]]$county

    }
    counter <- counter + 1
  }
  return(x)
}

