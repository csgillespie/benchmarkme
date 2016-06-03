#' Get BLAS and LAPACK libraries
#' 
#' This currently only works under Linux. For other OS, \code{NA}'s 
#' are returned.
#' 
#' @details Calls `Sys.getpid()` and greps blas/lapack
#' @export
get_linear_algebra = function() {
  ##XXX: ?R CMD config BLAS_LIBS
  os = R.version$os
  if(length(grep("^linux", os))) {
    p_id = Sys.getpid()
    cmd_blas = paste("lsof -p", p_id, "| grep 'blas' | awk '{print $9}'")
    cmd_lapack = paste("lsof -p", p_id, "| grep 'lapack' | awk '{print $9}'")
    blas = system(cmd_blas, intern=TRUE)
    lapack = system(cmd_lapack, intern=TRUE)
  } else {
    blas = NA
    lapack=NA
  }
  list(blas = blas, lapack=lapack)
}
