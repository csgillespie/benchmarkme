to_bytes = function(value) {
  num = as.numeric(value[1])
  units = value[2]
  power = match(units, c("kB", "MB", "GB", "TB"))
  if (!is.na(power)) return(num * 1000 ^ power)

  power = match(units, c("Kilobytes", "Megabytes", "Gigabytes", "Terabytes"))
  if (!is.na(power)) return(num * 1000 ^ power)
  num
}

clean_ram = function(ram, os) {
  ram = stringr::str_squish(ram)
  ram = ram[nchar(ram) > 0L]
  if (length(ram) > 1 ||
      is.na(ram) ||
      length(grep("^solaris", os))) { # Don't care about solaris
    return(NA)
  }

  if (length(grep("^linux", os))) {
    clean_ram = clean_linux_ram(ram)
  } else if (length(grep("^darwin", os))) {
    clean_ram = clean_darwin_ram(ram) # nocov
  } else {
    clean_ram = clean_win_ram(ram) # nocov
  }
  unname(clean_ram)
}


clean_linux_ram = function(ram) {
  as.numeric(ram) * 1024 # convert to bits
}

clean_darwin_ram = function(ram) {
  as.numeric(ram)
}

clean_win_ram = function(ram) {
  sum(as.numeric(ram))
}
