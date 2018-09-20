rcoreoa 0.3.0
=============

### NEW FEATURES

* gains new methods `core_articles_search()` and `core_articles_search_()` for searching for articles (#15)
* gains new manual file `?core_cache` for an overview of caching
* package `hoardr` now used for managing file caching (#13)
* function `core_advanced_search()` gains support for the `language` filter (#16) thanks @chreman

### MINOR IMPROVEMENTS

* support for passing in more than one journal/article/etc. identifier for `core_articles_pdf()`/`core_articles_history()` - already supported in other functions (#10)
* `overwrite` parameter was being ignored in `core_articles_pdf()`, now is passed on internally (#12)
* `parse` parameter dropped in `core_articles_pdf()`, only used internally (#11)
* Improved docs on how to get and use API keys (#14)
* Improve documentation about what a 404 error response means - that the thing reqeusted does not exist (#9)


rcoreoa 0.1.0
=============

### NEW FEATURES

* Released to CRAN.
