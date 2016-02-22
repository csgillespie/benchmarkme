#' Matrix function benchmarks
#' 
#' @description A collection of matrix benchmark functions
#' \itemize{
#' \item FFT over 2,500,000 random values.
#' \item Eigenvalues of a 640x640 random matrix.
#' \item Determinant of a 2500x2500 random matrix.
#' \item Cholesky decomposition of a 3000x3000 matrix.
#' \item Inverse of a 1600x1600 random matrix.
#' }
#' These benchmarks have been developed by many authors. See http://r.research.att.com/benchmarks/R-benchmark-25.R
#' for a complete history. The function \code{benchmark_matrix_fun()} runs the five \code{bm} functions.
#' @inheritParams benchmark_std
#' @references http://r.research.att.com/benchmarks/R-benchmark-25.R
#' @importFrom stats fft
#' @export
bm_matrix_fun_fft = function(runs=3, verbose=TRUE) {
  b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="fft", test_group="matrix_fun")
  for (i in 1:runs) {
    a = Rnorm(2500000)
    invisible(gc())
    timings[i,1:3] = system.time({b <- fft(a)})[1:3]
  }
  if(verbose)
    message(c("\tFFT over 2,500,000 random values", timings_mean(timings)))
  timings
}


#' @rdname bm_matrix_fun_fft
#' @export
bm_matrix_fun_eigen = function(runs=3, verbose=TRUE) {
  b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="eigen", test_group="matrix_fun")
  for (i in 1:runs) {
    a = array(Rnorm(600*600), dim = c(600, 600))
    invisible(gc())
    timings[i,1:3] = system.time({ b <- eigen(a, symmetric=FALSE, only.values=TRUE)$Value})[1:3]
  }
  if(verbose)
    message(c("\tEigenvalues of a 640x640 random matrix", timings_mean(timings)))
  timings
}

#' @rdname bm_matrix_fun_fft
#' @export
bm_matrix_fun_determinant = function(runs=3, verbose=TRUE) {
  b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="determinant", test_group="matrix_fun")
  for (i in 1:runs) {
    a = Rnorm(2500*2500); dim(a) = c(2500, 2500)
    invisible(gc())
    timings[i,1:3] = system.time({b <- det(a)})[1:3]
  }
  if(verbose)
    message(c("\tDeterminant of a 2500x2500 random matrix", timings_mean(timings)))
  timings
}

#' @importFrom methods new
#' @rdname bm_matrix_fun_fft
#' @import Matrix
#' @export
bm_matrix_fun_cholesky = function(runs=3, verbose=TRUE) {
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="cholesky", test_group="matrix_fun")
  for (i in 1:runs) {
    a = crossprod(new("dgeMatrix", x = Rnorm(3000*3000),
                       Dim = as.integer(c(3000, 3000))))
    invisible(gc())
    timings[i,1:3] = system.time({b <- chol(a)})[1:3]
  }
  if(verbose)
    message(c("\tCholesky decomposition of a 3000x3000 matrix", timings_mean(timings)))
  timings
}

#' @rdname bm_matrix_fun_fft
#' @export
bm_matrix_fun_inverse = function(runs=3, verbose=TRUE) {
  b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="inverse", test_group="matrix_fun")
  for (i in 1:runs) {
    a = new("dgeMatrix", x = Rnorm(1600*1600), Dim = as.integer(c(1600, 1600)))
    invisible(gc())
    timings[i,1:3] = system.time({b <- solve(a)})[1:3]
  }
  if(verbose)
    message(c("\tInverse of a 1600x1600 random matrix", timings_mean(timings)))
  timings
}
