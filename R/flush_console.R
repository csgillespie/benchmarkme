flush_console = function()
  if (R.Version()$os == "Win32" || R.Version()$os == "mingw32") flush.console()