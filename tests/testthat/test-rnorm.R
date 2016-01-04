test_that("Test Rnorm", {
  skip_on_cran()
  expect_true(is.numeric(benchmarkme:::Rnorm(1)))
}
)
