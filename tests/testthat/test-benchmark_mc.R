test_that("Test benchmark_mc", {
  skip_on_cran()
  # expect_error(benchmark_io(size = 1))
  res = benchmark_mc(runs = 1, cores = 2)
  # expect_equal(nrow(res), 2)
  # expect_equal(ncol(res), 5)
})