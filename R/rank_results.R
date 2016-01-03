#' Benchmark rankings
#' 
#' Comparison with past resultss
#' @inheritParams upload_results
#' @inheritParams benchmark_std
#' @export
rank_results = function(results, verbose=TRUE) {
  current = results
  
  tmp_env = new.env()
  data(past_results, package="benchmarkmeData", envir = tmp_env)
  pas_res = tmp_env$past_results
  pas_res = pas_res[order(pas_res$timings), ]
  if(get_byte_compiler() > 0.5)
    pas_res = pas_res[pas_res$byte_optimize > 0.5,]
  else 
    pas_res = pas_res[pas_res$byte_optimize < 0.5,]
  
  no_of_reps = length(results$test)/length(unique(results$test))
  ben_sum = sum(results[,3])/no_of_reps
  ben_rank = which(ben_sum < pas_res$timings)[1]
  if(is.na(ben_rank)) ben_rank = nrow(pas_res) + 1
  if(verbose)
    message("Ranked ", ben_rank, " out of ", nrow(pas_res))
  ben_rank
}
# data("sample_results", package="benchmarkme")
# 
# results = sample_results
# data(results)
# past_results = results
# save(past_results, file="data/past_results.RData")
