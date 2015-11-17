#' @export
get_all = function() {

  list(r_version = get_r_version(), 
       platform_info = get_platform_info(), 
       sys_info = get_sys_info())
}

#' @export
save_results = function(filename, results=NULL, ...) {
  if(is.null(results)) 
    results = benchmark_all(...)
  type = get_all()
  type$results = results
  saveRDS(type, file=filename)
}


# @export
# upload = function(results) {
#   
#  tmp = serialize(results, NULL)
#  
#   x = unserialize(tmp)
#   x
# }
