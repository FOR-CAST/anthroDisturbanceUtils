## A 10 x 10 grid of 1 m cells
grid10 <- function() {
  terra::rast(nrows = 10, ncols = 10, xmin = 0, xmax = 10, ymin = 0, ymax = 10, crs = "EPSG:3857")
}

test_that("disturbancePresenceRaster() marks the cells under any layer with 1, others with NA", {
  rasterToMatch <- grid10()
  distLayers <- list(
    mining = list(mining = square(0, 0, size = 2)),
    roads = list(roads = terra::vect("LINESTRING (0.5 9.5, 9.5 9.5)", crs = "EPSG:3857"))
  )

  out <- disturbancePresenceRaster(distLayers, rasterToMatch)
  expect_s4_class(out, "SpatRaster")
  expect_named(out, "disturbance")
  expect_true(terra::compareGeom(out, rasterToMatch))
  vals <- terra::values(out, mat = FALSE)
  expect_identical(sort(unique(vals[!is.na(vals)])), 1)
  expect_identical(sum(!is.na(vals)), 4L + 10L)
  expect_true(is.na(vals[terra::cellFromXY(out, cbind(5.5, 5.5))]))
})

test_that("disturbancePresenceRaster() keeps a raster layer's values, the first layer winning", {
  rasterToMatch <- grid10()
  ras <- terra::init(rasterToMatch, 2)
  ras[1:50] <- NA
  distLayers <- list(mining = list(mining = square(0, 0, size = 2)), fire = list(fire = ras))

  vals <- terra::values(disturbancePresenceRaster(distLayers, rasterToMatch), mat = FALSE)
  expect_identical(vals[terra::cellFromXY(rasterToMatch, cbind(0.5, 0.5))], 1)
  expect_identical(vals[terra::cellFromXY(rasterToMatch, cbind(5.5, 0.5))], 2)
  expect_true(is.na(vals[terra::cellFromXY(rasterToMatch, cbind(5.5, 9.5))]))
})

test_that("disturbancePresenceRaster() returns NULL when there is nothing to map", {
  rasterToMatch <- grid10()
  expect_null(disturbancePresenceRaster(list(), rasterToMatch))
  expect_null(disturbancePresenceRaster(list(roads = list(roads = square(0)[0, ])), rasterToMatch))
})
