#' Bar chart
#' @description Constructs a bar chart.
#'
#' @param inputId the id of the container
#' @param width width in CSS units
#' @param height height in CSS units
#' @param data a dataframe
#' @param category name of the column of \code{data} to be used on the
#' category axis
#' @param value name(s) of the column(s) of \code{data} to be used on the
#' value axis
#' @param valueNames names of the values variables, to appear in the legend
#' @param minValue minimum value
#' @param maxValue maximum value
#' @param valueFormatter a number formatter; see
#' \url{https://www.amcharts.com/docs/v4/concepts/formatters/formatting-numbers/}
#' @param draggable logical vector, one entry for each value; whether the
#' corresponding colum is draggable
#' @param tooltip tooltip settings given as a list, or just a string for the
#' \code{text} field, or \code{NULL} for no tooltip; the \code{text} field is
#' given as a formatted string; see
#' \url{https://www.amcharts.com/docs/v4/concepts/formatters/formatting-strings/}
#' @param chartTitle chart title, \code{NULL}, character, or list of settings
#' @param columnStyle settings of the columns style given as a list
#' @param backgroundColor a HTML color for the chart background
#' @param columnWidth column width in percent
#' @param xAxis settings of the category axis given as a list, or just a string
#' for the axis title
#' @param yAxis settings of the value axis given as a list, or just a string
#' for the axis title
#' @param gridLines settings of the grid lines
#' @param legend logical, whether to display the legend
#' @param caption settings of the caption, or \code{NULL} for no caption
#' @param theme theme, \code{NULL} or one of \code{"dataviz"}, \code{"material"},
#' \code{"kelly"}, \code{"dark"}, \code{"moonrisekingdom"},
#' \code{"frozen"}, \code{"spiritedaway"}
#' @param style inline CSS for the container
#'
#' @export
#' @import shiny
#' @importFrom jsonlite fromJSON toJSON
#' @examples
#' if(interactive()){
#'
#'   # simple bar chart ####
#'
#'   library(shiny)
#'   library(shinyAmBarCharts)
#'
#'   dat <- data.frame(
#'     country = c("USA", "China", "Japan", "Germany", "UK", "France"),
#'     visits = c(3025, 1882, 1809, 1322, 1122, 1114)
#'   )
#'
#'   ui <- fluidPage(
#'     fluidRow(
#'       column(8,
#'              amBarChart(
#'                "mybarchart", data = dat, height = "400px",
#'                category = "country", value = "visits",
#'                draggable = TRUE,
#'                tooltip = "[font-style:italic;#ffff00]{valueY}[/]",
#'                chartTitle =
#'                 list(text = "Visits per country", fontSize = 22, color = "orangered"),
#'                xAxis = list(title = list(text = "Country", color = "maroon")),
#'                yAxis = list(title = list(text = "Visits", color = "maroon")),
#'                minValue = 0, maxValue = 4000,
#'                valueFormatter = "#.",
#'                columnWidth = 90,
#'                caption = list(text = "Year 2018", color = "red"),
#'                theme = "material")),
#'       column(4,
#'              tags$label("Data:"),
#'              verbatimTextOutput("data"),
#'              br(),
#'              tags$label("Change:"),
#'              verbatimTextOutput("change"))
#'     )
#'
#'   )
#'
#'   server <- function(input, output){
#'
#'     output[["data"]] <- renderPrint({
#'       input[["mybarchart"]]
#'     })
#'
#'     output[["change"]] <- renderPrint({ input[["mybarchart_change"]] })
#'
#'   }
#'
#'   shinyApp(ui, server)
#'
#' }
#'
#' if(interactive()){
#'
#'   # grouped bar chart ####
#'
#'   library(shiny)
#'   library(shinyAmBarCharts)
#'
#'   set.seed(666)
#'   dat <- data.frame(
#'     country = c("USA", "China", "Japan", "Germany", "UK", "France"),
#'     visits = c(3025, 1882, 1809, 1322, 1122, 1114),
#'     income = rpois(6, 25),
#'     expenses = rpois(6, 20)
#'   )
#'
#'   ui <- fluidPage(
#'
#'     fluidRow(
#'       column(8,
#'              amBarChart(
#'                "mygroupedbarchart", data = dat, height = "400px",
#'                category = "country", value = c("income", "expenses"),
#'                valueNames = c("Income", "Expenses"),
#'                draggable = c(TRUE,FALSE),
#'                backgroundColor = "#30303d",
#'                columnStyle = list(fill = c("darkmagenta", "darkred"),
#'                                   stroke = "#cccccc"),
#'                chartTitle = list(text = "Income and expenses per country"),
#'                xAxis = list(title = list(text = "Country")),
#'                yAxis = list(title = list(text = "Income and expenses")),
#'                minValue = 0, maxValue = 41,
#'                valueFormatter = "#.#",
#'                columnWidth = 90,
#'                caption = list(text = "Year 2018"),
#'                theme = "dark")
#'       ),
#'       column(4,
#'              tags$label("Data:"),
#'              verbatimTextOutput("data"),
#'              br(),
#'              tags$label("Change:"),
#'              verbatimTextOutput("change"))
#'     )
#'
#'   )
#'
#'   server <- function(input, output){
#'
#'     output[["data"]] <- renderPrint({
#'       input[["mygroupedbarchart"]]
#'     })
#'
#'     output[["change"]] <- renderPrint({ input[["mygroupedbarchart_change"]] })
#'
#'   }
#'
#'   shinyApp(ui, server)
#'
#' }
amBarChart <- function(inputId, width = "100%", height = "400px",
                       data, category, value, valueNames = value,
                       minValue, maxValue,
                       valueFormatter = "#.",
                       draggable = rep(FALSE, length(value)),
                       tooltip = list(
                         text = "[bold]{name}:\n{valueY}[/]",
                         labelColor = "#ffffff",
                         backgroundColor = "#101010",
                         backgroundOpacity = 1,
                         scale = 1
                       ),
                       chartTitle = NULL,
                       columnStyle = list(
                         fill = rep(list(NULL), length(value)),
                         stroke = NULL,
                         cornerRadius = NULL
                       ),
                       backgroundColor = NULL,
                       columnWidth = 80,
                       xAxis = list(
                         title = list(
                           text = category,
                           fontSize = 20,
                           color = NULL
                         ),
                         labels = list(
                           color = NULL,
                           fontSize = 18,
                           rotation = 0
                         )
                       ),
                       yAxis = list(
                         title = list(
                           text = value,
                           fontSize = 20,
                           color = NULL
                         ),
                         labels = list(
                           color = NULL,
                           fontSize = 18,
                           rotation = 0
                         )
                       ),
                       gridLines = list(
                         color = NULL,
                         opacity = NULL,
                         width = NULL
                       ),
                       legend = length(value) > 1,
                       caption = NULL,
                       theme = NULL,
                       style = ""){
  addResourcePath(
    prefix = "wwwAC",
    directoryPath = system.file("www", package="shinyAmBarCharts")
  )
  registerInputHandler("dataframe", function(data, ...) {
    fromJSON(toJSON(data, auto_unbox = TRUE))
  }, force = TRUE)
  if(!is.null(theme)){
    theme <- match.arg(theme, c("dataviz","material","kelly","dark",
                                "frozen","moonrisekingdom","spiritedaway"))
  }
  if(is.character(chartTitle)){
    chartTitle <- list(text = chartTitle, fontSize = 22, color = NULL)
  }
  if(is.character(caption)){
    caption <- list(text = caption)
  }
  if(is.character(tooltip)){
    tooltip <- list(text = tooltip)
  }
  if(is.character(xAxis[["title"]])){
    xAxis[["title"]] <- list(text = xAxis[["title"]])
  }
  if(is.character(yAxis[["title"]])){
    yAxis[["title"]] <- list(text = yAxis[["title"]])
  }
  if(is.null(xAxis[["title"]])){
    xAxis[["title"]] <- list(
      text = category,
      fontSize = 20,
      color = NULL
    )
  }
  if(is.null(xAxis[["labels"]])){
    xAxis[["labels"]] <- list(
      color = NULL,
      fontSize = 18,
      rotation = 0
    )
  }
  if(is.null(yAxis[["title"]])){
    yAxis[["title"]] <- list(
      text = value,
      fontSize = 20,
      color = NULL
    )
  }
  if(is.null(yAxis[["labels"]])){
    yAxis[["labels"]] <- list(
      color = NULL,
      fontSize = 18,
      rotation = 0
    )
  }
  tagList(
    singleton(tags$head(tags$script(src = "wwwAC/amCharts/core.js"))),
    singleton(tags$head(tags$script(src = "wwwAC/amCharts/charts.js"))),
    singleton(tags$head(tags$script(src = "wwwAC/amCharts/themes/animated.js"))),
    if(!is.null(theme)){
      singleton(tags$head(
        tags$script(src = sprintf("wwwAC/amCharts/themes/%s.js", theme))))
    },
    singleton(tags$head(tags$script(src = "wwwAC/barChartBinding.js"))),
    tags$div(id = inputId, class = "amBarChart",
             style = sprintf("width: %s; height: %s; %s", width, height, style),
             `data-data` = as.character(toJSON(data)),
             `data-category` = category,
             `data-value` = as.character(toJSON(value)),
             `data-valuenames` = as.character(toJSON(valueNames)),
             `data-min` = minValue,
             `data-max` = maxValue,
             `data-tooltipstyle` = list2json(tooltip),
             `data-charttitle` = list2json(chartTitle),
             `data-columnstyle` = list2json(columnStyle),
             `data-columnwidth` = max(10,min(columnWidth,100)),
             `data-xaxis` = list2json(xAxis),
             `data-yaxis` = list2json(yAxis),
             `data-valueformatter` = valueFormatter,
             `data-theme` = theme %||% "null",
             `data-chartbackgroundcolor` = backgroundColor %||% "null",
             `data-gridlines` = list2json(gridLines),
             `data-legend` = ifelse(legend, "true", "false"),
             `data-draggable` = as.character(toJSON(draggable)),
             `data-caption` = list2json(caption)
    )
  )
}
