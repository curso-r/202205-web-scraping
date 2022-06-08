library(xml2)
library(purrr)
library(httr)
# depois vamos ter mais
library(furrr)
library(progressr)


u <- "https://en.wikipedia.org/wiki/R_language"
r <- GET(u)
links <- r |>
  read_html() |>
  xml_find_all("//table[@class='infobox vevent']//a") |>
  xml_attr("href")

links <- paste0(u, links)

# uma forma de dar os nomes
basename(links)

arquivos <- paste0("output/wiki/", seq_along(links), ".html")
arquivos <- glue::glue("output/wiki/{seq_along(links)}.html")

map2(
  links, arquivos,
  ~GET(.x, write_disk(.y, TRUE))
)

get <- function(link, id_link) {
  arquivo <- paste0("output/wiki/", id_link, ".html")
  r <- GET(link, write_disk(arquivo, TRUE))
  if(r$status_code != 200) {
    stop("Deu ruim!")
  }
  arquivo
}

# equivalentes
map2(links, seq_along(links), get)
imap(links, get)

maybe_get <- purrr::possibly(get, "erro")
map2(links, seq_along(links), maybe_get)

maybe_get <- purrr::safely(get, "erro")
resultados <- map2(links, seq_along(links), maybe_get)


f_quieta <- purrr::quietly(f)
x <- f_quieta(-1)

# imap(letters, ~ paste(.x, .y))
future::plan(future::multisession, workers = 4)

# resultados <- future_map2(links, seq_along(links), maybe_get)


# progresso ---------------------------------------------------------------


maybe_get <- purrr::possibly(get, "erro")
maybe_get_progress <- function(link, id_link, p) {
  p()
  maybe_get(link, id_link)
}

progressr::with_progress({
  p <- progressr::progressor(length(links))
  furrr::future_map2(
    links, seq_along(links),
    maybe_get_progress, p = p
  )
})


# curiosidade -------------------------------------------------------------

beepr::beep(8)

library(progressr)

handlers(list(
  handler_progress()#,
  # handler_beepr(
  #   initiate = 2L,
  #   update = 1L,
  #   finish = 8L
  # )
))

progressr::with_progress({
  p <- progressr::progressor(20)
  purrr::walk(1:20, ~{
    p()
    Sys.sleep(1)
  })
})





