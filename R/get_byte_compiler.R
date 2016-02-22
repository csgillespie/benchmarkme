#' Byte compiler status
#' 
#' Attempts to detect if byte compiling or JIT has been used on the package. 
#' @return An integer indicating if byte compiling has been turn on. See \code{?compiler} for
#' details.
#' @importFrom compiler getCompilerOption
#' @importFrom compiler compilePKGS enableJIT
#' @importFrom utils capture.output
#' @export
#' @examples
#' ## Detect if you use byte optimization
#' get_byte_compiler()
get_byte_compiler = function() {
  comp = Sys.getenv("R_COMPILE_PKGS")
  if(nchar(comp) > 0L) comp = as.numeric(comp)
  else comp = 0L
  
  
  ## Try to detect compilePKGS - long shot
  ## Return to same state as we found it
  if(comp == 0L) {
    comp = compiler::compilePKGS(1)
    compiler::compilePKGS(comp)
    if(comp) {
      comp = compiler::getCompilerOption("optimize")
    } else {
      comp = 0L
    } 
  } 
  
  ## Try to detect enableJIT
  ## Return to same state as we found it
  if(comp == 0L) {
    comp = compiler::enableJIT(3)
    compiler::enableJIT(comp)
  }
  
  if(comp == 0L){
    out = capture.output(benchmark_std)
    is_byte = out[length(out)-1]
    if(length(grep("bytecode: ", is_byte)) > 0) {
      comp = compiler::getCompilerOption("optimize")
    }
  }
  structure(as.integer(comp), names = "byte_optimize")
}
