#' Get BLAS and LAPACK libraries
#' Extract the the blas/lapack from \code{sessionInfo()}
#'
#' @importFrom utils sessionInfo
#' @export
get_linear_algebra = function() {
    s = sessionInfo()
    blas = s$BLAS
    lapack = s$LAPACK
    return(list(blas = blas, lapack = lapack))
}
