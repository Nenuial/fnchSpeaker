#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bs4Dash
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  mod_results_server("results")
}
