## Tests ported from anthroDisturbance_Generator (Ronald Kilian)
layerTable <- function(Sector = character(), dataClass = character()) {
  data.table::data.table(Sector = Sector, dataClass = dataClass)
}
## compare ignoring row order
expect_same_rows <- function(actual, expected) {
  data.table::setkeyv(actual, c("Sector", "dataClass"))
  data.table::setkeyv(expected, c("Sector", "dataClass"))
  expect_equal(actual, expected)
}

test_that("extractNonPotentialLayers() returns an empty table for an empty list", {
  out <- extractNonPotentialLayers(list())
  expect_s3_class(out, "data.table")
  expect_equal(out, layerTable())
})

test_that("extractNonPotentialLayers() returns an empty table when every layer is potential", {
  disturbanceList <- list(forestry = list(potentialCutblocks = NULL, potentialRoads = NULL))
  expect_equal(extractNonPotentialLayers(disturbanceList), layerTable())
})

test_that("extractNonPotentialLayers() returns only the classes not starting with 'potential'", {
  disturbanceList <- list(
    energy = list(potentialWind = NULL, solar = NULL, gridLines = NULL),
    sectorX = list(subpotentialLayer = NULL, potentialLayer = NULL, actualLayer = NULL)
  )
  expect_same_rows(
    extractNonPotentialLayers(disturbanceList),
    layerTable(
      c("energy", "energy", "sectorX", "sectorX"),
      c("solar", "gridLines", "subpotentialLayer", "actualLayer")
    )
  )
})

test_that("extractNonPotentialLayers() drops repeated rows, not repeated classes across sectors", {
  disturbanceList <- list(
    mining = list(minePits = NULL, potentialShafts = NULL, minePits = NULL),
    forestry = list(cutblocks = NULL, thinning = NULL, potentialFire = NULL),
    other = list(minePits = NULL)
  )
  expect_same_rows(
    extractNonPotentialLayers(disturbanceList),
    layerTable(
      c("mining", "forestry", "forestry", "other"),
      c("minePits", "cutblocks", "thinning", "minePits")
    )
  )
})

test_that("extractNonPotentialLayers() matches 'potential' case-sensitively", {
  disturbanceList <- list(sectorB = list(PotentialLayer = NULL, potentialLayer = NULL, real = NULL))
  expect_same_rows(
    extractNonPotentialLayers(disturbanceList),
    layerTable(c("sectorB", "sectorB"), c("PotentialLayer", "real"))
  )
})

test_that("extractNonPotentialLayers() skips unnamed sectors and sectors that are not lists", {
  unnamed <- list(list(layer1 = NULL, layer2 = NULL))
  expect_equal(extractNonPotentialLayers(unnamed), layerTable())
  expect_equal(extractNonPotentialLayers(list(sectorD = 42)), layerTable())
  expect_equal(
    extractNonPotentialLayers(list(sector = c(a = 1, b = 2, potentialX = 3))),
    layerTable()
  )
})

test_that("extractNonPotentialLayers() skips NA class names but keeps empty ones and 'NA'", {
  disturbanceList <- list(
    x = stats::setNames(list(NULL, NULL), c(NA_character_, "foo")),
    sectorC = stats::setNames(list(NULL, NULL, NULL), c("", "potentialXYZ", "actualXYZ")),
    sector = list(`NA` = NULL, potentialX = NULL)
  )
  expect_same_rows(
    extractNonPotentialLayers(disturbanceList),
    layerTable(c("x", "sectorC", "sectorC", "sector"), c("foo", "", "actualXYZ", "NA"))
  )
})

test_that("extractNonPotentialLayers() keeps class names with spaces or special characters", {
  disturbanceList <- list(
    sector = list("potential " = NULL, real = NULL),
    sectorA = list("layer@1" = NULL, "potential#Layer" = NULL, " layer1 " = NULL)
  )
  expect_same_rows(
    extractNonPotentialLayers(disturbanceList),
    layerTable(c("sector", "sectorA", "sectorA"), c("real", "layer@1", " layer1 "))
  )
})

test_that("extractNonPotentialLayers() reads only the first two levels of a nested list", {
  disturbanceList <- list(sectorA = list(subSector = list(layer1 = NULL, potentialLayer = NULL)))
  expect_equal(extractNonPotentialLayers(disturbanceList), layerTable("sectorA", "subSector"))
})
