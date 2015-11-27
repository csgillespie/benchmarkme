#' Run all benchmarks
#' 
#' This functions runs all benchmarks. To view the list of benchmarks, see \code{get_benchmarks}.
#' @param runs Number of times to run the test. Default 3.
#' @param verbose Default FALSE.
#' @export
benchmark_all = function(runs=3, verbose=FALSE) {

  results = lapply(get_benchmarks(), do.call, list(runs=runs, verbose=verbose))
  results = Reduce("rbind", results)
  class(results) = c("ben_results", class(ben))
  results
}

#' @rdname benchmark_all
#' @export
get_benchmarks = function(){
  prog_funs = c("bm_prog_fib", "bm_prog_gcd", "bm_prog_hilbert", "bm_prog_toeplitz", "bm_prog_escoufier")
  matrix_funs = c("bm_matrix_cholesky", "bm_matrix_cross_product", "bm_matrix_lm", 
                  "bm_matrix_determinant", "bm_matrix_eigen", "bm_matrix_fft", 
                  "bm_matrix_inverse", "bm_matrix_manip", "bm_matrix_power", 
                  "bm_matrix_sort")
  c(prog_funs, matrix_funs)  
}



