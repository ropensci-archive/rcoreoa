#' Advanced Search CORE
#'
#' @export
#' @template all
#' @param ... for `core_query()`, query fields, see Details. for
#' `core_advanced_search()` any number of queries, results of calling
#' `core_query()`. Required. See Details.
#' @param page (character) page number (default: 1), optional
#' @param limit (character) records to return (default: 10, minimum: 10,
#' maximum: 100), optional
#' @param key A CORE API key. Get one at 
#' \url{https://core.ac.uk/api-keys/register}. Once you have the key, 
#' you can pass it into this parameter, or as a much better option, 
#' store your key as an environment variable with the name 
#' \code{CORE_KEY} or an R option as \code{core_key}. See `?Startup` 
#' for how to work with env vars and R options
#' @param parse (logical) Whether to parse to list (\code{FALSE}) or
#' data.frame (\code{TRUE}). Default: \code{TRUE}
#' @param .list alternative to passing `core_query()` calls to `...`;
#' just create a list of them and pass to this parameter; easier for 
#' programming with
#' @param op (character) operator to combine multiple fields. options:
#' `AND`, `OR`
#' @details `query` should be one or more calls to `core_query()`, 
#' (at least one is required):
#' - `title`
#' - `description`
#' - `fullText`
#' - `authors`
#' - `publisher`: string, to be used as an absolute match against the
#' publisher name metadata field
#' - `repositories.id`: repository id
#' - `repositories.name`: repository name
#' - `doi`: string, to be used as an absolute match against the repository
#' name metadata field (all other fields will be ignored if included)
#' - `oai`
#' - `identifiers`
#' - `language.name`: string, to filter against languages specified in
#' https://en.wikipedia.org/wiki/ISO_639-1
#' - `year`: year to filter to
#' 
#' `core_advanced_search` does the HTTP request and parses, while
#' `core_advanced_search_` just does the HTTP request, gives back JSON as a
#' character string
#' @return data.frame with the following columns:
#' - `status`: string, which will be 'OK' or 'Not found' or
#' 'Too many queries' or 'Missing parameter' or 'Invalid parameter' or
#' 'Parameter out of bounds'
#' - `totalHits`: integer, Total number of items matching the search criteria
#' - `data`: list, a list of relevant resource
#' @references https://core.ac.uk/docs/#!/all/searchBatch
#' @examples \dontrun{
#' ## compose queries
#' core_query(title="psychology", year=2014)
#' core_query(title="psychology", year=2014, op="OR")
#' core_query(identifiers='"oai:aura.abdn.ac.uk:2164/3837"',
#'   identifiers='"oai:aura.abdn.ac.uk:2164/3843"', op="OR")
#' 
#' ## do actual searches
#' core_advanced_search(
#'   core_query(identifiers='"oai:aura.abdn.ac.uk:2164/3837"',
#'     identifiers='"oai:aura.abdn.ac.uk:2164/3843"', op="OR")
#' )
#' 
#' res <- core_advanced_search(
#'   core_query(title="psychology"),
#'   core_query(doi='"10.1186/1471-2458-6-309"'),
#'   core_query(language.name="german")
#' )
#' res
#' res[[1]]
#' res[[2]]
#' rbl(lapply(res, function(w) w$data$`_source`))
#' }
core_advanced_search <- function(..., page = 1, limit = 10,
  key = NULL, parse = TRUE, .list = list()) {

  assert(page, c('numeric', 'integer'))
  assert(limit, c('numeric', 'integer'))
  must_be(limit)
  qrs <- list(...)
  if (length(qrs) == 0) qrs <- NULL
  qrs <- c(qrs, .list)
  queries <- create_batch_query_list(qrs, page, limit)
  res <- core_POST(path = "search", key, NULL, queries)
  core_parse(res, parse)
}

acceptable_advanced_filters <- c(
  "title", "description", "fullText", "authors",
  "publisher", "repositories.id", "repositories.name", "doi",
  "oai", "identifiers", "language.name", "year",
  "repositoryDocument.metadataUpdated"
)

#' @export
#' @rdname core_advanced_search
core_query <- function(..., op = "AND") {
  x <- list(...)
  if (length(x) == 0) stop("no queries passed")
  x <- x[which(names(x) %in% acceptable_advanced_filters)]
  out <- c()
  for (i in seq_along(x)) {
    out[i] <- paste0(names(x)[i], ":", x[[i]])
  }
  paste(out, collapse = sprintf(" %s ", op))
}
