
#' @S3method plot ben_results
plot.ben_results = function(x, ...) {
  
  ## Load past data
  tmp_env = environment()
  data(results, package="benchmarkme", envir = tmp_env)
  results = tmp_env$results
  results = results[order(-results$timings), ]
  
  ## Manipulate new data
  no_of_reps = length(x$test)/length(unique(x$test))
  ben_sum = sum(ben[,3])/no_of_reps
  ben_rank = which(ben_sum > results$timings)[1]
  
  ## Sort plot
  op = par(mar=c(3,3,2,1), 
           mgp=c(2,0.4,0), tck=-.01,
           cex.axis=0.9, las=1, mfrow=c(1,2)) 
  on.exit(op)
  
  ymax = max(results$timings, ben_sum)
  
  
  plot(results$timings, xlab="CPU", ylab="Total timing (secs)", 
       ylim=c(0, ymax), xlim=c(0, nrow(results)+1), 
       panel.first=grid())
  
  points(ben_rank-1/2,ben_sum, bg=2, pch=21)
  text(ben_rank-1/2, mean(results$timings), "You", col=2)
  
  fastest = min(ben_sum, results$timings)
  ymax= ymax/fastest
  
  
  plot(results$timings/fastest, xlab="CPU", ylab="Relative", 
       ylim=c(0, ymax), xlim=c(0, nrow(results)+1), 
       panel.first=grid())
  
  points(ben_rank-1/2,ben_sum/fastest, bg=2, pch=21)
  text(ben_rank-1/2, mean(results$timings)/fastest, "You", col=2)
  
}