rcoreoa
=======



[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Build Status](https://travis-ci.org/ropensci/rcoreoa.svg?branch=master)](https://travis-ci.org/ropensci/rcoreoa)
[![codecov.io](https://codecov.io/github/ropensci/rcoreoa/coverage.svg?branch=master)](https://codecov.io/github/ropensci/rcoreoa?branch=master)
[![cran checks](https://cranchecks.info/badges/worst/rcoreoa)](https://cranchecks.info/pkgs/rcoreoa)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/rcoreoa)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/rcoreoa)](https://cran.r-project.org/package=rcoreoa)

CORE API R client

CORE API docs: https://core.ac.uk/docs/

Get an API key at https://core.ac.uk/api-keys/register. You'll need one, 
so do this now if you haven't yet. Once you have the key, you can pass it 
into the `key` parameter, or as a much better option store your key as an 
environment variable with the name `CORE_KEY` or an R option as `core_key`. 
See `?Startup` for how to work with env vars and R options

## About CORE

CORE's tagline is: "Aggregating the world's open access research papers"

CORE offers seamless access to millions of open access research papers, enrich
the collected data for text-mining and provide unique services to the research
community.

For more infos on CORE, see https://core.ac.uk/about

## Install


```r
install.packages("rcoreoa")
```

Development version


```r
remotes::install_github("ropensci/rcoreoa")
```


```r
library("rcoreoa")
```

## Pagination

Note that you are limited to a maximum of 100 results for the search functions;
use combination of `page` and `limit` parameters to paginate through results. 
For example:


```r
x1 <- core_search(query = 'ecology', limit = 100, page = 1)
x2 <- core_search(query = 'ecology', limit = 100, page = 2)
head(x1$data[,1:3])
#>                _index   _type       _id
#> 1 articles_2019_06_05 article  20955435
#> 2 articles_2019_06_05 article 102353278
#> 3 articles_2019_06_05 article 101526846
#> 4 articles_2019_06_05 article 103034034
#> 5 articles_2019_06_05 article 100453958
#> 6 articles_2019_06_05 article 101147175
head(x2$data[,1:3])
#>                _index   _type       _id
#> 1 articles_2019_06_05 article  76856113
#> 2 articles_2019_06_05 article  76855980
#> 3 articles_2019_06_05 article  99990752
#> 4 articles_2019_06_05 article 100658401
#> 5 articles_2019_06_05 article 100763270
#> 6 articles_2019_06_05 article 103321161
```

## high- vs. low-level interfaces

Each function has a higher level interface that does HTTP request for data and parses
the JSON using `jsonlite`. This is meant for those who want everything done for them,
but there's a time penalty for as the parsing adds extra time. If you just want raw JSON
unparsed text, you can use the low level interface.

The low level version of each function has `_` at the end (e.g., `core_search_`), while the
high level version doesn't have the `_` (e.g., `core_search`).

The high level version of each function uses the low level method, and the low level method
does all the logic and HTTP requesting, whereas the high level simply parses the output.

## Search


```r
res <- core_search(query = 'ecology', limit = 12)
tibble::as_tibble(res$data)
#> # A tibble: 12 x 5
#>    `_index` `_type` `_id` `_score` `_source`$id $authors $citations
#>    <chr>    <chr>   <chr>    <dbl> <chr>        <list>   <list>    
#>  1 article… article 2095…     18.5 20955435     <chr [1… <list [0]>
#>  2 article… article 1023…     18.4 102353278    <chr [2… <list [0]>
#>  3 article… article 1015…     17.5 101526846    <chr [1… <list [0]>
#>  4 article… article 1030…     17.5 103034034    <chr [1… <list [0]>
#>  5 article… article 1545…     17.4 154520563    <chr [1… <list [0]>
#>  6 article… article 1004…     17.4 100453958    <chr [1… <list [0]>
#>  7 article… article 1011…     17.4 101147175    <chr [1… <list [0]>
#>  8 article… article 1017…     17.4 101760738    <chr [1… <list [0]>
#>  9 article… article 1038…     17.4 103836217    <chr [1… <list [0]>
#> 10 article… article 1019…     17.3 101912806    <chr [1… <list [0]>
#> 11 article… article 1037…     17.3 103746797    <chr [1… <list [0]>
#> 12 article… article 1038…     17.3 103888859    <chr [1… <list [0]>
#> # … with 47 more variables: $contributors <list>, $datePublished <chr>,
#> #   $deleted <chr>, $description <chr>, $fullText <lgl>,
#> #   $fullTextIdentifier <chr>, $identifiers <list>, $journals <lgl>,
#> #   $language <lgl>, $duplicateId <lgl>, $publisher <chr>, $rawRecordXml <chr>,
#> #   $relations <list>, $repositories <list>,
#> #   $repositoryDocument$pdfStatus <int>, $$textStatus <int>,
#> #   $$metadataAdded <dbl>, $$metadataUpdated <dbl>, $$timestamp <dbl>,
#> #   $$depositedDate <dbl>, $$indexed <int>, $$deletedStatus <chr>,
#> #   $$pdfSize <int>, $$tdmOnly <lgl>, $$pdfOrigin <chr>, $similarities <lgl>,
#> #   $subjects <list>, $title <chr>, $topics <list>, $types <list>,
#> #   $urls <list>, $year <int>, $doi <lgl>, $oai <chr>, $downloadUrl <chr>,
#> #   $pdfHashValue <lgl>, $documentType <lgl>, $documentTypeConfidence <lgl>,
#> #   $citationCount <lgl>, $estimatedCitationCount <lgl>, $acceptedDate <lgl>,
#> #   $depositedDate <dbl>, $publishedDate <lgl>, $issn <lgl>,
#> #   $crossrefDocument <lgl>, $magDocument <lgl>, $orcidAuthors <lgl>
```

## Advanced Search


```r
query <- data.frame("all_of_the_words" = "data mining",
                    "without_the_words" = "social science",
                    "year_from" = "2013",
                    "year_to" = "2014")

res <- core_advanced_search(query)
tibble::as_tibble(res$data)
#> # A tibble: 10 x 5
#>    `_index` `_type` `_id` `_score` `_source`$id $authors $citations
#>    <chr>    <chr>   <chr>    <dbl> <chr>        <list>   <list>    
#>  1 article… article 1001…     31.3 100191766    <chr [1… <list [0]>
#>  2 article… article 2326…     31.3 23260687     <chr [1… <list [0]>
#>  3 article… article 1091…     31.3 109199257    <chr [1… <list [0]>
#>  4 article… article 2344…     26.1 23445515     <chr [3… <list [0]>
#>  5 article… article 2319…     25.3 23195960     <chr [3… <list [0]>
#>  6 article… article 2251…     25.1 22515702     <chr [3… <list [0]>
#>  7 article… article 1002…     24.0 100288450    <chr [4… <list [0]>
#>  8 article… article 2342…     23.4 23425167     <chr [3… <list [0]>
#>  9 article… article 2236…     23.2 22369029     <chr [3… <list [0]>
#> 10 article… article 1001…     22.0 100117738    <chr [3… <list [0]>
#> # … with 46 more variables: $contributors <list>, $datePublished <chr>,
#> #   $deleted <chr>, $description <chr>, $fullText <lgl>,
#> #   $fullTextIdentifier <chr>, $identifiers <list>, $journals <lgl>,
#> #   $language <lgl>, $duplicateId <lgl>, $publisher <lgl>, $rawRecordXml <chr>,
#> #   $relations <list>, $repositories <list>,
#> #   $repositoryDocument$pdfStatus <int>, $$textStatus <int>,
#> #   $$metadataAdded <dbl>, $$metadataUpdated <dbl>, $$timestamp <dbl>,
#> #   $$depositedDate <dbl>, $$indexed <int>, $$deletedStatus <chr>,
#> #   $$pdfSize <int>, $$tdmOnly <lgl>, $$pdfOrigin <chr>, $similarities <lgl>,
#> #   $subjects <list>, $title <chr>, $topics <list>, $types <list>,
#> #   $urls <list>, $year <int>, $doi <lgl>, $oai <chr>, $downloadUrl <chr>,
#> #   $pdfHashValue <lgl>, $documentType <lgl>, $documentTypeConfidence <lgl>,
#> #   $citationCount <lgl>, $estimatedCitationCount <lgl>, $acceptedDate <lgl>,
#> #   $depositedDate <dbl>, $publishedDate <lgl>, $issn <lgl>,
#> #   $crossrefDocument <lgl>, $magDocument <lgl>
```

# Articles


```r
core_articles(id = 21132995)
#> $status
#> [1] "OK"
#> 
#> $data
#> $data$id
#> [1] "21132995"
#> 
#> $data$authors
#> list()
#> 
...
```

# Article history


```r
core_articles_history(id = '21132995')
#> $status
#> [1] "OK"
#> 
#> $data
#>              datetime
#> 1 2016-08-03 00:13:41
#> 2 2014-10-22 16:42:14
...
```

# Journals


```r
core_journals(id = '2220-721X')
```

# Get PDFs

The `_` for these methods means that you get a file path back to the PDF, while the
high level version without the `_` parses the pdf to text for you.


```r
core_articles_pdf_(11549557)
```

## Contributors

* [Scott Chamberlain](https://github.com/sckott)
* [Aristotelis Charalampous](https://github.com/aresxs91)
* [Simon Goring](https://github.com/SimonGoring)

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rcoreoa/issues).
* License: MIT
* Get citation information for `rcoreoa` in R doing `citation(package = 'rcoreoa')`
* Please note that this project is released with a [Contributor Code of Conduct][coc]. By participating in this project you agree to abide by its terms.

[![ropensci](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)

[coc]: https://github.com/ropensci/rcoreoa/blob/master/CODE_OF_CONDUCT.md
