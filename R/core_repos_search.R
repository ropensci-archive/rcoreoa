#' Search CORE repositories
#'
#' @export
#' @template all
#' @param query (character) query string, required
#' @param page (character) page number (default: 1), optional
#' @param limit (character) records to return (default: 10, minimum: 10),
#' optional
#' @details `core_repos_search` does the HTTP request and parses, while
#' `core_repos_search_` just does the HTTP request, gives back JSON as
#' a character string
#'
#' A POST method is allowed on this route, but it's not supported yet.
#' @references <https://core.ac.uk/docs/#!/repositories/search>
#' @examples \dontrun{
#' core_repos_search(query = 'mathematics')
#' core_repos_search(query = 'physics', parse = FALSE)
#' core_repos_search(query = 'pubmed')
#'
#' core_repos_search_(query = 'pubmed')
#' library("jsonlite")
#' jsonlite::fromJSON(core_repos_search_(query = 'pubmed'))
#' }
core_repos_search <- function(query, page = 1, limit = 10, key = NULL,
                              parse = TRUE, ...) {

  core_parse(core_repos_search_(query, page, limit, key, ...), parse)
}

#' @export
#' @rdname core_search
core_repos_search_ <- function(query, page = 1, limit = 10, key = NULL, ...) {
  must_be(limit)
  core_GET(path = file.path("repositories/search", query), key,
           list(page = page, pageSize = limit), ...)
}
