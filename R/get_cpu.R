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
  cpu = try(get_cpu_internal(), silent = TRUE)
  if (class(cpu) == "try-error") {
    message("\t Unable to detect your CPU.
            Please raise an issue at https://github.com/csgillespie/benchmarkme") # nocov
    cpu = list(vendor_id = NA_character_, model_name = NA_character_) # nocov
  }
  cpu$no_of_cores = parallel::detectCores()
  cpu
}

get_cpu_internal = function() {
  os = R.version$os
  if (length(grep("^linux", os))) {
    cmd  = "awk '/vendor_id/' /proc/cpuinfo"
    vendor_id = gsub("vendor_id\t: ", "", unique(system(cmd, intern = TRUE)))
    cmd  = "awk '/model name/' /proc/cpuinfo"
    model_name = gsub("model name\t: ", "", unique(system(cmd, intern = TRUE)))
  } else if (length(grep("^darwin", os))) {
    sysctl = get_sysctl()
    if (is.na(sysctl)) {
      vendor_id = model_name = NA
    } else {
      vendor_id = system(paste(sysctl, "-n machdep.cpu.vendor"), intern = TRUE) # nocov
      model_name = system(paste(sysctl, "-n machdep.cpu.brand_string"), intern = TRUE) # nocov
    }
  } else if (length(grep("^solaris", os))) {
    vendor_id = NA # nocov
    model_name = NA # nocov
  } else {
    ## CPU
    model_name = system("wmic cpu get name", intern = TRUE)[2] # nocov
    vendor_id = system("wmic cpu get manufacturer", intern = TRUE)[2] # nocov
  }
  list(vendor_id = remove_white(vendor_id),
       model_name = remove_white(model_name),
       no_of_cores = parallel::detectCores())
}
