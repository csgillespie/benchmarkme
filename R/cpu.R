
#' @export
get_cpu = function() {
  os = R.version$os
  if(length(grep("^linux", os))) {
    cmd  = "awk '/vendor_id/' /proc/cpuinfo"
    vendor_id = gsub("vendor_id\t: ", "", unique(system(cmd, intern=TRUE)))
    
    cmd  = "awk '/model name/' /proc/cpuinfo"
    model_name = gsub("model name\t: ", "", unique(system(cmd, intern=TRUE)))
  }
#   } else if(length(grep("^darwin", os))) {
#     #(ram = system('system_profiler -detailLevel mini | grep "  Memory:"'))
#     #ram = to_Bytes(unlist(strsplit(ram, " ")))
#   }  else {
#     return(system("wmic cpu"))
#   }
  list(vendor_id=vendor_id, model_name = model_name)
}


# $ /usr/sbin/system_profiler SPHardwareDataType
#
# Hardware:
#
#   Hardware Overview:
#
#   Model Name: iMac
# Model Identifier: iMac7,1
# Processor Name: Intel Core 2 Duo
# Processor Speed: 2.4 GHz
# Number of Processors: 1
# Total Number of Cores: 2
# L2 Cache: 4 MB
# Memory: 4 GB
# Bus Speed: 800 MHz
