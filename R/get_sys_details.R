#' General system information
#' 
#' The \code{get_sys_info} returns general system level information as a list. The 
#' function parameters control the information to upload. If a parameter is set to
#' \code{FALSE}, an \code{NA} is uploaded instead. Each element of the list
#' is contains the output from: 
#' \itemize{
#' \item \code{Sys.info()};
#' \item \code{get_platform_info()};
#' \item \code{get_r_version()};
#' \item \code{get_ram()};
#' \item \code{get_cpu()};
#' \item \code{get_byte_compiler()};
#' \item \code{get_linear_algebra()};
#' \item \code{installed.packages()};
#' \item The package version number;
#' \item Unique ID - used to extract results;
#' \item The current date.
#' }
#' @param sys_info Default \code{TRUE}.
#' @param platform_info Default \code{TRUE}.
#' @param r_version Default \code{TRUE}.
#' @param ram Default \code{TRUE}.
#' @param cpu Default \code{TRUE}.
#' @param byte_compiler Default \code{TRUE}.
#' @param linear_algebra Default \code{TRUE}.
#' @param installed_packages Default \code{TRUE}.
#' @return A list
#' @export
get_sys_details = function(sys_info = TRUE, platform_info = TRUE,
                           r_version = TRUE, ram=TRUE, 
                           cpu=TRUE, byte_compiler=TRUE, linear_algebra=TRUE,
                           installed_packages=TRUE) {
  l = list()
  l$sys_info = ifelse(sys_info, as.list(Sys.info()), NA)
  l$platform_info = ifelse(platform_info, get_platform_info(), NA)
  l$r_version = ifelse(r_version, get_r_version(), NA)
  l$ram = ifelse(ram, as.list(get_ram()), NA)
  l$cpu = ifelse(cpu, get_cpu(), NA)
  l$byte_compiler = ifelse(byte_compiler, as.list(get_byte_compiler()), NA)
  l$linear_algebra = ifelse(linear_algebra, get_linear_algebra(), NA)
  l$installed_packages = ifelse(installed_packages, installed.packages(), NA)
  l$package_version = packageDescription("benchmarkme")$Version
  l$id = paste0(Sys.Date(), "-", sample(1e8, 1))
  l$date = structure(Sys.Date(), class="Date")
  l  
}
