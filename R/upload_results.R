#' @title Upload benchmark results
#' 
#' @description This function uploads the benchmarking results. These results will then be incorparated
#' in future versions of the package.
#' @param results Benchmark results. Probably obtained from \code{benchmark_all()}.
#' @param url The location of where to upload the results.
#' @inheritParams get_sys_details
#' @export
#' @importFrom httr POST upload_file
upload_results = function(results, url="http://www.mas.ncl.ac.uk/~ncsg3/form.php",
                          sys_info = TRUE, platform_info = TRUE,
                          r_version = TRUE, ram=TRUE, 
                          cpu=TRUE, byte_compiler=TRUE, linear_algebra=TRUE,
                          installed_packages=TRUE) {
  
  type = get_sys_details(sys_info=sys_info, platform_info=platform_info, 
                         r_version = r_version, ram=ram, cpu=cpu,
                         byte_compiler = byte_compiler, linear_algebra = linear_algebra,
                         installed_packages = installed_packages)
  type$results = results
  message("Creating temporary file")
  fname = tempfile(fileext=".RData")
  saveRDS(type, file=fname)
  message("Uploading results")
  r = POST(url, 
           body = list(userFile = upload_file(fname)),
           encode = "multipart")
  unlink(fname)        
  message("Upload complete")
  message("Tracking id: ", type$id)
  type$id
}
