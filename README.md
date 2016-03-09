cored
=====

[![Build Status](https://travis-ci.org/ropenscilabs/cored.svg?branch=master)](https://travis-ci.org/ropenscilabs/cored)
[![codecov.io](https://codecov.io/github/ropenscilabs/cored/coverage.svg?branch=master)](https://codecov.io/github/ropenscilabs/cored?branch=master)

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

## Search


```r
core_search(query = 'ecology', limit = 12)
```

```
## $status
## [1] "OK"
## 
## $totalHits
## [1] 228626
## 
## $data
##       type             id
## 1  journal issn:1005-264X
## 2  journal issn:2287-8327
## 3  journal issn:2193-3081
## 4  journal issn:2351-9894
## 5  article       15172123
## 6  journal issn:1472-6785
## 7  journal issn:1712-6568
## 8  journal issn:2008-9287
## 9  journal issn:2356-6647
## 10 journal issn:1687-9708
## 11 journal issn:1708-3087
## 12 journal issn:2299-1042
```


## Meta

* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
