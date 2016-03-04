context("package fails well")

test_that("core_search fails well on limit param", {
  skip_on_cran()

  expect_error(core_search_(query = 'ecology', limit = 3),
               "limit must be >= 10")
})
