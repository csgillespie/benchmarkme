#' Byte compiler status
#' 
#' Attempts to detect if byte compiling has been used on the package. There isn't a fool proof
#' way of detecting if the the package has been benchmarked. 
#' @return An integer indicating if byte compiling has been turn on. See \code{?compiler} for
#' details.
#' @importFrom compiler getCompilerOption
#' @export
get_byte_compiler = function() {
  comp = Sys.getenv("R_COMPILE_PKGS")
  
  ## Try to detect compilePKGS - long shot
  ## Return to same state as we found it
  if(nchar(comp) == 0L) {
    comp = compiler::compilePKGS(1)
    compiler::compilePKGS(comp)
    if(comp) {
      comp = compiler::getCompilerOption("optimize")
    } else {
      comp = 0
    }
  }
  structure(comp, names = "byte_optimize")
}


#' System info
#' 
#' Returns \code{Sys.info()}
#' @export
get_sys_info = function() Sys.info()