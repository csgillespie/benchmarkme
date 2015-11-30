#' @S3method plot ben_results
plot.ben_results = function(x, ...) {
  
  ## Load past data
  tmp_env = environment()
  data(results, package="benchmarkme", envir = tmp_env)
  results = tmp_env$results
  results = results[order(results$timings), ]
  if(get_byte_compiler() > 0.5)
    results = results[results$byte_optimize > 0.5,]
  else 
    results = results[results$byte_optimize < 0.5,]
  
  ## Manipulate new data
  no_of_reps = length(x$test)/length(unique(x$test))
  ben_sum = sum(x[,3])/no_of_reps
  ben_rank = which(ben_sum < results$timings)[1]
  if(is.na(ben_rank)) ben_rank = nrow(results) + 1
  
  ## Sort plot
  op = par(mar=c(3,3,2,1), 
           mgp=c(2,0.4,0), tck=-.01,
           cex.axis=0.9, las=1, mfrow=c(1,2)) 
  on.exit(op)
  
  adj = ifelse(ben_rank < nrow(results)/2, -1.5, 1.5)
  ymax = max(results$timings, ben_sum)
  plot(results$timings, xlab="Rank", ylab="Total timing (secs)", 
       ylim=c(0, ymax), xlim=c(0, nrow(results)+1), 
       panel.first=grid())
  
  points(ben_rank-1/2,ben_sum, bg=4, pch=21)
  text(ben_rank-1/2, ben_sum, "You", col=4, adj=adj)

  ## Relative timings  
  fastest = min(ben_sum, results$timings)
  ymax= ymax/fastest
  plot(results$timings/fastest, xlab="Rank", ylab="Relative timing", 
       ylim=c(0, ymax), xlim=c(0, nrow(results)+1), 
       panel.first=grid())
  
  points(ben_rank-1/2,ben_sum/fastest, bg=4, pch=21)
  text(ben_rank-1/2, ben_sum/fastest, "You", col=4, adj=adj)
}


#' Plot past results
#' 
#' Plot the previous benchmarks. This function creates two plots. The first showing
#' time in seconds, the other relative time. The data set used is \code{data(results)}.
#' @param byte_optimize Default \code{NULL}. The default behaviour is to plot all results.
#' To plot only the byte optimized results, set to \code{TRUE}, otherwise \code{FALSE}
#' @export
plot_past = function(byte_optimize = NULL) {
  ## Load past data
  tmp_env = environment()
  data(results, package="benchmarkme", envir = tmp_env)
  results = tmp_env$results
  results = results[order(results$timings), ]
  if(!is.null(byte_optimize) && byte_optimize)
    results = results[results$byte_optimize > 0.5,]
  else if(!is.null(byte_optimize) && !byte_optimize)
    results = results[results$byte_optimize < 0.5,]

  ## Sort plot
  op = par(mar=c(3,3,2,1), 
           mgp=c(2,0.4,0), tck=-.01,
           cex.axis=0.9, las=1, mfrow=c(1,2)) 
  on.exit(op)
  ymax = max(results$timings)
  plot(results$timings, xlab="Rank", ylab="Total timing (secs)", 
       ylim=c(0, ymax), xlim=c(0, nrow(results)+1), 
       panel.first=grid())
  
  ## Relative timings  
  fastest = min(results$timings)
  ymax= ymax/fastest
  plot(results$timings/fastest, xlab="Rank", ylab="Relative timing", 
       ylim=c(0, ymax), xlim=c(0, nrow(results)+1), 
       panel.first=grid())
}


