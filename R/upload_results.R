#' @param filename default \code{NULL}. A character vector of where to 
#' store the results (in an .rds file). If \code{NULL}, results are not saved.
#' @rdname upload_results
#' @export
create_bundle = function(results, filename = NULL, args = NULL) {
  if(is.null(args)) args = list()
  message("Getting system specs. This can take a while on Macs")
  type = do.call(get_sys_details, args)  
  
  type$results = results
  
  if(!is.null(filename)) {
    saveRDS(type, file = filename)
  } 
  type
}

#' @title Upload benchmark results
#' 
#' @description This function uploads the benchmarking results. 
#' These results will then be incorparated
#' in future versions of the package.
#' @param results Benchmark results. Probably obtained from 
#' \code{benchmark_std()} or \code{benchmark_io()}.
#' @param url The location of where to upload the results.
#' @param args Default \code{NULL}. A list of arguments to 
#' be passed to \code{get_sys_details()}. 
#' @param id_prefix Character string to prefix the benchmark id. Makes it
#' easier to retrieve past results.
#' @export
#' @importFrom httr POST upload_file
#' @examples
#' ## Run benchmarks
#' \dontrun{
#' res = benchmark_std()
#' upload_results(res)
#' }
upload_results = function(results, 
                          url = "http://www.mas.ncl.ac.uk/~ncsg3/form.php",
                          args = NULL, 
                          id_prefix = "") {
  message("Creating temporary file")
  fname = tempfile(fileext = ".rds")
  type = create_bundle(results, fname)
  
  message("Uploading results")
  r = httr::POST(url, 
           body = list(userFile = httr::upload_file(fname)),
           encode = "multipart")
  unlink(fname)        
  type$id = paste0(id_prefix, type$id)
  message("Upload complete")
  message("Tracking id: ", type$id)
  type$id
}
