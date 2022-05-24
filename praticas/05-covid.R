

library(tidyverse)
library(httr)

r <- GET("https://covid.saude.gov.br/")
content(r, "text")

link_arquivo_rar <- "https://mobileapps.saude.gov.br/esus-vepi/files/unAFkcaNDeXajurGB7LChj8SgQYS2ptm/94a39d4ea2f6ff9364655a8ce447c5be_HIST_PAINEL_COVIDBR_16mai2022.rar"
r_rar <- GET(
  link_arquivo_rar,
  write_disk("output/dados_covid.rar")
)


# automatizar a descoberta do link ----------------------------------------

u_portal_geral <- "https://qd28tcd6b5.execute-api.sa-east-1.amazonaws.com/prod/PortalGeral"
r_portal_geral <- GET(u_portal_geral, httr::accept_json())

content(r_portal_geral)


r_portal_geral <- GET(
  u_portal_geral,
  add_headers("x-parse-application-id" = "unAFkcaNDeXajurGB7LChj8SgQYS2ptm")
)

link_arquivo_rar <- content(r_portal_geral) |>
  pluck("results", 1, "arquivo", "url")

r_rar <- GET(
  link_arquivo_rar,
  write_disk("output/dados_covid.rar", overwrite = TRUE)
)


# descobrindo o x-parse-application-id ------------------------------------

u_javascript <- "https://covid.saude.gov.br/main-es2015.js"
r_javascript <- GET(u_javascript)

codigo <- r_javascript |>
  content("text", encoding = "UTF-8") |>
  str_extract("(?<=PARSE_APP_ID = ')[^']+")

r_portal_geral <- GET(
  u_portal_geral,
  add_headers("x-parse-application-id" = codigo)
)

link_arquivo_rar <- content(r_portal_geral) |>
  pluck("results", 1, "arquivo", "url")

r_rar <- GET(
  link_arquivo_rar,
  write_disk("output/dados_covid.rar", overwrite = TRUE)
)

