#' IO benchmarks
#' 
#' @description Benchmarking reading and writing a csv file (containing random numbers).
#' The tests are essentially \code{write.csv(x)} and \code{read.csv(...)} where \code{x} is a data frame.
#' Of \code{size}MB.
#' @inheritParams benchmark_std
#' @param tmpdir a non-empty character vector giving the directory name. Default \code{tempdir()}
#' @param size a number specifying the approximate size of the generated csv. 
#' Must be one of 5, 50, & 200.
#' @importFrom utils read.csv write.csv
#' @rdname benchmark_io
#' @export
benchmark_io = function(runs = 3, 
                        size = c(5, 50, 200),
                        tmpdir = tempdir(),
                        verbose = TRUE, 
                        parallel = FALSE) {
  # Order size largest to smallest for trial run. 
  # Trial on largest
  
  if(!(size %in% c(5, 50, 200))) {
    stop("Size must be one of 5, 50, or 500", call. = FALSE)
  }
  size = sort(size, decreasing = TRUE) 
  if (!isFALSE(parallel)) {
    results = benchmark_io_parallel(runs = runs, size = size, 
                                    tmpdir = tmpdir, verbose = verbose, 
                                    parallel = parallel)
  } else { 
    results = benchmark_io_serial(runs = runs, size = size, 
                                  tmpdir = tmpdir, verbose = verbose)
  }
  class(results) = c("ben_results", class(results))
  results
}

## Two helper functions ----
benchmark_io_serial = function(runs, size, tmpdir, verbose) {
  ## Avoid spurious first times.
  ## Perform a dummy run
  message("Preparing read/write io")
  bm_write(runs, size = size[1], tmpdir, verbose = FALSE)
  results = NULL # I know I'm growing a data frame. But nrow < 10
  for (s in size) {
    if (verbose) message("# IO benchmarks (2 tests) for size ", s, " MB:")
    res = bm_write(runs, size = s, tmpdir, verbose)
    results = rbind(results, res)
    res = bm_read(runs, size = s, tmpdir, verbose)
    results = rbind(results, res)
  }
  results$parallel = FALSE
  results$cores = 1
  results
}

benchmark_io_parallel = function(runs, size, tmpdir, verbose, parallel) {
  message("Preparing read/write io")
  bm_parallel("bm_write", runs = 1, 
              size = size[1], tmpdir = tmpdir, 
              verbose = verbose, cores = max(parallel))
  results = NULL
  for (s in size) {
    if (verbose) message("# IO benchmarks (2 tests) for size ", s, " MB (parallel)")
    results = rbind(results,
                    bm_parallel("bm_write", runs = runs, size = s, tmpdir = tmpdir, 
                                verbose = verbose, cores = parallel))
    results = rbind(results,
                    bm_parallel("bm_read", runs = runs, size = s, tmpdir = tmpdir, 
                                verbose = verbose, cores = parallel))
  }
  results$parallel = TRUE
  results
}

#bm_io(runs = runs, size = s, tmpdir = tmpdir, verbose = verbose)
#' @rdname benchmark_io
#' @export
bm_read = function (runs = 3, size = c(5, 50, 200),
                  tmpdir = tempdir(), verbose = TRUE) {
  n = 12.5e4 * size
  set.seed(1);  on.exit(set.seed(NULL))
  x = Rnorm(n)
  m = data.frame(matrix(x, ncol = 10))
  test = test_group = rep(paste0("read",  size), runs)
  timings = data.frame(user = numeric(runs), system = 0, 
                       elapsed = 0, test = test, 
                       test_group = test, 
                       stringsAsFactors = FALSE)
  fname = tempfile(fileext = ".csv", tmpdir = tmpdir)
  write.csv(m, fname, row.names = FALSE)
  for (i in 1:runs) {
    invisible(gc())
    timings[i, 1:3] = system.time({
      read.csv(fname, colClasses = rep("numeric", 10))
    })[1:3]
    if (verbose) {
      message(c("\t Reading a csv with ", n, " values", 
                timings_mean(timings[timings$test_group == paste0("read", size),])))
    }
  }
  unlink(fname)
  
  timings
}

#' @rdname benchmark_io
#' @export
bm_write = function (runs = 3, size = c(5, 50, 200),
                     tmpdir = tempdir(), verbose = TRUE) {
  n = 12.5e4 * size
  set.seed(1); on.exit(set.seed(NULL))
  x = Rnorm(n)
  m = data.frame(matrix(x, ncol = 10))
  test = test_group = rep(paste0("write",  size), runs)
  timings = data.frame(user = numeric(runs), system = 0, 
                       elapsed = 0, test = test, 
                       test_group = test, 
                       stringsAsFactors = FALSE)
  for (i in 1:runs) {
    fname = tempfile(fileext = ".csv", tmpdir = tmpdir)
    invisible(gc())
    timings[i, 1:3] = system.time({
      write.csv(m, fname, row.names = FALSE)
    })[1:3]
    unlink(fname)
    invisible(gc())
    if (verbose) {
      message(c("\t Writing a csv with ", n, " values", 
                timings_mean(timings[timings$test_group == paste0("write", size),])))
    }
  }
  timings
}
