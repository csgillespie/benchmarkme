test_that("Tests sys info", {
  expect_equal(get_sys_info(), Sys.info())
  }
)