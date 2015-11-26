#' Byte compiler status
#' 
#' Attempts to detect if byte compiling has been used on the package.
#' @return An integer indicating if byte compiling has been turn on. See \code{?compiler} for
#' details.
#' @importFrom compiler getCompilerOption
#' @export
get_byte_compiler = function() {
  optimize = compiler::getCompilerOption("optimize")
  structure(optimize, names = "byte_optimize")
}


#' System info
#' 
#' Returns \code{Sys.info()}
#' @export
get_sys_info = function() Sys.info()