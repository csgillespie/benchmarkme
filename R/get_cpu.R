#' CPU Description
#' 
#' Attempt to extract the CPU model on the current host. This is OS 
#' specific:
#' \itemize{
#' \item Linux: \code{/proc/cpuinfo}
#' \item Apple: \code{sysctl -n}
#' \item Solaris: Not implemented.
#' \item Windows: \code{wmic cpu}
#' }
#' A value of \code{NA} is return if it isn't possible to obtain the CPU.
#' @importFrom parallel detectCores
#' @export
#' @examples 
#' ## Return the machine CPU
#' get_cpu()
get_cpu = function() {
  cpu = try(get_cpu_internal(), silent=TRUE)
  if(class(cpu) == "try-error") {
    message("\t Unable to detect your CPU. 
            Please raise an issue at https://github.com/csgillespie/benchmarkme")
    cpu = list(vendor_id = NA_character_, model_name = NA_character_)
  }
  cpu$no_of_cores = parallel::detectCores()
  cpu
}


get_cpu_internal = function() {
  os = R.version$os
  if(length(grep("^linux", os))) {
    cmd  = "awk '/vendor_id/' /proc/cpuinfo"
    vendor_id = gsub("vendor_id\t: ", "", unique(system(cmd, intern=TRUE)))
    cmd  = "awk '/model name/' /proc/cpuinfo"
    model_name = gsub("model name\t: ", "", unique(system(cmd, intern=TRUE)))
  } else if(length(grep("^darwin", os))) {
    vendor_id = system("sysctl -n machdep.cpu.vendor",intern=TRUE) 
    model_name = system("sysctl -n machdep.cpu.brand_string",intern=TRUE) 
  } else if(length(grep("^solaris", os))) {
    vendor_id = NA
    model_name = NA
  } else {
    ## CPU
    model_name = system("wmic cpu get name", intern=TRUE)[2]
    vendor_id = system("wmic cpu get manufacturer", intern=TRUE)[2]
  }
  list(vendor_id=remove_white(vendor_id), 
       model_name = remove_white(model_name), 
       no_of_cores = parallel::detectCores())
}
