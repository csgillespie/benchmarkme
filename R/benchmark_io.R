#' @rdname benchmark_io
#' @inheritParams benchmark_all
#' @export
bm_io = function (runs = 3, size = c(5, 10, 50, 100, 500),
                  tmpdir = tempdir(), verbose = TRUE) 
{
  if(length(size) > 1) size = size[1]
  if(!(size %in% c(5, 10, 50, 100))) stop("Size must be one of 5, 10, 50, 100, 500")

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
    message(c("\t Reading a csv with 2*10^6 values", 
              timings_mean(timings[timings$test_group ==  paste0("read", size),])))
    message(c("\t Writing a csv with 2*10^6 values", 
              timings_mean(timings[timings$test_group == paste0("write", size),])))
  }
  timings
}