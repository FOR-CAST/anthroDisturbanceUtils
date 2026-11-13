test_that("flattenTerra() collects the terra layers of a nested list, in order", {
  poly <- square(0)
  line <- toyTerraList()$roads$roads
  ras <- terra::rast(nrows = 2, ncols = 2, crs = "EPSG:3857")
  nested <- list(
    mining = list(mining = poly, notes = "dropped"),
    roads = list(),
    deep = list(list(list(ras)), NULL, line)
  )

  out <- flattenTerra(nested)
  expect_length(out, 3)
  expect_null(names(out))
  expect_identical(out[[1]], poly)
  expect_identical(out[[2]], ras)
  expect_identical(out[[3]], line)
})

test_that("flattenTerra() wraps a single layer, and returns an empty list for anything else", {
  poly <- square(0)
  expect_identical(flattenTerra(poly), list(poly))
  expect_identical(flattenTerra(NULL), list())
  expect_identical(flattenTerra(list(a = 1, b = list("x"))), list())
})
