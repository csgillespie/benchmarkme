Rnorm   = function(...) {
  if(requireNamespace("RcppZiggurat", quietly = TRUE))
    RcppZiggurat::zrnorm(...)
  else
    rnorm(...)
}

Runif = function(...) {
  runif(...)
}