# #' Regression with high leverage example
# #'
# #' This function runs an example of a shiny application to
# #' do with a regression example to examine the change in 
# #' linear model fit when removing points of high influence.
# #'
# #' @param includecode Logical. If TRUE the code
# #' included in the ui.R and server.R source files will
# #' be shown alongside the app.
# #' @usage regressionExample(includecode = FALSE)
# #' @import ggplot2
# #' @import shiny
# #' @export
# shine = function(includecode = FALSE){
#   
#   appDir = system.file("shinyExamples", 
#                        "plotting", package = "benchmarkme")
#   if(nchar(appDir) == 0) {
#     stop("Could not find example directory. Try reinstalling `nclRmodelling`.", call. = FALSE)
#   }
#   shiny::runApp(appDir, display.mode = ifelse(includecode,"showcase","normal"))
# }
# 

#' @importFrom benchmarkmeData shine
#' @export
#' @examples 
#' ## Explore past data
#' \dontrun{
#' shine()
#' }
#' ## Explore your benchmarks
#' data(sample_results, package="benchmarkme")
#'\dontrun{
#'shine(sample_results)
#' }
benchmarkmeData::shine