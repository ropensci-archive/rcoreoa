test_that("core_articles_history", {
  skip_on_cran()

  vcr::use_cassette("core_articles_history", {
    aa <- core_articles_history(id = 21132995)
    bb <- core_articles_history(id = 21132995, parse = FALSE)
  })

  expect_is(aa, "list")
  expect_is(aa$status, "character")
  expect_equal(aa$status, "OK")

  expect_is(aa$data, "data.frame")
  expect_is(bb$data, "list")
})

test_that("core_articles_history_", {
  skip_on_cran()

  vcr::use_cassette("core_articles_history_", {
    z <- core_articles_history_(id = 21132995)
  })

  expect_is(z, "character")
  aa <- jsonlite::fromJSON(z)
  expect_is(aa$status, "character")
  expect_equal(aa$status, "OK")
  expect_is(aa$data, "data.frame")
})

test_that("core_articles_history fails well", {
  skip_on_cran()

  # id is required
  expect_error(core_articles_history(), "\"id\" is missing")

  # parse must be logical
  expect_error(core_articles_history(1, parse = "afff"),
    "must be of class logical")
})
