#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
choropleth <- function(
  data,
  polygon_json,
  projectionType = c('azimuthalEqualArea',
                     'azimuthalEquidistant',
                     'gnomonic',
                     'orthographic',
                     'stereographic',
                     'equalEarth',
                     'equirectangular',
                     'mercator',
                     'transverseMercator',
                     'naturalEarth1'),
  projectionScale = 200,
  interective_rotate = FALSE,
  ...,
  width = NULL,
  height = NULL,
  elementId = NULL
  ) {

  projectionType <- match.arg(projectionType)
  # describe a React component to send to the browser for rendering.
  # component <- reactR::reactMarkup(htmltools::tag("div", list(message)))
  configuration <- list(
    data               = jsonlite::toJSON(jsonlite::fromJSON(data)),
    polygon_json       = jsonlite::toJSON(jsonlite::fromJSON(polygon_json)),
    projectionType     = projectionType,
    # projectionScale    = projectionScale,
    ...
  )

  component <- reactR::reactMarkup(reactR::component("ChoroplethTag", configuration))


  # create widget
  htmlwidgets::createWidget(
    name = 'choropleth',
    component,
    width = width,
    height = height,
    package = 'nivoR',
    elementId = elementId
  )
}

#' Called by HTMLWidgets to produce the widget's root element.
#' @noRd
widget_html.choropleth <- function(id, style, class, ...) {
  htmltools::tagList(
    # Necessary for RStudio viewer version < 1.2
    reactR::html_dependency_corejs(),
    reactR::html_dependency_react(),
    reactR::html_dependency_reacttools(),
    htmltools::tags$div(id = id, class = class, style = style)
  )
}

#' Shiny bindings for choropleth
#'
#' Output and render functions for using choropleth within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a choropleth
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name choropleth-shiny
#'
#' @export
choroplethOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'choropleth', width, height, package = 'nivoR')
}

#' @rdname choropleth-shiny
#' @export
renderChoropleth <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, choroplethOutput, env, quoted = TRUE)
}
