library("vcr")
vcr_dir <- "../fixtures"
if (!nzchar(Sys.getenv("CORE_KEY"))) {
  if (dir.exists(vcr_dir)) {
    Sys.setenv("CORE_KEY" = "foobar")
  } else {
    stop("No API key nor cassettes, tests cannot be run.",
         call. = FALSE)
  }
}
invisible(vcr::vcr_configure(
  dir = vcr_dir,
  filter_sensitive_data = list("<<core_key>>" = Sys.getenv('CORE_KEY'))
))
vcr::check_cassette_names()
