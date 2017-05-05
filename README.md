rcore
=====



[![Project Status: WIP - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![Build Status](https://travis-ci.org/ropensci/rcore.svg?branch=master)](https://travis-ci.org/ropensci/rcore)
[![codecov.io](https://codecov.io/github/ropensci/rcore/coverage.svg?branch=master)](https://codecov.io/github/ropensci/rcore?branch=master)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/rcore)](https://github.com/metacran/cranlogs.app)


CORE API R client

[CORE API docs](https://core.ac.uk/docs/)

[CORE API - request access](https://core.ac.uk/api-keys/register)

<a href="https://core.ac.uk">
<img src="https://core.ac.uk/resources/corelogo_hires.png" width="150"
alt="CORE">
</a>

"Aggregating the world's open access research papers"

CORE offers seamless access to millions of open access research papers, enrich
the collected data for text-mining and provide unique services to the research
community.

For more infos on CORE, see:

[https://core.ac.uk/about](https://core.ac.uk/about)

## Install

Development version


```r
devtools::install_github("ropensci/rcore")
```


```r
library("rcore")
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
#> [1] 683556
#>
#> $data
#>       type             id
#> 1  journal issn:1005-264X
#> 2  journal issn:2287-8327
#> 3  journal issn:2193-3081
#> 4  journal issn:2351-9894
#> 5  journal issn:1472-6785
#> 6  journal issn:1712-6568
#> 7  journal issn:2008-9287
#> 8  journal issn:2356-6647
#> 9  journal issn:1687-9708
#> 10 journal issn:1708-3087
#> 11 journal issn:2299-1042
#> 12 journal issn:2162-1985
```


```r
core_search_(query = 'ecology', limit = 12)
#> [1] "{\"status\":\"OK\",\"totalHits\":683556,\"data\":[{\"type\":\"journal\",\"id\":\"issn:1005-264X\"},{\"type\":\"journal\",\"id\":\"issn:2287-8327\"},{\"type\":\"journal\",\"id\":\"issn:2193-3081\"},{\"type\":\"journal\",\"id\":\"issn:2351-9894\"},{\"type\":\"journal\",\"id\":\"issn:1472-6785\"},{\"type\":\"journal\",\"id\":\"issn:1712-6568\"},{\"type\":\"journal\",\"id\":\"issn:2008-9287\"},{\"type\":\"journal\",\"id\":\"issn:2356-6647\"},{\"type\":\"journal\",\"id\":\"issn:1687-9708\"},{\"type\":\"journal\",\"id\":\"issn:1708-3087\"},{\"type\":\"journal\",\"id\":\"issn:2299-1042\"},{\"type\":\"journal\",\"id\":\"issn:2162-1985\"}]}"
```

## Advanced Search


```r
query <- data.frame("all_of_the_words" = "data mining",
                    "without_the_words" = "social science",
                    "year_from" = "2013",
                    "year_to" = "2014")

core_advanced_search(query)
#> $status
#> [1] "OK"
#>
#> $totalHits
#> [1] 23271
#>
#> $data
#>       type       id
#> 1  article 22642150
#> 2  article 22650635
#> 3  article 24006259
#> 4  article 23964816
#> 5  article 24074440
#> 6  article 22654775
#> 7  article 35379905
#> 8  article 22625437
#> 9  article 23849064
#> 10 article 23723370
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

## Contributors

* [Scott Chamberlain](https://github.com/sckott)
* [Aristotelis Charalampous](https://github.com/aresxs91)

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rcore/issues).
* License: MIT
* Get citation information for `rcore` in R doing `citation(package = 'rcore')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
