baixar_pag <- function(pag, ementa, path) {

  u_inicial <- "https://pje-jurisprudencia.tjpb.jus.br/"

  r0 <- httr::GET(u_inicial)

  token <- r0 |>
    xml2::read_html() |>
    xml2::xml_find_all("//meta[@name='_token']") |>
    xml2::xml_attr("content")


  u_tjpb <- "https://pje-jurisprudencia.tjpb.jus.br/api/jurisprudencia/pesquisar"

  body <- list(
    `_token` = token,
    jurisprudencia = list(
      decisoes = FALSE, dt_fim = "", dt_inicio = "", ementa = ementa,
      id_classe_judicial = "", id_orgao_julgador = "", id_origem = "2,3,4",
      id_relator = "", nr_rocesso = "", teor = ""
    ),
    page = pag
  )

  f <- glue::glue("{path}/tjpb_pagina{pag}.json")

  r <- httr::POST(
    u_tjpb, body = body, encode = "json",
    httr::write_disk(f, TRUE)
  )

  f
}

purrr::walk(1:10, baixar_pag, "acordam", "output/tjpb_acordam/")

parse_tjpb <- function(file) {
  dados <- jsonlite::read_json(file, simplifyDataFrame = TRUE) |>
    purrr::pluck("hits") |>
    tibble::as_tibble() |>
    janitor::clean_names() |>
    dplyr::mutate(
      link = stringr::str_glue("https://pje-jurisprudencia.tjpb.jus.br/jurisprudencia/view/{id}?words=acordam")
    )

  dados
}


fs::dir_ls("output/tjpb_acordam/") |>
  purrr::map_dfr(parse_tjpb)



dados$link[1] |>
  browseURL()

