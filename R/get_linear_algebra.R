la_helper = function() {
  p_id = Sys.getpid()
  # Get all R processes
  lsof_cmd = paste("lsof -p", p_id, "| awk '{print $9}'")
  lsof = try(system(lsof_cmd, intern = TRUE), silent = TRUE)
  
  # Grep for BLAS; should pick up the mkl BLAS as well
  blas = lsof[grep("blas", x = lsof)]
  if(class(blas) == "try-error" || length(blas) == 0) 
    blas = NA
  
  # Now lapack; try standard, then the libmkl
  lapack = lsof[grep("lapack", x = lsof)]
  
  if(length(lapack) == 0)
    lapack = lsof[grep("libmkl_.*lp.*\\.so$", lsof)]
  
  if(class(lapack) == "try-error" || length(lapack) == 0)
    lapack = NA
  
  ## NA returned if BLAS is hiding
  return(list(blas = blas, lapack = lapack))
}



#' Get BLAS and LAPACK libraries
#' 
#' This currently only works under Linux and Apple OS. For other OS, e.g. Windows \code{NA}'s 
#' are returned.
#' 
#' @details Calls `Sys.getpid()` and greps for blas,lapack and libmkl. 
#' Under Linux a warning is raised 
#' "lsof: WARNING: can't stat() tracefs file system /sys/kernel/debug/tracing Output information may be incomplete."
#' There seems to be no way to avoid this http://askubuntu.com/q/748498/1986
#' @export
get_linear_algebra = function() {
  os = R.version$os
  if(length(grep("^linux", os)) || length(grep("^darwin", os))) {
    linear_algebra = la_helper()
  } else {
    linear_algebra = list(blas = NA, lapack = NA) # nocov
  }
  return(linear_algebra)
}

