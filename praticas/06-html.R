
# library(XML)
library(xml2)

html <- read_html("exemplos_de_aula/html_exemplo.html")

# XPATH
nodes <- xml_find_all(html, "//p")
nodes <- xml_find_first(html, "//p")


xml_find_all(html, "//head")
xml_find_first(html, "//head")

# xml_find_

xml_text(nodes)


xml_attr(nodes, "style")
xml_attrs(nodes)


# rvest -------------------------------------------------------------------

library(rvest)

## parte do acesso, que chama o {httr} por trás
# html_session()
# html_form()

## parte do processamento, chama o {xml2} por trás
html <- rvest::read_html("exemplos_de_aula/html_exemplo.html")

nodes <- html_elements(html, xpath = "//p")
html_elements(html, css = "p")

html_elements(html, xpath = "/html/body/h1")
html_elements(html, css = "body > h1")

## table
# html_table()

html_element()


html_text(nodes)
html_attr(nodes, "style")
html_attrs(nodes)




