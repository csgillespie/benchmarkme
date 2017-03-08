
#' Run multicore benchmarks
#' 
#' @description This function runs a set of multicore benchmarks, which should be suitable for most
#' machines. It runs a collection of matrix benchmark functions
#' \itemize{
#' \item \code{benchmark_prog}
#' \item \code{benchmark_matrix_cal}
#' \item \code{benchmark_matrix_fun}
#' }
#' To view the list of benchmarks, see \code{get_available_benchmarks}.
#' @param runs Number of times to run the test. Default 3.
#' @param verbose Default TRUE.
#' @param cores Number of cores to try to use. Default is \code{detectCores}
#' @importFrom parallel detectCores
#' @import foreach
#' @export
#' @examples 
#' ## Benchmark your system
#' \dontrun{
#' res = benchmark_std(3)
#' 
#' ## Plot results
#' plot(res)
#' }
benchmark_mc = function(runs=3, verbose=TRUE, cores = NULL) {
  if(missing(cores)){
    cores <- parallel::detectCores()
  }
  coreList <- 2^(0:sqrt(cores))
  maxCores <- max(coreList)
  results <- data.frame(user = NA, system = NA, elapsed = NA, test = NA, 
                        test_group = NA, cores = NA)
  for(i in coreList){
    cl <- parallel::makeCluster(i)
    doParallel::registerDoParallel(cl)
    res <- rbind(benchmark_prog_mc(runs, verbose, maxCores),
                 benchmark_matrix_cal_mc(runs, verbose, maxCores))
    res$cores <- i
    results <- rbind(results, res)
    parallel::stopCluster(cl)
    rm(res)
  }
  results <- na.omit(results)
  return(results)
  
}
