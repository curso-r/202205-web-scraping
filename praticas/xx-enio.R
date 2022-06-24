u <- "http://186.209.101.218:8080/transparencia/leiacessoinf.aspx"

# jsonlite::read_json("output/dados_enio.json") |>
#   dput()


pegar_data <- function(data, path = "output/enio") {

  fs::dir_create(path)

  data <- format(data, "%d/%m/%Y")

  # primeiro acessa a pagina inicial
  r0 <- httr::GET(u)

  # coleta os dados da sessao
  vs <- r0 |>
    xml2::read_html() |>
    xml2::xml_find_all("//*[@name='__VIEWSTATE']") |>
    xml2::xml_attr("value")

  ev <- r0 |>
    xml2::read_html() |>
    xml2::xml_find_all("//*[@name='__EVENTVALIDATION']") |>
    xml2::xml_attr("value")

  body <- list(
    `__EVENTTARGET` = "",
    `__EVENTARGUMENT` = "",
    `__LASTFOCUS` = "",
    `__VIEWSTATE` = vs,
    `__VIEWSTATEGENERATOR` = "E0486018",
    `__VIEWSTATEENCRYPTED` = "",
    `__EVENTVALIDATION` = ev,
    `ctl00$ContentPlaceHolder1$ddlMesReferencia` = data,
    `ctl00$ContentPlaceHolder1$TipoPesq` = "rbPesqPorNome",
    `ctl00$ContentPlaceHolder1$txtPesqNome` = "",
    `ctl00$ContentPlaceHolder1$btnPesquisar` = "Pesquisar"
  )


  # primeira pagina
  r <- httr::POST(
    u, body = body,
    encode = "form",
    httr::write_disk(paste0(path, "/pagina_inicial.html"), TRUE)
  )

  # digamos que a gente consiga calcular o numero de paginas
  n_pags <- 10


  r_anterior <- r

  for(pag in 1:n_pags) {

    vs <- r_anterior |>
      xml2::read_html() |>
      xml2::xml_find_all("//*[@name='__VIEWSTATE']") |>
      xml2::xml_attr("value")

    ev <- r_anterior |>
      xml2::read_html() |>
      xml2::xml_find_all("//*[@name='__EVENTVALIDATION']") |>
      xml2::xml_attr("value")

    body_pag <- list(
      `__EVENTTARGET` = "ctl00$ContentPlaceHolder1$gvFuncionarios",
      `__EVENTARGUMENT` = paste0("Page$", pag),
      `__VIEWSTATE` = vs,
      `__VIEWSTATEGENERATOR` = "E0486018",
      `__VIEWSTATEENCRYPTED` = "",
      `__EVENTVALIDATION` = ev
    )

    f <- glue::glue("{path}/enio_pag_{pag}.html")

    r_anterior <- httr::POST(
      u,
      body = body_pag,
      encode = "form",
      httr::write_disk(f, TRUE)
    )

  }

}


pegar_data(as.Date("2022-04-01"), path = "output/enio")



format(as.Date("2022-04-01"), "%d/%m/%Y")

fs::dir_ls("output/resultados")





vs <- r |>
  xml2::read_html() |>
  xml2::xml_find_all("//*[@name='__VIEWSTATE']") |>
  xml2::xml_attr("value")

ev <- r |>
  xml2::read_html() |>
  xml2::xml_find_all("//*[@name='__EVENTVALIDATION']") |>
  xml2::xml_attr("value")

# fazer uma funcao
pag <- 2
body_pag <- list(
  `__EVENTTARGET` = "ctl00$ContentPlaceHolder1$gvFuncionarios",
  `__EVENTARGUMENT` = paste0("Page$", pag),
  `__VIEWSTATE` = vs,
  `__VIEWSTATEGENERATOR` = "E0486018",
  `__VIEWSTATEENCRYPTED` = "",
  `__EVENTVALIDATION` = ev
)

httr::POST(
  u,
  body = body_pag,
  encode = "form",
  httr::write_disk("output/enio_pag2.html", TRUE)
)





