#' Matrix calculation benchmarks
#' 
#' @description A collection of matrix benchmark functions aimed at
#' assessing the calculation speed.
#' \itemize{
#' \item Creation, transp., deformation of a 2500x2500 matrix.
#' \item 2500x2500 normal distributed random matrix ^1000.
#' \item Sorting of 7,000,000 random values.
#' \item 2500x2500 cross-product matrix (b = a' * a)
#' \item Linear regr. over a 3000x3000 matrix.
#' }
#' These benchmarks have been developed by many authors. See http://r.research.att.com/benchmarks/R-benchmark-25.R
#' for a complete history. The function \code{benchmark_matrix_cal()} runs the five \code{bm} functions.
#' @inheritParams benchmark_std
#' @references http://r.research.att.com/benchmarks/R-benchmark-25.R
#' @export
bm_matrix_cal_manip = function(runs=3, verbose=TRUE) {
  a = 0; b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0,
                       test="manip", test_group="matrix_cal")
  for (i in 1:runs) {
    invisible(gc())
    timing <- system.time({
      a = matrix(rnorm(2500 * 2500)/10, ncol=2500, nrow=2500);
      b = t(a);
      dim(b) = c(1250, 5000);
      a = t(b)
    })
    timings[i,1:3] = timing[1:3]
  }
  if(verbose)
    message(c("\tCreation, transp., deformation of a 5000x5000 matrix", timings_mean(timings)))
  timings
}

#' @rdname bm_matrix_cal_manip
#' @export
bm_matrix_cal_power = function(runs=3, verbose=TRUE) {
  b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="power", test_group="matrix_cal")
  for (i in 1:runs) {
    a <- abs(matrix(Rnorm(2500*2500)/2, ncol=2500, nrow=2500));
    invisible(gc())
    timings[i,1:3] = system.time({b <- a^1000})[1:3]
  }
  if(verbose)
    message(c("\t2500x2500 normal distributed random matrix ^1000", timings_mean(timings)))
  timings
}

#' @rdname bm_matrix_cal_manip
#' @export
bm_matrix_cal_sort = function(runs=3, verbose=TRUE) {
  b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="sort", test_group="matrix_cal")
  for (i in 1:runs) {
    a = Rnorm(7000000)
    invisible(gc())
    timings[i,1:3] = system.time({b <- sort(a, method="quick")})[1:3]
  }
  if(verbose)
    message(c("\tSorting of 7,000,000 random values", timings_mean(timings)))
  timings
}

#' @rdname bm_matrix_cal_manip
#' @export
bm_matrix_cal_cross_product = function(runs=3, verbose=TRUE) {
  b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="cross_product", test_group="matrix_cal")
  for (i in 1:runs) {
    a = Rnorm(2500*2500); dim(a) = c(2500, 2500)
    invisible(gc())
    timings[i,1:3] = system.time({b <- crossprod(a)})[1:3]
  }
  if(verbose)
    message(c("\t2500x2500 cross-product matrix (b = a' * a)", timings_mean(timings)))
  timings
}

#' @rdname bm_matrix_cal_manip
#' @export
bm_matrix_cal_lm = function(runs=3, verbose=TRUE) {
  ans = 0
  b = as.double(1:2000)
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="lm", test_group="matrix_cal")
  for (i in 1:runs) {
    a = new("dgeMatrix", x = Rnorm(2000*2000), Dim = as.integer(c(2000,2000)))
    invisible(gc())
    timings[i,1:3] = system.time({ans = solve(crossprod(a), crossprod(a,b))})[1:3]
  }
  if(verbose)
    message(c("\tLinear regr. over a 3000x3000 matrix (c = a \\ b')", timings_mean(timings)))
  timings
}
