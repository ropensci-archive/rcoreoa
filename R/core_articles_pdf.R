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
#' We now do a request to [core_articles()] first to find out if there is a
#' PDF available via existence of the field `fulltextIdentifier`. If not,
#' we stop with error message; if the field exists, we proceed to
#' attempting to fetch the PDF.
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
	# check if the ID has a PDF associated
	x <- core_articles(id, key = key)
	if (is.null(x$data$fulltextIdentifier)) {
		stop("no PDF available for ", id, call. = FALSE)
	} else {
		# get PDF
  	core_GET_disk(path = sprintf("articles/get/%s/download/pdf", id), id,
                key, overwrite, ...)
	}
}
