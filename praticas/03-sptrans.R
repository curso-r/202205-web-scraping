
library(tidyverse)
library(httr)

u_sptrans <- "http://api.olhovivo.sptrans.com.br/v2.1"
endpoint <- "/Posicao"

u_sptrans_busca <- paste0(u_sptrans, endpoint)

r_sptrans <- GET(u_sptrans_busca)
content(r_sptrans)

# ctrl+shift+F10 - reiniciar sessa -----------------------------------------

api_key <- Sys.getenv("API_OLHO_VIVO")

u_sptrans_login <- paste0(u_sptrans, "/Login/Autenticar")
q_sptrans_login <- list(token = api_key)

r_sptrans_login <- POST(
  u_sptrans_login,
  query = q_sptrans_login
)

content(r_sptrans_login)

u_sptrans_busca <- paste0(u_sptrans, endpoint)
r_sptrans <- GET(u_sptrans_busca)

## jogar fora as informacoes sobre a sessao
# handle_reset(u_sptrans_busca)

content(r_sptrans, simplifyDataFrame = TRUE) |>
  pluck("l") |>
  tibble::as_tibble() |>
  unnest(vs) |>
  ggplot(aes(x = px, y = py)) +
  geom_point() +
  coord_fixed()





