#' Platform Info
#' @return Returns \code{.Platform}
#' @export
get_platform_info = function() {
  .Platform
}

#' @export
get_rversion = function() unclass(R.version)
