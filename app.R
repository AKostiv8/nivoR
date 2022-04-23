library(shiny)
library(nivoR)

ui <- fluidPage(
  titlePanel("reactR HTMLWidget Example"),
  areabumpOutput('widgetOutput')
)

server <- function(input, output, session) {
  output$widgetOutput <- renderAreabump(
    areabump("Hello world!")
  )
}

shinyApp(ui, server)
