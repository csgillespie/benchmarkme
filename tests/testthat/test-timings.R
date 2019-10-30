test_that("Test Timing mean", {
  skip_on_cran()
  data("sample_results", package = "benchmarkme")
  expect_true(is.character(benchmarkme:::timings_mean(sample_results)))
}
)
