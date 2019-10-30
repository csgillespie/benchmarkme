#' @importFrom stats rnorm
Rnorm = function(n) { #nolint
  if (requireNamespace("RcppZiggurat", quietly = TRUE))
    RcppZiggurat::zrnorm(n)
  else
    rnorm(n)
}
