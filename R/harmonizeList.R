#' Combine the layers of a disturbance list that share a class name
#'
#' Within each sector of `disturbances`, layers with the same class name are
#' combined into one layer with `rbind()`, unless the class name matches one of
#' the patterns in `whatNotToCombine`.
#'
#' @param disturbances A list of lists of `SpatVector`s, named by sector and then
#'   by class. A class name may appear more than once in a sector.
#' @param whatNotToCombine Character vector of regular expressions. Classes whose
#'   name matches any of them are left as they are, repeats included. With
#'   `NULL` (the default), every repeated class is combined.
#'
#' @return A list with the sectors of `disturbances`. A sector with no class to
#'   combine is returned unchanged. In the others, the classes left as they are
#'   come first (those matching `whatNotToCombine`, then the rest), followed by
#'   the combined classes.
#'
#' @author Tati Micheletti, Ronald Kilian, Alex M. Chubaty
#' @export
#' @examples
#' square <- function(x) {
#'   terra::vect(
#'     sprintf("POLYGON ((%1$d 0, %2$d 0, %2$d 1, %1$d 1, %1$d 0))", x, x + 1),
#'     crs = "EPSG:3857"
#'   )
#' }
#' disturbances <- list(
#'   mining = list(claims = square(0), claims = square(2), potentialMining = square(4))
#' )
#' out <- harmonizeList(disturbances, whatNotToCombine = "potential")
#' names(out$mining)
#' nrow(out$mining$claims)
harmonizeList <- function(disturbances, whatNotToCombine = NULL) {
  if (is.null(disturbances)) {
    stop("`disturbances` can't be NULL.", call. = FALSE)
  }
  harmonized <- lapply(names(disturbances), function(sector) {
    message("Harmonizing ", sector)
    layers <- disturbances[[sector]]
    classes <- names(layers)
    excluded <- if (length(whatNotToCombine) > 0) {
      grepl(paste(whatNotToCombine, collapse = "|"), classes)
    } else {
      rep(FALSE, length(classes))
    }
    dups <- unique(classes[!excluded][duplicated(classes[!excluded])])
    if (length(dups) == 0) {
      message("Returning ", sector, " unchanged.")
      return(layers)
    }
    combined <- lapply(dups, function(class) {
      do.call(rbind, unname(layers[classes == class]))
    })
    names(combined) <- dups
    message("Returning ", sector, " merged.")
    c(layers[excluded], layers[!excluded & !classes %in% dups], combined)
  })
  names(harmonized) <- names(disturbances)
  harmonized
}
