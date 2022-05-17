library(httr)
library(jsonlite)


# cep ---------------------------------------------------------------------

u_base <- "https://brasilapi.com.br/api"
endpoint_cep <- "/cep/v2/"
cep <- "61917055"

u_cep <- paste0(u_base, endpoint_cep, cep)
r_cep <- GET(u_cep)

cep <- readline("digite o cep...")

baixar_cep <- function(cep) {
  u_base <- "https://brasilapi.com.br/api"
  endpoint_cep <- "/cep/v2/"
  u_cep <- paste0(u_base, endpoint_cep, cep)
  r_cep <- GET(u_cep)
  content(r_cep)
}

# baixar_cep("61917051")

# vamos ver como obter o resultado disso

content(r_cep)
content(r_cep, as = "text")
content(r_cep, as = "parsed")
content(r_cep, as = "raw")

jsonlite::fromJSON()
# jsonlite::read_json()

content(r_cep, as = "text") |>
  jsonlite::fromJSON(simplifyDataFrame = TRUE)


# FIPE --------------------------------------------------------------------


endpoint_fipe <- "/fipe/marcas/v1/"
tipo_veiculo <- "carros"
u_fipe <- paste0(u_base, endpoint_fipe, tipo_veiculo)

r_fipe <- GET(u_fipe)

content(r_fipe)

content(r_fipe, "text") |>
  jsonlite::fromJSON(simplifyDataFrame = TRUE)

content(r_fipe, simplifyDataFrame = TRUE) |>
  tibble::as_tibble()

# requisicoes com parâmetros

endpoint_tabelas <- "/fipe/tabelas/v1"
u_tabelas <- paste0(u_base, endpoint_tabelas)
r_tabelas <- GET(u_tabelas)

content(r_tabelas, simplifyDataFrame = TRUE) |>
  tibble::as_tibble() |>
  print(n = 900)

# agora vamos colocar essa tabela como parâmetro

u_fipe

## não precisamos fazer manualmente, mas funciona
u_fipe_parm <- paste0(u_fipe, "?tabela_referencia=", "150")
r_fipe_parm_manual <- GET(u_fipe_parm)


## esse é o jeito mais usual de colocar parâmetros
q_fipe <- list(tabela_referencia = 150)
r_fipe_parm <- GET(u_fipe, query = q_fipe)

content(r_fipe_parm, simplifyDataFrame = TRUE) |>
  tibble::as_tibble()


# pesquisar o preço de um carro na FIPE -----------------------------------

cod_carro_fipe <- "0780081"
endpoint_carro_fipe <- "/fipe/preco/v1/"
u_carro <- paste0(u_base, endpoint_carro_fipe, cod_carro_fipe)

r_carro <- GET(u_carro)
da_carro_hoje <- content(r_carro, simplifyDataFrame = TRUE) |>
  tibble::as_tibble()

q_fipe <- list(tabela_referencia = 237)

r_carro_2019 <- GET(u_carro, query = q_fipe)
da_carro_2019 <- content(r_carro_2019, simplifyDataFrame = TRUE) |>
  tibble::as_tibble()


da_carro_2019 |>
  dplyr::select(valor, anoModelo)

da_carro_hoje |>
  dplyr::select(valor, anoModelo)


#' api sem autenticacao, com documentacao

#' ->>api sem autenticacao, escondida

#' api com autenticacao, com documentacao
#' api com autenticacao, escondida
#'
#'
