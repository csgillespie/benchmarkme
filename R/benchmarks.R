run_benchmarks = function(bm, runs, verbose) {
  results = lapply(bm, do.call, list(runs=runs, verbose=verbose), envir = environment(run_benchmarks))
  results = Reduce("rbind", results)
  class(results) = c("ben_results", class(results))
  results
}

run_benchmarks_mc = function(bm, runs, verbose, cores) {
  results = lapply(bm, do.call, list(runs=runs, 
                                     verbose=verbose, 
                                     cores), 
                   envir = environment(run_benchmarks))
  results = Reduce("rbind", results)
  class(results) = c("ben_results", class(results))
  results
}


#' Available benchmarks
#' 
#' The function returns the available benchmarks
#' @export
#' @examples 
#' get_available_benchmarks()
get_available_benchmarks = function() {
  c("benchmark_std", "benchmark_prog", "benchmark_matrix_cal", "benchmark_matrix_fun", "benchmark_io")
}


#' @inheritParams benchmark_std
#' @rdname bm_prog_fib
#' @export
benchmark_prog = function(runs=3, verbose=TRUE) {
  bm = c("bm_prog_fib", "bm_prog_gcd", "bm_prog_hilbert", 
         "bm_prog_toeplitz", "bm_prog_escoufier")
  if(verbose)
    message("# Programming benchmarks (5 tests):")
  
  run_benchmarks(bm, runs, verbose)
}

#' @inheritParams benchmark_std
#' @rdname bm_matrix_cal_manip
#' @export
benchmark_matrix_cal = function(runs=3, verbose=TRUE) {
  bm =  c("bm_matrix_cal_manip","bm_matrix_cal_power", "bm_matrix_cal_sort", 
           "bm_matrix_cal_cross_product", "bm_matrix_cal_lm")
  if(verbose)
    message("# Matrix calculation benchmarks (5 tests):")
  
  run_benchmarks(bm, runs, verbose)
}

#' @inheritParams benchmark_mc
#' @rdname bm_matrix_cal_manip
#' @export
benchmark_matrix_cal_mc = function(runs=3, verbose=TRUE, cores = NULL) {
  bm =  c("bm_matrix_cal_manip_mc", "bm_matrix_cal_power_mc", 
          "bm_matrix_cal_sort_mc", "bm_matrix_cal_cross_product_mc", 
          "bm_matrix_cal_lm_mc")
  if(verbose)
    message("# Matrix calculation benchmarks (5 test):")
  
  run_benchmarks_mc(bm, runs, verbose, cores)
}


#' @inheritParams benchmark_std
#' @rdname bm_matrix_fun_fft
#' @export
benchmark_matrix_fun = function(runs=3, verbose=TRUE) {
  bm = c("bm_matrix_fun_cholesky", "bm_matrix_fun_determinant",
         "bm_matrix_fun_eigen", "bm_matrix_fun_fft",
         "bm_matrix_fun_inverse")
  if(verbose)
    message("# Matrix function benchmarks (5 tests):")
  run_benchmarks(bm, runs, verbose)  
}

