# Write a list of disturbance layers to disk, and read it back

`wrapTerraList()` saves a list of vector layers grouped by sector and
class, such as the `disturbanceList` of the anthropogenic disturbance
modules: one `.rds` file per layer (a wrapped `SpatVector`), plus an
index, `theList.rds`, holding each layer's file name by sector and
class. With `zipFiles = TRUE` it also packs them into
`disturbanceList.zip`, the archive `unwrapTerraList()` downloads.

## Usage

``` r
wrapTerraList(terraList, generalPath, zipFiles = FALSE)

unwrapTerraList(terraList, generalPath)
```

## Arguments

- terraList:

  For `wrapTerraList()`, a list of lists of `SpatVector`s, named by
  sector and then by class.

  For `unwrapTerraList()`, either the index (a list of lists of file
  names, as `wrapTerraList()` returns), or a character string. If
  `theList.rds` is in `generalPath`, the string is ignored and the index
  is read from there; otherwise the string is the URL of
  `disturbanceList.zip`, which is downloaded (unless it is already in
  `generalPath`) and extracted into `generalPath` by
  [`reproducible::prepInputs()`](https://reproducible.predictiveecology.org/reference/prepInputs.html).

- generalPath:

  Directory that holds, or will hold, `theList.rds` and the layer files.

- zipFiles:

  Logical. Also write `disturbanceList.zip` to `generalPath`? Needs a
  `zip` program (see
  [`utils::zip()`](https://rdrr.io/r/utils/zip.html)).

## Value

`wrapTerraList()` returns the index invisibly: a list of lists of file
names, named by sector and class. `unwrapTerraList()` returns a list of
lists of `SpatVector`s with the same names.

## Details

`unwrapTerraList()` reads such a list back. It looks for the layers in
`generalPath`, whatever directory the index names, so an index written
on another machine, or one holding full paths, still works.

## Author

Tati Micheletti, Alex M. Chubaty

## Examples

``` r
disturbanceList <- list(
  mining = list(
    mining = terra::vect("POLYGON ((0 0, 1 0, 1 1, 0 1, 0 0))", crs = "EPSG:3857")
  ),
  roads = list(roads = terra::vect("LINESTRING (0 0, 2 2)", crs = "EPSG:3857"))
)
generalPath <- file.path(tempdir(), "disturbanceList")
index <- wrapTerraList(disturbanceList, generalPath)
str(index)
#> List of 2
#>  $ mining:List of 1
#>   ..$ mining: chr "mining_mining.rds"
#>  $ roads :List of 1
#>   ..$ roads: chr "roads_roads.rds"

layers <- unwrapTerraList("theList.rds", generalPath)
#> Recovering mining_mining.rds
#> Recovering roads_roads.rds
layers$roads$roads
#> class       : SpatVector
#> geometry    : lines
#> dimensions  : 1, 0  (geometries, attributes)
#> extent      : 0, 2, 0, 2  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / Pseudo-Mercator (EPSG:3857)
```
