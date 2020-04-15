
library(dplyr, warn.conflicts = FALSE)
library(RJSONIO)
library(tidyr)
library(usethis)

#read csv file
covid19cv <-
  read.csv("~/covid19cvdata/data-raw/cvcovid_12_04_2020_raw.csv")

# Generate age range
covid19cv$grupo_etario <- cut(as.numeric(covid19cv$FaixaEtaria), seq(0, 100, 10))
covid19cv$grupo_etario <- chartr("(", "[", covid19cv$grupo_etario)
covid19cv$grupo_etario <- as.factor(covid19cv$grupo_etario)

#Convert to appropriate format
covid19cv$Data<-as.Date(covid19cv$Data, format="%m/%d/%y")
covid19cv$TipoTransmissao <- as.factor(covid19cv$TipoTransmissao)
covid19cv$Sexo <- as.factor(covid19cv$Sexo)
covid19cv$TipoCaso <- as.factor(covid19cv$TipoCaso)
covid19cv$Data<-as.Date(covid19cv$Data, format="%d/%m/%Y")


# Change Column Name
names(covid19cv)[1] <- "data"
names(covid19cv)[2] <- "nacionalidade"
names(covid19cv)[3] <- "faixa_etaria"
names(covid19cv)[4] <- tolower(names(covid19cv)[4])
names(covid19cv)[5] <- "tipo_caso"
names(covid19cv)[6] <- "tipo_transmissao"
names(covid19cv)[7] <- tolower(names(covid19cv)[7])

#get island
covid19cv$ilha <- lapply(covid19cv$local, get.ilha)
covid19cv$ilha <- gsub("Pa", "ST", covid19cv$ilha)
covid19cv$ilha <- as.factor(covid19cv$ilha)

#Set Cities
covid19cv$local <- gsub("Boa Vista", "Sal Rei", covid19cv$local)
covid19cv$local <- gsub("São Vicente", "Mindelo", covid19cv$local)
names(covid19cv)[7] <- "cidade"
covid19cv$cidade <- as.factor(covid19cv$cidade)

#Get lat and Long from Cities
covid19cv <- get.geocode(covid19cv, "cidade")

covid19cv$lat <- as.numeric(covid19cv$lat)
covid19cv$long <- as.numeric(covid19cv$long)


write.csv(covid19cv, "data-raw/covid19cv.csv")
usethis::use_data(covid19cv, overwrite = TRUE)



