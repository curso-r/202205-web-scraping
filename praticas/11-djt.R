u <- "https://dejt.jt.jus.br/dejt/f/n/diariocon"

jsonlite::read_json("output/parametros2.json") |>
  dput()

r0 <- httr::GET(u)

viewstate <- r0 |>
  xml2::read_html() |>
  xml2::xml_find_first("//input[@name='javax.faces.ViewState']") |>
  xml2::xml_attr("value")

## nao foi util agora...
# j_id <- r0 |>
#   xml2::read_html() |>
#   xml2::xml_find_first("//button[@id='corpo:formulario:botaoRecuperaUnidadePorTribunalSelecionado']") |>
#   xml2::xml_attr("onclick") |>
#   stringr::str_extract("corpo:formulario:j_id[0-9]+")

body <- list(
  `corpo:formulario:dataIni` = "24/05/2022",
  `corpo:formulario:dataFim` = "24/05/2022",
  `corpo:formulario:tipoCaderno` = "",
  `corpo:formulario:tribunal` = "5",
  `corpo:formulario:ordenacaoPlc` = "",
  navDe = "1", detCorrPlc = "",
  tabCorrPlc = "",
  detCorrPlcPaginado = "",
  exibeEdDocPlc = "",
  indExcDetPlc = "",
  org.apache.myfaces.trinidad.faces.FORM = "corpo:formulario",
  `_noJavaScript` = "false",
  javax.faces.ViewState = viewstate,
  source = "corpo:formulario:botaoAcaoPesquisar"
)

r <- httr::POST(
  u, body = body, encode = "form",
  # httr::config(ssl_verifypeer = FALSE),
  httr::write_disk("output/consulta_djt.html", TRUE)
)


# acessando o PDF ---------------------------------------------------------

j_id <- r |>
  xml2::read_html() |>
  xml2::xml_find_all("//button[@class='bt af_commandButton']") |>
  xml2::xml_attr("onclick") |>
  stringr::str_extract("(?<=source:')[^']+")

baixar_pdf <- function(j_id, viewstate) {

  num_pdf <- j_id |>
    stringr::str_extract("(?<=:)[0-9]+(?=:)")

  body_pdf <- list(
    `corpo:formulario:dataIni` = "24/05/2022",
    `corpo:formulario:dataFim` = "24/05/2022",
    `corpo:formulario:tipoCaderno` = "",
    `corpo:formulario:tribunal` = "5",
    `corpo:formulario:ordenacaoPlc` = "",
    navDe = "1",
    detCorrPlc = "",
    tabCorrPlc = "",
    detCorrPlcPaginado = "", exibeEdDocPlc = "",
    indExcDetPlc = "",
    org.apache.myfaces.trinidad.faces.FORM = "corpo:formulario",
    `_noJavaScript` = "false",
    javax.faces.ViewState = viewstate,
    source = j_id
  )
  r_pdf <- httr::POST(
    u, body = body_pdf, encode = "form",
    # httr::config(ssl_verifypeer = FALSE),
    httr::write_disk(
      glue::glue("output/diario_{num_pdf}.pdf"), TRUE
    )
  )
}

purrr::map(j_id, baixar_pdf, viewstate)


# DJT package -------------------------------------------------------------

## Não funciona :(
# remotes::install_github("courtsbr/djt")

djt::download_djt(
  2, path = "output/trt2",
  date_min =  "2022-05-24",
  date_max = "2022-05-24"
)
