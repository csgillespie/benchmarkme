test_that("Test Timing mean", {
  skip_on_cran()
  data("sample_results")
  expect_true(is.character(timings_mean(sample_results)))
}
)