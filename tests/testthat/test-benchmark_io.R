test_that("Test benchmark_io", {
  skip_on_cran()
  expect_error(benchmark_io(size = 1))
  res = benchmark_io(runs = 1, size = 5)
  expect_equal(nrow(res), 2)
  expect_equal(ncol(res), 5)
})