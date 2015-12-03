#' @importFrom stats rnorm
Rnorm   = function(n) {
  if(requireNamespace("RcppZiggurat", quietly = TRUE))
    RcppZiggurat::zrnorm(n)
  else
    rnorm(n)
}
