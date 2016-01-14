#' @rdname benchmark_io
#' @inheritParams benchmark_all
#' @export
bm_io= function(runs=3, verbose=TRUE) {
  set.seed(1); on.exit(set.seed(NULL))
  x = Rnorm(2e6)
  m = data.frame(x, ncol=10)

  timings = data.frame(user = numeric(2*runs), system=0, elapsed=0, 
                       test=c("read", "write"), test_group=c("read", "write"), 
                       stringsAsFactors = FALSE)
  for (i in 1:runs) {
    fname = tempfile(fileext=".csv")
    invisible(gc())
    timings[2*i-1, 1:3] = system.time({write.csv(m, fname)})[1:3]
    timings[2*i, 1:3] = system.time({read.csv(fname)})[1:3]
    unlink(fname)
  }
  if(verbose) {
    message(c("\t Reading a csv with 2*10^6 values", timings_mean(timings[timings$test_group=="read",])))
    message(c("\t Writing a csv with 2*10^6 values", timings_mean(timings[timings$test_group=="write",])))
  }
  timings
}

