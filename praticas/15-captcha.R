



baixar_tjpe <- function(id_processo) {
  u_inicial <- "https://srv01.tjpe.jus.br/consultaprocessualunificada/"
  httr::handle_reset(u_inicial)

  r_inicial <- httr::GET(u_inicial)

  u_captcha <- "https://srv01.tjpe.jus.br/consultaprocessualunificadaservico/api/captcha"
  r_captcha <- httr::GET(u_captcha)

  httr::content(r_captcha) |>
    purrr::pluck("image") |>
    stringr::str_remove("data:image/png;base64,") |>
    base64enc::base64decode() |>
    writeBin("captcha.png")


  # a resposta seria 4yxk7

  cap <- captcha::read_captcha("captcha.png")

  cap |>
    plot()

  # captcha::classify(cap)

  # remotes::install_github("decryptr/captcha")

  modelo <- captcha::captcha_load_model("/Users/julio/Downloads/tjpe.pt")
  lab <- captcha::decrypt("captcha.png", modelo)

  usethis::ui_info("A resposta do modelo foi: {lab}")

  u_consulta <- "https://srv01.tjpe.jus.br/consultaprocessualunificadaservico/api/processo"

  r_consulta <- httr::POST(
    u_consulta,
    body = list(npu = id_processo),
    httr::add_headers(captcha = lab),
    encode = "json",
    httr::write_disk("output/resultado.json", TRUE)
  )


  # importante validar os resultados
  if(r_consulta$status_code != 200) {


  }


}

id_processo <- "00034728720148171030"
baixar_tjpe(id_processo)
