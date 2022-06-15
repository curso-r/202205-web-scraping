library(parallel)
library(tictoc)

tic()
res <- map(1:4, function(x) Sys.sleep(1))
toc()

## 4.011 sec elapsed

tic();res <- mclapply(1:4, function(x) Sys.sleep(1));toc()


library(future)
availableCores()



# future::sequential()
# future::multicore()

plan(future::multisession)

tic()
furrr::future_map(1:4, function(x) Sys.sleep(1))
toc()

