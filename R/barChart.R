#' Bar chart
#' @description Constructs a bar chart.
#'
#' @param inputId the id of the container
#' @param width width in CSS units
#' @param height height in CSS units
#' @param data a dataframe
#' @param data2 a dataframe used to update the data with the button
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
#' @param cellWidth cell width in percent; for a simple bar chart, this is the
#' width of the columns; for a grouped bar chart, this is the width of the
#' clusters of columns
#' @param columnWidth column width, a percentage of the cell width; set to 100
#' for a simple bar chart and use \code{cellWidth} to control the width of the
#' columns; for a grouped bar chart, this controls the spacing between the
#' columns within a cluster of columns
#' @param xAxis settings of the category axis given as a list, or just a string
#' for the axis title
#' @param yAxis settings of the value axis given as a list, or just a string
#' for the axis title
#' @param scrollbarX logical, whether to add a scrollbar for the category axis
#' @param scrollbarY logical, whether to add a scrollbar for the value axis
#' @param gridLines settings of the grid lines
#' @param legend logical, whether to display the legend
#' @param caption settings of the caption, or \code{NULL} for no caption
#' @param button \code{NULL} for no button, or settings of the buttons given as
#' a list with these fields: \code{text} for the button label, \code{color} for
#' the label color, \code{fill} for the button color, and \code{position}
#' for the button position as a percentage (\code{0} for bottom,
#' \code{1} for top); this button is used to replace the current data
#' with \code{data2}
#' @param theme theme, \code{NULL} or one of \code{"dataviz"}, \code{"material"},
#' \code{"kelly"}, \code{"dark"}, \code{"moonrisekingdom"},
#' \code{"frozen"}, \code{"spiritedaway"}
#' @param style inline CSS for the container
#'
#' @export
#' @import shiny
#' @importFrom jsonlite toJSON
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
#'                "mybarchart", data = dat, data2 = dat, height = "400px",
#'                category = "country", value = "visits",
#'                draggable = TRUE,
#'                tooltip = "[font-style:italic;#ffff00]{valueY}[/]",
#'                chartTitle =
#'                 list(text = "Visits per country", fontSize = 22, color = "orangered"),
#'                xAxis = list(title = list(text = "Country", color = "maroon")),
#'                yAxis = list(title = list(text = "Visits", color = "maroon")),
#'                minValue = 0, maxValue = 4000,
#'                valueFormatter = "#.",
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
#'
#' if(interactive()){
#'
#'   # large bar chart => use scrollbars ####
#'
#'   library(shiny)
#'   library(shinyAmBarCharts)
#'
#'   dat <- cbind(Year = 1960:1986,
#'                setNames(
#'                  as.data.frame(matrix(UKgas, ncol = 4, byrow = TRUE)),
#'                  c("Qtr1", "Qtr2", "Qtr3", "Qtr4")))
#'
#'   ui <- fluidPage(
#'     amBarChart("UKgas", data = dat, height = "550px", category = "Year",
#'                xAxis = list(title = "Year", labels = list(rotation = -45)),
#'                value = c("Qtr1", "Qtr2", "Qtr3", "Qtr4"),
#'                yAxis = "Gas consumption",
#'                valueFormatter = "#.#",
#'                scrollbarX = TRUE, scrollbarY = TRUE,
#'                minValue = 0, maxValue = 1200,
#'                chartTitle = "Quarterly UK gas consumption",
#'                theme = "moonrisekingdom")
#'   )
#'   server <- function(input, output) {}
#'   shinyApp(ui, server)
#'
#' }
#'
#' if(interactive()){
#'   # illustration of cellWidth and columnWidth ####
#'
#'   library(shiny)
#'   library(shinyAmBarCharts)
#'
#'   set.seed(666)
#'   dat <- data.frame(
#'     country = c("USA", "China", "Japan", "Germany"),
#'     visits = c(3025, 1882, 1809, 1322),
#'     income = rpois(4, 25),
#'     expenses = rpois(4, 20)
#'   )
#'
#'   ui <- fluidPage(
#'     fluidRow(
#'       column(
#'         6, amBarChart("chart1", data = dat, height = "300px",
#'                       category = "country", value = "visits",
#'                       minValue = 0, maxValue = 3500,
#'                       cellWidth = 100,
#'                       chartTitle = "cellWidth: 100")),
#'       column(
#'         6, amBarChart("chart2", data = dat, height = "300px",
#'                       category = "country", value = "visits",
#'                       minValue = 0, maxValue = 3500,
#'                       cellWidth = 80,
#'                       chartTitle = "cellWidth: 80"))
#'     ),
#'     fluidRow(
#'       column(
#'         4, amBarChart("chart3", data = dat, height = "300px",
#'                       category = "country", value = c("income","expenses"),
#'                       minValue = 0, maxValue = 40,
#'                       cellWidth = 100, columnWidth = 100,
#'                       chartTitle = list(
#'                         text = "cellWidth: 100, columnWidth: 100",
#'                         fontSize = 19))),
#'       column(
#'         4, amBarChart("chart4", data = dat, height = "300px",
#'                       category = "country", value = c("income","expenses"),
#'                       minValue = 0, maxValue = 40,
#'                       cellWidth = 80, columnWidth = 100,
#'                       chartTitle = list(
#'                         text = "cellWidth: 80, columnWidth: 100",
#'                         fontSize = 19))),
#'       column(
#'         4, amBarChart("chart5", data = dat, height = "300px",
#'                       category = "country", value = c("income","expenses"),
#'                       minValue = 0, maxValue = 40,
#'                       cellWidth = 80, columnWidth = 80,
#'                       chartTitle = list(
#'                         text = "cellWidth: 80, columnWidth: 80",
#'                         fontSize = 19)))
#'     )
#'   )
#'
#'   shinyApp(ui, server = function(input,output){})
#' }
amBarChart <- function(inputId, width = "100%", height = "400px",
                       data, data2 = NULL,
                       category, value, valueNames = value,
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
                       cellWidth = 90,
                       columnWidth = ifelse(length(value)==1, 100, 90),
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
                         title = if(length(value)==1) {
                           list(
                             text = value,
                             fontSize = 20,
                             color = NULL
                           )} else NULL,
                         labels = list(
                           color = NULL,
                           fontSize = 18,
                           rotation = 0
                         )
                       ),
                       scrollbarX = FALSE,
                       scrollbarY = FALSE,
                       gridLines = list(
                         color = NULL,
                         opacity = NULL,
                         width = NULL
                       ),
                       legend = length(value) > 1,
                       caption = NULL,
                       button =
                         if(is.null(data2)) NULL else list(
                           text = "Reset",
                           color = NULL,
                           fill = NULL,
                           position = 0.8),
                       theme = NULL,
                       style = ""){
  if(!is.null(theme)){
    theme <- match.arg(theme, c("dataviz","material","kelly","dark",
                                "frozen","moonrisekingdom","spiritedaway"))
  }
  if(is.character(chartTitle)){
    chartTitle <- list(text = chartTitle, fontSize = 22, color = NULL)
  }
  if(is.character(chartTitle[["title"]])){
    chartTitle[["title"]] <- list(text = chartTitle[["title"]])
  }
  if(is.character(caption)){
    caption <- list(text = caption)
  }
  if(is.character(tooltip)){
    tooltip <- list(text = tooltip)
  }
  if(is.character(xAxis)){
    xAxis <- list(title = list(text = xAxis))
  }
  if(is.character(yAxis)){
    yAxis <- list(title = list(text = yAxis))
  }
  if(is.character(xAxis[["title"]])){
    xAxis[["title"]] <- list(text = xAxis[["title"]])
  }
  if(is.character(yAxis[["title"]])){
    yAxis[["title"]] <- list(text = yAxis[["title"]])
  }
  # if(is.null(xAxis[["title"]])){
  #   xAxis[["title"]] <- list(
  #     text = category,
  #     fontSize = 20,
  #     color = NULL
  #   )
  # }
  if(is.null(xAxis[["labels"]])){
    xAxis[["labels"]] <- list(
      color = NULL,
      fontSize = 18,
      rotation = 0
    )
  }
  # if(is.null(yAxis[["title"]])){
  #   yAxis[["title"]] <- list(
  #     text = value,
  #     fontSize = 20,
  #     color = NULL
  #   )
  # }
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
             `data-data2` = as.character(toJSON(data2)),
             `data-category` = category,
             `data-value` = as.character(toJSON(value)),
             `data-valuenames` = as.character(toJSON(valueNames)),
             `data-min` = minValue,
             `data-max` = maxValue,
             `data-tooltipstyle` = list2json(tooltip),
             `data-charttitle` = list2json(chartTitle),
             `data-columnstyle` = list2json(columnStyle),
             `data-cellwidth` = max(50, min(cellWidth, 100)),
             `data-columnwidth` = max(10, min(columnWidth, 100)),
             `data-xaxis` = list2json(xAxis),
             `data-yaxis` = list2json(yAxis),
             `data-valueformatter` = valueFormatter,
             `data-theme` = theme %||% "null",
             `data-chartbackgroundcolor` = backgroundColor %||% "null",
             `data-gridlines` = list2json(gridLines),
             `data-legend` = ifelse(legend, "true", "false"),
             `data-draggable` = as.character(toJSON(draggable)),
             `data-button` = list2json(button),
             `data-caption` = list2json(caption),
             `data-scrollbarx` = ifelse(scrollbarX, "true", "false"),
             `data-scrollbary` = ifelse(scrollbarY, "true", "false")
    )
  )
}

