#' @importFrom compiler getCompilerOption
#' @export
get_byte_compiler = function() {
  optimize = compiler::getCompilerOption("optimize")
  structure(optimize, names = "byte_optimize")
}

#' @export
get_sys_info = function(){
  sys_info = as.list(Sys.info())
  sys_info = c(sys_info, get_ram(), get_cpu(), get_byte_compiler())
  sys_info$date = structure(Sys.Date(), class="Date")
  sys_info
}