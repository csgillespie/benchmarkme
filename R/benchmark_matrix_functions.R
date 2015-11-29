
#' Matrix function benchmarks
#' 
#' @description A collection of matrix benchmark functions
#' \itemize{
#' \item FFT over 5,000,000 random values.
#' \item Eigenvalues of a 640x640 random matrix.
#' \item Determinant of a 2500x2500 random matrix.
#' \item Cholesky decomposition of a 3000x3000 matrix.
#' \item Inverse of a 1600x1600 random matrix.
#' }
#' These benchmarks have been developed by many authors. See http://r.research.att.com/benchmarks/R-benchmark-25.R
#' for a complete history.
#' @inheritParams benchmark_all
#' @references http://r.research.att.com/benchmarks/R-benchmark-25.R
#' @export
bm_matrix_fft = function(runs=3, verbose=FALSE) {
  b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="fft", group="matrix_fun")
  for (i in 1:runs) {
    a = Rnorm(5000000)
    invisible(gc())
    timings[i,1:3] = system.time({b <- fft(a)})[1:3]
  }
  if(verbose)
    message(c("FFT over 5,000,000 random values", timings_mean(timings)))
  timings
}


#' @rdname bm_matrix_fft
#' @export
bm_matrix_eigen = function(runs=3, verbose=FALSE) {
  b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="eigen", group="matrix_fun")
  for (i in 1:runs) {
    a = array(Rnorm(600*600), dim = c(600, 600))
    invisible(gc())
    timings[i,1:3] = system.time({ b <- eigen(a, symmetric=FALSE, only.values=TRUE)$Value})[1:3]
  }
  if(verbose)
    message(c("Eigenvalues of a 640x640 random matrix", timings_mean(timings)))
  timings
}

#' @rdname bm_matrix_fft
#' @export
bm_matrix_determinant = function(runs=3, verbose=FALSE) {
  b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="determinant", group="matrix_fun")
  for (i in 1:runs) {
    a = Rnorm(2500*2500); dim(a) = c(2500, 2500)
    invisible(gc())
    timings[i,1:3] = system.time({b <- det(a)})[1:3]
  }
  if(verbose)
    message(c("Determinant of a 2500x2500 random matrix", timings_mean(timings)))
  timings
}

#' @rdname bm_matrix_fft
#' @import Matrix
#' @export
bm_matrix_cholesky = function(runs=3, verbose=FALSE) {
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="cholesky", group="matrix_fun")
  for (i in 1:runs) {
    a = crossprod(new("dgeMatrix", x = Rnorm(3000*3000),
                       Dim = as.integer(c(3000, 3000))))
    invisible(gc())
    timings[i,1:3] = system.time({b <- chol(a)})[1:3]
  }
  if(verbose)
    message(c("Cholesky decomposition of a 3000x3000 matrix", timings_mean(timings)))
  timings
}

#' @rdname bm_matrix_fft
#' @export
bm_matrix_inverse = function(runs=3, verbose=FALSE) {
  b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="inverse", group="matrix_fun")
  for (i in 1:runs) {
    a = new("dgeMatrix", x = Rnorm(1600*1600), Dim = as.integer(c(1600, 1600)))
    invisible(gc())
    timings[i,1:3] = system.time({b <- solve(a)})[1:3]
  }
  if(verbose)
    message(c("Inverse of a 1600x1600 random matrix", timings_mean(timings)))
  timings
}
