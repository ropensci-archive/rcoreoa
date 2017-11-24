#' Download article pdf
#'
#' @export
#' @template all
#' @param id (integer) CORE ID of the article that needs to be fetched.
#' Required
#' @param overwrite (logical) overwrite file or not. Default: `TRUE`
#' @details `core_articles_pdf` does the HTTP request and parses
#' PDF to text, while `core_articles_pdf_` just does the HTTP request
#' and gives back the path to the file
#'
#' If you get a message like `Error: Not Found (HTTP 404)`, that means
#' a PDF was not found. That is, it does not exist. That is, there is no
#' PDF associated with the article ID you searched for. This is the
#' correct behavior, and nothing is wrong with this function or this
#' package. We could do another web request to check if the id you
#' pass in has a PDF or not first, but that's another request, slowing
#' this function down.
#'
#' These functions take one article ID at a time. Use lapply/loops/etc for
#' many ids
#' @references <https://core.ac.uk/docs/#!/articles/getArticlePdfByCoreId>
#' @examples \dontrun{
#' # just http request, get file path back
#' core_articles_pdf_(11549557)
#'
#' # get paper and parse to text
#' core_articles_pdf(11549557)
#'
#' ids <- c(11549557, 385071)
#' res <- lapply(ids, core_articles_pdf)
#' vapply(res, "[[", "", 1)
#' }
core_articles_pdf <- function(id, key = NULL, overwrite = TRUE, parse = TRUE,
                              ...) {
  pdf_parse(core_articles_pdf_(id, key, overwrite, ...), parse)
}

#' @export
#' @rdname core_articles_pdf
core_articles_pdf_ <- function(id, key = NULL, overwrite = TRUE, ...) {
	core_GET_disk(path = sprintf("articles/get/%s/download/pdf", id), id,
		key, overwrite, ...)
}
