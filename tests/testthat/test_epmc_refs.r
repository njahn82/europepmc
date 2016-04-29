context("testing epmc_refs")

test_that("epmc_refs returns", {
  skip_on_cran()
  a <- epmc_refs("PMC3166943", data_src = "pmc")
  b <- epmc_refs("25378340")
  c <- epmc_refs("2439888", limit = 10)

  #correct dimensions and class
  expect_output(str(a), "List of 2")
  expect_output(str(b), "List of 2")
  expect_output(str(c), "List of 2")

  #correct class metadata
  expect_is(a$data, "data.frame")
  expect_is(b$data, "data.frame")
  expect_is(c$data, "data.frame")
  expect_is(a$hit_count, "integer")

  expect_equal(nrow(c$data), 10)

  # fails correctly
  expect_error(epmc_refs("14756321"), "No references found")
  expect_error(epmc_refs("13814508", n_pages = "abc"))
  expect_error(epmc_refs("13814508", data_src = "abc"))
})
