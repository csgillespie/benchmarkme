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


#' General system information
#' 
#' The \code{get_sys_info} returns general system level information as a list. Each element of the list
#' is contains the output from: 
#' \itemize{
#' \item \code{Sys.info()};
#' \item \code{get_platform_info()};
#' \item \code{get_r_version()};
#' \item \code{get_ram()};
#' \item \code{get_cpu()};
#' \item \code{get_byte_compiler()};
#' \item The current date.
#' }
#' @return A list
#' @export
get_sys_info = function(){
  l = list()
  l$sys_info = as.list(Sys.info())
  l$platform_info = as.list(get_platform_info())
  l$r_version = as.list(get_r_version())
  l$ram = as.list(get_ram())
  l$cpu = as.list(get_cpu())
  l$byte_compiler = as.list(get_byte_compiler())
              
  l$date = structure(Sys.Date(), class="Date")
  l
}