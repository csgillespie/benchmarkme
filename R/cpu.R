#' CPU Description
#' 
#' Extracting the amount of RAM is OS specific and hence messy.
#' \itemize{
#' \item Linux: \code{/proc/cpuinfo}
#' \item Apple: \code{sysctl -n}
#' \item Windows: \code{??}
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
  }
  #   }  else {
  #     return(system("wmic cpu"))
  #   }
  list(vendor_id=vendor_id, model_name = model_name)
}

