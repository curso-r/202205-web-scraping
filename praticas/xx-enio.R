u <- "http://186.209.101.218:8080/transparencia/leiacessoinf.aspx"

# jsonlite::read_json("output/dados_enio.json") |>
#   dput()

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
  `ctl00$ContentPlaceHolder1$ddlMesReferencia` = "01/04/2022",
  `ctl00$ContentPlaceHolder1$TipoPesq` = "rbPesqPorNome",
  `ctl00$ContentPlaceHolder1$txtPesqNome` = "",
  `ctl00$ContentPlaceHolder1$btnPesquisar` = "Pesquisar"
)

r <- httr::POST(
  u, body = body,
  encode = "form",
  httr::write_disk("output/enio.html", TRUE)
)



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
