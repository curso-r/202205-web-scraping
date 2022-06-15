


lapply()
sapply()
# familia apply


2 + 3

purrr::map(1:10, \(x)x+1)

\(x)x+1
~.x+1
purrr::map(1:10, ~.x+1)
purrr::map(1:10, ~ ..1 + 1)


purrr::map2_dbl(1:10, 2:11, ~ .x + .y)

purrr::pmap(list(
  a = 1:10, b = 2:11, c = 3:12
), ~ ..1 + ..2 + ..3)

purrr::pmap(list(
  a = 1:10, b = 2:11, c = 3:12
), \(a,b,c) a+b+c)

purrr::walk(1:10, ~print(.x))


purrr::cross_df(list(a = 1:3, b = 2:6))


f <- function(a) {

  try({
    log(a)
  })

  print("OK!")
}

f(1)
f(-1)

f("a")

try({
  f("a")
})





