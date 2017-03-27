cp <- function(x) Filter(Negate(is.null), x)

core_GET <- function(path, key, args, ...){
  temp <- httr::GET(file.path(core_base(), path),
              query = cp(c(args, list(apiKey = check_key(key)))), ...)
  httr::stop_for_status(temp)
  stopifnot(temp$headers$`content-type` == 'application/json')
  #err_catcher(temp)
  httr::content(temp, as = 'text', encoding = "UTF-8")
}

core_POST <- function(path, key, args, body, ...){
  temp <- httr::POST(file.path(core_base(), path),
              query = cp(c(args, list(apiKey = check_key(key)))),
              body = jsonlite::toJSON(body), encode = "json", ...)
  httr::stop_for_status(temp)
  stopifnot(temp$headers$`content-type` == 'application/json')
  #err_catcher(temp)
  httr::content(temp, as = 'text', encoding = "UTF-8")
}

core_GET_disk <- function(path, id, key, overwrite, ...){
  temp <- httr::GET(file.path(core_base(), path),
              query = list(apiKey = check_key(key)),
              httr::write_disk(path = paste0(id, ".pdf"),
                               overwrite = overwrite), ...)
  httr::stop_for_status(temp)
  temp$request$output$path
}

core_parse <- function(x, parse) {
  jsonlite::fromJSON(x, parse)
}

check_key <- function(x){
  tmp <- if (is.null(x)) Sys.getenv("CORE_KEY", "") else x
  if (tmp == "") {
    getOption("core_key", stop("you need an API key for Core", call. = FALSE))
  } else {
    tmp
  }
}

must_be <- function(x, y = 10) {
  if (x < y) stop("limit must be >= 10", call. = FALSE)
}

core_base <- function() "https://core.ac.uk/api-v2"

clog <- function(x){
  if (is.null(x)) {
    NULL
  } else {
    if (x) 'true' else 'false'
  }
}

pdf_parse <- function(x, parse) {
  if (parse) pdftools::pdf_text(x) else x
}
