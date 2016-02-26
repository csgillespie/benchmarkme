nice_palette = function(){
  alpha =150
  palette(c(rgb(85,130,169, alpha=alpha, maxColorValue=255),
            rgb(200,79,178, alpha=alpha,maxColorValue=255), 
            rgb(105,147,45, alpha=alpha, maxColorValue=255),
            rgb(204,74,83, alpha=alpha, maxColorValue=255),
            rgb(183,110,39, alpha=alpha, maxColorValue=255),
            rgb(131,108,192, alpha=alpha, maxColorValue=255)))
}

#' Compare results to past tests
#' 
#' Plotting
#' @param x The output from a \code{benchmark_*} call.
#' @param test_group Default \code{unique(x$test_group)}. 
#' The default behaviour is select the groups from your benchmark results.
#' @param byte_optimize The default behaviour is to compare your results with results that use the same 
#' byte_optimized setting. To use all results, set to \code{NULL}.
#' @param blas_optimize Logical. Default The default behaviour 
#' is to compare your results with results that use the same 
#' blas_optimize setting. To use all results, set to \code{NULL}.
#' @param log By default the y axis is plotted on the log scale. To change, set the 
#' the argument equal to the empty parameter string, \code{""}.
#' @param ... Arguments to be passed to other downstream methods.
#' @importFrom graphics abline grid par plot points text legend title
#' @importFrom grDevices palette rgb
#' @importFrom utils data
#' @importFrom stats aggregate
#' @importFrom benchmarkmeData select_results is_blas_optimize
#' @S3method plot ben_results
#' @examples 
#' data(sample_results)
#' plot(sample_results)
#' plot(sample_results, byte_optimze=NULL)
plot.ben_results = function(x, 
                            test_group=unique(x$test_group), 
                            byte_optimize=get_byte_compiler(), 
                            blas_optimize=is_blas_optimize(x),
                            log="y", ...) {
  
  for(i in seq_along(test_group)) {
    make_plot(x, test_group[i], byte_optimize, blas_optimize, log, ...)
    if(length(test_group) != i)
      readline("Press return get next plot ")
  }
  
}

make_plot = function(x, test_group, byte_optimize, blas_optimize, log, ...){
  results = select_results(test_group, byte_optimize, blas_optimize)
  
  ## Manipulate new data
  x = x[x$test_group %in% test_group,]
  no_of_reps = length(x$test)/length(unique(x$test))
  ben_sum = sum(x[,3])/no_of_reps
  ben_rank = which(ben_sum < results$time)[1]
  if(is.na(ben_rank)) ben_rank = nrow(results) + 1
  message("You are ranked ", ben_rank, " out of ", nrow(results)+1, " machines.")
  
  ## Arrange plot colours and layout
  op = par(mar=c(3,3,2,1), 
           mgp=c(2,0.4,0), tck=-.01,
           cex.axis=0.8, las=1, mfrow=c(1,2)) 
  old_pal = palette()
  on.exit({palette(old_pal); par(op)})
  nice_palette()
  
  ## Calculate adjustment for sensible "You" placement
  adj = ifelse(ben_rank < nrow(results)/2, -1.5, 1.5)
  
  ## Plot limits
  ymin = min(results$time, ben_sum)
  ymax = max(results$time, ben_sum)
  
  ## Standard timings
  plot(results$time, xlab="Rank", ylab="Total timing (secs)", 
       ylim=c(ymin, ymax), xlim=c(1, nrow(results)+1), 
       panel.first=grid(), cex=0.7, log=log, ...)
  points(ben_rank-1/2,ben_sum, bg=4, pch=21)
  abline(v=ben_rank-1/2, col=4, lty=3)
  text(ben_rank-1/2, ymin, "You", col=4, adj=adj)
  title(paste("Benchmark:", test_group), cex=0.9)
  ## Relative timings  
  fastest = min(ben_sum, results$time)
  ymax= ymax/fastest
  plot(results$time/fastest, xlab="Rank", ylab="Relative timing", 
       ylim=c(1, ymax), xlim=c(1, nrow(results)+1), 
       panel.first=grid(), cex=0.7, log=log, ...)
  abline(h=1, lty=3)
  abline(v=ben_rank-1/2, col=4, lty=3)
  points(ben_rank-1/2,ben_sum/fastest, bg=4, pch=21)
  text(ben_rank-1/2, 1.2, "You", col=4, adj=adj)
  title(paste("Benchmark:", test_group), cex=0.9)
}







#' @importFrom benchmarkmeData plot_past
#' @export
benchmarkmeData::plot_past
