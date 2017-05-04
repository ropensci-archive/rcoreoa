#' cored - CORE R client
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
#' \itemize{
#'  \item [core_articles()] / [core_articles_()] - get article metadata
#'  \item [core_articles_history()] / [core_articles_history_()] - get
#'  article history metadata
#'  \item [core_articles_pdf()] / [core_articles_pdf_()] - download
#'  article PDF, and optionally extract text
#'  \item [core_journals()] / [core_journals_()] - get journal metadata
#'  \item [core_repos()] / [core_repos_()] - get repository metadata
#'  \item [core_repos_search()] / [core_repos_search_()] - search for
#'  repositories
#'  \item [core_search()] / [core_search_()] - search articles
#'  \item [core_advanced_search()] / [core_advanced_search_()] -
#'  advanced search of articles
#' }
#'
#' @name cored-package
#' @aliases cored
#' @docType package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @author Aristotelis Charalampous
#' @keywords package
NULL
