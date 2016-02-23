#' The benchmarkme package
#' 
#' Benchmark your CPU and compare against other CPUs. Also provides 
#' functions for obtaining system specifications, such as 
#' RAM, CPU type, and R version.
#' @name benchmarkme-package 
#' @aliases benchmarkme
#' @docType package
#' @author \email{csgillespie@gmail.com}
#' @keywords package
#' @seealso \url{https://github.com/csgillespie/benchmarkme}
#' @examples
#' ## Benchmark your system and compare 
#' \dontrun{
#' res = benchmark_std()
#' upload_results(res)
#' plot(res)
#' }
NULL