## ----eval=FALSE, include=TRUE--------------------------------------------
#  library("benchmarkme")
#  res = benchmark_std(runs = 3)

## ----eval=FALSE----------------------------------------------------------
#  id = upload_results(res)

## ------------------------------------------------------------------------
data(past_results, package="benchmarkmeData")

## ------------------------------------------------------------------------
head(past_results, 3)

## ---- fig.width=7, fig.height=3.5----------------------------------------
plot_past()
## shine() # if you have shiny

## ---- fig.width=7, fig.height=3.5----------------------------------------
plot(res)
## shine(res) # if you have shiny

## ----eval=FALSE----------------------------------------------------------
#  install.packages("DT")

## ----eval=FALSE----------------------------------------------------------
#  ## Your result is highlighted in orange.
#  get_datatable(res)
#  get_datatable_past()

