#' Search CORE
#'
#' @export
#' @template all
#' @param query (character) query string, required
#' @param page (character) page number (default: 1), optional
#' @param limit (character) records to return (default: 10, minimum: 10), optional
#' @details \code{core_search} does the HTTP request and parses, while
#' \code{core_search_} just does the HTTP request, gives back JSON as a character
#' string
#' @examples \dontrun{
#' core_search(query = 'ecology')
#' core_search(query = 'ecology', parse = FALSE)
#' core_search(query = 'ecology', limit = 2)
#'
#' core_search_(query = 'ecology')
#' library("jsonlite")
#' jsonlite::fromJSON(core_search_(query = 'ecology'))
#'
#' # core_search_(query = 'ecology', limit = 3)
#' }
core_search <- function(query, page = 1, limit = 10, key = NULL, parse = TRUE, ...) {
  core_parse(core_search_(query, page, limit, key, ...), parse)
}

#' @export
#' @rdname core_search
core_search_ <- function(query, page = 1, limit = 10, key = NULL, ...) {
  must_be(limit)
  core_GET(path = file.path("search", query), key, list(page = page, pageSize = limit), ...)
}
