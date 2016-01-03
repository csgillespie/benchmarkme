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
  tmp_env = new.env()
  data(past_results, package="benchmarkmeData", envir = tmp_env)
  pas_res = tmp_env$past_results
  if(get_byte_compiler() > 0.5)
    pas_res = pas_res[pas_res$byte_optimize > 0.5,]
  else 
    pas_res = pas_res[pas_res$byte_optimize < 0.5,]
  
  pas_res$new = FALSE
  pas_res$cpus = as.character(pas_res$cpus)
  pas_res = pas_res[,c("cpus", "timings", "new")]
  results = rbind(pas_res, 
                  data.frame(cpus = get_cpu()$model_name, 
                             timings=ben_sum, new=TRUE))

  results$timings = signif(results$timings, 5)
  results = results[order(results$timings), ]
  results$rank = 1:nrow(results)
  current_rank = results$rank[results$new]
  
  results = results[,c("rank", "cpus", "timings")]
  colnames(results) = c("Rank", "CPU", "Time (sec)")
  
  data_table = DT::datatable(results, rownames=FALSE) 
  DT::formatStyle(data_table, "Rank",
                  backgroundColor = DT::styleEqual(current_rank, "orange"))
}

#' @importFrom benchmarkmeData get_datatable_past
#' @export
benchmarkmeData::get_datatable_past
