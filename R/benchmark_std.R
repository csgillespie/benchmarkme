#' Run standard benchmarks
#' 
#' @description This function runs a set of standard benchmarks, which should be suitable for most
#' machines. It runs a collection of matrix benchmark functions
#' \itemize{
#' \item \code{benchmark_prog}
#' \item \code{benchmark_matrix_cal}
#' \item \code{benchmark_matrix_fun}
#' }
#' To view the list of benchmarks, see \code{get_available_benchmarks}.
#' @param runs Number of times to run the test. Default 3.
#' @param cores Default 0 (serial). When cores > 0, the benchmark is run in parallel.
#' @param verbose Default TRUE.
#' @details Setting \code{cores} equal to 1 is useful for assessing the impact of the 
#' parallel computing overhead.  
#' @export
#' @examples 
#' ## Benchmark your system
#' \dontrun{
#' res = benchmark_std(3)
#' 
#' ## Plot results
#' plot(res)
#' }
benchmark_std = function(runs = 3, verbose = TRUE, cores = 0L) {
  rbind(benchmark_prog(runs, verbose, cores), 
        benchmark_matrix_cal(runs, verbose, cores),
        benchmark_matrix_fun(runs, verbose, cores))
}
