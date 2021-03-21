# Try to find sysctl in Macs
get_sysctl = function() {
  cmd = Sys.which("sysctl")
  if (nchar(cmd) == 0) cmd = "/usr/sbin/sysctl"

  if (!file.exists(cmd)) cmd = "/sbin/sysctl"

  if (!file.exists(cmd)) cmd = NA

  return(cmd)
}
