test_that("Test Sys Details", {
  skip_on_cran()
  sys = get_sys_details(sys_info=FALSE, installed_packages=FALSE)
  expect_equal(length(sys), 13)
  expect_equal(is.na(sys$sys_info), TRUE)
  expect_equal(is.na(sys$installed_packages), TRUE)
  }
)
