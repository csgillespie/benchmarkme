#' CPU Description
#' 
#' Extracting the amount of RAM is OS specific and hence messy.
#' \itemize{
#' \item Linux: \code{/proc/cpuinfo}
#' \item Apple: \code{sysctl -n}
#' \item Windows: \code{wmic cpu}
#' }
#' @export
get_cpu = function() {
  os = R.version$os
  if(length(grep("^linux", os))) {
    cmd  = "awk '/vendor_id/' /proc/cpuinfo"
    vendor_id = gsub("vendor_id\t: ", "", unique(system(cmd, intern=TRUE)))
    
    cmd  = "awk '/model name/' /proc/cpuinfo"
    model_name = gsub("model name\t: ", "", unique(system(cmd, intern=TRUE)))
  } else if(length(grep("^darwin", os))) {
    vendor_id = system("sysctl -n machdep.cpu.vendor",intern=TRUE) 
    model_name = system("sysctl -n machdep.cpu.brand_string",intern=TRUE) 
  }  else {
    ## CPU
    model_name = system("wmic cpu get name", intern=TRUE)[2]
    vendor_id = system("wmic cpu get manufacturer", intern=TRUE)[2]
  }
  list(vendor_id=remove_white(vendor_id), model_name = remove_white(model_name))
}

