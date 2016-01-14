#' Benchmark rankings
#' 
#' Comparison with past results.
#' @inheritParams upload_results
#' @inheritParams benchmark_std
#' @inheritParams plot.ben_results
#' @export
rank_results = function(results, 
                        test_group=unique(results$test_group), 
                        byte_optimize=get_byte_compiler(), 
                        verbose=TRUE) {
  tmp_env = new.env()
  data(past_results, package="benchmarkmeData", envir = tmp_env)
  pas_res = tmp_env$past_results
  pas_res = pas_res[order(pas_res$time), ]
  if(!is.null(byte_optimize)) {
    if(get_byte_compiler() > 0.5)
      pas_res = pas_res[pas_res$byte_optimize > 0.5,]
    else 
      pas_res = pas_res[pas_res$byte_optimize < 0.5,]
  }
  pas_res = pas_res[pas_res$test_group %in% test_group,]
  pas_res = aggregate(time ~ id + byte_optimize + cpu + date + sysname, 
                      data=pas_res, 
                      FUN=function(i) ifelse(length(i) == length(test_group), sum(i), NA))
  pas_res = pas_res[!is.na(pas_res$time), ]
  pas_res = pas_res[order(pas_res$time), ]
  
  no_of_reps = length(results$test)/length(unique(results$test))
  ben_sum = sum(results[,3])/no_of_reps
  ben_rank = which(ben_sum < pas_res$time)[1]
  if(is.na(ben_rank)) ben_rank = nrow(pas_res) + 1
  if(verbose)
    message("You are ranked ", ben_rank, " out of ", nrow(results), " machines.")
  ben_rank
}