test_that("Test RAM", {
  skip_on_cran()
  expect_is(unclass(get_ram()), "numeric")
  expect_true(get_ram() > 0)
}
)
