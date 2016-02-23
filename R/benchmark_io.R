#' IO benchmarks
#' 
#' @description Benchmarking reading and writing a csv file (containing random numbers).
#' The tests are essentially \code{write.csv(x)} and \code{read.csv(...)} where \code{x} is a data frame.
#' Of \code{size}MB.
#' 
#' This function is liable to change.
#' @inheritParams benchmark_std
#' @param tmpdir a non-empty character vector giving the directory name. Default \code{tempdir()}
#' @param size a number specifying the approximate size of the generated csv. Must be one of
#' 5,  50, 200.
#' @importFrom utils read.csv write.csv
#' @importFrom utils write.csv
#' @rdname benchmark_io
#' @export
benchmark_io = function(runs=3, 
                        size = c(5, 50, 200),
                        tmpdir = tempdir(),
                        verbose=TRUE) {
  
  results = NULL ## I know I'm growing a data frame. But I'm in a rush :(
  for(s in size) {
    if(verbose) message("# IO benchmarks (2 tests) for size ", s, " MB:")
    results = rbind(results, bm_io(runs, s, tmpdir, verbose))
  }
  class(results) = c("ben_results", class(results))
  results
}


bm_io = function (runs = 3, size = c(5, 50, 200),
                  tmpdir = tempdir(), verbose = TRUE) 
{
 
  if(!(size %in% c(5, 50, 200))) stop("Size must be one of 5, 50, 200")
  if(size == 200) message("This may take a while")
  n = 12.5e4*size
  set.seed(1)
  on.exit(set.seed(NULL))
  x = Rnorm(n)
  m = data.frame(matrix(x, ncol = 10))
  timings = data.frame(user = numeric(2 * runs), system = 0, 
                       elapsed = 0, 
                       test = paste0(c("write","read"), size), 
                       test_group = paste0(c("write","read"), size), 
                       stringsAsFactors = FALSE)
  for (i in 1:runs) {
    fname = tempfile(fileext = ".csv", tmpdir=tmpdir)
    invisible(gc())
    timings[2 * i - 1, 1:3] = system.time({
      write.csv(m, fname,row.names = FALSE)
    })[1:3]
    timings[2 * i, 1:3] = system.time({
      read.csv(fname)
    })[1:3]
    unlink(fname)
  }
  if (verbose) {
    message(c("\t Reading a csv with ", n, " values", 
              timings_mean(timings[timings$test_group ==  paste0("read", size),])))
    message(c("\t Writing a csv with ", n, " values", 
              timings_mean(timings[timings$test_group == paste0("write", size),])))
  }
  timings
}