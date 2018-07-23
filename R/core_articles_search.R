#' Search CORE articles
#'
#' @export
#' @template all
#' @param query (character) query string, required
#' @param page (character) page number (default: 1), optional
#' @param limit (character) records to return (default: 10, minimum: 10),
#' optional
#' @param metadata (logical) Whether to retrieve the full article metadata or 
#' only the ID. Default: `TRUE`
#' @param fulltext (logical) Whether to retrieve full text of the article. 
#' Default: `FALSE`
#' @param citations (logical) Whether to retrieve citations found in the 
#' article. Default: `FALSE`
#' @param similar (logical) Whether to retrieve a list of similar articles. 
#' Default: `FALSE`. Because the similar articles are calculated on demand, 
#' setting this parameter to true might slightly slow down the response time
#' @param duplicate (logical) Whether to retrieve a list of CORE IDs of 
#' different versions of the article. Default: `FALSE`
#' @param urls (logical) Whether to retrieve a list of URLs from which the 
#' article can be downloaded. This can include links to PDFs as well as 
#' HTML pages. Default: `FALSE`
#' @param faithfulMetadata (logical) Returns the records raw XML metadata 
#' from the original repository. Default: `FALSE`
#' 
#' @details `core_articles_search` does the HTTP request and parses, while
#' `core_articles_search_` just does the HTTP request, gives back JSON as a character
#' string
#' 
#' @references <https://core.ac.uk/docs/#!/all/search>
#' 
#' @examples \dontrun{
#' core_articles_search(query = 'ecology')
#' core_articles_search(query = 'ecology', parse = FALSE)
#' core_articles_search(query = 'ecology', limit = 12)
#' out = core_articles_search(query = 'ecology', fulltext = TRUE)
#'
#' core_articles_search_(query = 'ecology')
#' jsonlite::fromJSON(core_articles_search_(query = 'ecology'))
#' 
#' # post request
#' query <- c('data mining', 'semantic web')
#' res <- core_articles_search(query)
#' head(res$data)
#' res$data[[2]]$doi
#' }
core_articles_search <- function(query, metadata = TRUE, fulltext = FALSE, 
  citations = FALSE, similar = FALSE, duplicate = FALSE, urls = FALSE, 
  faithfulMetadata = FALSE, page = 1, limit = 10, key = NULL, 
  parse = TRUE, ...) {

  core_parse(
    core_articles_search_(query, metadata, fulltext, citations, 
      similar, duplicate, urls, faithfulMetadata, page, limit, key, ...),
    parse
  )
}

#' @export
#' @rdname core_articles_search
core_articles_search_ <- function(query, metadata = TRUE, fulltext = FALSE, 
  citations = FALSE, similar = FALSE, duplicate = FALSE, urls = FALSE, 
  faithfulMetadata = FALSE, page = 1, limit = 10, key = NULL, ...) {
  
  must_be(limit)
  args <- cp(list(metadata = asl(metadata), fulltext = asl(fulltext), 
    citations = asl(citations), similar = asl(similar), 
    duplicate = asl(duplicate), urls = asl(urls), 
    faithfulMetadata = asl(faithfulMetadata)))
  if (length(query) > 1) {
    queries <- create_batch_query_list(query, page, limit)
    core_POST(path = "articles/search", key, args, queries, ...)
  } else {
    args$page <- page
    args$pageSize <- limit
    core_GET(path = file.path("articles/search", query), key,
             args, ...)
  }
}
