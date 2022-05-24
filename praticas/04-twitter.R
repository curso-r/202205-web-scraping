
library(tidyverse)
library(httr)

library(rtweet)

trends <- get_trends()
glimpse(trends)

trends |>
  count(trend, sort = TRUE)

post_tweet(
  "Estou tuitando no curso de Web Scraping da @curso_r, usando o pacote {rtweet}! #rstats"
)

dados <- get_timeline("allison_horst")
View(dados)

da_mencoes <- get_mentions()
