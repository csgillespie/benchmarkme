to_Bytes = function(value) {
  num = as.numeric(value[1])
  units = value[2]
  power = match(units, c("kB", "MB", "GB", "TB"))
  if(!is.na(power)) return(num*1000^power)
  
  power = match(units, c("Kilobytes", "Megabytes", "Gigabytes", "Terabytes"))
  if(!is.na(power)) return(num*1000^power)
  num
}

clean_linux_ram = function(ram) {
  as.numeric(ram)*1000
}
clean_darwin_ram = function(ram) {
  ram = remove_white(ram)
  to_Bytes(unlist(strsplit(ram, " "))[2:3])
}
  
clean_solaris_ram = function(ram) {
  ram = remove_white(ram)
  to_Bytes(unlist(strsplit(ram, " "))[3:4])
}

clean_win_ram = function(ram) {
    ram = remove_white(ram)
    ram = ram[nchar(ram) > 0]
    sum(as.numeric(ram))
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
    ram = system(cmd, intern=TRUE)
    clean_ram = suppressWarnings(try(clean_linux_ram(ram), silent=TRUE))
  } else if(length(grep("^darwin", os))) {
    (ram = system('system_profiler -detailLevel mini | grep "  Memory:"', intern=TRUE)[1])
    clean_ram = suppressWarnings(try(clean_darwin_ram(ram), silent=TRUE))
  } else if(length(grep("^solaris", os))) {
    cmd = "prtconf | grep Memory"
    ram = system(cmd, intern=TRUE) ## Memory size: XXX Megabytes
    clean_ram = suppressWarnings(try(clean_solaris_ram(ram), silent=TRUE))
  } else {
    ram = system("wmic MemoryChip get Capacity", intern=TRUE)[-1]
    clean_ram = suppressWarnings(try(clean_win_ram(ram), silent=TRUE))
  }
  
  if(!(class(clean_ram) == "try-error")) ram = clean_ram
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