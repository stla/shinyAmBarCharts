#' @importFrom shiny addResourcePath registerInputHandler
#' @importFrom jsonlite fromJSON toJSON
#' @noRd
.onLoad <- function(...){
  addResourcePath(
    prefix = "wwwAC",
    directoryPath = system.file("www", package="shinyAmBarCharts")
  )
  registerInputHandler("shinyAmBarCharts.dataframe", function(data, ...) {
    fromJSON(toJSON(data, auto_unbox = TRUE))
  }, force = TRUE)
}
