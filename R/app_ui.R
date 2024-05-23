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
    page_navbar(
      window_title = "SpeakerApp",
      bg = "#306489",
      fluid = TRUE,
      fillable = FALSE,
      title = img(src = "www/favicon.png", width = "50"),
      theme = app_theme(),
      nav_panel(
        title = "Saut",
        mod_results_jumping_ui("jumping")
      ),
      nav_panel(
        title = "Dressage",
        mod_results_dressage_ui("dressage")
      ),
      nav_panel(
        title = "Concours Complet",
        mod_results_eventing_ui("eventing")
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
    ),
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
    HTML(
      "
        <script>
        var socket_timeout_interval
        var n = 0
        $(document).on('shiny:connected', function(event) {
        socket_timeout_interval = setInterval(function(){
        Shiny.onInputChange('count', n++)
        }, 15000)
        });
        $(document).on('shiny:disconnected', function(event) {
        clearInterval(socket_timeout_interval)
        });
        </script>
      "
    )
  )
}
