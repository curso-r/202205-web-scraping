u <- "https://realpython.github.io/fake-jobs/"
r <- httr::GET(u)
h <- xml2::read_html(r)

links <- h |>
  xml2::xml_find_all("//footer[@class='card-footer']/a") |>
  xml2::xml_attr("href") |>
  stringr::str_subset("github")


# set.seed(1)
# link <- sample(links, 1)

download_parse_link <- function(link, p) {
  p()
  r_link <- httr::GET(link)
  h_link <- xml2::read_html(r_link)
  box_link <- h_link |>
    xml2::xml_find_first("//*[@id='ResultsContainer']/div[@class='box']")

  xp <- c(
    "./h1", "./h2", ".//p[1]",
    ".//p[@id='location']",
    ".//p[@id='date']"
  )

  ## alternativa que dá trabalho
  # posicao <- xml2::xml_find_first(box_link, "./h1")
  # empresa <- xml2::xml_find_first(box_link, "./h2")
  # descricao <- xml2::xml_find_first(box_link, ".//p[1]")
  # local <- xml2::xml_find_first(box_link, ".//p[2]")
  # data <- xml2::xml_find_first(box_link".//p[3]")


  textos <- xp |>
    purrr::map(~xml2::xml_find_first(box_link, .x)) |>
    purrr::map_chr(xml2::xml_text) |>
    purrr::set_names(c(
      "posicao", "empresa",
      "descricao", "local", "data"
    )) |>
    tibble::enframe()

  textos
}

# iteracao
future::plan(future::multisession)

maybe_download_parse_link <- purrr::possibly(
  download_parse_link,
  tibble::tibble(erro = "erro")
)

progressr::with_progress({
  p <- progressr::progressor(length(links))
  dados_jobs <- furrr::future_map_dfr(
    links,
    maybe_download_parse_link,
    p = p,
    .id = "id"
  )
})

dados_jobs_tidy <- dados_jobs |>
  tidyr::pivot_wider(
    names_from = name,
    values_from = value
  ) |>
  dplyr::mutate(
    local = stringr::str_remove(local, ".+: "),
    data = stringr::str_remove(data, ".+: "),
    data = as.Date(data)
  )


