
r_home <- httr::GET(
  "https://app.glueup.com/my/home/",
  httr::write_disk("output/glueup_home.html", TRUE)
)



u <- "https://app.glueup.com/account/login/iframe"

# usethis::edit_r_environ("project")

r <- httr::POST(
  u, body = list(
    "email" = Sys.getenv("GLUEUP_LOGIN"),
    "password" = Sys.getenv("GLUEUP_SENHA"),
    "rememberMe" = "on",
    "forgotPassword" = '{"value":"Esqueceu a senha?","url":"/account/forgot-password"}',
    "stayOnPage" = "",
    "showFirstTimeModal" = "true"
  ),
  encode = "form",
  httr::write_disk("output/glueup_login.html", TRUE)
)

r_home <- httr::GET(
  "https://app.glueup.com/my/home/",
  httr::write_disk("output/glueup_home.html", TRUE)
)
