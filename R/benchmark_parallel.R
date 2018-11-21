#' Benchmark in parallel
#' 
#' This function runs benchmarks in parallel to test multithreading
#' @param bm character name of benchmark function to run from \code{\link{get_available_benchmarks}}
#' @param runs number of runs of benchmark to make
#' @param verbose display messages during benchmarking
#' @param cores number of cores to benchmark. If cores is specified, the benchmark is also 
#' run for cores = 1 to allow for normalisation. 
#' @param ... additional arguments to pass to \code{bm}
#' @import parallel
#' @import foreach
#' @import doParallel
#' @export
#' @examples 
#' \dontrun{
#' bm_parallel("bm_matrix_cal_manip", runs = 3, verbose = TRUE, cores = 2)
#' bm = c("bm_matrix_cal_manip","bm_matrix_cal_power", "bm_matrix_cal_sort", 
#'        "bm_matrix_cal_cross_product", "bm_matrix_cal_lm")
#' results = lapply(bm, bm_parallel, 
#'                 runs = 5, verbose = TRUE, cores = 2L)
#' }
#' @importFrom foreach foreach %dopar%
bm_parallel = function(bm, runs, verbose, cores, ...){
  args = list(...)
  args[['runs']] = 1
  
  #TODO consider dropping first results from parallel results due to overhead
  results = data.frame(user = NA, system = NA, elapsed = NA, test = NA, 
                        test_group = NA, cores = NA)
  for(core in cores) {
    cl = parallel::makeCluster(core, outfile = "")
    
    parallel::clusterExport(cl, bm) # Export 
    doParallel::registerDoParallel(cl)
    tmp = data.frame(user = numeric(length(runs)), system = 0, elapsed = 0,
                     test = NA, test_group = NA, cores = NA, stringsAsFactors = FALSE)

    args$runs = 1
    for(j in 1:runs){
      tmp[j, 1:3] <- system.time({
        out <- foreach(k = 1:(core)) %dopar% 
          do.call(bm, args, quote = TRUE) #, envir = environment(bm_parallel))
      })[1:3]
    }
    tmp$cores = core
    tmp$test = as.character(out[[1]]$test)[1]
    tmp$test_group = as.character(out[[1]]$test_group)[1]
    results = rbind(results, tmp)
    parallel::stopCluster(cl)# Would be nice to have on.exit here, but we run out of memory
  }
  
  return(na.omit(results))
}

