`%||%` <- function(x, y){
  if(is.null(x)) y else x
}

#' @importFrom jsonlite toJSON
list2json <- function(x){
  as.character(toJSON(x, null = "null", auto_unbox = TRUE))
}
