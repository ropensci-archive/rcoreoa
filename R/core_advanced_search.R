#' Advanced Search CORE
#'
#' @export
#' @template all
#' @param query data.frame, required
#' @param page (character) page number (default: 1), optional
#' @param limit (character) records to return (default: 10, minimum: 10),
#' optional
#' @details `core_advanced_search` does the HTTP request and parses, while
#' `core_advanced_search_` just does the HTTP request, gives back JSON as a character
#' string
#' @references <https://core.ac.uk/docs/#!/all/advanced_search>
#' @examples \dontrun{
#' query <- data.frame("all_of_the_words" = c("data mining", "machine learning"), 
#' "without_the_words" = c("social science", "medicine"),
#' "year_from" = c("2013","2000"), 
#' "year_to" = c("2014", "2016"))
#' 
#' res <- core_advanced_search(query)
#' head(res$data)
#' res$data[[1]]$id
core_advanced_search <- function(query, page = 1, limit = 10, key = NULL,
                        parse = TRUE, ...) {
  core_parse(core_advanced_search_(query, page, limit, key, ...), parse)
}

#' @export
#' @rdname core_advanced_search
core_advanced_search_ <- function(query, page = 1, limit = 10, key = NULL, ...) {
  must_be(limit)
  
  parsed_advanced_query <- apply(X = query, MARGIN = 1, FUN = parse_advanced_search_query)
  
  if(length(parsed_advanced_query) > 1){
    queries <- create_batch_query_list(parsed_advanced_query, page, limit)
    args <- NULL
    
    core_POST(path = "search", key, args, queries, ...)
  } else {
    core_GET(path = file.path("search", parsed_advanced_query), key,
             list(page = page, pageSize = limit), ...)
  }
}
