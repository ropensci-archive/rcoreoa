core_base <- function() "https://core.ac.uk"

cp <- function(x) Filter(Negate(is.null), x)

core_GET <- function(path, key, args, ...){
  cli <- crul::HttpClient$new(
    url = core_base(),
    headers = list(apiKey = check_key(key))
  )
  temp <- cli$get(
    path = file.path("api-v2", path),
    query = cp(args),
    ...
  )
  temp$raise_for_status()
  stopifnot(temp$response_headers$`content-type` == 'application/json')
  temp$parse("UTF-8")
}

core_POST <- function(path, key, args, body, ...){
  cli <- crul::HttpClient$new(
    url = core_base(),
    headers = list(apiKey = check_key(key))
  )
  temp <- cli$post(
    path = file.path("api-v2", path),
    query = cp(args),
    body = jsonlite::toJSON(body, auto_unbox=T), encode = "json", ...
  )
  temp$raise_for_status()
  stopifnot(temp$response_headers$`content-type` == 'application/json')
  temp$parse("UTF-8")
}

core_GET_disk <- function(path, id, key, overwrite, ...){
  cli <- crul::HttpClient$new(
    url = core_base(),
    headers = list(apiKey = check_key(key))
  )
  temp <- cli$get(
    path = file.path("api-v2", path),
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

create_batch_query_list <- function(queries, page = NULL, pageSize = NULL) {
  # We could have allowed for variable values with the pages or pageSize variables, but for simplicity, 
  # this function will allow for a single value across only --v
  if(!is.numeric(page)){
    return(NULL)
  } else if (!is.numeric(pageSize)) {
    return(NULL)
  }
  
  if(is.null(page)){ # || length(page) != length(queries)){
    page = 1
  }
  
  if(is.null(pageSize)){ # || length(page) != length(pageSize)){
    pageSize = 10
  }
  
  queryList <- lapply(queries, function(x){
    as.list(setNames(x, rep("query", length(x))))
  })
  
  queryList <- Map(c, queryList, page = rep(page))
  queryList <- Map(c, queryList, pageSize = rep(pageSize))
  
  return(queryList)
}
