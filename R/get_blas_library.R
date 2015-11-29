#' Get BLAS and LAPACK libraries
#' 
#' This currently only works under Linux. For other OS, \code{NA}'s 
#' are returned.
#' @export
get_linear_algebra = function() {
  os = R.version$os
  if(length(grep("^linux", os))) {
    
    gui = get_platform_info()$GUI
    if(gui == "RStudio") {
      search = "/rstudio"
    } else { 
      search = "exec/R"
    }
    #!/bin/bash
    cmd = paste("ps aux | grep -i", search, "| awk 'FNR == 1 {print $2}'")
    p_id = system(cmd, intern=TRUE)
    
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
