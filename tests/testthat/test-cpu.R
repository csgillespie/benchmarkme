test_that("Test CPU", {
  skip_on_cran()
  cpu = get_cpu()
  expect_equal(length(cpu), 3)
  expect_equal(anyNA(cpu), FALSE)
}
)
