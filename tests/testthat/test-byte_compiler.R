test_that("Test Byte Compiler", {
  skip_on_cran()
  byte = get_byte_compiler()
  expect_gte(byte, 0L)
  expect_lte(byte, 3L)

  benchmark_std = compiler::cmpfun(benchmarkme::benchmark_std)
  assign("benchmark_std", benchmark_std, envir = globalenv())
  expect_gt(get_byte_compiler(), 0L)
}
)
