slide <- function(fname) {
  require(slidify)
  require(knitr)
  slidify(fname)
  fname <- gsub(".Rmd", ".html", fname)
  system(sprintf('open %s', fname))
}