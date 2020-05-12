#' Method to add new data
#'
#' This function allows to insert new row
#' @param x for dataframe
#' @return the altered dataframe
#' @examples
#' \dontrun{
#' insert.case(covid19cv)
#' }
#'
#' @export
insert.case <- function(x) {
  nrow = nrow(x)
  ncol = ncol(x)
  count <- 1
  nrow <- nrow + 1
  while (count <= ncol) {
    x[nrow, count] <-
      readline(prompt = glue::str_glue('Please enter the "{colnames(x[count])}" value: '))

    count <- count + 1

  }
  return(x)
}
#' Method to extract siglum
#'
#' This function allows to extract the island siglum
#' @param l for dataframe specific column
#' @keywords get.ilha
#' @return the altered dataframe
#' @examples
#' \dontrun{
#' lapply(covid19cv$local,get.ilha)
#' }
#'
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
#' @param place argument to specify if this island or city (chr)
#' @keywords get.geocode
#' @return the altered dataframe with long and lat columns
#' @examples
#' \dontrun{
#' get.geocode(covid19cv,covid19cv$concelho)
#' }
#' @export
get.geocode <- function(x, place) {
  nrow <- nrow(x)
  counter <- 1
  x$long[counter] <- 0
  x$lat[counter] <- 0

  while (counter <= nrow) {
    CityName <-
      gsub(' ', '%20', x[[place]][counter]) #remove space for URLs

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

    if (url != "") {

      y <- RJSONIO::fromJSON(url)

      if (is.vector(y)) {

        x$long[counter]  <- y[[1]]$lon
        x$lat[counter]  <- y[[1]]$lat

      }
    } else{

      print("No able to find lat & long")

      return(x)

    }

    counter <- counter + 1

  }
  print("Got lat and long!")
  return (x)
}

#' Reverse lat and long into island long name
#'
#' This function allows to extract the island name with reverse geocode
#' @param x for the dataframe
#' @keywords geo.reverse
#' @return the altered dataframe with island name
#' @examples
#' \dontrun{
#' geo.reverse(covid19cv)
#' }
#'
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

#' Update the Package datasets
#'
#' This function allows to update the datasets by comparing the changes in csv file
#'
#' @keywords data.update()
#' @examples
#' \dontrun{
#' data.update()
#' }
#' @export
data.update <- function() {
  flag <- FALSE

  `%>%` <- magrittr::`%>%`

  #Loading the current version
  cv_current <- covid19cvdata::covid19cv

  #Loading the csv version
  covid19cv <-
    utils::read.csv(
      "./data-raw/csv/cvcovid19_raw.csv",
      stringsAsFactors = FALSE
    )

  covid19cv$Data <- as.Date(covid19cv$Data, format = "%m/%d/%y")

  covid19cv <- covid19cv %>% dplyr::arrange(Data)

  # Testing if there is a change in the data

  if (identical(cv_current, covid19cv)) {
    print("No updates available")
  } else {
    if (nrow(cv_current) != nrow(covid19cv)) {
      print("The number of rows in the package dataset is lower than the one in the current version")
      flag <- TRUE
    }

    if (min(cv_current$data) != min(covid19cv$Data)) {
      print("The start date of the new dataset is not match the one in the current version")
      flag <- TRUE
    }

  }
  #Check if user want updates

  if (flag) {
    x <-
      base::tolower(base::print("Updates are available. Starting process "))

    base::tryCatch(
      expr = {
        # save and commit
        print("Starting update....")
        #read csv file
        covid19cv <-
          utils::read.csv(
            "./data-raw/csv/cvcovid19_raw.csv",
            stringsAsFactors = FALSE
          )

        # Generate age range
        covid19cv$grupo_etario <-
          cut(as.numeric(covid19cv$FaixaEtaria), seq(0, 100, 10),right = FALSE)
        covid19cv$grupo_etario <-
          chartr(")", "[", covid19cv$grupo_etario)
        covid19cv$grupo_etario <-
          as.factor(covid19cv$grupo_etario)

        #Deleting column due to unaccurate data
        covid19cv$FaixaEtaria <- NULL

        #Convert to appropriate format
        covid19cv$Data <-
          as.Date(covid19cv$Data, format = "%m/%d/%y")
        covid19cv$TipoTransmissao <-
          as.factor(covid19cv$TipoTransmissao)
        covid19cv$Sexo <- as.factor(covid19cv$Sexo)
        covid19cv$TipoCaso <- as.factor(covid19cv$TipoCaso)


        # Change Column Name
        colnames(covid19cv) <- tolower(colnames(covid19cv))


        names(covid19cv)[4] <- "tipo_caso"
        names(covid19cv)[5] <- "tipo_transmissao"


        #get island
        covid19cv$ilha <- lapply(covid19cv$local, get.ilha)
        covid19cv$ilha <-stringr::str_replace_all(covid19cv$ilha, c("Pa"= "ST", "Ta"="ST","SD"="ST"))
        covid19cv$ilha <- as.factor(covid19cv$ilha)

        names(covid19cv)[6] <- "concelho"
        covid19cv$concelho <- as.factor(covid19cv$concelho)

        #Get lat and Long from Cities
        covid19cv <- get.geocode(covid19cv, "concelho")

        covid19cv$lat <- as.numeric(covid19cv$lat)
        covid19cv$long <- as.numeric(covid19cv$long)


        covid19cv_nacional <- covid19cv %>%
          #Complete missing dates
          dplyr::mutate(Data = as.Date(data)) %>%
          tidyr::complete(Data = seq.Date(min(Data), Sys.Date(), by =
                                            "day")) %>%
          dplyr::group_by(Data) %>%
          #summarise all values by case type
          dplyr::summarise(
            recuperados = sum(tipo_caso == "recuperado"),
            obitos = sum(tipo_caso == "obito"),
            evacuados = sum(tipo_caso == "evacuado"),
            confirmados = sum(tipo_caso == "confirmado")
          )
        #Clean NA
        covid19cv_nacional[is.na(covid19cv_nacional)] <- 0

        #Cumulative Positive Cases
        covid19cv_nacional$confirmados_acumulados <-
          cumsum(covid19cv_nacional$confirmados)

        #Ative Positive Cases
        covid19cv_nacional$confirmados_ativos <-
          cumsum(
            covid19cv_nacional$confirmados - covid19cv_nacional$obitos - covid19cv_nacional$recuperados -
              covid19cv_nacional$evacuados
          )
        #get cases by cities
        covid19cv_concelhos <-
          covid19cv %>%  dplyr::mutate(Data = as.Date(data)) %>%
          tidyr::complete(Data = seq.Date(min(Data), Sys.Date(), by =
                                            "day"), concelho) %>%
          dplyr::group_by(Data, concelho) %>%
          #summarise all values by case type
          dplyr::summarise(
            recuperados = sum(tipo_caso == "recuperado"),
            obitos = sum(tipo_caso == "obito"),
            evacuados = sum(tipo_caso == "evacuado"),
            confirmados = sum(tipo_caso == "confirmado")
          )

        #Clean NA
        covid19cv_concelhos[is.na(covid19cv_concelhos)] <- 0

        #Cummulative cases for each cities by date
        covid19cv_concelhos <-
          covid19cv_concelhos %>% dplyr::group_by(concelho) %>% dplyr::mutate(confirmados_acumulados =
                                                                                cumsum(confirmados))

        #Ative positive cases
        covid19cv_concelhos <-
          covid19cv_concelhos %>% dplyr::group_by(concelho) %>% dplyr::mutate(c_ativos_acumulados =
                                                                                cumsum(confirmados - recuperados - obitos - evacuados))

        #Get lat & long
        x <- covid19cv %>% dplyr::select(concelho, lat, long, ilha)
        x <- unique(x)

        covid19cv_concelhos <-
          dplyr::left_join(covid19cv_concelhos, x, by = "concelho")
        covid19cv_concelhos <-
          covid19cv_concelhos[, c(1, 2, 9, 10, 11, 3, 4, 5, 6, 7, 8)]


        #get cases by demographics
        covid19cv_pop <- covid19cv %>%
          dplyr::group_by(grupo_etario, sexo) %>%
          #summarise all values by case type
          dplyr::summarise(
            recuperados = sum(tipo_caso == "recuperado"),
            obitos = sum(tipo_caso == "obito"),
            evacuados = sum(tipo_caso == "evacuado"),
            confirmados = sum(tipo_caso == "confirmado")
          )
        #positve cases demographics
        covid19cv_pop$confirmados_ativos <-
          covid19cv_pop$confirmados - covid19cv_pop$obitos - covid19cv_pop$recuperados -
          covid19cv_pop$evacuados

        #set to dataframe to avoid future conflicts
        covid19cv_concelhos <- as.data.frame(covid19cv_concelhos)
        covid19cv_nacional <- as.data.frame(covid19cv_nacional)
        covid19cv_pop <- as.data.frame(covid19cv_pop)


        usethis::use_data(covid19cv, overwrite = TRUE)
        usethis::use_data(covid19cv_concelhos, overwrite = TRUE)
        usethis::use_data(covid19cv_nacional, overwrite = TRUE)
        usethis::use_data(covid19cv_pop, overwrite = TRUE)

        flag <- TRUE
        #export csv

        utils::write.csv(covid19cv, "data-raw/csv/covid19cv.csv", row.names = FALSE)

        devtools::document()
        devtools::check()
        devtools::install()


        base::message("The data was refresed, please restart your session to have the new data available")
      },
      error = function(e) {
        message('Caught an error!')
        print(e)
      },
      warning = function(w) {
        message('Caught an warning!')
        print(w)
      }

    )

  } else {
    base::message("No updates are available")
  }

}
