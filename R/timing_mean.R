timings_mean = function(timings) {
  ti = timings[, 3]
  ti = ti[ti > 0]
  m = mean(ti)
  paste0(": ", signif(m, 3), " (sec).")
}
