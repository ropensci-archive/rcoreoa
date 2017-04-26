core_base <- function() "https://core.ac.uk"

# Advanced search related functions

get_acceptable_advanced_search_query_filter <- function(){
  return(c("all_of_the_words", "exact_phrase", "at_least_one_of_the_words", 
           "without_the_words", "find_those_words", "author", "publisher",
           "repository", "doi", "yearFrom", "yearTo", "advAuthor"))
}

# Leading and trailing spaces
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

paste3 <- function(..., sep=", ") {
  L <- list(...)
  L <- lapply(L,function(x) {x[is.null(x) || is.na(x) ] <- ""; x})
  ret <-gsub(paste0("(^",sep,"|",sep,"$)"),"",
             gsub(paste0(sep,sep),sep,
                  do.call(paste,c(L,list(sep=sep)))))
  is.na(ret) <- ret==""
  ret
}

prepareESTerm <- function(filter) {
  if(!is.na(filter)){
    if(is.acceptable.string(filter)){
      filterArr <- unlist(strsplit(x = filter, split = " "))
      return(paste(":(", paste(filterArr, sep = " AND "), ")", sep=""))
    }
  }
}

is.acceptable.year.filter <- function(year, nullable=TRUE) {
  today <- Sys.Date();
  numericPattern <- "^[0-9]{4}$"
  
  if(nullable){
    return (
      (!is.na(as.integer(year)) &&
         (as.integer(year) <= format(today, "%Y")) &&
         regexpr(pattern = numericPattern, text = year)[1] == 1
      ) || nchar(year) > 0);
  } else {
    return (
      !is.na(as.integer(year)) &&
        (as.integer(year) <= format(today, "%Y")) &&
        regexpr(pattern = numericPattern, text = year)[1] == 1
    )
  }
}

are.acceptable.year.filter <- function(year_from, year_to){
  return( 
    (!is.null(year_from) && nchar(year_from) > 0 && !is.na(as.integer(year_from))) &&
      (!is.null(year_to) && nchar(year_to) > 0 && !is.na(as.integer(year_to))) &&
      (as.integer(year_from) <= as.integer(year_to))
  ) 
}

is.acceptable.string <- function(txt){
  return(is.character(txt) && nchar(txt) > 0)
}

parse_advanced_search_query <- function(query){
  if ("doi" %in% names(query)){
    if(!is.null(query["doi"]) && query["doi"] != ""){
      # Form query only with a DOI as it is a unique identifier and no more filters are required.
      return(paste('doi:(', query["doi"], ')', sep=""))
    } else {
      return("")
    }
  } else {
    if(is.na(query["find_those_words"]) || !is.acceptable.string(query["find_those_words"])){
      query["find_those_words"] <- "anywhere in the article"
    }
    
    # word related filters (left column of advanced search query UI)
    basicTermReplacement <- "";
    wordFilter <- "";
    
    today <- Sys.Date();
    yearToday <- format(today, "%Y")
    
    if("without_the_words" %in% names(query)){
      withoutTheWordsArr <- unlist(strsplit(x = query["without_the_words"], split = " "))
      withoutTheWordsArrStr <- paste("-", paste(withoutTheWordsArr, collapse = " -"), sep = "")
    } else {
      withoutTheWordsArrStr <- ""
    }
    
    if("all_of_the_words" %in% names(query)){
      allOfTheWords <- paste("(", paste(x = unlist(strsplit(x = query["all_of_the_words"], split = " ")), collapse = (" AND ")), ") ", sep = "")
    } else {
      allOfTheWords <- ""
    }
    
    if("exact_phrase" %in% names(query)){
      exactPhrase <- paste("\"", query["exact_phrase"], "\"", sep = "")
    } else {
      exactPhrase <- ""
    }
    
    if("at_least_one_of_the_words" %in% names(query)){
      atLeastOneOfTheWords <- paste("(", paste(x = unlist(strsplit(x = query["at_least_one_of_the_words"], split = " ")), collapse = (" OR ")), ") ", sep = "")
    } else {
      atLeastOneOfTheWords <- ""
    }
    
    wordFilter <- paste(if(is.acceptable.string(withoutTheWordsArrStr)) withoutTheWordsArrStr else "",
                        if(is.acceptable.string(allOfTheWords)) allOfTheWords else "",
                        if(is.acceptable.string(exactPhrase)) exactPhrase else "",
                        if(is.acceptable.string(atLeastOneOfTheWords)) atLeastOneOfTheWords else "",
                        sep = "")
    
    # Not guarranteed to be here so set its default at this point manually.
    if(!"find_those_words" %in% query){
      query["findThoseWords"] <- "anywhere in the article"
    }
    
    if(regexpr(pattern = "title", text = query["find_those_words"])[1] == 1) {
      basicTermReplacement <- paste(basicTermReplacement, "title:(", wordFilter, ")", sep = "");
    } else if(regexpr(pattern = "abstract", text = query["find_those_words"])[1] == 1) {
      basicTermReplacement <- paste(basicTermReplacement, "abstract:(", wordFilter, ")", sep = "");
    } else {
      basicTermReplacement <- paste(basicTermReplacement, wordFilter, sep = "")
    }
    
    yearFilter <- ""
    
    yearFilter <- if(are.acceptable.year.filter(query["year_from"], query["year_to"])) 
      paste("year:[", query["year_from"], " TO ", query["year_to"], "]", sep="") else ""
    
    yearFilter = if(nchar(yearFilter) == 0 && (is.null(query["year_from"]) || nchar(query["year_from"]) == 0)
                    && is.acceptable.year.filter(query["yearTo"], FALSE)) paste("year:[* TO ", query["yearTo"], "]", sep="") else yearFilter
    
    yearFilter = if (nchar(yearFilter) == 0 && (is.null(query["year_to"]) || nchar(query["year_to"]) == 0)
                     && is.acceptable.year.filter(query["year_to"], FALSE)) paste("year:[", query["year_from"], " TO ", today, "]", sep="") else yearFilter
    
    authorFilter <- prepareESTerm(query["author"])
    publisherFilter <- prepareESTerm(query["publisher"])
    repositoryFilter <- prepareESTerm(query["repository"])
    
    print(basicTermReplacement)
    print(yearFilter)
    print(authorFilter)
    print(publisherFilter)
    print(repositoryFilter)
    
    basicTermReplacement <- paste3(authorFilter, basicTermReplacement, yearFilter, publisherFilter, repositoryFilter, sep = " AND ")
    
    return(basicTermReplacement)
  }
}

# End of advanced search related functions.

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
    body = jsonlite::toJSON(body, auto_unbox = TRUE), encode = "json", ...
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

create_batch_query_list <- function(queries, page, pageSize) {
  queryList <- lapply(queries, function(x){
    as.list(stats::setNames(x, rep("query", length(x))))
  })
  
  queryList <- Map(c, queryList, page = rep(page))
  queryList <- Map(c, queryList, pageSize = rep(pageSize))
  
  return(queryList)
}
