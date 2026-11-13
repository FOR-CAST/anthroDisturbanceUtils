#' Replace layers in a disturbance list
#'
#' For each sector and class in `layers`, removes every layer of that class from
#' the sector in `disturbanceList`, then adds the new layer at the end of the
#' sector. A `NULL` layer only removes the class. A sector not yet in
#' `disturbanceList` is added.
#'
#' @param disturbanceList A list of lists of layers, named by sector and then by
#'   class.
#' @param layers The new layers: a list of lists, named by sector and then by
#'   class, like `disturbanceList`.
#'
#' @return `disturbanceList`, with the layers replaced.
#'
#' @author Tati Micheletti, Alex M. Chubaty
#' @export
#' @examples
#' square <- terra::vect("POLYGON ((0 0, 1 0, 1 1, 0 1, 0 0))", crs = "EPSG:3857")
#' disturbanceList <- list(mining = list(mining = square, potentialMining = NULL))
#' newLayers <- list(
#'   mining = list(potentialMining = square),
#'   forestry = list(potentialCutblocks = square)
#' )
#' str(replaceLayers(disturbanceList, newLayers), max.level = 2)
replaceLayers <- function(disturbanceList, layers) {
  if (!isNamedList(layers) || !all(vapply(layers, isNamedList, logical(1)))) {
    msg <- "`layers` must be a list of lists of layers, with unique sector and class names."
    stop(msg, call. = FALSE)
  }
  for (sector in names(layers)) {
    for (class in names(layers[[sector]])) {
      disturbanceList[[sector]][names(disturbanceList[[sector]]) == class] <- NULL
      disturbanceList[[sector]][[class]] <- layers[[sector]][[class]]
    }
  }
  disturbanceList
}
