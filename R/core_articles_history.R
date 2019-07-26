#' Get article history
#'
#' @export
#' @template all
#' @param id (integer) CORE ID of the article that needs to be fetched.
#' One or more. Required
#' @param page (character) page number (default: 1), optional
#' @param limit (character) records to return (default: 10, minimum: 10,
#' maximum: 100), optional
#' @details `core_articles_history` does the HTTP request and parses,
#' while `core_articles_history_` just does the HTTP request, gives back JSON
#' as a character string
#' @return `core_articles_history_` returns a JSON string on success.
#' `core_articles_history` returns a list (equal to `id` length) where each
#' element is a list of length two with elements for data and status of
#' the request; on failure the data slot is NULL.
#' @references <https://core.ac.uk/docs/#!/articles/getArticleHistoryByCoreId>
#' @examples \dontrun{
#' core_articles_history(id = 21132995)
#'
#' ids <- c(20955435, 21132995, 21813171, 22815670, 14045109, 23828884,
#'    23465055, 23831838, 23923390, 22559733)
#' res <- core_articles_history(ids)
#' vapply(res, function(z) z$data$datetime[1], "")
#'
#' # just http request, get text back
#' core_articles_history_(21132995)
#' }
core_articles_history <- function(id, page = 1, limit = 10, key = NULL,
                                  parse = TRUE, ...) {

	if (length(id) == 1) {
		core_parse(core_articles_history_(id, page, limit, key, ...), parse)
	} else {
		lapply(id, function(z) {
			res <- tryCatch(core_articles_history_(z, page, limit, key, ...),
				error = function(e) e)
			if (inherits(res, "error")) {
				warning(sprintf("id %s - ", z), res)
				return(NULL)
			} else {
				return(core_parse(res, parse))
			}
		})
	}
}

#' @export
#' @rdname core_articles_history
core_articles_history_ <- function(id, page = 1, limit = 10, key = NULL, ...) {
  must_be(limit)
  core_GET(path = sprintf("articles/get/%s/history", id), key,
           list(page = page, pageSize = limit), ...)
}
