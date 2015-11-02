
#' @title Programming benchmarks
#' @export
bm_prog_fib = function(runs=3, verbose=FALSE) {
  a = 0; b = 0; phi = 1.6180339887498949
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, test="prog_fib")
  for (i in 1:runs) {
    a = floor(Runif(3500000)*1000)
    invisible(gc())
    timings[i, 1:3] = system.time({b <- (phi^a - (-phi)^(-a))/sqrt(5)})[1:3]
  }
  if(verbose)
    message(c("3,500,000 Fibonacci numbers calculation (vector calc)(sec): ", mean(timings[,3]), "\n"))
  timings
}

#' @rdname bm_prog_fib
#' @export
bm_prog_hilbert = function(runs=3, verbose=FALSE) {
  a = 3000; b = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, test="prog_hilbert")
  for (i in 1:runs) {
    invisible(gc())
    timing <- system.time({
      b <- rep(1:a, a); dim(b) <- c(a, a);
      b <- 1 / (t(b) + 0:(a-1))
    })[1:3]
    timings[i,1:3] = timing
  }
  if(verbose)
    message(c("Creation of a 3000x3000 Hilbert matrix (matrix calc) (sec): ", mean(timings[,3]), "\n"))
  timings
}

#' @rdname bm_prog_fib
#' @export
bm_prog_gcd = function(runs=3, verbose=FALSE) {
  ans = 0
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, test="prog_gcd")
  gcd2 = function(x, y) {if (sum(y > 1.0E-4) == 0) x else {y[y == 0] <- x[y == 0]; Recall(y, x %% y)}}
  for (i in 1:runs) {
    a = ceiling(Runif(400000)*1000)
    b = ceiling(Runif(400000)*1000)
    invisible(gc())
    timings[i,1:3] <- system.time({ans <- gcd2(a, b)})[1:3]                            # gcd2 is a recursive function
  }
  if(verbose)
    message(c("Grand common divisors of 400,000 pairs (recursion): ", mean(timings[,3]), " (sec) \n"))
  timings
}

#' @rdname bm_prog_fib
#' @export
bm_prog_toeplitz = function(runs=3, verbose=FALSE) {
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, test="prog_toeplitz")
  N = 5000
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
    })[1:3]
    timings[i,1:3] = timing
  }
  if(verbose)
    message(c("Creation of a 500x500 Toeplitz matrix (loops)_______ (sec): ", mean(timings[,3]), "\n"))
  timings
}

#' @rdname bm_prog_fib
#' @export
bm_prog_escoufier = function(runs=3, verbose=FALSE) {
  timings = data.frame(user = numeric(runs), system=0, elapsed=0, test="prog_escoufier")
  p <- 0; vt <- 0; vr <- 0; vrt <- 0; rvt <- 0; RV <- 0; j <- 0; k <- 0;
  x2 <- 0; R <- 0; Rxx <- 0; Ryy <- 0; Rxy <- 0; Ryx <- 0; Rvmax <- 0
  # Calculate the trace of a matrix (sum of its diagonal elements)
  Trace <- function(y) {sum(c(y)[1 + 0:(min(dim(y)) - 1) * (dim(y)[1] + 1)], na.rm=FALSE)}
  for (i in 1:runs) {
    x <- abs(Rnorm(45*45)); dim(x) <- c(45, 45)
    invisible(gc())
    timing <- system.time({
      # Calculation of Escoufier's equivalent vectors
      p <- ncol(x)
      vt <- 1:p                                  # Variables to test
      vr <- NULL                                 # Result: ordered variables
      RV <- 1:p                                  # Result: correlations
      vrt <- NULL
      for (j in 1:p) {                           # loop on the variable number
        Rvmax <- 0
        for (k in 1:(p-j+1)) {                   # loop on the variables
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
    })[1:3]
    timings[i,1:3] = timing
  }
  if(verbose)
    message(c("Escoufier's method on a 45x45 matrix (mixed)________ (sec): ", mean(timings[,3]), "\n"))
  timings
}
