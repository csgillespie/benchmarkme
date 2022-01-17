test_that("Test benchmark_std", {
  skip_on_cran()
  skip_on_travis()
  expect_error(benchmark_std(runs = 0))
  res = benchmark_std(runs = 1)
  expect_equal(nrow(res), 15)
  expect_equal(ncol(res), 6)
})
