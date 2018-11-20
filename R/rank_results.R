#' Benchmark rankings
#' 
#' Comparison with past results.
#' @inheritParams upload_results
#' @inheritParams benchmark_std
#' @inheritParams plot.ben_results
#' @importFrom tibble tibble
#' @import dplyr
#' @export
rank_results = function(results,
                        blas_optimize = blas_optimize, 
                        verbose = TRUE) {
  
  
  no_of_test_groups =  length(unique(results$test_group))
  if (no_of_test_groups != 1) 
    stop("Can only rank a single group at a time", call. = FALSE)
  
  no_of_reps = length(results$test) / length(unique(results$test))
  results_tib = tibble(time = sum(results$elapsed) / no_of_reps, 
                               is_past = FALSE)
    
  if (is.null(blas_optimize)) blas_optimize = c(FALSE, TRUE)
  tmp_env = new.env()
  data(past_results_v2, package = "benchmarkmeData", envir = tmp_env)
  pst = tmp_env$past_results_v2
  pst$test_group = as.character(pst$test_group)
  
  rankings = pst %>%
    filter(test_group == unique(results$test_group)) %>%
    filter(blas_optimize %in% !!blas_optimize) %>%
    filter(cores %in% results$cores) %>%
    filter(!is.na(time)) %>%
    mutate(is_past = TRUE) %>%
    select(time, is_past) %>%
    bind_rows(results_tib) %>%
    arrange(time)

  ben_rank = which(!rankings$is_past)
  
  if (verbose)
    message("You are ranked ", ben_rank, " out of ", nrow(rankings), " machines.")
  ben_rank
}