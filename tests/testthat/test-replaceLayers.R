## The potentialResources modules' replaceList(), which replaceLayers() generalizes
replaceListModule <- function(
  disturbanceList,
  potentialOil,
  potentialMining,
  potentialCutblocks,
  potentialSeismicLines
) {
  disturbanceList$oilGas[names(disturbanceList$oilGas) == "potentialOilGas"] <- NULL
  disturbanceList$oilGas[["potentialOilGas"]] <- potentialOil
  disturbanceList$oilGas[names(disturbanceList$oilGas) == "potentialSeismicLines"] <- NULL
  disturbanceList$oilGas[["potentialSeismicLines"]] <- potentialSeismicLines
  disturbanceList$mining[names(disturbanceList$mining) == "potentialMining"] <- NULL
  disturbanceList$mining[["potentialMining"]] <- potentialMining
  disturbanceList$forestry[names(disturbanceList$forestry) == "potentialCutblocks"] <- NULL
  disturbanceList$forestry[["potentialCutblocks"]] <- potentialCutblocks
  disturbanceList
}

test_that("replaceLayers() gives what the modules' replaceList() gave", {
  old <- square(0)
  new <- list(oil = square(1), seismic = square(2), mining = square(3), cutblocks = square(4))
  disturbanceList <- list(
    oilGas = list(potentialOilGas = old, wells = old, potentialOilGas = old),
    mining = list(potentialMining = old, mining = old),
    settlements = list(settlements = old)
  )
  replace <- function(oil) {
    replaceLayers(
      disturbanceList,
      list(
        oilGas = list(potentialOilGas = oil, potentialSeismicLines = new$seismic),
        mining = list(potentialMining = new$mining),
        forestry = list(potentialCutblocks = new$cutblocks)
      )
    )
  }

  for (oil in list(new$oil, NULL)) {
    expected <- replaceListModule(disturbanceList, oil, new$mining, new$cutblocks, new$seismic)
    expect_identical(replace(oil), expected)
  }
  out <- replace(new$oil)
  expect_named(out, c("oilGas", "mining", "settlements", "forestry"))
  expect_named(out$oilGas, c("wells", "potentialOilGas", "potentialSeismicLines"))
  expect_identical(out$oilGas$potentialOilGas, new$oil)
})

test_that("replaceLayers() removes a class given a NULL layer", {
  disturbanceList <- list(mining = list(mining = square(0), potentialMining = square(1)))
  out <- replaceLayers(disturbanceList, list(mining = list(potentialMining = NULL)))
  expect_identical(out, list(mining = list(mining = disturbanceList$mining$mining)))
})

test_that("replaceLayers() stops on layers it cannot place", {
  disturbanceList <- list(mining = list(mining = square(0)))
  expect_snapshot(replaceLayers(disturbanceList, list(square(1))), error = TRUE)
  expect_snapshot(replaceLayers(disturbanceList, list(mining = square(1))), error = TRUE)
})
