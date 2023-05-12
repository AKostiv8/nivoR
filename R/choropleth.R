#' Choropleth
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
choropleth <- function(
  map_id,
  data,
  polygon_json = nivoR::world_countries_json,
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
  projectionTranslation_x = 0.5,
  projectionTranslation_y = 0.5,
  rotate_x = 0,
  rotate_y = 0,
  rotate_z = 0,
  domainMin = 0,
  domainMax = 1000000,
  border_width = 0.5,
  border_Color="#989627",
  width = NULL,
  height = '400px',
  margin_top = 0,
  margin_left = 0,
  margin_right = 0,
  margin_bottom = 0,
  unknownColor="#666666",
  tooltipText,
  polygonColors = '#9b0034',
  pausePlayBTNcolor = 'black',
  elementId = NULL,
  ...
  ) {

  projectionType <- match.arg(projectionType)
  # describe a React component to send to the browser for rendering.
  # component <- reactR::reactMarkup(htmltools::tag("div", list(message)))
  if(projectionType == 'orthographic') {
    interective_rotate <- TRUE
  } else {
    interective_rotate <- FALSE
  }

  configuration <- list(
    map_id                  = map_id,
    data                    = jsonlite::toJSON(jsonlite::fromJSON(data)),
    polygon_json            = polygon_json,
    projectionType          = projectionType,
    height                  = height,
    projectionScale         = projectionScale,
    projectionTranslation_x = projectionTranslation_x,
    projectionTranslation_y = projectionTranslation_y,
    rotate_x                = rotate_x,
    rotate_y                = rotate_y,
    rotate_z                = rotate_z,
    border_width            = border_width,
    unknownColor            = unknownColor,
    border_Color            = border_Color,
    margin_top              = margin_top,
    margin_left             = margin_left,
    margin_right            = margin_right,
    margin_bottom           = margin_bottom,
    tooltipText             = tooltipText,
    polygonColors           = polygonColors,
    pausePlayBTNcolor       = pausePlayBTNcolor,
    interective_rotate      = interective_rotate,
    domainMin               = domainMin,
    domainMax               = domainMax,
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
