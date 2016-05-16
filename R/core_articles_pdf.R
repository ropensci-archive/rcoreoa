#' Download article pdf
#'
#' @export
#' @template all
#' @param id (integer) CORE ID of the article that needs to be fetched. Required
#' @param overwrite (logical) overwrite file or not. Default: \code{TRUE}
#' @details \code{core_articles_history} does the HTTP request and parses, while
#' \code{core_articles_history_} just does the HTTP request, gives back JSON as a character
#' string
#'
#' These functions take one article ID at a time. Use lapply/loops/etc for many ids
#' @references \url{https://core.ac.uk/docs/#!/articles/getArticlePdfByCoreId}
#' @examples \dontrun{
#' # just http request, get file path back
#' core_articles_pdf_(11549557)
#'
#' # get paper and parse to text
#' core_articles_pdf(11549557)
#'
#' ids <- c(11549557, 385071, 6264645)
#' res <- lapply(ids, core_articles_pdf)
#' vapply(res, "[[", "", 1)
#' }
core_articles_pdf <- function(id, key = NULL, overwrite = TRUE, parse = TRUE, ...) {
  pdf_parse(core_articles_pdf_(id, key, overwrite, ...), parse)
}

#' @export
#' @rdname core_articles_pdf
core_articles_pdf_ <- function(id, key = NULL, overwrite = TRUE, ...) {
  core_GET_disk(path = sprintf("articles/get/%s/download/pdf", id), id, key, overwrite, ...)
}
