#' @export
benchmark_all = function(runs=3, verbose=FALSE) {
  prog_funs = c("bm_prog_fib", "bm_prog_gcd", "bm_prog_hilbert", "bm_prog_toeplitz", "bm_prog_escoufier")
  matrix_funs = c("bm_matrix_cholesky", "bm_matrix_cross_product", "bm_matrix_lm", 
                  "bm_matrix_determinant", "bm_matrix_eigen", "bm_matrix_fft", 
                  "bm_matrix_inverse", "bm_matrix_manip", "bm_matrix_power", 
                  "bm_matrix_sort")

  results = lapply(c(prog_funs, matrix_funs), do.call, list(runs=runs, verbose=verbose))
  Reduce("rbind", results)
}



