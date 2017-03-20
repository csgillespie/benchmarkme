#' IO benchmarks
#' 
#' @description Benchmarking reading and writing a csv file (containing random numbers).
#' The tests are essentially \code{write.csv(x)} and \code{read.csv(...)} where \code{x} is a data frame.
#' Of \code{size}MB.
#' @inheritParams benchmark_std
#' @param tmpdir a non-empty character vector giving the directory name. Default \code{tempdir()}
#' @param size a number specifying the approximate size of the generated csv. Must be one of
#' 5,  50, 200.
#' @param cores, integer, default to NULL and single threaded performance only is 
#' tested, specify an integer to test multithreaded performance
#' @importFrom utils read.csv write.csv
#' @importFrom utils write.csv
#' @rdname benchmark_io
#' @export
benchmark_io = function(runs=3, 
                        size = c(5, 50, 200),
                        tmpdir = tempdir(),
                        verbose=TRUE, cores = NULL) {
  if(missing(cores)){
    results = NULL ## I know I'm growing a data frame. But I'm in a rush :(
    for(s in size) {
      if(verbose) message("# IO benchmarks (2 tests) for size ", s, " MB:")
      
      results = rbind(results, bm_read_io(runs, s, tmpdir, verbose), 
                      bm_write_io(runs, s, tmpdir, verbose))
      results$cores <- 0
    }
  } else{
    results = NULL ## I know I'm growing a data frame. But I'm in a rush :(
    for(s in size) {
      if(verbose) message("# IO benchmarks (2 tests) for size ", s, " MB:", 
                          " in parallel")
      bm <- c("bm_read_io", "bm_write_io")
      results <- lapply(bm, bm_parallel, 
                        runs = runs, size = s, tmpdir = tmpdir, 
                        verbose = verbose, cores = cores)
      results = Reduce("rbind", results)
    }
  }
    class(results) = c("ben_results", class(results))
    results
}

# TODO: Split into read and write


#' A benchmark to test input/output performance in R
#'
#' @param runs Integer, length 1, Number of times to run the benchmark
#' @param size Integer, must be one of 5, 50, 200; default = 5
#' @param tmpdir path, where to write and read temporary data from
#' @param verbose logical, default TRUE, should verbose output be returned?
#' @rdname benchmark_io
#' @return results data.frame
#' @export
bm_write_io = function (runs = 3, size = 5,
                  tmpdir = tempdir(), verbose = TRUE) {
   if(!(size %in% c(5, 50, 200))) stop("Size must be one of 5, 50, 200")
  if(size == 200) message("This may take a while") # nocov
  n = 12.5e4*size
  set.seed(1)
  on.exit(set.seed(NULL))
  x = Rnorm(n)
  m = data.frame(matrix(x, ncol = 10))
  timings = data.frame(user = numeric(runs), system = 0, 
                       elapsed = 0, 
                       test = paste0(c("write"), size), 
                       test_group = paste0(c("write"), size), 
                       stringsAsFactors = FALSE)
  for (i in 1:runs) {
    fname = tempfile(fileext = ".csv", tmpdir=tmpdir)
    invisible(gc())
    timings[i, 1:3] = system.time({
      write.csv(m, fname,row.names = FALSE)
    })[1:3]
    invisible(gc())
    unlink(fname)
  }
  if (verbose) {
    message(c("\t Writing a csv with ", n, " values", 
              timings_mean(timings[timings$test_group == paste0("write", size),])))
  }
  timings
}

#' A benchmark to test input/output performance in R
#'
#' @param runs Integer, length 1, Number of times to run the benchmark
#' @param size Integer, can be length greater than 1, size in MB of temp file to 
#' read and write; default = 5
#' @param tmpdir path, where to write and read temporary data from
#' @param verbose logical, default TRUE, should verbose output be returned?
#' @rdname benchmark_io
#' @return results data.frame
#' @export
bm_read_io = function (runs = 3, size = 5,
                  tmpdir = tempdir(), verbose = TRUE) {
  if(!(size %in% c(5, 50, 200))) stop("Size must be one of 5, 50, 200")
  if(size == 200) message("This may take a while") # nocov
  n = 12.5e4*size
  set.seed(1)
  on.exit(set.seed(NULL))
  x = Rnorm(n)
  m = data.frame(matrix(x, ncol = 10))
  timings = data.frame(user = numeric(runs), system = 0, 
                       elapsed = 0, 
                       test = paste0(c("read"), size), 
                       test_group = paste0(c("read"), size), 
                       stringsAsFactors = FALSE)
  for (i in 1:runs) {
    fname = tempfile(fileext = ".csv", tmpdir=tmpdir)
    invisible(gc())
    write.csv(m, fname,row.names = FALSE)
    invisible(gc())
    timings[i, 1:3] = system.time({
      read.csv(fname)
    })[1:3]
    unlink(fname)
  }
  if (verbose) {
    message(c("\t Reading a csv with ", n, " values", 
              timings_mean(timings[timings$test_group ==  paste0("read", size),])))
  }
  timings
}