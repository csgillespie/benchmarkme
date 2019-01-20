test_that("Test RAM", {
  skip_on_cran()
  expect_is(unclass(get_ram()), "numeric")
  expect_true(get_ram() > 0)
  expect_output(benchmarkme:::print.ram(1.63e+10), regexp = "GB")
  expect_output(benchmarkme:::print.ram(10), regexp = "B")
  expect_equal(benchmarkme:::to_Bytes(c(16.4,  "GB")), 1.64e+10)
}
)
