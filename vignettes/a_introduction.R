## ----eval=FALSE, include=TRUE--------------------------------------------
#  library("benchmarkme")
#  res = benchmark_std(runs = 3)

## ----eval=FALSE----------------------------------------------------------
#  id = upload_results(res)

## ------------------------------------------------------------------------
data(results, package="benchmarkme")

## ------------------------------------------------------------------------
head(results, 3)

## ---- fig.width=7, fig.height=3.5----------------------------------------
plot_past()

## ---- fig.width=7, fig.height=3.5----------------------------------------
plot(res)

## ----eval=FALSE----------------------------------------------------------
#  install.packages("DT")

## ----eval=FALSE----------------------------------------------------------
#  ## Your result is highlighted in orange.
#  get_datatable(res)
#  get_datatable_past()

