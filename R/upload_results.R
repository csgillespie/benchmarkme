#' @title Upload results
#' @export
#' @importFrom httr POST upload_file
upload_results = function(results) {
  type = get_sys_details()
  type$results = results
  url = "http://www.mas.ncl.ac.uk/~ncsg3/form.php"
  fname = tempfile(fileext=".RData")
  saveRDS(results, file=fname)
  r = POST(url, 
           body = list(userFile = upload_file(fname)),
                       encode = "multipart")
  unlink(fname)        
  
}

