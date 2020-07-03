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
#' 
#' ab = 'Neonicotinoid seed dressings have caused concern world-wide. We use
#' large field experiments to assess the effects of neonicotinoid-treated crops
#' on three bee species across three countries (Hungary, Germany, and the
#' United Kingdom). Winter-sown oilseed rape was grown commercially with
#' either seed coatings containing neonicotinoids (clothianidin or
#' thiamethoxam) or no seed treatment (control). For honey bees, we found
#' both negative (Hungary and United Kingdom) and positive (Germany)
#' effects during crop flowering. In Hungary, negative effects on honey
#' bees (associated with clothianidin) persisted over winter and resulted
#' in smaller colonies in the following spring (24% declines). In wild
#' bees (Bombus terrestris and Osmia bicornis), reproduction was
#' negatively correlated with neonicotinoid residues. These findings
#' point to neonicotinoids causing a reduced capacity of bee species
#' to establish new populations in the year following exposure.'
#' core_articles_dedup(
#'   title = "Country-specific effects of neonicotinoid pesticides on honey bees and wild bees",
#'   description = ab, verbose = TRUE)
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

  body <- cp(list(
    doi = doi, title = title, year = year, description = description,
    fulltext = fulltext, identifier = identifier, repositoryId = repositoryId
  ))
  core_POST(path = "articles/dedup", key, list(), body, ...)
}
