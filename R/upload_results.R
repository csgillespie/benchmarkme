#' @title Upload benchmark results
#' 
#' @description This function uploads the benchmarking results. 
#' These results will then be incorparated
#' in future versions of the package.
#' @param results Benchmark results. Probably obtained from 
#' \code{benchmark_std()}.
#' @param url The location of where to upload the results.
#' @param args Default \code{NULL}. A list of arguments to 
#' be passed to \code{get_sys_details}. 
#' @export
#' @importFrom httr POST upload_file
#' @examples
#' ## Run benchmarks
#' \dontrun{
#' res = benchmark_std()
#' upload_results(res)
#' }
upload_results = function(results, 
                          url="http://www.mas.ncl.ac.uk/~ncsg3/form.php",
                          args = NULL) {

  if(is.null(args)) args = list()
  message("Getting system specs. This can take a while on Macs")
  type = do.call(get_sys_details, args)  

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
