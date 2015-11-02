#' @export
get_all = function() {
  list(ram = get_ram(), 
       cpu = get_cpu(), 
       r_version = get_r_version(), 
       byte_compiler = get_byte_compiler(), 
       platform_info = get_platform_info())
}


