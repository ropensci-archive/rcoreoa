test_that("core_advanced_search", {
  skip_on_cran()

  advanced_query_list <- list(core_query(title="psychology"),
    core_query(doi='"10.1186/1471-2458-6-309"'),
    core_query(language.name="german"))

  vcr::use_cassette("core_advanced_search", {
    aa <- core_advanced_search(.list = advanced_query_list)
    bb <- core_advanced_search(advanced_query_list, parse = FALSE)
  })

  expect_is(aa, "data.frame")
  expect_is(aa$status, "character")
  expect_type(aa$totalHits, "integer")
  expect_is(aa$data, "list")
  expect_is(aa$data[[1]]$`_source`$id, "character")
  expect_is(aa$data[[1]]$`_source`$fullText, "character")
  expect_true(any(aa$status == "OK"))

  expect_is(bb, "list")
  expect_is(bb[[1]]$status, "character")
  expect_is(bb[[1]]$data, "list")
  expect_equal(bb[[1]]$status, "OK")
  expect_true(grepl("numeric|integer", class(bb[[1]]$totalHits)))

  # no results found
  vcr::use_cassette("core_advanced_search_no_results", {
    aa <- core_advanced_search(core_query(language.name = "german"))
  })
  expect_is(aa, "data.frame")
  expect_equal(unique(aa$status), "Not found")
  expect_equal(sum(aa$totalHits), 0)
  expect_true(all(is.na(aa$data)))
})
