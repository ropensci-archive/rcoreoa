test_that("core_search", {
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

test_that("core_search_", {
  skip_on_cran()

  vcr::use_cassette("core_search_", {
    z <- core_search_(query = 'ecology')
  })

  expect_is(z, "character")
  aa <- jsonlite::fromJSON(z)
  expect_is(aa$status, "character")
  expect_is(aa$data, "data.frame")
  expect_equal(aa$status, "OK")
  expect_true(grepl("numeric|integer", class(aa$totalHits)))
})

test_that("core_search fails well", {
  skip_on_cran()

  # limit value must be 10 or greater
  expect_error(core_search_(query = 'ecology', limit = 3),
    "limit must be >= 10")

  # limit exceeds max value of 100
  expect_error(core_search(query = 'ecology', limit = 200),
    "Parameter out of bounds")

  # limit value not allowed
  expect_error(core_search(query = 'ecology', limit = "foobar"),
    "Invalid parameter")

  # bad key
  expect_error(core_search(query = 'ecology', key = "foobar"),
    "Unauthorized")
})
