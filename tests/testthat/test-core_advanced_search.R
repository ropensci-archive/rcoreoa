context("core_advanced_search functions")

test_that("high level works - parsing", {
  skip_on_cran()

  # Testing for random combinations of advnaced query filters

  advanced_query_list <- list()

  advanced_query_list <- c(advanced_query_list, list(data.frame(
    "all_of_the_words" = c("data mining", "machine learning"),
    "without_the_words" = c("social science", "medicine"),
    "year_from" = c("2013","2000"),
    "year_to" = c("2014", "2016"))))

  advanced_query_list <- c(advanced_query_list, list(data.frame(
    "exact_phrase" = c("deep learning", "neuroscience"),
    "at_least_one_of_the_words" = c("medicine cancer", "image"),
    "publisher" = c("Cambridge University","PubMed Central"),
    "year_to" = c("2000", "2016"))))

  for (advanced_query in advanced_query_list) {
    aa <- core_advanced_search(query = advanced_query)
    bb <- core_advanced_search(query = advanced_query, parse = FALSE)

    expect_is(aa, "data.frame")
    expect_is(aa$status, "character")
    expect_is(aa$data, "list")
    expect_is(aa$data[[1]], "data.frame")
    expect_is(aa$data[[2]], "data.frame")
    expect_equal(unique(aa$status), "OK")
    expect_true(grepl("numeric|integer", class(aa$totalHits)))

    expect_is(bb, "list")
    expect_is(bb[[1]]$status, "character")
    expect_is(bb[[1]]$data, "list")
    expect_equal(bb[[1]]$status, "OK")
    expect_true(grepl("numeric|integer", class(bb[[1]]$totalHits)))
  }

  # no results found
  advanced_query <- data.frame(
    "exact_phrase" = c("deep learning", "neuroscience"),
    "at_least_one_of_the_words" = c("medicine cancer", "image"),
    "author" = c("Geoffrey Hinton","Geoffrey Hinton"),
    "year_to" = c("2014", "2016")
  )
  aa <- core_advanced_search(query = advanced_query)
  expect_is(aa, "data.frame")
  expect_equal(unique(aa$status), "Not found")
  expect_equal(sum(aa$totalHits), 0)
  expect_true(all(is.na(aa$data)))
})


test_that("high level - language filter", {
  skip_on_cran()

  # advanced_query <- data.frame(
  #   exact_phrase = c("machine learning", "maschinelles Lernen"),
  #   language = c("English", "German")
  # )
  advanced_query <- data.frame(
    title = c("machine learning", "maschinelles Lernen"),
    language = c("English", "German")
  )
  
  aa <- core_advanced_search(query = advanced_query)
  bb <- core_advanced_search(query = advanced_query, parse = FALSE)

  expect_is(aa, "data.frame")
  expect_is(aa$status, "character")
  expect_is(aa$data, "list")
  expect_is(aa$data[[1]], "data.frame")
  expect_is(aa$data[[2]], "data.frame")
  expect_equal(unique(aa$status), "OK")
  expect_true(grepl("numeric|integer", class(aa$totalHits)))

  expect_is(bb, "list")
  expect_is(bb[[1]]$status, "character")
  expect_is(bb[[1]]$data, "list")
  expect_equal(bb[[1]]$status, "OK")
  expect_true(grepl("numeric|integer", class(bb[[1]]$totalHits)))
})
