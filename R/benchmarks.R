run_benchmarks = function(bm, runs, verbose, cores = NULL) {
  if(missing(cores)){
    results = lapply(bm, do.call, list(runs=runs, verbose=verbose), 
                     envir = environment(run_benchmarks))
    results = Reduce("rbind", results)
    results$cores <- 0
  } else{
    results <- lapply(bm, bm_parallel, 
                      runs = runs, verbose = verbose, cores = cores)
    results = Reduce("rbind", results)
  }
  
  
  class(results) = c("ben_results", class(results))
  results
}


#' Benchmark in parallel
#' 
#' This function runs benchmarks in parallel to test multithreading
#' @param bm character name of benchmark function to run from \code{\link{get_available_benchmarks}}
#' @param runs number of runs of benchmark to make
#' @param verbose display messages during benchmarking
#' @param cores number of cores to benchmark
#' @param ... additional arguments to pass to \code{bm}
#' @description When a user specifies cores, the benchmark will be run on a 
#' maximum number of cores, and all counts descending in powers of 2 from that 
#' maximum. If a user specifies 6 cores, then the benchmarks will be repeated 
#' for 6 core, 4 core, 2 core, and finally single core performance. 
#' @export
#' @import parallel
#' @import foreach
#' @import doParallel
#' @examples 
#' \dontrun{
#' bm_parallel("bm_matrix_cal_manip", runs = 3, verbose = TRUE, cores = 2)
#' bm <- c("bm_matrix_cal_manip","bm_matrix_cal_power", "bm_matrix_cal_sort", 
#' "bm_matrix_cal_cross_product", "bm_matrix_cal_lm")
#' results <- lapply(bm, bm_parallel, 
#'                 runs = 5, verbose = TRUE, cores = 2L)
#' }
bm_parallel <- function(bm, runs, verbose, cores, ...){
  args <- list(...)
  args[['runs']] <- 1
  if(cores == 1){
    coreList <- 1
  } else{
    coreList <- unique(c(2^(0:sqrt(cores)), cores))
  }
  maxCores <- max(coreList)
  K <- maxCores
  #TODO consider dropping first results from parallel results due to overhead
  results <- data.frame(user = NA, system = NA, elapsed = NA, test = NA, 
                        test_group = NA, cores = NA)
  for(i in coreList){
    cl <- parallel::makeCluster(i)
    doParallel::registerDoParallel(cl)
    tmp <- data.frame(user = numeric(runs), system=0, elapsed=0,
                      test=NA, test_group=NA, cores = NA)
    for(j in 1:runs){
      tmp[j, 1:3] <- system.time({
        out <- foreach(k = 1:K,  .export = bm) %dopar% 
          do.call(bm, args, quote = TRUE) #, envir = environment(bm_parallel))
      })[1:3]
    }
    tmp$cores <- i
    tmp$test <- as.character(out[[1]]$test)
    tmp$test_group <- as.character(out[[1]]$test_group)
    results <- rbind(results, tmp)
    parallel::stopCluster(cl)
  }
  return(na.omit(results))
}

#' Available benchmarks
#' 
#' The function returns the available benchmarks
#' @export
#' @examples 
#' get_available_benchmarks()
get_available_benchmarks = function() {
  c("benchmark_std", "benchmark_prog", "benchmark_matrix_cal", 
    "benchmark_matrix_fun", "benchmark_io")
}


#' @inheritParams benchmark_std
#' @rdname bm_prog_fib
#' @export
benchmark_prog = function(runs=3, verbose=TRUE, ...) {
  bm = c("bm_prog_fib", "bm_prog_gcd", "bm_prog_hilbert", 
         "bm_prog_toeplitz", "bm_prog_escoufier")
  if(verbose)
    message("# Programming benchmarks (5 tests):")
  
  run_benchmarks(bm, runs, verbose, ...)
}

#' @inheritParams benchmark_std
#' @rdname bm_matrix_cal_manip
#' @export
benchmark_matrix_cal = function(runs=3, verbose=TRUE, ...) {
  bm =  c("bm_matrix_cal_manip","bm_matrix_cal_power", "bm_matrix_cal_sort", 
           "bm_matrix_cal_cross_product", "bm_matrix_cal_lm")
  if(verbose)
    message("# Matrix calculation benchmarks (5 tests):")
  
  run_benchmarks(bm, runs, verbose, ...)
}

#' @inheritParams benchmark_std
#' @rdname bm_matrix_fun_fft
#' @export
benchmark_matrix_fun = function(runs=3, verbose=TRUE, ...) {
  bm = c("bm_matrix_fun_cholesky", "bm_matrix_fun_determinant",
         "bm_matrix_fun_eigen", "bm_matrix_fun_fft",
         "bm_matrix_fun_inverse")
  if(verbose)
    message("# Matrix function benchmarks (5 tests):")
  run_benchmarks(bm, runs, verbose, ...)  
}


