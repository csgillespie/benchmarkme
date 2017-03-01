
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
#' @param cores Number of cores to try to use. Default is \code{detectCores}
#' @param verbose Default TRUE.
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
benchmark_mc = function(runs=3, cores = NULL, verbose=TRUE) {
  if(missing(cores)){
    cores <- parallel::detectCores()
  }
  rbind(benchmark_matrix_cal_mc(runs, cores, verbose)
  )
}
