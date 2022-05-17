
library(httr)

u_base <- "https://mananciais.sabesp.com.br/api/Mananciais/ResumoSistemas/"
data_consulta <- "2022-05-09"

u_sabesp <- paste0(u_base, data_consulta)

r_sabesp <- GET(u_sabesp)

resultados <- r_sabesp |>
  content(simplifyDataFrame = TRUE)

# pluck!
x <- list(a = 2, b = list(c = 4))
purrr::pluck(x, "b", "c")
purrr::pluck(x, "b")
purrr::pluck(x, "a")
x |>
  purrr::pluck("b", "c")

# forma equivalente
x$b$c

da_sabesp <- resultados |>
  purrr::pluck("ReturnObj", "sistemas") |>
  janitor::clean_names() |>
  tibble::as_tibble()

## outra alternativa
# resultados$ReturnObj$sistemas


# outro dia ---------------------------------------------------------------

data_consulta <- "2022-05-08"
u_sabesp <- paste0(u_base, data_consulta)
r_sabesp <- GET(u_sabesp)

resultados <- r_sabesp |>
  content(simplifyDataFrame = TRUE)

da_sabesp <- resultados |>
  purrr::pluck("ReturnObj", "sistemas") |>
  janitor::clean_names() |>
  tibble::as_tibble()

da_sabesp

baixar_dia <- function(dia) {
  u_sabesp <- paste0(u_base, dia)
  r_sabesp <- GET(u_sabesp)
  resultados <- r_sabesp |>
    content(simplifyDataFrame = TRUE)
  da_sabesp <- resultados |>
    purrr::pluck("ReturnObj", "sistemas") |>
    janitor::clean_names() |>
    tibble::as_tibble()
  da_sabesp
}

baixar_dia(Sys.Date()-3)



