#' rcoreoa - CORE R client
#'
#' CORE is a web service for metadata on scholarly journal articles. Find
#' CORE at <https://core.ac.uk> and their API docs at
#' <https://core.ac.uk/docs/>.
#'
#' @section Package API:
#' Each API endpoint has two functions that interface with it - a higher
#' level interface and a lower level interface. The lower level functions
#' have an underscore (`_`) at the end of the function name, while their
#' corresponding higher level companions do not. The higher level functions
#' parse to list/data.frame's (as tidy as possible). Lower level
#' functions give back JSON (character class) thus are slightly faster not
#' spending time on parsing to R structures.
#'
#' - [core_articles()] / [core_articles_()] - get article metadata
#' - [core_articles_history()] / [core_articles_history_()] - get
#'  article history metadata
#' - [core_articles_pdf()] / [core_articles_pdf_()] - download
#'  article PDF, and optionally extract text
#' - [core_journals()] / [core_journals_()] - get journal metadata
#' - [core_repos()] / [core_repos_()] - get repository metadata
#' - [core_repos_search()] / [core_repos_search_()] - search for
#'  repositories
#' - [core_search()] / [core_search_()] - search articles
#' - [core_advanced_search()] / [core_advanced_search_()] -
#'  advanced search of articles
#' 
#' @section Authentication:
#' You'll need a CORE API token/key to use this package. Get one at 
#' <https://core.ac.uk/api-keys/register>
#' 
#' @section Pagination:
#' Note that you are limited to a maximum of 100 results for the search
#' functions; use combination of `page` and `limit` parameters to
#' paginate through results. For example:
#' 
#' ```
#' x1 <- core_search(query = 'ecology', limit = 100, page = 1)
#' x2 <- core_search(query = 'ecology', limit = 100, page = 2)
#' ```
#'
#' @name rcoreoa-package
#' @aliases rcoreoa
#' @docType package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @author Aristotelis Charalampous
#' @keywords package
NULL
