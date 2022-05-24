
library(tidyverse)
library(httr)
library(rvest)

u_cdg <- "http://www.chancedegol.com.br/br21.htm"

r_cdg <- GET(u_cdg)

# content(r_cdg, encoding = "latin1")

read_html(r_cdg, encoding = "latin1") |>
  html_element(xpath = "//table") |>
  html_table()

# equivalente, com xml2
xml2::read_html(r_cdg, encoding = "latin1") |>
  xml2::xml_find_first("//table") |>
  rvest::html_table()

# Continua...
