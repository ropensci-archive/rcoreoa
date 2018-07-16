#' @param key A CORE API key. Get one at 
#' \url{https://core.ac.uk/api-keys/register}. Once you have the key, 
#' you can pass it into this parameter, or as a much better option, 
#' store your key as an environment variable with the name 
#' \code{CORE_KEY} or an R option as \code{core_key}. See `?Startup` 
#' for how to work with env vars and R options
#' @param ... Curl options passed to \code{\link[crul]{HttpClient}}
#' @param parse (logical) Whether to parse to list (\code{FALSE}) or
#' data.frame (\code{TRUE}). Default: \code{TRUE}
