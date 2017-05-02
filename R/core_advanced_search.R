#' Advanced Search CORE
#'
#' @export
#' @template all
#' @param query data.frame, required (details for structure)
#' @param page (character) page number (default: 1), optional
#' @param limit (character) records to return (default: 10, minimum: 10),
#' optional
#' @details `query` should include columns with the following information 
#' (at least one is required):
#' 1. `all_of_the_words`: string, with space separated terms that should all exist
#' in target document(s)
#' 2. `exact_phrase`: string, used as an absolute match in comparison with 
#' `all_of_the_words`
#' 3. `at_least_one_of_the_words`: string, with space separated terms of which at
#' least one should exist in target document(s)
#' 4. `without_the_words`: string, with space separated terms of which none should
#' exist in target document(s)
#' 5. `find_those_words`: 3 available options, a. "anywhere in the article", 
#' b. "in the title", c. "in the title and abstract" to either do a fulltext
#' search, a title only or a title and abstract respectively
#' 6. `author`: string, to be used as an absolute match against the author name
#' metadata field
#' 7. `publisher`: string, to be used as an absolute match against the publisher 
#' name metadata field
#' 8. `repository`: string, to be used as an absolute match against the repository 
#' name metadata field
#' 9. `doi`: string, to be used as an absolute match against the repository 
#' name metadata field (all other fields will be ignored if included)
#' 10. `year_from`: string, to filter target document(s) publisher earlier than 
#' indicated
#' 11. `year_to`: string, to filter target document(s) publisher later than 
#' indicated
#' `core_advanced_search` does the HTTP request and parses, while
#' `core_advanced_search_` just does the HTTP request, gives back JSON as a 
#' character string
#' @examples \dontrun{
#' query <- data.frame(
#' 'all_of_the_words' = c('data mining', 'machine learning'), 
#' 'without_the_words' = c('social science', 'medicine'),
#' 'year_from' = c('2013','2000'), 
#' 'year_to' = c('2014', '2016'))
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
    print("query must be a data.frame (see details)")
  }
}
