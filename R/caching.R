#' @title Caching
#'
#' @description Manage cached `rcoreoa` files with \pkg{hoardr}
#'
#' @export
#' @name core_cache
#'
#' @details The dafault cache directory is
#' `paste0(rappdirs::user_cache_dir(), "/R/rcoreoa")`, but you can set
#' your own path using `cache_path_set()`
#'
#' `cache_delete` only accepts 1 file name, while
#' `cache_delete_all` doesn't accept any names, but deletes all files.
#' For deleting many specific files, use `cache_delete` in a [lapply()]
#' type call
#'
#' @section Useful user functions:
#' \itemize{
#'  \item `core_cache$cache_path_get()` get cache path
#'  \item `core_cache$cache_path_set()` set cache path
#'  \item `core_cache$list()` returns a character vector of full
#'  path file names
#'  \item `core_cache$files()` returns file objects with metadata
#'  \item `core_cache$details()` returns files with details
#'  \item `core_cache$delete()` delete specific files
#'  \item `core_cache$delete_all()` delete all files, returns nothing
#' }
#'
#' @examples \dontrun{
#' core_cache
#'
#' # list files in cache
#' core_cache$list()
#'
#' # delete certain database files
#' # core_cache$delete("file path")
#' # core_cache$list()
#'
#' # delete all files in cache
#' # core_cache$delete_all()
#' # core_cache$list()
#'
#' # set a different cache path from the default
#' }
NULL
