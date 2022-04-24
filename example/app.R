library(shiny)
library(nivoR)
library(shinyStore)
library(jsonlite)
library(tidyverse)

ui <- fluidPage(
  titlePanel("reactR HTMLWidget Example"),
  areabumpOutput('widgetOutput'),
  choroplethOutput('mapOutput'),
  tags$script(src = "script.js")

)

server <- function(input, output, session) {
  output$widgetOutput <- renderAreabump(
    areabump("Hello world!")
  )

  output$mapOutput <- renderChoropleth(
    choropleth(data = read_json('../../../../audio_recorder/src/nivo/countries.json'),
               polygon_json = read_json('../srcjs/test.json'),
               projectionType = 'stereographic'
               )
  )
  # observe({
  #   print(input$foo)
  # })

  observeEvent(input$foo, {
    print(input$foo$id)
  })
}

shinyApp(ui, server)
