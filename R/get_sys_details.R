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
#' \item \code{Sys.getlocale()}
#' \item \code{installed.packages()};
#' \item \code{.Machine}
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
#' @param locale Default \code{TRUE}
#' @param installed_packages Default \code{TRUE}.
#' @param machine Default \code{TRUE}
#' @return A list
#' @importFrom utils installed.packages packageDescription
#' @export
#' @examples
#' ## Returns all details about your machine
#' get_sys_details()
get_sys_details = function(sys_info = TRUE, platform_info = TRUE,
                           r_version = TRUE, ram=TRUE, 
                           cpu=TRUE, byte_compiler=TRUE, 
                           linear_algebra=TRUE,
                           locale = TRUE, installed_packages=TRUE,
                           machine=TRUE) {
  l = list()
  if(sys_info) l$sys_info = as.list(Sys.info())
  else l$sys_info = NA
  
  if(platform_info) l$platform_info = get_platform_info()
  else  l$platform_info = NA
  
  if(r_version) l$r_version = get_r_version()
  else l$r_version = NA
  
  if(ram) l$ram = get_ram()
  else l$ram  = NA
  
  if(cpu) l$cpu = get_cpu()
  else l$cpu = NA
  
  if(byte_compiler) l$byte_compiler = get_byte_compiler()
  else l$byte_compiler = NA
  
  if(linear_algebra) l$linear_algebra = get_linear_algebra()
  else l$linear_algebra = NA
  
  if(locale) l$locale = Sys.getlocale()
  else l$locale = NA
  
  if(installed_packages) l$installed_packages  = installed.packages()
  else   l$installed_packages = NA

  if(machine) l$machine = .Machine
  else l$machine = NA
  
  l$package_version = packageDescription("benchmarkme")$Version
  l$id = paste0(Sys.Date(), "-", sample(1e8, 1))
  l$date = structure(Sys.Date(), class="Date")
  l  
}
