context("core_search functions")

test_that("high level works - parsing", {
  skip_on_cran()

  vcr::use_cassette("core_search", {
    aa <- core_search(query = 'ecology')
    bb <- core_search(query = 'ecology', parse = FALSE)
  })

  expect_is(aa, "list")
  expect_is(aa$status, "character")
  expect_is(aa$data, "data.frame")
  expect_equal(aa$status, "OK")
  expect_true(grepl("numeric|integer", class(aa$totalHits)))

  expect_is(bb, "list")
  expect_is(bb$status, "character")
  expect_is(bb$data, "list")
  expect_equal(bb$status, "OK")
  expect_true(grepl("numeric|integer", class(bb$totalHits)))
})
