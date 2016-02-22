
#' @title Programming benchmarks
#' @description A collection of matrix programming benchmark functions
#' \itemize{
#' \item 3,500,000 Fibonacci numbers calculation (vector calc).
#' \item Creation of a 3500x3500 Hilbert matrix (matrix calc).
#' \item Grand common divisors of 1,000,000 pairs (recursion).
#' \item Creation of a 1600x1600 Toeplitz matrix (loops).
#' \item Escoufier's method on a 60x60 matrix (mixed).
#' }
#' These benchmarks have been developed by many authors. See http://r.research.att.com/benchmarks/R-benchmark-25.R
#' for a complete history. The function \code{benchmark_prog()} runs the five \code{bm} functions.
#' @inheritParams benchmark_std
#' @importFrom stats runif
#' @export
bm_prog_fib = function(runs=3, verbose=TRUE) {
  a = 0; b = 0; phi = 1.6180339887498949
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="fib", test_group="prog")
  for (i in 1:runs) {
    a = floor(runif(3500000)*1000)
    invisible(gc())
    timings[i, 1:3] = system.time({b <- (phi^a - (-phi)^(-a))/sqrt(5)})[1:3]
  }
  if(verbose)
    message(c("\t3,500,000 Fibonacci numbers calculation (vector calc)", timings_mean(timings)))
  timings
}

#' @rdname bm_prog_fib
#' @export
bm_prog_hilbert = function(runs=3, verbose=TRUE) {
  a = 3500; b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="hilbert", test_group="prog")
  for (i in 1:runs) {
    invisible(gc())
    timing <- system.time({
      b <- rep(1:a, a); dim(b) <- c(a, a);
      b <- 1 / (t(b) + 0:(a-1))
    }
    )[1:3]
    timings[i,1:3] = timing
  }
  if(verbose)
    message(c("\tCreation of a 3500x3500 Hilbert matrix (matrix calc)", timings_mean(timings)))
  timings
}

#' @rdname bm_prog_fib
#' @export
bm_prog_gcd = function(runs=3, verbose=TRUE) {
  ans = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="gcd", test_group="prog")
  gcd2 = function(x, y) {if (sum(y > 1.0E-4) == 0) x else {y[y == 0] <- x[y == 0]; Recall(y, x %% y)}}
  for (i in 1:runs) {
    a = ceiling(runif(1000000)*1000)
    b = ceiling(runif(1000000)*1000)
    invisible(gc())
    timings[i,1:3] <- system.time({ans <- gcd2(a, b)})[1:3] # gcd2 is a recursive function
  }
  if(verbose)
    message(c("\tGrand common divisors of 1,000,000 pairs (recursion)", timings_mean(timings)))
  timings
}

#' @rdname bm_prog_fib
#' @export
bm_prog_toeplitz = function(runs=3, verbose=TRUE) {
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="toeplitz", test_group="prog")
  N = 3000
  ans = rep(0, N*N)
  dim(ans) = c(N, N)
  for (i in 1:runs) {
    invisible(gc())
    timing <- system.time({
      # Rem: there are faster ways to do this
      # but here we want to time loops (220*220 'for' loops)! 
      for (j in 1:N) {
        for (k in 1:N) {
          ans[k,j] = abs(j - k) + 1
        }
      }
    }
    )[1:3]
    timings[i,1:3] = timing
  }
  if(verbose)
    message(c("\tCreation of a 3000x3000 Toeplitz matrix (loops)", timings_mean(timings)))
  timings
}


#' @importFrom stats cor
#' @rdname bm_prog_fib
#' @export
bm_prog_escoufier = function(runs=3, verbose=TRUE) {
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, 
                       test="escoufier", test_group="prog")
  p <- 0; vt <- 0; vr <- 0; vrt <- 0; rvt <- 0; RV <- 0; j <- 0; k <- 0;
  x2 <- 0; R <- 0; Rxx <- 0; Ryy <- 0; Rxy <- 0; Ryx <- 0; Rvmax <- 0
  # Calculate the trace of a matrix (sum of its diagonal elements)
  Trace <- function(y) {sum(c(y)[1 + 0:(min(dim(y)) - 1) * (dim(y)[1] + 1)], na.rm=FALSE)}
  for (i in 1:runs) {
    x <- abs(Rnorm(60*60)); dim(x) <- c(60, 60)
    invisible(gc())
    timing <- system.time({
      # Calculation of Escoufier's equivalent vectors
      p <- ncol(x)
      vt <- 1:p                                  # Variables to test
      vr <- NULL                                 # Result: ordered variables
      RV <- 1:p                                  # Result: correlations
      vrt <- NULL
      # loop on the variable number
      for (j in 1:p) {
        Rvmax <- 0
        # loop on the variables
        for (k in 1:(p-j+1)) {
          x2 <- cbind(x, x[,vr], x[,vt[k]])
          R <- cor(x2)                           # Correlations table
          Ryy <- R[1:p, 1:p]
          Rxx <- R[(p+1):(p+j), (p+1):(p+j)]
          Rxy <- R[(p+1):(p+j), 1:p]
          Ryx <- t(Rxy)
          rvt <- Trace(Ryx %*% Rxy) / sqrt(Trace(Ryy %*% Ryy) * Trace(Rxx %*% Rxx)) # RV calculation
          if (rvt > Rvmax) {
            Rvmax <- rvt                         # test of RV
            vrt <- vt[k]                         # temporary held variable
          }
        }
        vr[j] <- vrt                             # Result: variable
        RV[j] <- Rvmax                           # Result: correlation
        vt <- vt[vt!=vr[j]]                      # reidentify variables to test
      }
    }
    )[1:3]
    timings[i,1:3] = timing
  }
  if(verbose)
    message(c("\tEscoufier's method on a 60x60 matrix (mixed)", timings_mean(timings)))
  timings
}
