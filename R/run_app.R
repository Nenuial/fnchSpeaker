#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  css <- "@import url('https://fonts.googleapis.com/css2?family=Fira+Sans:wght@400&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Fira+Code:wght@400&display=swap');

* {
  font-family: 'Fira Sans', 'Helvetica Neue', Helvetica, Arial, sans-serif;
  font-size: 15px;
}
.panel-auth {background-color: #2e3440;}"

  with_golem_options(
    app = shinyApp(
      ui = shinymanager::secure_app(
        app_ui, 
        theme = app_theme(), 
        enable_admin = T, 
        language = "fr", 
        tags_top = tags$div(tags$head(tags$style(css)))
      ),
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
