#' The application theme
#'
#' @export
app_theme <- function() {
  bslib::bs_theme(
    bg = "#2e3440",
    fg = "#eceff4",
    primary = "#306489",
    secondary = "#ad8cae",
    success = "#a3be8c",
    info = "#4f93b8",
    warning = "#d08770",
    danger = "#bf616a",
    base_font = "Fira Sans",
    code_font = "Fira Code",
    heading_font = "Fira Sans",
    bootswatch = "darkly"
  )
}

#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
      title = "SpeakerApp",
      navbarPage(
        title = tags$img(src = "www/favicon.png", width = "50"),
        theme = app_theme(),
        tabPanel(
          "Saut",
          fluid = TRUE,
          mod_results_jumping_ui("jumping")
        ),
        tabPanel(
          "Dressage",
          fluid = TRUE,
          mod_results_dressage_ui("dressage")
        ),
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(ext = "png"),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "fnchSpeaker"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
