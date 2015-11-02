
#' Matrix calculations
#' @export
bm_matrix_manip = function(runs=3, verbose=FALSE) {
  a = 0; b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, test="matrix_manip")
  for (i in 1:runs) {
    invisible(gc())
    timing <- system.time({
      a = matrix(Rnorm(2500*2500)/10, ncol=2500, nrow=2500);
      b = t(a);
      dim(b) = c(1250, 5000);
      a = t(b)
    })
    timings[i,1:3] = timing[1:3]
  }
  if(verbose)
    message(c("Creation, transp., deformation of a 2500x2500 matrix (sec): ", mean(timings[,3]), "\n"))
  timings
}

#' @rdname bm_matrix_manip
#' @export
bm_matrix_power = function(runs=3, verbose=FALSE) {
  b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, test="matrix_power")
  for (i in 1:runs) {
    a <- abs(matrix(Rnorm(2500*2500)/2, ncol=2500, nrow=2500));
    invisible(gc())
    timings[i,1:3] = system.time({b <- a^1000})[1:3]
  }
  if(verbose)
    message(c("2400x2400 normal distributed random matrix ^1000____ (sec): ", mean(timings[,3]), "\n"))
  timings
}

#' @rdname bm_matrix_manip
#' @export
bm_matrix_sort = function(runs=3, verbose=FALSE) {
  b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, test="matrix_sort")
  for (i in 1:runs) {
    a = Rnorm(7000000)
    invisible(gc())
    timings[i,1:3] = system.time({b <- sort(a, method="quick")})[1:3]
  }
  if(verbose)
    message(c("Sorting of 7,000,000 random values__________________ (sec): ", mean(timings[,3]), "\n"))
  timings
}

#' @rdname bm_matrix_manip
#' @export
bm_matrix_cross_product = function(runs=3, verbose=FALSE) {
  b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, test="matrix_cross_product")
  for (i in 1:runs) {
    a = Rnorm(2800*2800); dim(a) = c(2800, 2800)
    invisible(gc())
    timings[i,1:3] = system.time({b <- crossprod(a)})[1:3]
  }
  if(verbose)
    message(c("2800x2800 cross-product matrix (b = a' * a)_________ (sec): ", mean(timings[,3]), "\n"))
  timings
}

#' @rdname bm_matrix_manip
#' @export
bm_matrix_lm = function(runs=3, verbose=FALSE) {
  ans = 0
  b = as.double(1:2000)
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, test="matrix_lm")
  for (i in 1:runs) {
    a = new("dgeMatrix", x = Rnorm(2000*2000), Dim = as.integer(c(2000,2000)))
    invisible(gc())
    timings[i,1:3] = system.time({ans = solve(crossprod(a), crossprod(a,b))})[1:3]
  }
  if(verbose)
    message(c("Linear regr. over a 3000x3000 matrix (c = a \\ b')___ (sec): ", mean(timings[,3]), "\n"))
  timings
}
