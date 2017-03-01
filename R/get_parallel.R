# Parallel functions

#' Set up parallel environment
#'
#' @return Nothing
setup_parallel <- function() {
  if (!requireNamespace("foreach", quietly = TRUE)) {
    # Stop, parallel will not work
    stop("foreach package required for mc testing operation",
         call. = FALSE)
  }
  if (foreach::getDoParWorkers() == 1) {
    # Need to set do par workers up
    warning("No parallel backend registered", call. = TRUE)
  }
}
