#' @title Upload benchmark results
#' @param results Benchmark results. Probably obtained from \code{benchmark_all()}.
#' @param url The location of where to upload the results.
#' @export
#' @importFrom httr POST upload_file
upload_results = function(results, url="http://www.mas.ncl.ac.uk/~ncsg3/form.php") {
  type = get_sys_details()
  type$results = results
  fname = tempfile(fileext=".RData")
  saveRDS(results, file=fname)
  r = POST(url, 
           body = list(userFile = upload_file(fname)),
                       encode = "multipart")
  unlink(fname)        
  
}

