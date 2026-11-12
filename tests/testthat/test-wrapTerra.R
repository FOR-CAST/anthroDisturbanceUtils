test_that("wrapTerraList() and unwrapTerraList() round-trip a disturbance list", {
  gp <- withr::local_tempdir()
  dl <- toyTerraList()

  index <- wrapTerraList(dl, gp)
  expect_identical(
    index,
    list(
      mining = list(potentialMining = "mining_potentialMining.rds"),
      roads = list(roads = "roads_roads.rds")
    )
  )
  expect_identical(readRDS(file.path(gp, "theList.rds")), index)

  out <- suppressMessages(unwrapTerraList(index, gp))
  expect_named(out, c("mining", "roads"))
  expect_named(out$mining, "potentialMining")
  expect_s4_class(out$mining$potentialMining, "SpatVector")
  expect_identical(terra::geom(out$roads$roads), terra::geom(dl$roads$roads))
  ## the WKT can differ in form (e.g., DATUM vs ENSEMBLE for WGS 84); the CRS does not
  expect_identical(terra::crs(out$mining$potentialMining, describe = TRUE)$code, "3857")
  expect_identical(out$mining$potentialMining$Class, "mining")
})

test_that("unwrapTerraList() reads theList.rds from generalPath, with terra attached or not", {
  gp <- withr::local_tempdir()
  wrapTerraList(toyTerraList(), gp)

  suppressMessages(
    expect_message(out <- unwrapTerraList("theList.rds", gp), "Recovering roads_roads.rds")
  )
  expect_s4_class(out$roads$roads, "SpatVector")

  ## attached, terra masks readRDS(); attach it only if needed, so the search path is left as found
  if (!"package:terra" %in% search()) {
    withr::local_package("terra")
  }
  out <- suppressMessages(unwrapTerraList("theList.rds", gp))
  expect_s4_class(out$roads$roads, "SpatVector")
  expect_identical(terra::geomtype(out$mining$potentialMining), "polygons")
})

test_that("unwrapTerraList() finds the layers in generalPath, whatever directory the index names", {
  gp <- withr::local_tempdir()
  index <- wrapTerraList(toyTerraList(), gp)
  ## full paths on the machine that wrote the index, and the "./" of a flat archive
  moved <- list(
    mining = list(potentialMining = file.path("/elsewhere", index$mining$potentialMining)),
    roads = list(roads = file.path(".", index$roads$roads))
  )
  saveRDS(moved, file.path(gp, "theList.rds"))

  out <- suppressMessages(unwrapTerraList("theList.rds", gp))
  expect_s4_class(out$mining$potentialMining, "SpatVector")
  expect_s4_class(out$roads$roads, "SpatVector")
})

test_that("wrapTerraList(zipFiles = TRUE) writes a flat archive that unwrapTerraList() extracts", {
  skip_if(Sys.which("zip") == "", "no zip program")
  withr::local_options(reproducible.destinationPath = NULL)
  gp <- withr::local_tempdir()
  index <- wrapTerraList(toyTerraList(), gp, zipFiles = TRUE)

  files <- c("theList.rds", unlist(index, use.names = FALSE))
  zipFile <- file.path(gp, "disturbanceList.zip")
  expect_setequal(utils::unzip(zipFile, list = TRUE)$Name, files)

  unlink(file.path(gp, files)) ## only disturbanceList.zip is left in generalPath
  withr::local_dir(withr::local_tempdir()) ## the working directory is not generalPath
  ## the archive is already in generalPath, so nothing is downloaded
  out <- suppressMessages(
    unwrapTerraList("https://example.invalid/disturbanceList.zip", generalPath = gp)
  )
  expect_named(out, c("mining", "roads"))
  expect_s4_class(out$roads$roads, "SpatVector")
})

test_that("unwrapTerraList() extracts and reads an archive that wrapTerraList() did not write", {
  skip_if(Sys.which("zip") == "", "no zip program")
  withr::local_options(reproducible.destinationPath = NULL)
  gp <- withr::local_tempdir()
  ## laid out like the archive on Zenodo: layer files with names of their own, zipped flat
  dl <- toyTerraList()
  saveRDS(terra::wrap(dl$mining$potentialMining), file.path(gp, "polyLayer01.rds"))
  saveRDS(terra::wrap(dl$roads$roads), file.path(gp, "lineLayer02.rds"))
  index <- list(
    mining = list(potentialMining = "polyLayer01.rds"),
    roads = list(roads = "lineLayer02.rds")
  )
  saveRDS(index, file.path(gp, "theList.rds"))
  files <- c("theList.rds", "polyLayer01.rds", "lineLayer02.rds")
  withr::with_dir(gp, utils::zip("disturbanceList.zip", files, flags = "-q"))

  unlink(file.path(gp, files))
  withr::local_dir(withr::local_tempdir())
  out <- suppressMessages(
    unwrapTerraList("https://example.invalid/disturbanceList.zip", generalPath = gp)
  )
  expect_named(out, c("mining", "roads"))
  expect_s4_class(out$mining$potentialMining, "SpatVector")
  expect_identical(terra::geomtype(out$roads$roads), "lines")
})

test_that("wrapTerraList() gives each layer its own safe file name", {
  gp <- withr::local_tempdir()
  line <- toyTerraList()$roads$roads
  dl <- list(`a b` = list(c = line), a = list(`b c` = line, `b/c` = line))

  index <- wrapTerraList(dl, gp)
  files <- unlist(index, use.names = FALSE)
  expect_identical(files, c("a_b_c.rds", "a_b_c_1.rds", "a_b_c_2.rds"))
  expect_true(all(file.exists(file.path(gp, files))))
})

test_that("a sector with no layers round-trips as an empty list", {
  gp <- withr::local_tempdir()
  dl <- list(wind = list(), roads = toyTerraList()$roads)

  index <- wrapTerraList(dl, gp)
  expect_identical(index, list(wind = list(), roads = list(roads = "roads_roads.rds")))
  out <- suppressMessages(unwrapTerraList("theList.rds", gp))
  expect_identical(out$wind, list())
  expect_s4_class(out$roads$roads, "SpatVector")
})

test_that("wrapTerraList() stops on a list it cannot write", {
  gp <- withr::local_tempdir()
  line <- toyTerraList()$roads$roads
  expect_snapshot(wrapTerraList(list(line), gp), error = TRUE)
  expect_snapshot(wrapTerraList(list(roads = line), gp), error = TRUE)
  expect_snapshot(wrapTerraList(list(roads = list(roads = data.frame(x = 1))), gp), error = TRUE)
  expect_snapshot(wrapTerraList(list(roads = list(roads = line, roads = line)), gp), error = TRUE)
})
