#' Get repositories via their repository IDs
#'
#' @export
#' @template all
#' @param id (integer) One or more repository IDs. Required
#' @param method (character) one of 'GET' (default) or 'POST'
#' @details `core_repos` does the HTTP request and parses, while
#' `core_repos_` just does the HTTP request, gives back JSON as a
#' character string
#'
#' These functions take one article ID at a time. Use lapply/loops/etc for
#' many ids
#' @references <https://core.ac.uk/docs/#!/repositories/getRepositoryById>
#' <https://core.ac.uk/docs/#!/repositories/getRepositoryByIdBatch>
#' @examples \dontrun{
#' core_repos(id = 507)
#' core_repos(id = 444)
#'
#' ids <- c(507, 444, 70)
#' res <- lapply(ids, core_repos)
#' vapply(res, "[[", "", c("data", "name"))
#'
#' # just http request, get json as character vector back
#' core_repos_(507)
#' }
core_repos <- function(id, key = NULL, method = "GET", parse = TRUE, ...) {
  core_parse(core_repos_(id, key, method, ...), parse)
}

#' @export
#' @rdname core_journals
core_repos_ <- function(id, key = NULL, method = "GET", ...) {
  if (!method %in% c('GET', 'POST')) {
    stop("'method' must be one of 'GET' or 'POST'", call. = FALSE)
  }
  switch(
    method,
    `GET` = {
      if (length(id) > 1) stop("'id' must be of length 1 when 'method=GET'",
                               call. = FALSE)
      core_GET(path = paste0("repositories/get/", id), key, list(), ...)
    },
    `POST` = core_POST(path = "repositories/get", key, list(), id, ...)
  )
}
