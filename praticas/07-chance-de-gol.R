
library(tidyverse)
library(httr)
library(rvest)

u_cdg <- "http://www.chancedegol.com.br/br21.htm"

r_cdg <- GET(u_cdg)

content(r_cdg)

# content(r_cdg, encoding = "latin1")

read_html(r_cdg, encoding = "latin1") |>
  html_element(xpath = "//table") |>
  html_table()

# equivalente, com xml2
da_bruto <- xml2::read_html(r_cdg, encoding = "latin1") |>
  xml2::xml_find_first("//table") |>
  rvest::html_table(header = TRUE)

# Continua...

da <- da_bruto |>
  janitor::clean_names() |>
  mutate(
    data = lubridate::dmy(data),
    across(
      c(vitoria_do_mandante, empate, vitoria_do_visitante),
      parse_number
    )
  ) |>
  separate(x, c("gols_mandante", "gols_visitante"), sep = "x") |>
  mutate(
    realidade = case_when(
      gols_mandante > gols_visitante ~ "Mandante",
      gols_mandante < gols_visitante ~ "Visitante",
      TRUE ~ "Empate"
    ),
    probabilidade_maxima = pmax(
      vitoria_do_mandante,
      empate,
      vitoria_do_visitante
    ),
    chute = case_when(
      probabilidade_maxima == vitoria_do_mandante ~ "Mandante",
      probabilidade_maxima == vitoria_do_visitante ~ "Visitante",
      TRUE ~ "Empate"
    )
  )

da |>
  count(chute, realidade)

da |>
  mutate(acertou = chute == realidade) |>
  count(acertou) |>
  mutate(prop = n/sum(n))



# outra alternativa: vermelho ---------------------------------------------

x <- c(1,2,3)
x[1]

vermelho <- xml2::read_html(r_cdg, encoding = "latin1") |>
  xml2::xml_find_first("//table") |>
  xml2::xml_find_all(".//font[@color='#FF0000']") |>
  xml2::xml_text()

# xml2::read_html(r_cdg, encoding = "latin1") |>
#   xml2::xml_find_first("//table") |>
#   xml2::xml_find_all(".//body")

da_bruto |>
  janitor::clean_names() |>
  mutate(verm = vermelho) |>
  mutate(
    realidade = case_when(
      verm == vitoria_do_mandante ~ "Mandante",
      verm == vitoria_do_visitante ~ "Visitante",
      TRUE ~ "Empate"
    )
  )


# exemplo extra - xpath ---------------------------------------------------

u <- "https://pt.wikipedia.org/wiki/Campeonato_Brasileiro_de_League_of_Legends"
r <- GET(u, httr::write_disk("output/exemplo_lol.html"))

library(xml2)

xp <- "/html/body/div/div/div[1]/div[3]/main/div[3]/div[3]/div[1]/table[9]"
r |>
  read_html() |>
  xml_find_all("//table[contains(@class,'wikitable sortable')]")

# html.client-js.vector-animations-ready.ve-available body.skin-vector.skin-vector-search-vue.mediawiki.ltr.sitedir-ltr.mw-hide-empty-elt.ns-0.ns-subject.mw-editable.page-Campeonato_Brasileiro_de_League_of_Legends.rootpage-Campeonato_Brasileiro_de_League_of_Legends.skin-vector-2022.action-view div.mw-page-container.vector-layout-legacy div.mw-page-container-inner div.mw-workspace-container div.mw-content-container main#content.mw-body div#bodyContent.vector-body div#mw-content-text.mw-body-content.mw-content-ltr div.mw-parser-output table.wikitable.sortable.jquery-tablesorter
# html.client-js.vector-animations-ready.ve-available body.skin-vector.skin-vector-search-vue.mediawiki.ltr.sitedir-ltr.mw-hide-empty-elt.ns-0.ns-subject.mw-editable.page-Campeonato_Brasileiro_de_League_of_Legends.rootpage-Campeonato_Brasileiro_de_League_of_Legends.skin-vector-2022.action-view div.mw-page-container.vector-layout-legacy div.mw-page-container-inner div.mw-workspace-container div.mw-content-container main#content.mw-body div#bodyContent.vector-body div#mw-content-text.mw-body-content.mw-content-ltr div.mw-parser-output table.wikitable.sortable.jquery-tablesorter
# table.wikitable:nth-child(121)

r |>
  read_html() |>
  xml_find_all(xp)

