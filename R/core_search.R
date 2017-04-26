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
core_search_ <- function(query, page = 1, limit = 10, key = NULL, ...) {
  must_be(limit)

  if(as.character(length(query) > 1)){
    if(!is.data.frame(query)){
      queries <- create_batch_query_list(query, page, limit)
      args <- NULL
      
      core_POST(path = "search", key, args, queries, ...)
    } else {
      # Drop any names not in the acceptable_advanced_filters list and form the query with the rest.
      acceptable_advanced_filters <- get_acceptable_advanced_search_query_filter()
      advanced_query <- query[which(!names(query) %in% acceptable_advanced_filters)]
      # Possibly point to helper function to parse each one individually (zzz.R). Translate code already in core-frontend to construct the query.
      parsed_advanced_query <- parse_advanced_search_query(advanced_query)
      # Figure out if these were part of a batch request or not and execute CORE_GET or CORE_POST accordingly...
      
    }
  } else {
    core_GET(path = file.path("search", query), key,
             list(page = page, pageSize = limit), ...)
  }
}
