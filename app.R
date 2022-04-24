library(shiny)
library(choropleth)

ui <- fluidPage(
  titlePanel("reactR HTMLWidget Example"),
  choroplethOutput('widgetOutput')
)

server <- function(input, output, session) {
  output$widgetOutput <- renderChoropleth(
    choropleth("Hello world!")
  )
}

shinyApp(ui, server)