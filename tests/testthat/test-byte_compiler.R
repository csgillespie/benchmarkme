test_that("Test Byte Compiler", {
  skip_on_cran()
  byte = get_byte_compiler()
  expect_gte(byte, 0L)
  expect_lte(byte, 3L)
}
)
