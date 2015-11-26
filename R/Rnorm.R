Rnorm   = function(n) {
  if(requireNamespace("RcppZiggurat", quietly = TRUE))
    zrnorm(n)
  else
    rnorm(n)
}

Runif = function(...) {
  runif(...)
}