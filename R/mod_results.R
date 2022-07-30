#' results UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_results_ui <- function(id){
  ns <- NS(id)
  tagList(
    bs4Card(
      title = "Paramètres",
      collapsible = FALSE,
      collapsed = FALSE,
      closable = FALSE,
      headerBorder = TRUE,
      status = "primary",
      width = 12,

      fluidRow(
        col_6(
          shiny::selectInput(
            inputId = ns("event_id"),
            label = "Concours",
            choices = rsvps::get_fnch_sp_events() |>
              dplyr::select(ort, id) |>
              tibble::deframe()
          )
        ),
        col_6(
          shiny::uiOutput(
            outputId = ns("startlist_ui")
          )
        )
      ),

      fluidRow(
        col_6(
          shiny::numericInput(
            inputId = ns("nb_ranks"),
            label = "Rang max.",
            value = 5, min = 5, max = 10, step = 1
          )
        ),
        col_6(
          shiny::numericInput(
            inputId = ns("nb_years"),
            label = "Nombre d'années",
            value = 2, min = 2, max = 5, step = 1
          )
        )
      ),
      fluidRow(
        col_12(
          shiny::actionButton(
            inputId = ns("load"),
            label = "Charger"
          )
        )
      )
    ),

    bs4Card(
      title = "Liste",
      collapsed = FALSE,
      closable = FALSE,
      headerBorder = TRUE,
      status = "primary",
      width = 12,

      fluidRow(
        col_12(
          reactable::reactableOutput(
            outputId = ns("startlist_table")
          )
        )
      )
    )
  )
}

#' results Server Functions
#'
#' @noRd
mod_results_server <- function(id){
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observe({
      req(input$event_id)

      output$startlist_ui <- shiny::renderUI({
        shiny::selectInput(
          inputId = ns("class_id"),
          label = "Épreuve",
          choices = rsvps::get_fnch_event_startlists(input$event_id) |>
            dplyr::mutate(name = glue::glue("{nummer} - {name}"), id) |>
            dplyr::select(name, id) |>
            tibble::deframe()
        )
      })
    })

    observeEvent(input$load,{
      output$startlist_table <- reactable::renderReactable({
        rsvps::get_fnch_sp_startlist(
          eventid = isolate(input$event_id),
          classid = isolate(input$class_id),
          nb_years = isolate(input$nb_years),
          nb_ranks = isolate(input$nb_ranks)
        )
      })
    })
  })
}

## To be copied in the UI
# mod_results_ui("results_1")

## To be copied in the server
# mod_results_server("results_1")
