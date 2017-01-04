.onAttach = function(...) {
  if (!interactive()) return()
  msg = "See https://jumpingrivers.shinyapps.io/benchmarkme/ for a Shiny interface to the benchmark data."
  
  packageStartupMessage(paste(strwrap(msg), collapse = "\n"))
}