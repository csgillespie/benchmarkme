test_that("Test Platform Info", {
  skip_on_cran()
  expect_equal(get_platform_info(), .Platform)
  }
)
