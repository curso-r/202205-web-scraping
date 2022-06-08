library(tidyverse)
library(httr)
library(rvest)

u_tjsp <- "https://esaj.tjsp.jus.br/cjsg/resultadoCompleta.do"

b_tjsp <- list(
  dados.buscaInteiroTeor = "coronavirus",
  dados.origensSelecionadas = "T"
)

r_tjsp <- POST(u_tjsp, body = b_tjsp)

# muitas vezes precisa disso aqui
r_tjsp <- POST(u_tjsp, body = b_tjsp, encode = "form")

u_tjsp_pag <- "https://esaj.tjsp.jus.br/cjsg/trocaDePagina.do"
q_tjsp_pag <- list(tipoDeDecisao = "A", pagina = 1, conversationId = "")
r_tjsp_pag <- GET(u_tjsp_pag, query = q_tjsp_pag,
                  httr::write_disk("output/tjsp_pag1.html"))

# jurimetria --> raspadores

trs <- r_tjsp_pag |>
  read_html() |>
  xml_find_all("//tr[@class='fundocinza1']")


arrumar_processo <- function(tr) {
  base_completa <- tr |>
    xml_find_first(".//table") |>
    html_table() |>
    mutate(X1 = str_squish(X1)) |>
    select(-X2)

  processo <- base_completa |>
    slice(1) |>
    mutate(processo = str_extract(X1, "[^ ]+")) |>
    pull(processo)

  dados <- base_completa |>
    slice(-1) |>
    separate(X1, c("name", "value"), sep = ": ", extra = "merge") |>
    pivot_wider(names_from = name, values_from = value) |>
    janitor::clean_names() |>
    mutate(id_processo = processo, .before = 1)
}

dados_completos <- purrr::map_dfr(trs, arrumar_processo)



# TJSP package ------------------------------------------------------------

# remotes::install_github("jjesusfilho/tjsp")

tjsp::baixar_cjsg("coronavirus",
                  diretorio = "output/cjsg", n = 3)

fs::dir_ls("output/cjsg") |>
  tjsp::tjsp_ler_cjsg()
