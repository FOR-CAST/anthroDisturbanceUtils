## Tests ported from anthroDisturbance_DataPrep (Ronald Kilian), plus the last two
harmonize <- function(...) suppressMessages(harmonizeList(...))

test_that("harmonizeList() stops on NULL", {
  expect_snapshot(harmonizeList(NULL, whatNotToCombine = "potential"), error = TRUE)
})

test_that("harmonizeList() returns a sector unchanged when no class name repeats", {
  disturbances <- list(
    mining = list(claims = square(0), permits = square(2)),
    forestry = list(cutblocks = square(0, 2), roads = square(2, 2))
  )
  suppressMessages(
    expect_message(harmonizeList(disturbances, "potential"), "Returning mining unchanged")
  )
  expect_identical(harmonize(disturbances, whatNotToCombine = "potential"), disturbances)
})

test_that("harmonizeList() combines repeated classes, except those matching whatNotToCombine", {
  mining <- list(claims = square(0), claims = square(2), permits = square(4))
  forestry <- list(
    roads = square(0, 2),
    roads = square(2, 2),
    potentialCutblocks = square(4, 2),
    potentialCutblocks = square(6, 2)
  )
  out <- harmonize(list(mining = mining, forestry = forestry), whatNotToCombine = "potential")

  expect_named(out, c("mining", "forestry"))
  expect_named(out$mining, c("permits", "claims"))
  expect_equal(nrow(out$mining$claims), 2)
  expect_equal(nrow(out$mining$permits), 1)
  expect_named(out$forestry, c("potentialCutblocks", "potentialCutblocks", "roads"))
  expect_equal(nrow(out$forestry$roads), 2)
})

test_that("harmonizeList() honours several whatNotToCombine patterns", {
  forestry <- list(
    roads = square(0),
    roads = square(1.5),
    potentialX = square(0, 2),
    potentialX = square(1.5, 2)
  )
  out <- harmonize(list(forestry = forestry), whatNotToCombine = c("potential", "^roads$"))
  expect_identical(out$forestry, forestry)
})

test_that("harmonizeList() returns an empty list for an empty list", {
  expect_identical(harmonize(list(), whatNotToCombine = "potential"), list())
})

test_that("harmonizeList() keeps repeats of a sector's only, excluded, class", {
  forestry <- list(
    potentialCutblocks = square(0),
    potentialCutblocks = square(1.5),
    potentialCutblocks = square(3)
  )
  out <- harmonize(list(forestry = forestry), whatNotToCombine = "potential")
  expect_identical(out$forestry, forestry)
})

test_that("harmonizeList() matches whatNotToCombine case-sensitively, unless told otherwise", {
  forestry <- list(PotentialCutblocks = square(0), PotentialCutblocks = square(1.5))
  disturbances <- list(forestry = forestry)

  out <- harmonize(disturbances, whatNotToCombine = "potential")
  expect_named(out$forestry, "PotentialCutblocks")
  expect_equal(nrow(out$forestry$PotentialCutblocks), 2)

  out <- harmonize(disturbances, whatNotToCombine = "(?i)potential")
  expect_identical(out$forestry, forestry)
})

test_that("harmonizeList() fills attributes missing from some of the combined layers with NA", {
  a <- square(0)
  a$id <- 1L
  b <- square(2)
  b$val <- 10.5
  c <- square(4)
  c$id <- 3L
  c$val <- 20
  out <- harmonize(list(forestry = list(roads = a, roads = b, roads = c)))

  df <- as.data.frame(out$forestry$roads)
  expect_equal(nrow(df), 3)
  expect_identical(df$id, c(1L, NA, 3L))
  ## terra fills a missing numeric attribute with NaN
  expect_identical(is.na(df$val), c(TRUE, FALSE, FALSE))
  expect_identical(df$val[2:3], c(10.5, 20))
})

test_that("harmonizeList() returns each layer once when only excluded classes repeat", {
  forestry <- list(
    roads = square(0),
    potentialCutblocks = square(2),
    potentialCutblocks = square(4)
  )
  out <- harmonize(list(forestry = forestry), whatNotToCombine = "potential")
  expect_identical(out$forestry, forestry)
})

test_that("harmonizeList() combines every repeated class when whatNotToCombine is NULL", {
  forestry <- list(potentialCutblocks = square(0), potentialCutblocks = square(2))
  out <- harmonize(list(forestry = forestry))
  expect_named(out$forestry, "potentialCutblocks")
  expect_equal(nrow(out$forestry$potentialCutblocks), 2)
})
