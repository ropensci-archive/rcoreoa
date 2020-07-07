rcoreoa
=======



[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Build Status](https://travis-ci.org/ropensci/rcoreoa.svg?branch=master)](https://travis-ci.org/ropensci/rcoreoa)
[![codecov.io](https://codecov.io/github/ropensci/rcoreoa/coverage.svg?branch=master)](https://codecov.io/github/ropensci/rcoreoa?branch=master)
[![cran checks](https://cranchecks.info/badges/worst/rcoreoa)](https://cranchecks.info/pkgs/rcoreoa)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/rcoreoa)](https://github.com/metacran/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/rcoreoa)](https://cran.r-project.org/package=rcoreoa)

CORE API R client

CORE API docs: https://core.ac.uk/docs/

rcoreoa docs: https://docs.ropensci.org/rcoreoa/

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

## Get started

Get started with an introduction to the package: https://docs.ropensci.org/rcoreoa/articles/rcoreoa

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
