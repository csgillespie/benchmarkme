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
#' \item \code{get_linear_algebra()};
#' \item \code{installed.packages()}
#' \item The current date.
#' }
#' @return A list
#' @export
get_sys_details = function() {
  l = list()
  l$sys_info = as.list(Sys.info())
  l$platform_info = get_platform_info()
  l$r_version = get_r_version()
  l$ram = as.list(get_ram())
  l$cpu = get_cpu()
  l$byte_compiler = as.list(get_byte_compiler())
  l$linear_algebra = get_linear_algebra()
  l$install_packages = installed.packages()
  l$date = structure(Sys.Date(), class="Date")
  l  
}
