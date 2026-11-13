## Tests ported from anthroDisturbance_Generator (Ronald Kilian)
noSteps <- list(outer = FALSE, inner = FALSE, cleanEmpty = FALSE, nullEmpty = FALSE)
cleanup <- function(aList, ...) {
  args <- utils::modifyList(noSteps, list(...))
  do.call(cleanupList, c(list(aList), args))
}

test_that("cleanupList(inner = TRUE) removes NULL elements of the inner lists", {
  aList <- list(a = list(1, NULL, 2), b = list(NULL, 3))
  expect_identical(cleanup(aList, inner = TRUE), list(a = list(1, 2), b = list(3)))
  expect_identical(cleanup(aList), aList)
})

test_that("cleanupList(outer = TRUE) removes NULL elements of the list", {
  aList <- list(a = 1, b = NULL, c = 3)
  expect_identical(cleanup(aList, outer = TRUE), list(a = 1, c = 3))
})

test_that("cleanupList(nullEmpty = TRUE) replaces empty lists with NULL", {
  aList <- list(a = list(), b = list(1))
  expect_identical(cleanup(aList, nullEmpty = TRUE), list(a = NULL, b = list(1)))
})

test_that("cleanupList(cleanEmpty = TRUE) removes empty lists", {
  aList <- list(a = list(), b = list(1), c = list())
  expect_identical(cleanup(aList, cleanEmpty = TRUE), list(b = list(1)))
})

test_that("cleanupList() applies every step together", {
  aList <- list(a = list(1, NULL), b = NULL, c = list())
  out <- cleanupList(aList, outer = TRUE, inner = TRUE, cleanEmpty = TRUE, nullEmpty = TRUE)
  expect_identical(out, list(a = list(1)))
})

test_that("cleanupList() with no steps returns the list unchanged", {
  aList <- list(a = list(), b = NULL, c = list(5))
  expect_identical(cleanup(aList), aList)
})

test_that("cleanupList() keeps the layers of a disturbance list", {
  roads <- toyTerraList()$roads$roads
  aList <- list(roads = list(roads = roads, old = NULL), wind = list())
  out <- cleanupList(aList, outer = TRUE, cleanEmpty = TRUE, nullEmpty = FALSE)
  expect_identical(out, list(roads = list(roads = roads)))
})
