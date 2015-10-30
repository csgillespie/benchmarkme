# require(SuppDists)	# Optimized random number generators
# Runif <- rMWC1019	# The fast uniform number generator
# Rnorm <- rnorm
# Rnorm <- rziggurat	


Rnorm   = function(...) {
  if(requireNamespace("RcppZiggurat", quietly = TRUE))
    RcppZiggurat::zrnorm(...)
  else
    rnorm(...)
}

Runif = function(...) {
  runif(...)
}