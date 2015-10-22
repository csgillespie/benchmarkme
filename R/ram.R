to_Bytes = function(value) {
  num = as.numeric(value[1])
  units = value[2]
  power = match(units, c("kB", "MB", "GB", "TB"))
  if(!is.na(power)) return(num*1000^power)

  power = match(units, c("Kilobytes", "Megabytes", "Gigabytes", "Terabytes"))
  if(!is.na(power)) return(num*1000^power)

}


#' @export
get_ram = function() {
  os = R.version$os
  if(length(grep("^linux", os))) {
    cmd = "awk '/MemFree/ {print $2}' /proc/meminfo"
    ram = as.numeric(system(cmd, intern=TRUE))*1000
  } else if(length(grep("^darwin", os))) {
    (ram = system('system_profiler -detailLevel mini | grep "  Memory:"'))
    ram = to_Bytes(unlist(strsplit(ram, " ")))
  } else if(length(grep("^solaris", os))) {
    cmd = "prtconf | grep Memory"
    ram = system(cmd) ## Memory size: XXX Megabytes
    ram = to_Bytes(unlist(strsplit(ram, " "))[3:4])
  }  else {
    ram =  memory.size()
  }
  structure(ram, class="bytes")
}

#' @references Taken from the pryr package
#' @export
print.bytes = function (x, digits = 3, ...) 
{
  power <- min(floor(log(abs(x), 1000)), 4)
  if (power < 1) {
    unit <- "B"
  }
  else {
    unit <- c("kB", "MB", "GB", "TB")[[power]]
    x <- x/(1000^power)
  }
  formatted <- format(signif(x, digits = digits), big.mark = ",", 
                      scientific = FALSE)
  cat(formatted, " ", unit, "\n", sep = "")
}