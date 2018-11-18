#' 
#' make_DT = function(results, test_group, byte_optimize, blas_optimize) {
#'   
#'   pas_res = select_results(test_group, byte_optimize = byte_optimize, 
#'                            blas_optimize = blas_optimize)
#'   ## New result
#'   results = results[results$test_group %in% test_group,]
#'   no_of_reps = length(results$test)/length(unique(results$test))
#'   ben_sum = sum(results[,3])/no_of_reps
#'   
#'   pas_res$new = FALSE
#'   pas_res = pas_res[,c("cpu", "time", "sysname", "new")]
#'   results = rbind(pas_res, 
#'                   data.frame(cpu = get_cpu()$model_name, 
#'                              time=ben_sum, 
#'                              sysname = as.character(Sys.info()["sysname"]),
#'                              new=TRUE, stringsAsFactors = FALSE))
#'   
#'   results$time = signif(results$time, 4)
#'   results = results[order(results$time), ]
#'   results$rank = 1:nrow(results)
#'   current_rank = results$rank[results$new]
#'   message("You are ranked ", current_rank, " out of ", nrow(results), " machines.")
#'   results = results[,c("rank", "cpu", "time", "sysname")]
#'   colnames(results) = c("Rank", "CPU", "Time (sec)", "OS")
#'   
#'   data_table = DT::datatable(results, rownames=FALSE) 
#'   DT::formatStyle(data_table, "Rank",
#'                   backgroundColor = DT::styleEqual(current_rank, "orange"))
#' }
#' 
#' #' @importFrom benchmarkmeData get_datatable_past
#' #' @export
#' benchmarkmeData::get_datatable_past
