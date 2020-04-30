test_that("core_articles", {
  skip_on_cran()

  vcr::use_cassette("core_articles", {
    aa <- core_articles(id = 21132995)
    bb <- core_articles(id = 21132995, parse = FALSE)
  })

  expect_is(aa, "list")
  expect_is(aa$status, "character")
  expect_is(aa$data, "list")
  expect_equal(aa$status, "OK")

  expect_is(aa$data$repositories, "data.frame")
  expect_is(bb$data$repositories, "list")
})

test_that("core_articles_", {
  skip_on_cran()

  vcr::use_cassette("core_articles_", {
    z <- core_articles_(id = 21132995)
  })

  expect_is(z, "character")
  aa <- jsonlite::fromJSON(z)
  expect_is(aa, "list")
  expect_is(aa$status, "character")
  expect_is(aa$data, "list")
  expect_equal(aa$status, "OK")
})

test_that("core_articles fails well", {
  skip_on_cran()

  # id is required
  expect_error(core_articles(), "\"id\" is missing")

  # parse must be logical
  expect_error(core_articles(1, parse = "afff"),
    "must be of class logical")

  # method must be GET or POST
  expect_error(core_articles(1, method = "PUT"), "'method' must be one of")

  # id not found
  expect_error(core_articles(id = "adsfdf"), "Not Found")
})
