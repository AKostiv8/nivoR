library(shiny)
library(nivoR)
library(shinyStore)
library(jsonlite)
library(tidyverse)
library(colourpicker)
library(shiny.router)


map_page <- div(
  titlePanel("nivoR Choropleth example"),
  choroplethOutput('mapOutput'),
  fluidRow(
    column(width = 4,
           sliderInput(inputId = 'projectionScale',
                       label = 'projectionScale',
                       min = 0,
                       max = 400,
                       value = 180,
                       step = 1),
           sliderInput(inputId = 'projectionTranslation_x',
                       label = 'projectionTranslation X',
                       min = -1,
                       max = 1,
                       value = 0.5,
                       step = 0.01),
           sliderInput(inputId = 'projectionTranslation_y',
                       label = 'projectionTranslation Y',
                       min = -1,
                       max = 1,
                       value = 0.5,
                       step = 0.01)
    ), # column end
    column(width = 4,
           sliderInput(inputId = 'borderWidth',
                       label = 'border Width',
                       min = 0,
                       max = 20,
                       value = 0.5,
                       step = 0.5),
           sliderInput(inputId = 'projectionRotation_y',
                       label = 'projectionRotation Y',
                       min = -360,
                       max = 360,
                       value = 0,
                       step = 1),
           sliderInput(inputId = 'projectionRotation_z',
                       label = 'projectionRotation Z',
                       min = -360,
                       max = 360,
                       value = 0,
                       step = 1)
    ),
    column(width = 4,
           colourInput("pol_col", "Polygon colour", "#166CF5"),
           colourInput("nodata_col", "No data colour", "#1C1C1C"),
           colourInput("border_col", "Border colour", "#989627"),
           textInput(inputId = 'tooltipID',label = 'No date tooltip text', value = 'No Data')
    )

  )
)

chart_page <- div(
  titlePanel("nivoR AreaBump example"),
  areabumpOutput('widgetOutput'),
  div('Clicked:', textOutput('areaSelected'))
)

router <- make_router(
  route("/", map_page),
  route("bumpchart", chart_page)
)

ui <- fluidPage(
  theme = "style.css",
  tags$ul(
    tags$li(a(href = route_link("/"), "Choropleth")),
    tags$li(a(href = route_link("bumpchart"), "AreaBump"))
  ),
  tags$script(src = "script.js"),
  router$ui

)

server <- function(input, output, session) {

  router$server(input, output, session)


  output$mapOutput <- renderChoropleth(
    choropleth(data = './data_globe.json',
               projectionType = 'orthographic',
               map_id = 'globalMap',
               projectionScale = input$projectionScale,
               projectionTranslation_x = input$projectionTranslation_x,
               projectionTranslation_y = input$projectionTranslation_y,
               tooltipText = input$tooltipID,
               rotate_y = input$projectionRotation_y,
               rotate_z = input$projectionRotation_z,
               border_width = input$borderWidth,
               polygonColors = 'oranges',
               unknownColor = '#EBEBEB',
               border_Color = '#595959',
               domainMin = 0,
               domainMax = 100000
               )
  )

  output$widgetOutput <- renderAreabump(
    areabump('test')
  )

  observeEvent(input$globalMap, {
    print(input$globalMap)
  })

  observeEvent(input$foo, {
    output$areaSelected <- renderText({
      input$foo$id
    })
    # print(input$foo$id)
  })
}

shinyApp(ui, server)
