#' List the layers of a disturbance list that are not potential layers
#'
#' Potential layers, whose class name starts with `"potential"`, show where a
#' disturbance may happen; the other layers show where one has happened.
#'
#' @param disturbanceList A list of lists of layers, named by sector and then by
#'   class.
#'
#' @return A `data.table` with columns `Sector` and `dataClass`, one row per
#'   sector and class whose name does not start with `"potential"`. Unnamed
#'   sectors, sectors that are not lists and `NA` class names are skipped, and
#'   repeated rows are dropped.
#'
#' @author Tati Micheletti, Ronald Kilian
#' @importFrom data.table data.table rbindlist
#' @export
#' @examples
#' disturbanceList <- list(
#'   mining = list(mining = NULL, potentialMining = NULL),
#'   roads = list(roads = NULL)
#' )
#' extractNonPotentialLayers(disturbanceList)
extractNonPotentialLayers <- function(disturbanceList) {
  empty <- data.table::data.table(Sector = character(), dataClass = character())
  if (!is.list(disturbanceList) || length(disturbanceList) == 0) {
    return(empty)
  }
  sectors <- lapply(seq_along(disturbanceList), function(i) {
    sector <- names(disturbanceList)[i]
    classes <- disturbanceList[[i]]
    if (is.null(sector) || is.na(sector) || !is.list(classes)) {
      return(NULL)
    }
    classes <- names(classes)
    classes <- classes[!is.na(classes) & !startsWith(classes, "potential")]
    if (length(classes) == 0) {
      return(NULL)
    }
    data.table::data.table(Sector = sector, dataClass = classes)
  })
  result <- unique(data.table::rbindlist(sectors, use.names = TRUE, fill = TRUE))
  if (nrow(result) == 0) empty else result
}
