## A square polygon with its lower-left corner at (xmin, ymin)
square <- function(xmin, ymin = 0, size = 1) {
  wkt <- sprintf(
    "POLYGON ((%1$g %2$g, %3$g %2$g, %3$g %4$g, %1$g %4$g, %1$g %2$g))",
    xmin,
    ymin,
    xmin + size,
    ymin + size
  )
  terra::vect(wkt, crs = "EPSG:3857")
}
