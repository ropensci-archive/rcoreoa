#' Get articles
#'
#' @export
#' @template all
#' @param id (integer) CORE ID of the article that needs to be fetched.
#' Required
#' @param metadata Whether to retrieve the full article metadata or only the
#' ID. Default: `TRUE`
#' @param fulltext Whether to retrieve full text of the article. Default:
#' `FALSE`
#' @param citations	Whether to retrieve citations found in the article.
#' Default: `FALSE`
#' @param similar	Whether to retrieve a list of similar articles.
#' Default: `FALSE`
#' Because the similar articles are calculated on demand, setting this
#' parameter to true might slightly slow down the response time	query
#' @param duplicate	Whether to retrieve a list of CORE IDs of different
#' versions of the article. Default: `FALSE`
#' @param urls Whether to retrieve a list of URLs from which the article can
#' be downloaded. This can include links to PDFs as well as HTML pages.
#' Default: `FALSE`
#' @param extractedUrls Whether to retrieve a list of URLs which were extracted
#' from the article fulltext. Default: `FALSE`. This parameter is not
#' available in CORE API v2.0 beta
#' @param faithfulMetadata Whether to retrieve the raw XML metadata of the
#' article. Default: `FALSE`
#' @param method (character) one of 'GET' (default) or 'POST'
#' @details `core_articles` does the HTTP request and parses, while
#' `core_articles_` just does the HTTP request, gives back JSON as a
#' character string
#'
#' These functions take one article ID at a time. Use lapply/loops/etc for
#' many ids
#' @references
#' <https://core.ac.uk/docs/#!/articles/getArticleByCoreIdBatch>
#' <https://core.ac.uk/docs/#!/articles/getArticleByCoreId>
#' @examples \dontrun{
#' core_articles(id = 21132995)
#' core_articles(id = 21132995, fulltext = TRUE)
#' core_articles(id = 21132995, citations = TRUE)
#'
#' # when passing >1 article ID
#' ids <- c(20955435, 21132995, 21813171, 22815670, 23828884,
#'    23465055, 23831838, 23923390, 22559733)
#' ## you can use method="GET" with lapply or similar
#' res <- lapply(ids, core_articles)
#' vapply(res, "[[", "", c("data", "datePublished"))
#'
#' ## or use method="POST" passing all at once
#' res <- core_articles(ids, method = "POST")
#' head(res$data)
#' res$data$authors
#'
#' # just http request, get text back
#' core_articles_(id = '21132995')
#' ## POST, can pass many at once
#' core_articles_(id = ids, method = "POST")
#' }
core_articles <- function(id, metadata = TRUE, fulltext = FALSE,
  citations = FALSE, similar = FALSE, duplicate = FALSE, urls = FALSE,
  extractedUrls = FALSE, faithfulMetadata = FALSE, key = NULL,
  method = "GET", parse = TRUE, ...) {

  core_parse(core_articles_(
    id, metadata, fulltext, citations, similar, duplicate,
    urls, extractedUrls, faithfulMetadata, key, method, ...), parse)
}

#' @export
#' @rdname core_articles
core_articles_ <- function(id, metadata = TRUE, fulltext = FALSE,
  citations = FALSE, similar = FALSE, duplicate = FALSE, urls = FALSE,
  extractedUrls = FALSE, faithfulMetadata = FALSE, key = NULL,
  method = "GET", ...) {

  args <- cp(list(
    metadata = clog(metadata), fulltext = clog(fulltext),
    citations = clog(citations), similar = clog(similar),
    duplicate = clog(duplicate), urls = clog(urls),
    extractedUrls = clog(extractedUrls),
    faithfulMetadata = clog(faithfulMetadata))
  )
  if (!method %in% c('GET', 'POST')) {
    stop("'method' must be one of 'GET' or 'POST'", call. = FALSE)
  }
  switch(
    method,
    `GET` = {
      if (length(id) > 1) stop("'id' must be of length 1 when 'method=GET'",
                               call. = FALSE)
      core_GET(path = file.path("articles/get", id), key, args, ...)
    },
    `POST` = core_POST(path = "articles/get", key, args, id, ...)
  )
}
