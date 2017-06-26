system_ram = function(os) {
  if(length(grep("^linux", os))) {
    cmd = "awk '/MemTotal/ {print $2}' /proc/meminfo"
    ram = system(cmd, intern=TRUE)
  } else if(length(grep("^darwin", os))) {
    ram = substring(system("sysctl hw.memsize", intern = TRUE), 13) #nocov
  } else if(length(grep("^solaris", os))) {
    cmd = "prtconf | grep Memory" # nocov
    ram = system(cmd, intern=TRUE) ## Memory size: XXX Megabytes # nocov
  } else {
    ram = system("wmic MemoryChip get Capacity", intern=TRUE)[-1] # nocov
  }
  ram
}

#' Get the amount of RAM
#' 
#' Attempt to extract the amount of RAM on the current machine. This is OS 
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
  ram = suppressWarnings(try(system_ram(os), silent = TRUE))
  if(class(ram) == "try-error" || length(ram) == 0) {
    message("\t Unable to detect your RAM. # nocov
            Please raise an issue at https://github.com/csgillespie/benchmarkme") # nocov
    ram = structure(NA, names="ram") # nocov
  } else {
    cleaned_ram = suppressWarnings(try(clean_ram(ram,os), silent=TRUE))
    if(class(cleaned_ram) == "try-error" || length(ram) == 0) {
      message("\t Unable to detect your RAM. # nocov 
            Please raise an issue at https://github.com/csgillespie/benchmarkme") # nocov
      ram = structure(NA, names="ram") #nocov
    } else {
      ram = structure(cleaned_ram, class = "bytes", names="ram")
    }
  }
  return(ram)
}

## Not sure why export doesn't work here
#' @rawNamespace S3method(print,bytes)
print.bytes = function (x, digits = 3, unit_system = c("metric", "iec"), ...) {
  unit_system = match.arg(unit_system)
  base = switch(unit_system, metric = 1000, iec = 1024)
  power = min(floor(log(abs(x), base)), 8)
  if (power < 1) {
    unit = "B"
  } else {
    unit_labels = switch(
      unit_system,
      metric = c("kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"),
      iec = c("KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB")
    )
    unit = unit_labels[[power]]
    x = x/(base^power)
  }
  formatted = format(signif(x, digits = digits), big.mark = ",", 
    scientific = FALSE, ...)
  cat(unclass(formatted), " ", unit, "\n", sep = "")
  invisible(paste(unclass(formatted), unit))
}
