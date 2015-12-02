timings_mean = function(timings) {
  m = mean(timings[, 3])
  paste0(": ", signif(m, 3), " (sec).")
}

remove_white = function(x) gsub("(^[[:space:]]+|[[:space:]]+$)", "", x)
