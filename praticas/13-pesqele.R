u_pesqele <- "https://rseis.shinyapps.io/pesqEle/"

# é dinamico mesmo ;(
httr::GET(u_pesqele, httr::write_disk("output/pesqele.html"))

library(webdriver)

pjs <- run_phantomjs()
ses <- Session$new(port = pjs$port)


ses$go(u_pesqele)
ses$takeScreenshot()

elems <- ses$findElements(xpath = "//*[@class='info-box-number']")

elems[[1]]$getText()
numeros <- purrr::map_chr(elems, ~.x$getText())
numeros

# agora vamos filtrar a base para obter os números novamente

radio <- ses$findElement(xpath = "/html/body/div[1]/aside/section/ul/div[1]/div/div[3]/label/input")
radio$click()
ses$takeScreenshot()

elems <- ses$findElements(xpath = "//*[@class='info-box-number']")
numeros <- purrr::map_chr(elems, ~.x$getText())
numeros

html <- ses$getSource()
readr::write_file(html, "output/pesqele_completo.html")
xml2::read_html("output/pesqele_completo.html") |>
  xml2::xml_find_all("//*[@class='info-box-number']") |>
  xml2::xml_text()


# baixar uma tabela -------------------------------------------------------

# radio <- ses$findElement(xpath = "/html/body/div[1]/aside/section/ul/div[1]/div/div[1]/label/input")
# radio$click()
# ses$takeScreenshot()

elem <- ses$findElement(xpath = "//a[@data-value='empresas']")
elem$click()
ses$takeScreenshot()

lista <- ses$findElement(xpath = "//select[@name='DataTables_Table_0_length']/option[@value='100']")
lista$click()

html <- ses$getSource()
readr::write_file(html, "output/pesqele_empresas_pag1.html")

pagina_2 <- ses$findElement(xpath = "/html/body/div[1]/div/section/div[2]/div[3]/div/div/div/div/div[1]/div/div/div/div[5]/span/a[2]")
pagina_2$click()

html <- ses$getSource()
readr::write_file(html, "output/pesqele_empresas_pag2.html")


# parse -------------------------------------------------------------------

arquivo <- "output/pesqele_empresas_pag2.html"

parse_pagina <- function(arquivo) {
  arquivo |>
    xml2::read_html() |>
    rvest::html_table() |>
    dplyr::first() |>
    janitor::clean_names()
}

arquivos <- c("output/pesqele_empresas_pag1.html",
              "output/pesqele_empresas_pag2.html")

dados <- purrr::map_dfr(arquivos, parse_pagina)

ses$delete()
