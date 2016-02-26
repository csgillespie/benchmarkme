system_ram = function(os) {
  if(length(grep("^linux", os))) {
    cmd = "awk '/MemTotal/ {print $2}' /proc/meminfo"
    ram = system(cmd, intern=TRUE)
  } else if(length(grep("^darwin", os))) {
    (ram = system('system_profiler -detailLevel mini | grep "  Memory:"', intern=TRUE)[1])
  } else if(length(grep("^solaris", os))) {
    cmd = "prtconf | grep Memory"
    ram = system(cmd, intern=TRUE) ## Memory size: XXX Megabytes
  } else {
    ram = system("wmic MemoryChip get Capacity", intern=TRUE)[-1]
  }
  ram
}


#' Get the amount of RAM
#' 
#' Attempt to extract the amount of RAM on the current host. This is OS 
#' specific:
#' \itemize{
#' \item Linux: \code{proc/meminfo}
#' \item Apple: \code{system_profiler -detailLevel mini}
#' \item Windows: \code{memory.size()}
#' \item Solaris: \code{prtconf}
#' }
#' A value of \code{NA} is return if it isn't possible to determine the amount of RAM.
#' @export
#' @references The \code{print.bytes} function was taken from the \pkg{pryr} package.
#' @examples 
#' ## Return (and pretty print) the amount of RAM
#' get_ram()
get_ram = function() {
  os = R.version$os
  ram = try(system_ram(os), silent=TRUE)
  if(class(ram) == "try-error") {
    message("\t Unable to detect your RAM. 
            Please raise an issue at https://github.com/csgillespie/benchmarkme")
    ram = structure(NA, names="ram")
  } else {
    
    cleaned_ram = suppressWarnings(try(clean_ram(ram,os), silent=TRUE))
    
    if(class(cleaned_ram) == "try-error") {
      message("\t Unable to detect your RAM. 
            Please raise an issue at https://github.com/csgillespie/benchmarkme")
      ram = structure(NA, names="ram")
    } else {
      ram = structure(cleaned_ram, class="bytes", names="ram")
      
    }
  }
  return(ram)
}


#' @S3method  print bytes
print.bytes = function (x, digits = 3, ...) {
  power <- min(floor(log(abs(x), 1000)), 4)
  if (power < 1) {
    unit <- "B"
  } else {
    unit <- c("kB", "MB", "GB", "TB")[[power]]
    x <- x/(1000^power)
  }
  formatted <- format(signif(x, digits = digits), big.mark = ",", 
                      scientific = FALSE)
  cat(unclass(formatted), " ", unit, "\n", sep = "")
  invisible(paste(unclass(formatted), unit))
}
