test_that("Test datatable", {
  skip_on_cran()
  ## Upload empty results that are removed on the server.
  x = upload_results(NULL)
  ## Results ID should have date.
  expect_equal(grep(Sys.Date(), x), 1)
  
  fname = tempfile(fileext = ".rds")
  res = create_bundle(NULL, fname)
  expect_equal(res, readRDS(fname))
  
  res = create_bundle(NULL, fname, args=list(sys_info=FALSE))
  expect_true(is.na(res$sys_info))
  unlink(fname)
  
  }
)
