library(shiny)
library(knitr)
library(slidify)

swd <- function(loc) {
  if (loc == "work") setwd("D:\\github\\DatProds\\Power_Demo")
  if (loc == "home") setwd("C:\\dev\\study\\R\\DatProds\\Power_Demo")
}

go <- function() {
  slidify("index.Rmd")
  browseURL("index.html")
}