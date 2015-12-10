#' @importFrom graphics abline grid par plot points text
#' @importFrom utils data
#' @S3method plot ben_results
plot.ben_results = function(x, log="y", ...) {
  
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
  op = par(mar=c(3, 3, 2, 1), 
           mgp=c(2, 0.4, 0), tck=-.01,
           cex.axis=0.9, las=1, mfrow=c(1,2)) 
  on.exit(op)
  
  ## Calculate adjustment for sensible "You" placement
  adj = ifelse(ben_rank < nrow(results)/2, -1.5, 1.5)

  ## Maximum value for plot
  ymax = max(results$timings, ben_sum)

  ## Standard timings
  plot(results$timings, xlab="Rank", ylab="Total timing (secs)", 
       ylim=c(1, ymax), xlim=c(1, nrow(results)+1), 
       panel.first=grid(), cex=0.7, log=log, ...)
  points(ben_rank-1/2,ben_sum, bg=4, pch=21)
  abline(v=ben_rank-1/2, col=4, lty=3)
  text(ben_rank-1/2, 1.2, "You", col=4, adj=adj)

  ## Relative timings  
  fastest = min(ben_sum, results$timings)
  ymax= ymax/fastest
  plot(results$timings/fastest, xlab="Rank", ylab="Relative timing", 
       ylim=c(1, ymax), xlim=c(1, nrow(results)+1), 
       panel.first=grid(), cex=0.7, log=log, ...)
  abline(h=1, lty=3)
  abline(v=ben_rank-1/2, col=4, lty=3)
  points(ben_rank-1/2,ben_sum/fastest, bg=4, pch=21)
  text(ben_rank-1/2, 1.2, "You", col=4, adj=adj)
}


#' Plot past results
#' 
#' Plot the previous benchmarks. This function creates two figures.
#' \itemize{
#' \item Figure 1: Total benchmark time over all benchmarks (in seconds) on the y-axis..
#' \item Figure 2: Relative time (compared to the smallest benchmark).
#' }
#' The data set used is \code{data(results)}.
#' @param byte_optimize Default \code{NULL}. The default behaviour is to plot all results.
#' To plot only the byte optimized results, set to \code{TRUE}, otherwise \code{FALSE}.
#' @param log By default the y axis is plotted on the log scale. To change, set the 
#' the argument equal to the empty parameter string, \code{""}.
#' @examples 
#' ## Plot non byte optimize code
#' plot_past(byte_optimize=FALSE)
#' @export
plot_past = function(byte_optimize = NULL, log="y") {
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
       ylim=c(1, ymax), xlim=c(1, nrow(results)+1), 
       panel.first=grid(), log=log)
  
  ## Relative timings  
  fastest = min(results$timings)
  ymax= ymax/fastest
  plot(results$timings/fastest, xlab="Rank", ylab="Relative timing", 
       ylim=c(1, ymax), xlim=c(1, nrow(results)+1), 
       panel.first=grid(), log=log)
  abline(h=1, lty=3)
}
