#' Article deduplication
#'
#' @export
#' @template all
#' @param doi (character) the DOI for which the duplicates will be identified.
#' optional
#' @param title (character) title to match when looking for duplicate articles.
#' Either `year` or `description` should also be supplied if this parameter is
#' supplied. optional
#' @param year (character) year the article was published. Only used in
#' combination with the value for `title` parameter. optional
#' @param description (character) abstract for an article based on which its
#' duplicates will be found. This should be more than 500 characters. Value
#' for the `title` parameter should also be supplied if this is supplied.
#' optional
#' @param fulltext (character) Full text for an article based on which its
#' duplicates will be found. optional
#' @param identifier (character) CORE ID of the article for which the
#' duplicates will be identified. optional
#' @param repositoryId (character) Limit the duplicates search to
#' particular repository id. optional
#' @references
#' <https://core.ac.uk/docs/#!/articles/nearDuplicateArticles>
#' @examples \dontrun{
#' core_articles_dedup(title = "Managing exploratory innovation", year = 2010)
#' core_articles_dedup_(title = "Managing exploratory innovation", year = 2010)
#' }
core_articles_dedup <- function(doi = NULL, title = NULL, year = NULL,
  description = NULL, fulltext = NULL, identifier = NULL, repositoryId = NULL,
  key = NULL, parse = TRUE, ...) {

  core_parse(core_articles_dedup_(
    doi, title, year, description, fulltext, identifier,
    repositoryId, key, ...), parse)
}

#' @export
#' @rdname core_articles_dedup
core_articles_dedup_ <- function(doi = NULL, title = NULL, year = NULL,
  description = NULL, fulltext = NULL, identifier = NULL, repositoryId = NULL,
  key = NULL, ...) {

  args <- cp(list(
    doi = doi, title = title, year = year, description = description,
    fulltext = fulltext, identifier = identifier, repositoryId = repositoryId)
  )
  core_POST(path = "articles/dedup", key, args, list(), ...)
}
