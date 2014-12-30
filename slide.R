slide <- function(fname, envir = new.env()) {
  require(slidify)
  require(knitr)
  slidify(fname)
  fname <- gsub(".Rmd", ".html", fname)
  system(sprintf('open %s', shQuote(fname)))
}

oknit <- function(fname, envir = new.env(), 
                  knitfunc = "knit2html", ...) {
  require(knitr)
  do.call(knitfunc, list(input = fname, envir = envir, ... = ...))
  fname <- gsub(".Rmd", ".html", fname)
  system(sprintf('open %s', shQuote(fname)))
}