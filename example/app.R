library(shiny)
library(nivoR)
library(shinyStore)

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
    choropleth("Test!")
  )
  # observe({
  #   print(input$foo)
  # })

  observeEvent(input$foo, {
    print(input$foo$id)
  })
}

shinyApp(ui, server)
