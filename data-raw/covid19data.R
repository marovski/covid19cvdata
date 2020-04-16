
library(dplyr, warn.conflicts = FALSE)
library(RJSONIO)
library(tidyr)
library(usethis)
require("R/supportfunctions.R")

#read csv file 4 the first time
covid19cv <-
    read.csv("data-raw/cvcovid19_raw.csv")

# Generate age range
covid19cv$grupo_etario <- cut(as.numeric(covid19cv$FaixaEtaria), seq(0, 100, 10))
covid19cv$grupo_etario <- chartr("(", "[", covid19cv$grupo_etario)
covid19cv$grupo_etario <- as.factor(covid19cv$grupo_etario)

#Deleting column due to unaccurate data
covid19cv$FaixaEtaria<-NULL

#Convert to appropriate format
covid19cv$Data<-as.Date(covid19cv$Data, format="%m/%d/%y")
covid19cv$TipoTransmissao <- as.factor(covid19cv$TipoTransmissao)
covid19cv$Sexo <- as.factor(covid19cv$Sexo)
covid19cv$TipoCaso <- as.factor(covid19cv$TipoCaso)


# Change Column Name
colnames(covid19cv)<-tolower(colnames(covid19cv))


names(covid19cv)[4] <- "tipo_caso"
names(covid19cv)[5] <- "tipo_transmissao"


#get island
covid19cv$ilha <- lapply(covid19cv$local, get.ilha)
covid19cv$ilha <- gsub("Pa", "ST", covid19cv$ilha)
covid19cv$ilha <- as.factor(covid19cv$ilha)

#Set Cities
covid19cv$local <- gsub("Boa Vista", "Sal Rei", covid19cv$local)
covid19cv$local <- gsub("Sao Vicente", "Mindelo", covid19cv$local)
names(covid19cv)[6] <- "cidade"
covid19cv$cidade <- as.factor(covid19cv$cidade)

#Get lat and Long from Cities
covid19cv <- get.geocode(covid19cv, "cidade")

covid19cv$lat <- as.numeric(covid19cv$lat)
covid19cv$long <- as.numeric(covid19cv$long)

#export csv

write.csv(covid19cv, "data-raw/covid19cv.csv", row.names = FALSE)

usethis::use_data(covid19cv, overwrite = TRUE)



