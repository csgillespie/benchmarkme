#' @export
get_sys_details = function() {
  list(r_version = get_r_version(), 
       platform_info = get_platform_info(), 
       sys_info = get_sys_info(), 
       installed_packages = install.packages())
}


# @export
# upload = function(results) {
#   
#  tmp = serialize(results, NULL)
#  
#   x = unserialize(tmp)
#   x
# }
