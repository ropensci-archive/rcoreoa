#' Search CORE
#'
#' @export
#' @template all
#' @param query (character) query string, required
#' @param page (character) page number (default: 1), optional
#' @param limit (character) records to return (default: 10, minimum: 10),
#' optional
#' @details `core_search` does the HTTP request and parses, while
#' `core_search_` just does the HTTP request, gives back JSON as a character
#' string
#' @references <https://core.ac.uk/docs/#!/all/search>
#' @examples \dontrun{
#' core_search(query = 'ecology')
#' core_search(query = 'ecology', parse = FALSE)
#' core_search(query = 'ecology', limit = 12)
#'
#' core_search_(query = 'ecology')
#' library("jsonlite")
#' jsonlite::fromJSON(core_search_(query = 'ecology'))
#' }
core_search <- function(query, page = 1, limit = 10, key = NULL,
                        parse = TRUE, ...) {
  core_parse(core_search_(query, page, limit, key, ...), parse)
}

#' @export
#' @rdname core_search
core_search_ <- function(query, page = 1, limit = 10, key = NULL, method = "GET", ...) {
  must_be(limit)
  
  if (!method %in% c('GET', 'POST')) {
    stop("'method' must be one of 'GET' or 'POST'", call. = FALSE)
  }
  
  switch(
    method,
    `GET` = {
      core_GET(path = file.path("search", query), key,
               list(page = page, pageSize = limit), ...)
    },
    `POST` = { 
      queries <- create_batch_query_list(query, page, pageSize)
      args <- NULL
      
      core_POST(path = file.path("search"), key, args, queries)
    }
  )
}
