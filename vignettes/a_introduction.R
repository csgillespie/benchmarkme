## ----eval=FALSE, include=TRUE--------------------------------------------
#  library("benchmarkme")
#  res = benchmark_std(runs = 3)

## ----eval=FALSE----------------------------------------------------------
#  id = upload_results(res)

## ------------------------------------------------------------------------
data(past_results, package="benchmarkmeData")

## ------------------------------------------------------------------------
head(past_results, 3)

## ---- fig.width=7, fig.height=3.5, message=FALSE-------------------------
plot_past()
## shine() # if you have shiny

## ---- fig.width=7, fig.height=3.5, message=FALSE, results="hide"---------
plot(res)

## ----eval=FALSE----------------------------------------------------------
#  install.packages("DT")

## ----eval=FALSE----------------------------------------------------------
#  ## Your result is highlighted in orange.
#  get_datatable(res)
#  get_datatable_past()

## ----eval=FALSE----------------------------------------------------------
#  res_io = benchmark_io()
#  upload_results(res_io)
#  ## Sample size is small, so don't split by byte/blas
#  plot(res_io, byte_optimize=NULL, blas_optimize=NULL)

## ----eval=FALSE----------------------------------------------------------
#  Sys.getenv("TMPDIR")

## ----eval=FALSE----------------------------------------------------------
#  res_io = benchmark_io(tmpdir="some_other_directory")

