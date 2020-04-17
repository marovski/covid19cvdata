#' @keywords covid19cvdata
"_PACKAGE"
NULL

#' Overall Summary of Covid19 Cases in Cabo Verde.
#'
#' Dataset extracted from public source and organized by date of confirmed case of covid19
#'
#' @source Public government website-covid19.cv
#' @format A data frame with eleven variables: \code{data}, \code{nacionalidade},
#'   \code{faixa_etaria}, \code{sexo} , \code{tipo_caso},\code{tipo_transmissao},
#'   \code{cidade}, \code{grupo_etario},\code{ilha},\code{long},\code{lat}
#'
"covid19cv"

#' Daily Summuray of Covid19 cases in Cabo Verde.
#'
#' Dataset organized with type of cases by date
#'
#' @source Public government website-covid19.cv
#' @format A data.frame object with eleven variables: \code{Data}, \code{recuperados},
#'   \code{obitos}, \code{evacuados} , \code{confirmados}
#'
"covid19cv_nacional"

#' Data from Covid19 by cities in Cabo Verde.
#'
#' Dataset organized with type of cases by cities
#'
#' @source Public government website-covid19.cv
#' @format A data.frame with eleven variables: \code{Data}, \code{cidade},
#'   \code{lat}, \code{long} , \code{ilha},\code{recuperados},\code{obitos},
#'   \code{evacuados},\code{confirmados},\code{confirmados_acumulados},\code{c_ativos_acumulados}
#'
"covid19cv_cidades"

#' Demographics Data of Covid19 Case in Cabo Verde.
#'
#' Dataset organized with type of cases by age group and sex
#'
#' @source Public government website-covid19.cv
#' @format A data.frame with eleven variables: \code{grupo_etario}, \code{sexo},
#'   \code{recuperados}, \code{obitos} , \code{evacuados},\code{confirmados},\code{confirmados_ativos}
#'
"covid19cv_pop"
