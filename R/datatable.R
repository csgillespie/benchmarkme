#' Interactive table of results
#' 
#' Compare your results against past results. Your results is 
#' shown in Orange.
#' @inheritParams upload_results
#' @inheritParams plot.ben_results
#' @export
get_datatable = function(results, 
                         test_group=unique(results$test_group), 
                         byte_optimize=get_byte_compiler()) {
  if(!requireNamespace("DT", quietly = TRUE))
    stop("Install DT package to use datatable")
  
  ## Load past data
  tmp_env = new.env()
  data(past_results, package="benchmarkmeData", envir = tmp_env)
  pas_res = tmp_env$past_results
  pas_res = pas_res[order(pas_res$time), ]
  if(!is.null(byte_optimize)) {
    if(byte_optimize > 0.5)
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
  
  ## New result
  results = results[results$test_group %in% test_group,]
  no_of_reps = length(results$test)/length(unique(results$test))
  ben_sum = sum(results[,3])/no_of_reps
  
  pas_res$new = FALSE
  pas_res = pas_res[,c("cpu", "time", "sysname", "new")]
  results = rbind(pas_res, 
                  data.frame(cpu = get_cpu()$model_name, 
                             time=ben_sum, 
                             sysname = as.character(Sys.info()["sysname"]),
                             new=TRUE, stringsAsFactors = FALSE))
  
  results$time = signif(results$time, 4)
  results = results[order(results$time), ]
  results$rank = 1:nrow(results)
  current_rank = results$rank[results$new]
  message("You are ranked ", current_rank, " out of ", nrow(results), " machines.")
  results = results[,c("rank", "cpu", "time", "sysname")]
  colnames(results) = c("Rank", "CPU", "Time (sec)", "OS")
  
  data_table = DT::datatable(results, rownames=FALSE) 
  DT::formatStyle(data_table, "Rank",
                  backgroundColor = DT::styleEqual(current_rank, "orange"))
}

#' @importFrom benchmarkmeData get_datatable_past
#' @export
benchmarkmeData::get_datatable_past
