min_year_default <- "1900"
max_year_default <- yearToday <- format(Sys.Date(), "%Y")

get_acceptable_advanced_search_query_filter <- function(){
  return(c("all_of_the_words", "exact_phrase", "at_least_one_of_the_words",
           "without_the_words", "find_those_words", "author", "publisher",
           "repository", "doi", "year_from", "year_to"))
}

paste_three <- function(..., sep = " ", collapse = NULL, na.rm = TRUE) {
  if (na.rm == FALSE)
    paste(..., sep = sep, collapse = collapse)
  else
    if (na.rm == TRUE) {
      paste_na <- function(x, sep) {
        x <- gsub("^\\s+|\\s+$", "", x)
        ret <- paste(stats::na.omit(x), collapse = sep)
        is.na(ret) <- ret == ""
        return(ret)
      }
      df <- data.frame(..., stringsAsFactors = FALSE)
      ret <- apply(df, 1, FUN = function(x) paste_na(x, sep))

      if (is.null(collapse))
        ret
      else {
        paste_na(ret, sep = collapse)
      }
    }
}

prepare_elasticsearch_term <- function(filter, filterName) {
  if (!is.na(filter)) {
    if (is_acceptable_string(filter)) {
      filterArr <- unlist(strsplit(x = filter, split = " "))
      return(paste(filterName, ":(", paste(filterArr, collapse = " AND "), ")",
                   sep = ""))
    }
  } else {
    return(NA)
  }
}

is_acceptable_year_filter <- function(year, nullable = TRUE) {
  numericPattern <- "^[0-9]{4}$"

  if (nullable) {
    return(
      (!is.na(as.integer(year)) &&
         (as.integer(year) <= yearToday) &&
         regexpr(pattern = numericPattern, text = year)[1] == 1
      ) || nchar(year) > 0)
  } else {
    return(
      !is.na(as.integer(year)) &&
        (as.integer(year) <= yearToday) &&
        regexpr(pattern = numericPattern, text = year)[1] == 1
    )
  }
}

are_acceptable_year_filters <- function(year_from, year_to){
  return(
    (!is.null(year_from) && nchar(year_from) > 0 &&
       !is.na(as.integer(year_from))) &&
      (!is.null(year_to) && nchar(year_to) > 0 &&
         !is.na(as.integer(year_to))) &&
      (as.integer(year_from) <= as.integer(year_to))
  )
}

is_acceptable_string <- function(txt){
  return(is.character(txt) && nchar(txt) > 0)
}

parse_advanced_search_query <- function(query){
  acceptable_advanced_filters <- get_acceptable_advanced_search_query_filter()
  query <- query[which(names(query) %in% acceptable_advanced_filters)]

  if ("doi" %in% names(query)) {
    if (!is.null(query["doi"]) && query["doi"] != "") {
      return(paste('doi:(', query["doi"], ')', sep = ""))
    } else {
      return("")
    }
  } else {
    if (is.na(query["find_those_words"]) ||
       !is_acceptable_string(query["find_those_words"])) {
      query["find_those_words"] <- "anywhere in the article"
    }

    # word related filters (left column of advanced search query UI)
    basicTermReplacement <- ""
    wordFilter <- ""

    if ("without_the_words" %in% names(query)) {
      withoutTheWordsArr <- unlist(strsplit(x = query["without_the_words"],
                                            split = " "))
      withoutTheWordsArrStr <- paste("-", paste(withoutTheWordsArr, collapse =
                                                  " -"),
                                     sep = "")
    } else {
      withoutTheWordsArrStr <- ""
    }

    if ("all_of_the_words" %in% names(query)) {
      allOfTheWords <-
        paste("(", paste(x = unlist(strsplit(x = query["all_of_the_words"],
                                             split = " ")),
                         collapse = (" AND ")), ") ", sep = "")
    } else {
      allOfTheWords <- ""
    }

    if ("exact_phrase" %in% names(query)) {
      exactPhrase <- paste("\"", query["exact_phrase"], "\"", sep = "")
    } else {
      exactPhrase <- ""
    }

    if ("at_least_one_of_the_words" %in% names(query)) {
      atLeastOneOfTheWords <-
        paste("(",
              paste(x = unlist(strsplit(x = query["at_least_one_of_the_words"],
                                        split = " ")),
                    collapse = (" OR ")), ") ", sep = "")
    } else {
      atLeastOneOfTheWords <- ""
    }

    wordFilter <- paste(if (is_acceptable_string(withoutTheWordsArrStr))
      withoutTheWordsArrStr else "",
      if (is_acceptable_string(allOfTheWords)) allOfTheWords else "",
      if (is_acceptable_string(exactPhrase)) exactPhrase else "",
      if (is_acceptable_string(atLeastOneOfTheWords))
        atLeastOneOfTheWords else "", sep = "")

    # Not guarranteed to be here so set its default at this point manually.
    if (!"find_those_words" %in% query) {
      query["findThoseWords"] <- "anywhere in the article"
    }

    if (regexpr(pattern = "title", text = query["find_those_words"])[1] == 1) {
      basicTermReplacement <-
        paste(basicTermReplacement, "title:(", wordFilter, ")", sep = "")
    } else if (regexpr(pattern = "abstract",
                      text = query["find_those_words"])[1] == 1) {
      basicTermReplacement <-
        paste(basicTermReplacement, "abstract:(", wordFilter, ")", sep = "")
    } else {
      basicTermReplacement <- paste(basicTermReplacement, wordFilter, sep = "")
    }

    yearFilter <- ""

    query_year_from <- if (!"year_from" %in% names(query)) min_year_default else
      query["year_from"]

    query_year_to <- if ("year_to" %in% names(query)) {
      query["year_to"]
    } else {
      yearToday
    }

    yearFilter <-
      if (are_acceptable_year_filters(query_year_from, query_year_to))
        paste("year:[", query_year_from, " TO ", query_year_to, "]",
              sep = "") else ""

    yearFilter <- if (nchar(yearFilter) == 0 && (is.null(query_year_from) ||
                                                nchar(query_year_from) == 0)
                     && is_acceptable_year_filter(query_year_to, FALSE))
      paste("year:[* TO ", query_year_to, "]", sep = "") else yearFilter

    yearFilter <- if (nchar(yearFilter) == 0 && (is.null(query_year_to) ||
                                                 nchar(query_year_to) == 0)
                      && is_acceptable_year_filter(query_year_to, FALSE))
      paste("year:[", query_year_from, " TO ", yearToday, "]", sep = "") else
        yearFilter

    authorFilter <-
      prepare_elasticsearch_term(query["author"], "author")
    publisherFilter <-
      prepare_elasticsearch_term(query["publisher"], "publisher")
    repositoryFilter <-
      prepare_elasticsearch_term(query["repository"], "repository")

    basicTermReplacement <- paste_three(basicTermReplacement, yearFilter,
                                        publisherFilter, repositoryFilter,
                                        authorFilter, sep = " AND ")

    return(basicTermReplacement)
  }
}
