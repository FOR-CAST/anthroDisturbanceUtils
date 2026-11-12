## A two-sector disturbance list: a polygon layer with an attribute, and a line layer
toyTerraList <- function() {
  poly <- terra::vect("POLYGON ((0 0, 1 0, 1 1, 0 1, 0 0))", crs = "EPSG:3857")
  poly$Class <- "mining"
  line <- terra::vect("LINESTRING (0 0, 2 2)", crs = "EPSG:3857")
  list(mining = list(potentialMining = poly), roads = list(roads = line))
}
