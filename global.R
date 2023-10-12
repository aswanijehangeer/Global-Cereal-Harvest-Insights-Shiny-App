# Loading Packages

library(shiny)
library(tidyverse)
library(bslib)
library(echarts4r)
library(shinycssloaders)
library(shinyWidgets)
library(shinyalert)

# Importing data set (In data/ folder)
cereal_data <- readxl::read_xlsx("data/index-of-cereal-production-yield-and-land-use.xlsx") |> 
  janitor::clean_names()
