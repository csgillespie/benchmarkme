test_that("Test ranking", {
  skip_on_cran()
  tmp_env = new.env()
  data(sample_results, envir=tmp_env, package="benchmarkme")
  res = tmp_env$sample_results
  expect_gt(rank_results(res), 0)
}
)
