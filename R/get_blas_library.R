#' Get BLAS and LAPACK libraries
#' 
#' This currently only works under Linux and Apple OS. For other OS, e.g. Windows \code{NA}'s 
#' are returned.
#' 
#' @details Calls `Sys.getpid()` and greps blas/lapack
#' @export
get_linear_algebra = function() {
  ##XXX: ?R CMD config BLAS_LIBS
  os = R.version$os
  if(length(grep("^linux", os)) || length(grep("^darwin", os))) {
    p_id = Sys.getpid()
    cmd_blas = paste("lsof -p", p_id, "| grep 'blas' | awk '{print $9}'")
    cmd_lapack = paste("lsof -p", p_id, "| grep 'lapack' | awk '{print $9}'")
    blas = try(system(cmd_blas, intern=TRUE), silent=TRUE)
    lapack = try(system(cmd_lapack, intern=TRUE), silent=TRUE)
    if(class(blas) == "try-error") {
      blas = lapack = NA
    }
  } else {
    blas = lapack = NA
  }
  list(blas = blas, lapack=lapack)
}

