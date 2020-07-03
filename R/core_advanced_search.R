#' Advanced Search CORE
#'
#' @export
#' @template all
#' @param query data.frame, required (details for structure)
#' @param page (character) page number (default: 1), optional
#' @param limit (character) records to return (default: 10, minimum: 10,
#' maximum: 100), optional
#' @details `query` should include columns with the following information
#' (at least one is required):
#' - `title`
#' - `description`
#' - `fullText`
#' - `authors`
#' - `publisher`: string, to be used as an absolute match against the
#' publisher name metadata field
#' - `repositories.id`: repository id
#' - `repositories.name`: repository name
#' - `doi`: string, to be used as an absolute match against the repository
#' name metadata field (all other fields will be ignored if included)
#' - `oai`
#' - `identifiers`
#' - `language.name`: string, to filter against languages specified in
#' https://en.wikipedia.org/wiki/ISO_639-1
#' `core_advanced_search` does the HTTP request and parses, while
#' `core_advanced_search_` just does the HTTP request, gives back JSON as a
#' character string
#' - `year`: year to filter to
#' @return data.frame with the following columns:
#' - `status`: string, which will be 'OK' or 'Not found' or
#' 'Too many queries' or 'Missing parameter' or 'Invalid parameter' or
#' 'Parameter out of bounds'
#' - `totalHits`: integer, Total number of items matching the search criteria
#' - `data`: list, a list of relevant resources
#' @examples \dontrun{
#' query <- data.frame(
#' "all_of_the_words" = c("data mining", "machine learning"),
#' "without_the_words" = c("social science", "medicine"),
#' "year_from" = c("2013","2000"),
#' "year_to" = c("2014", "2016"))
#'
#' res <- core_advanced_search(query)
#' head(res$data)
#' res$data[[1]]$`_source`$id
#' }
core_advanced_search <- function(query, page = 1, limit = 10, key = NULL,
                                 parse = TRUE, ...) {
  core_parse(core_advanced_search_(query, page, limit, key, ...), parse)
}

#' @export
#' @rdname core_advanced_search
core_advanced_search_ <- function(query, page = 1, limit = 10, key = NULL, ...)
{
  must_be(limit)
  if(is.data.frame(query)){
    parsed_advanced_query <- apply(X = query, MARGIN = 1, FUN =
                                     parse_advanced_search_query)

    if(length(parsed_advanced_query) > 1){
      queries <- create_batch_query_list(parsed_advanced_query, page, limit)
      args <- NULL

      core_POST(path = "search", key, args, queries, ...)
    } else {
      core_GET(path = file.path("search", parsed_advanced_query), key,
               list(page = page, pageSize = limit), ...)
    }
  } else {
    stop("query must be a data.frame (see details)")
  }
}
