test_that("Test plot_past", {
  skip_on_cran()
  tmp_env = new.env()
  data(sample_results, envir=tmp_env, package="benchmarkme")
  res = tmp_env$sample_results
  expect_null(plot(res))
}
)
