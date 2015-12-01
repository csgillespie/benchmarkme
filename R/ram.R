to_Bytes = function(value) {
  num = as.numeric(value[1])
  units = value[2]
  power = match(units, c("kB", "MB", "GB", "TB"))
  if(!is.na(power)) return(num*1000^power)
  
  power = match(units, c("Kilobytes", "Megabytes", "Gigabytes", "Terabytes"))
  if(!is.na(power)) return(num*1000^power)
  num
}

#' Get the amount of RAM
#' 
#' Extracting the amount of RAM is OS specific and hence messy.
#' \itemize{
#' \item Linux: \code{proc/meminfo}
#' \item Apple: \code{system_profiler -detailLevel mini}
#' \item Windows: \code{memory.size()}
#' \item Solaris: \code{prtconf}
#' }
#' @export
#' @examples 
#' get_ram()
get_ram = function() {
  os = R.version$os
  
  if(length(grep("^linux", os))) {
    cmd = "awk '/MemTotal/ {print $2}' /proc/meminfo"
    ram = as.numeric(system(cmd, intern=TRUE))*1000
  } else if(length(grep("^darwin", os))) {
    (ram = system('system_profiler -detailLevel mini | grep "  Memory:"', intern=TRUE)[1])
    ram = to_Bytes(unlist(strsplit(ram, " ")))
  } else if(length(grep("^solaris", os))) {
    cmd = "prtconf | grep Memory"
    ram = system(cmd, intern=TRUE) ## Memory size: XXX Megabytes
    ram = to_Bytes(unlist(strsplit(ram, " "))[3:4])
  } else {
    ## Ram
    ram = system("wmic MemoryChip get Capacity", intern=TRUE)[-1]
    ram = remove_white(ram)
    ram = ram[nchar(ram) > 0]
    ram = sum(as.numeric(ram))
  }
  if(is.na(ram)) {
    message("I'm having trouble detecting your RAM. So try a number of things to help future versions")
    ## Hack to see what's happening on MACs - why can't everyone use Linux
    ram1 = system('system_profiler -detailLevel mini | grep "  Memory:"', intern=TRUE)
    ram2 = system("awk '/MemFree/ {print $2}' /proc/meminfo", intern=TRUE)
    ram3 = system("wmic MemoryChip get Capacity", intern=TRUE)
    return(list(ram1, ram2, ram3))
  }
  
  structure(ram, class="bytes", names="ram")
}


# @references The print.bytes function was taken from the pryr package.
#' @S3method  print bytes
print.bytes = function (x, digits = 3, ...) 
{
  power <- min(floor(log(abs(x), 1000)), 4)
  if (power < 1) {
    unit <- "B"
  } else {
    unit <- c("kB", "MB", "GB", "TB")[[power]]
    x <- x/(1000^power)
  }
  formatted <- format(signif(x, digits = digits), big.mark = ",", 
                      scientific = FALSE)
  cat(formatted, " ", unit, "\n", sep = "")
}