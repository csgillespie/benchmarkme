#' Interactive table of results
#' 
#' Compare your results against past results. Your results is 
#' shown in Orange.
#' @inheritParams upload_results
#' @export
get_datatable = function(results) {
  if(!requireNamespace("DT", quietly = TRUE))
    stop("Install DT package to use datatable")

  ## New result
  no_of_reps = length(results$test)/length(unique(results$test))
  ben_sum = sum(results[,3])/no_of_reps

  ## Load past data
  tmp_env = environment()
  data(results, package="benchmarkme", envir = tmp_env)
  results = tmp_env$results
  results$new = FALSE
  results$cpus = as.character(results$cpus)
  results = rbind(results, data.frame(cpus = get_cpu()$model_name, timings=ben_sum, new=TRUE))
  
  
  results$timings = signif(results$timings, 5)
  results = results[order(results$timings), ]
  results$rank = 1:nrow(results)
  current_rank = results$rank[results$new]
  
  results = results[,c("rank", "cpus", "timings")]
  colnames(results) = c("Rank", "CPU", "Time (sec)")
  
  data_table = DT::datatable(results, rownames=FALSE) 
  DT::formatStyle(data_table, 'Rank',
              backgroundColor = DT::styleEqual(current_rank, c('orange')))
  
  
}