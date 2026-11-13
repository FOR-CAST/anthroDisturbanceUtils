#' Collect the terra layers from a nested list
#'
#' @param x A `SpatRaster`, a `SpatVector`, or a list of them, nested to any
#'   depth (such as a disturbance list).
#'
#' @return A flat, unnamed list of the `SpatRaster`s and `SpatVector`s in `x`, in
#'   the order they appear. Other elements are dropped.
#'
#' @author Alex M. Chubaty
#' @export
#' @examples
#' square <- terra::vect("POLYGON ((0 0, 1 0, 1 1, 0 1, 0 0))", crs = "EPSG:3857")
#' nested <- list(mining = list(mining = square, notes = "dropped"), roads = list())
#' flattenTerra(nested)
flattenTerra <- function(x) {
  if (inherits(x, c("SpatRaster", "SpatVector"))) {
    return(list(x))
  }
  if (is.list(x)) {
    out <- list()
    for (el in x) {
      out <- c(out, flattenTerra(el))
    }
    return(out)
  }
  list()
}
