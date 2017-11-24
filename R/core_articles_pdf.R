#' Download article pdf
#'
#' @export
#' @param id (integer) CORE ID of the article that needs to be fetched.
#' One or more. Required
#' @param key A IUCN API token. Required
#' @param overwrite (logical) overwrite file or not if already
#' on disk. Default: `FALSE`
#' @param ... Curl options passed to [crul::HttpClient()]
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
#' @return `core_articles_pdf_` returns a file path on success.
#' When many IDs passed to `core_articles_pdf` it returns a list (equal to
#' length of IDs) where each element is a character vector of length equal
#' to number of pages in the PDF; but on failure throws warning and returns
#' NULL. When single ID apssed to `core_articles_pdf` it returns a character
#' vector of length equal to number of pages in the PDF, but on failure
#' stops with message
#' @references <https://core.ac.uk/docs/#!/articles/getArticlePdfByCoreId>
#' @examples \dontrun{
#' # just http request, get file path back
#' core_articles_pdf_(11549557)
#'
#' # get paper and parse to text
#' core_articles_pdf(11549557)
#'
#' ids <- c(11549557, 385071)
#' res <- core_articles_pdf(ids)
#' cat(res[[1]][1])
#' cat(res[[2]][1])
#' }
core_articles_pdf <- function(id, key = NULL, overwrite = FALSE, ...) {
	if (length(id) == 1) {
		pdf_parse(core_articles_pdf_(id, key, overwrite, ...))
	} else {
		lapply(id, function(z) {
			res <- tryCatch(core_articles_pdf_(z, key, overwrite, ...),
				error = function(e) e)
			if (inherits(res, "error")) {
				warning(sprintf("id %s - ", z), res)
				return(NULL)
			} else {
				return(pdf_parse(res))
			}
		})
	}
}

#' @export
#' @rdname core_articles_pdf
core_articles_pdf_ <- function(id, key = NULL, overwrite = FALSE, ...) {
	core_GET_disk(path = sprintf("articles/get/%s/download/pdf", id), id,
		key, overwrite, ...)
}
