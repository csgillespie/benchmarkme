to_Bytes = function(value) {
  num = as.numeric(value[1])
  units = value[2]
  power = match(units, c("kB", "MB", "GB", "TB"))
  if(!is.na(power)) return(num*1000^power)
  
  power = match(units, c("Kilobytes", "Megabytes", "Gigabytes", "Terabytes"))
  if(!is.na(power)) return(num*1000^power)
  num
}

clean_ram = function(ram, os) {
  if(is.na(ram)) return(NA)
  
  if(length(grep("^linux", os))) {
    clean_ram = clean_linux_ram(ram)
  } else if(length(grep("^darwin", os))) {
    clean_ram = clean_darwin_ram(ram)
  } else if(length(grep("^solaris", os))) {
    clean_ram = clean_solaris_ram(ram)
  } else {
    clean_ram = clean_win_ram(ram)
  }
  clean_ram
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
