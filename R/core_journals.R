#' Get journal via its ISSN
#'
#' @export
#' @template all
#' @param id (integer) One or more journal ISSNs. Required
#' @param method (character) one of 'GET' (default) or 'POST'
#' @details `core_journals` does the HTTP request and parses, while
#' `core_journals_` just does the HTTP request, gives back JSON as a
#' character string
#'
#' These functions take one article ID at a time. Use lapply/loops/etc for
#' many ids
#' @references <https://core.ac.uk/docs/#!/journals/getJournalByIssnBatch>
#' <https://core.ac.uk/docs/#!/journals/getJournalByIssn>
#' @examples \dontrun{
#' core_journals(id = '2167-8359')
#'
#' ids <- c("2167-8359", "1471-2105", "2050-084X")
#' res <- lapply(ids, core_journals)
#' vapply(res, "[[", "", c("data", "title"))
#'
#' # just http request, get text back
#' core_journals_('2167-8359')
#'
#' # post request, ideal for lots of ISSNs
#' if (requireNamespace("rcrossref", quietly = TRUE)) {
#'  library(rcrossref)
#'  res <- lapply(c("bmc", "peerj", "elife", "plos", "frontiers"), function(z)
#'     cr_journals(query = z))
#'  ids <- unlist(lapply(res, function(b) b$data$issn))
#'  out <- core_journals(ids, method = "POST")
#'  head(out)
#' }
#'
#' }
core_journals <- function(id, key = NULL, method = "GET", parse = TRUE, ...) {
  core_parse(core_journals_(id, key, method, ...), parse)
}

#' @export
#' @rdname core_journals
core_journals_ <- function(id, key = NULL, method = "GET", ...) {
  if (!method %in% c('GET', 'POST')) {
    stop("'method' must be one of 'GET' or 'POST'", call. = FALSE)
  }
  switch(
    method,
    `GET` = {
      if (length(id) > 1) stop("'id' must be of length 1 when 'method=GET'",
                               call. = FALSE)
      core_GET(path = paste0("journals/get/", id), key, list(), ...)
    },
    `POST` = core_POST(path = "journals/get", key, list(), id, ...)
  )
}
