get_windows_ram = function() {
  ram = try(system("grep MemTotal /proc/meminfo", intern = TRUE), silent = TRUE)
  if (class(ram) != "try-error" && length(ram) != 0) {
    ram = strsplit(ram, " ")[[1]]
    mult = switch(ram[length(ram)],
                  "B" = 1L,
                  "kB" = 1024L,
                  "MB" = 1048576L)
    ram = as.numeric(ram[length(ram) - 1])
    ram_size = ram * mult
  } else {
    # Fallback: This was the old method I used
    # It worked for Windows 7 and below.
    ram_size = system("wmic MemoryChip get Capacity", intern = TRUE)[-1]
  }
  return(ram_size)
}

system_ram = function(os) {
  if (length(grep("^linux", os))) {
    cmd = "awk '/MemTotal/ {print $2}' /proc/meminfo"
    ram = system(cmd, intern = TRUE)
  } else if (length(grep("^darwin", os))) {
    ram = substring(system("sysctl hw.memsize", intern = TRUE), 13) #nocov
  } else if (length(grep("^solaris", os))) {
    cmd = "prtconf | grep Memory" # nocov
    ram = system(cmd, intern = TRUE) ## Memory size: XXX Megabytes # nocov
  } else {
    ram = get_windows_ram() # nocov
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
#' \item Windows: First tries \code{grep MemTotal /proc/meminfo} then falls back to
#' \code{wmic MemoryChip get Capacity}
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
  if (class(ram) == "try-error" || length(ram) == 0) {
    message("\t Unable to detect your RAM. # nocov
            Please raise an issue at https://github.com/csgillespie/benchmarkme") # nocov
    ram = structure(NA, class = "ram") # nocov
  } else {
    cleaned_ram = suppressWarnings(try(clean_ram(ram, os), silent = TRUE))
    if (class(cleaned_ram) == "try-error" || length(ram) == 0) {
      message("\t Unable to detect your RAM. # nocov
            Please raise an issue at https://github.com/csgillespie/benchmarkme") # nocov
      ram = structure(NA, class = "ram") #nocov
    } else {
      ram = structure(cleaned_ram, class = "ram")
    }
  }
  return(ram)
}

#' @rawNamespace S3method(print,ram)
print.ram = function(x, digits = 3, unit_system = c("metric", "iec"), ...) {
  unit_system = match.arg(unit_system)
  #unit_system = "metric"
  base = switch(unit_system, metric = 1000, iec = 1024)
  power = min(floor(log(abs(x), base)), 8)
  if (is.na(x) || power < 1) {
    unit = "B"
  } else {
    unit_labels = switch(
      unit_system,
      metric = c("kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"),
      iec = c("KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB")
    )
    unit = unit_labels[[power]]
    x = x / (base^power)
  }

  formatted = format(signif(x, digits = digits), big.mark = ",",
    scientific = FALSE, ...)
  cat(unclass(formatted), " ", unit, "\n", sep = "")
  invisible(paste(unclass(formatted), unit))
}
