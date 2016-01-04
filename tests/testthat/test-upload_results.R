test_that("Test datatable", {
  skip_on_cran()
  ## Upload empty results that are removed on the server.
  x = upload_results(NULL)
  ## Results ID should have date.
  expect_equal(grep(Sys.Date(), x), 1)
  }
)
