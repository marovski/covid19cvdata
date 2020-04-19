
# covid19cvdata

<!-- badges: start -->

[![R build status](https://github.com/marovski/covid-19-cabo-verde-data/workflows/R-CMD-check/badge.svg)](https://github.com/marovski/covid-19-cabo-verde-data/actions)
<!-- badges: end -->

The goal of covid19cvdata package is to provide datasets of Covid19 Cases in Cabo Verde, although the public entities only provided dashboards (the sad part) it was possible to extract the data from them and organize them in A Tidy format for the COVID-19 datasets.
Mantainer [Marovski](https://github.com/marovski).

* `covid19cv` - For each date since the first case, containing the nacionality, the sex, the type of case and other categories.

+ `covid19cv_nacional` - The number of cases by type for each date since the first case

* `covid19cv_cidades` - The number of cases by type for each city of Cabo Verde for each date since the first case

* `covid19cv_pop` - The number of cases for each type (recovered,death,confirmed,ative,etc)by age group and sex



## Installation

You can install the most recent version of covid19cvdata from [Github](https://github.com/marovski/covid19cvdata) with:

``` r
devtools::install.github("covid19cvdata")
```

## Data Update

This is a basic example which shows you how to update the installed package datasets

``` r
library(covid19cvdata)

data.update()

```

### How to Use

This is a basic example which shows you how to use the data

```{r} 
data("covid19cv")


```
### Data Dictionary



### Data Sources

*Public Website [covid19.cv](www.covid19.cv) with information about covid19 coordenated by Instituto Nacional de Saúde Pública de Cabo Verde.

### Credits

* Italy Covid19 by [Rami Krispin](https://ramikrispin.github.io/italy_dash/#about): This project was a bible to learn how to building flexdashboard package and follow the tidy standart format applied. Thank You!
+ covid19-dash by [João Silva](https://rpubs.com/joaosilva/covid19-dash): By the publication of João I got in touch with beautiful

-------------------
Please note that the 'covid19cvdata' project is released with a [Contributor Code of Conduct](.github/CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.
