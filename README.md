cored
=====



[![Project Status: WIP - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![Build Status](https://travis-ci.org/ropenscilabs/cored.svg?branch=master)](https://travis-ci.org/ropenscilabs/cored)
[![codecov.io](https://codecov.io/github/ropenscilabs/cored/coverage.svg?branch=master)](https://codecov.io/github/ropenscilabs/cored?branch=master)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/cored)](https://github.com/metacran/cranlogs.app)

CORE API R client

[CORE API docs](https://core.ac.uk/docs/)

## Install

Development version


```r
devtools::install_github("ropenscilabs/cored")
```


```r
library("cored")
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
core_search(query = 'ecology', limit = 12)
#> $status
#> [1] "OK"
#> 
#> $totalHits
#> [1] 228626
#> 
#> $data
#>       type             id
#> 1  journal issn:1005-264X
#> 2  journal issn:2287-8327
#> 3  journal issn:2193-3081
#> 4  journal issn:2351-9894
#> 5  article       15172123
#> 6  journal issn:1472-6785
#> 7  journal issn:1712-6568
#> 8  journal issn:2008-9287
#> 9  journal issn:2356-6647
#> 10 journal issn:1687-9708
#> 11 journal issn:1708-3087
#> 12 journal issn:2299-1042
```


```r
core_search_(query = 'ecology', limit = 12)
#> [1] "{\"status\":\"OK\",\"totalHits\":228626,\"data\":[{\"type\":\"journal\",\"id\":\"issn:1005-264X\"},{\"type\":\"journal\",\"id\":\"issn:2287-8327\"},{\"type\":\"journal\",\"id\":\"issn:2193-3081\"},{\"type\":\"journal\",\"id\":\"issn:2351-9894\"},{\"type\":\"article\",\"id\":\"15172123\"},{\"type\":\"journal\",\"id\":\"issn:1472-6785\"},{\"type\":\"journal\",\"id\":\"issn:1712-6568\"},{\"type\":\"journal\",\"id\":\"issn:2008-9287\"},{\"type\":\"journal\",\"id\":\"issn:2356-6647\"},{\"type\":\"journal\",\"id\":\"issn:1687-9708\"},{\"type\":\"journal\",\"id\":\"issn:1708-3087\"},{\"type\":\"journal\",\"id\":\"issn:2299-1042\"}]}"
```

# Articles


```r
core_articles(id = 21132995)
#> $status
#> [1] "OK"
#> 
#> $data
#> $data$id
#> [1] 21132995
#> 
#> $data$authors
#> list()
#> 
...
```

# Aritcle history


```r
core_articles_history(id = '21132995')
#> $status
#> [1] "OK"
#> 
#> $data
#>              datetime
...
```

# Journals


```r
core_journals(id = '2167-8359')
#> $status
#> [1] "OK"
#> 
#> $data
#> $data$title
#> [1] "PeerJ"
#> 
#> $data$identifiers
#> [1] "oai:doaj.org/journal:576e4d34b8bf461bb586f1e90d80d7cc"
#> [2] "issn:2167-8359"                                       
...
```

# Get PDFs

The `_` for these methods means that you get a file path back to the PDF, while the 
high level version without the `_` parses the pdf to text for you.


```r
core_articles_pdf_(11549557)
```

## Meta

* Please [report any issues or bugs](https://github.com/ropenscilabs/cored/issues).
* License: MIT
* Get citation information for `cored` in R doing `citation(package = 'cored')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
