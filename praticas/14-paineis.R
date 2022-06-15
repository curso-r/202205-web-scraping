library(RSelenium)

drv <- rsDriver(browser = "firefox")
u <- "https://paineis.cnj.jus.br/QvAJAXZfc/opendoc.htm?document=qvw_l%2FPainelCNJ.qvw&host=QVS%40neodimio03&anonymous=true&sheet=shPDPrincipal"
u <- "https://paineis.cnj.jus.br/QvAJAXZfc/opendoc.htm?document=qvw_l%2FPainelCNJ.qvw&host=QVS%40neodimio03&anonymous=true&sheet=shResumoDespFT"

u_pbi <- "https://painel-estatistica.stg.cloud.cnj.jus.br/estatisticas.html"
u_pbi_real <- "https://app.powerbi.com/view?r=eyJrIjoiZWU5ZjFiZDItMGM5Ny00ZTU2LWEzMTEtMzc1ZWMwMjkzMTFmIiwidCI6ImFkOTE5MGU2LWM0NWQtNDYwMC1iYzVjLWVjYTU1NGNjZjQ5NyIsImMiOjJ9&pageName=ReportSectionfa1fcf7b6d15b9e55814"
drv$client$navigate(u_pbi_real)

# por algum motivo, utilizar //svg não funciona!
elems <- drv$client$findElements("xpath", "//*[@class='card']")

# elems[[1]]$getElementTagName()
# elems[[1]]$getElementText

numeros <- purrr::map(elems, ~.x$getElementText()) |>
  purrr::map_chr(1)

html <- drv$client$getPageSource()
readr::write_file(html[[1]], "output/pbi_cnj.html")

ramo <- drv$client$findElement(
  "xpath",
  "//*[@class='slicer-content-wrapper']"
)
ramo$clickElement()

opcao <- drv$client$findElement(
  "xpath",
  "//span[@title='Justiça Estadual']/parent::div"
)
opcao$clickElement()

elems2 <- drv$client$findElements("xpath", "//*[@class='card']")
numeros2 <- purrr::map(elems, ~.x$getElementText()) |>
  purrr::map_chr(1)

ramo$clickElement()


# mpm ---------------------------------------------------------------------


u_mpm <- "https://paineis.cnj.jus.br/QvAJAXZfc/opendoc.htm?document=qvw_l%2FPainelCNJ.qvw&host=QVS%40neodimio03&anonymous=true&sheet=shPDPrincipal"
drv$client$navigate(u_mpm)

# ao inves de digitar o código para
# acessar os gráficos customizados,
# eu cliquei

estados_para_clicar <- c(
  "TJAC", "TJAL", "TJAM",
  "TJAP", "TJBA", "TJCE",
  "TJDFT", "TJES", "TJGO"
)

estado <- estados_para_clicar[2]


baixar_estado <- function(estado, drv) {

  usethis::ui_info(estado)

  elemento <- drv$client$findElement(
    "xpath",
    glue::glue(
      "//*[@title='{estado}' and @class='QvExcluded']"
    )
  )

  elemento$clickElement()

  Sys.sleep(10)

  excel <- drv$client$findElement(
    "xpath",
    "//div[@title='Resultado']//div[@title='Enviar para Excel']"
  )

  excel$clickElement()

  Sys.sleep(20)

}

purrr::walk(
  estados_para_clicar,
  baixar_estado,
  drv
)


dados <- fs::dir_ls(
  "/Users/julio/Downloads/",
  glob = "*.xlsx"
) |>
  purrr::map_dfr(
    readxl::read_excel,
    .id = "file"
  )

