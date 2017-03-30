#' Get article history
#'
#' @export
#' @template all
#' @param id (integer) CORE ID of the article that needs to be fetched.
#' Required
#' @param page (character) page number (default: 1), optional
#' @param limit (character) records to return (default: 10, minimum: 10),
#' optional
#' @details `core_articles_history` does the HTTP request and parses,
#' while `core_articles_history_` just does the HTTP request, gives back JSON
#' as a character string
#'
#' These functions take one article ID at a time. Use lapply/loops/etc for
#' many ids
#' @references <https://core.ac.uk/docs/#!/articles/getArticleHistoryByCoreId>
#' @examples \dontrun{
#' core_articles_history(id = '21132995')
#'
#' ids <- c(20955435, 21132995, 21813171, 22815670, 14045109, 23828884,
#'    23465055, 23831838, 23923390, 22559733)
#' res <- lapply(ids, core_articles_history)
#' vapply(res, function(z) z$data$datetime[1], "")
#'
#' # just http request, get text back
#' core_articles_history_('21132995')
#' }
core_articles_history <- function(id, page = 1, limit = 10, key = NULL,
                                  parse = TRUE, ...) {

  core_parse(core_articles_history_(id, page, limit, key, ...), parse)
}

#' @export
#' @rdname core_articles_history
core_articles_history_ <- function(id, page = 1, limit = 10, key = NULL, ...) {
  must_be(limit)
  core_GET(path = sprintf("articles/get/%s/history", id), key,
           list(page = page, pageSize = limit), ...)
}
