cp <- function(x) Filter(Negate(is.null), x)

core_GET <- function(path, key, args, ...){
  cli <- crul::HttpClient$new(url = core_base())
  temp <- cli$get(
    path = file.path("api-v2", path),
    query = cp(c(args, list(apiKey = check_key(key)))),
    ...
  )
  temp$raise_for_status()
  stopifnot(temp$response_headers$`content-type` == 'application/json')
  temp$parse("UTF-8")
}

core_POST <- function(path, key, args, body, ...){
  cli <- crul::HttpClient$new(url = core_base())
  temp <- cli$post(
    path = file.path("api-v2", path),
    query = cp(c(args, list(apiKey = check_key(key)))),
    body = jsonlite::toJSON(body), encode = "json", ...
  )
  temp$raise_for_status()
  stopifnot(temp$response_headers$`content-type` == 'application/json')
  temp$parse("UTF-8")
}

core_GET_disk <- function(path, id, key, overwrite, ...){
  cli <- crul::HttpClient$new(url = core_base())
  temp <- cli$get(
    path = file.path("api-v2", path),
    query = list(apiKey = check_key(key)),
    disk = paste0(id, ".pdf"),
    ...
  )
  temp$raise_for_status()
  temp$content
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

core_base <- function() "https://core.ac.uk"

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
