
# covid19cvdata

<!-- badges: start -->

<!-- badges: end -->

The goal of covid19cvdata package is to provide datasets of Covid19 Cases in Cabo Verde, although the public entities only provided dashboards (the sad part) it was possible to extract the data from them and organize them in A Tidy format for the COVID-19 datasets.
Mantainer [Marovski](https://github.com/marovski).

* `covid19cv` - For each date since the first case, containing the nacionality, the sex, the type of case and other categories.

+ `covid19cv_nacional` - The number of cases by type for each date since the first case

* `covid19cv_concelhos` - The number of cases by type for each province/region of Cabo Verde for each date since the first case

* `covid19cv_pop` - The number of cases for each type (recovered,death,confirmed,ative,etc)by age group and sex



### Installation

You can install the most recent version of covid19cvdata from [Github](https://github.com/marovski/covid19cvdata) with:

``` r
devtools::install.github("covid19cvdata")
```

### Data Update

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

missing...

### Data Sources

* Public Website [covid19.cv](www.covid19.cv) with information about covid19 coordenated by Institute of Nacional Public Health of Cabo Verde.

### Credits

+ covid19-dash by [João Silva](https://rpubs.com/joaosilva/covid19-dash): Thanks to João work and [post](https://www.linkedin.com/posts/antonio-joao_rpubs-covid-19-dashboard-activity-6647282965627850752-LvFd) I've came in contact with flexdashboard and how to build interesting dashboard. This inspired me to build something focus in Cabo Verde and Africa.

* Italy Covid19 by [Rami Krispin](https://ramikrispin.github.io/italy_dash/#about): This project was a bible to learn how to build datasets package and follow the tidy standart format applied by his project [Covid19R](https://covid19r.github.io/documentation/index.html). Thank You!

* Tutorial on [R-bloggers](https://www.r-bloggers.com/creating-a-package-for-your-data-set/)

+ [R Packages](http://r-pkgs.had.co.nz/) Book Site 



-------------------
Please note that the 'covid19cvdata' project is released with a [Contributor Code of Conduct](.github/CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.
