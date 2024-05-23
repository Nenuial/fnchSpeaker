#' Jumping results UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import bslib
mod_results_jumping_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$head(
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
    ),

    bslib::card(
      bslib::card_header("Paramètres"),
      bslib::card_body(
        layout_columns(
          shiny::selectInput(
            inputId = ns("event_id"),
            label = "Concours",
            choices = rsvps::get_fnch_sp_events() |>
              dplyr::select(titre, id) |>
              tibble::deframe()
          ),
          shiny::uiOutput(
            fill = "container",
            inline= TRUE,
            outputId = ns("startlist_ui")
          )
        ),

        layout_columns(
          shiny::numericInput(
            inputId = ns("nb_ranks"),
            label = "Rang max.",
            value = 5, min = 5, max = 10, step = 1
          ),
          shiny::numericInput(
            inputId = ns("nb_years"),
            label = "Nombre d'années",
            value = 2, min = 1, max = 5, step = 1
          )
        ),
        layout_columns(
          shiny::selectInput(
            inputId = ns("class_min"),
            label = "Catégorie min.",
            choices = rsvps::get_fnch_sp_class_cat()
          ),
          shiny::numericInput(
            inputId = ns("titles_min"),
            label = "Titres depuis",
            value = 2015, min = 2015, max = format(Sys.Date(), "%Y") |> as.numeric() - 1, step = 1
          )
        ),
        fluidRow(
          col_12(
            shiny::actionButton(
              inputId = ns("load"),
              label = "Charger"
            ),
            uiOutput(ns("pdf_button_placeholder"), inline = TRUE)
          )
        )
      )
    ),

    bslib::card(
      bslib::card_header("Liste"),
      bslib::card_body(
        fluidRow(
          col_12(
            uiOutput(ns("startlist_placeholder"))
          )
        ),

        textOutput("keepAlive")
      )
    )
  )
}

#' Jumping results Server Functions
#'
#' @noRd
mod_results_jumping_server <- function(id){
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    titles_data <- NULL
    startlist_data <- list()

    output$keepAlive <- renderText({
      req(input$count)
      paste("keep alive ", input$count)
    })

    observe({
      req(input$event_id)

      output$startlist_ui <- shiny::renderUI({
        shiny::selectInput(
          inputId = ns("class_id"),
          label = "Épreuve",
          choices = rsvps::get_fnch_event_startlists(input$event_id) |>
            dplyr::mutate(name = glue::glue("{nummer} - {kategorie_text} - {name}"), id) |>
            dplyr::select(name, id) |>
            tibble::deframe()
        )
      })
    })

    observe({
      output$startlist_placeholder <- renderUI({
        reactable::reactableOutput(
          outputId = ns("startlist_table")
        ) |> shinycssloaders::withSpinner()
      })

      output$startlist_table <- reactable::renderReactable({
        titles_data <<- rsvps::get_fnch_sp_titles(titles_min = isolate(input$titles_min))
        startlist_data <<- rsvps::get_fnch_sp_startlist_data(
          eventid = isolate(input$event_id),
          classid = isolate(input$class_id),
          nb_years = isolate(input$nb_years),
          nb_ranks = isolate(input$nb_ranks),
          class_min = isolate(input$class_min)
        )

        rsvps::get_fnch_sp_startlist(
          startlist_data = startlist_data,
          titles = titles_data
        )
      })

      output$pdf_button_placeholder <- renderUI({
        downloadButton(ns("dwnlpdf"), label = "PDF")
      })
    }) |> bindEvent(input$load)

    output$dwnlpdf <- downloadHandler(
      filename = "startlist.pdf",
      content = function(file) {
        out <- rsvps::render_fnch_sp_startlist_pdf(startlist_data, titles_data)

        file.rename(out, file)
      }
    )
  })
}

## To be copied in the UI
# mod_results_ui("results_1")

## To be copied in the server
# mod_results_server("results_1")
