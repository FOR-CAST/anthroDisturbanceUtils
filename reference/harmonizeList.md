# Combine the layers of a disturbance list that share a class name

Within each sector of `disturbances`, layers with the same class name
are combined into one layer with
[`rbind()`](https://rdrr.io/r/base/cbind.html), unless the class name
matches one of the patterns in `whatNotToCombine`.

## Usage

``` r
harmonizeList(disturbances, whatNotToCombine = NULL)
```

## Arguments

- disturbances:

  A list of lists of `SpatVector`s, named by sector and then by class. A
  class name may appear more than once in a sector.

- whatNotToCombine:

  Character vector of regular expressions. Classes whose name matches
  any of them are left as they are, repeats included. With `NULL` (the
  default), every repeated class is combined.

## Value

A list with the sectors of `disturbances`. A sector with no class to
combine is returned unchanged. In the others, the classes left as they
are come first (those matching `whatNotToCombine`, then the rest),
followed by the combined classes.

## Author

Tati Micheletti, Ronald Kilian, Alex M. Chubaty

## Examples

``` r
square <- function(x) {
  terra::vect(
    sprintf("POLYGON ((%1$d 0, %2$d 0, %2$d 1, %1$d 1, %1$d 0))", x, x + 1),
    crs = "EPSG:3857"
  )
}
disturbances <- list(
  mining = list(claims = square(0), claims = square(2), potentialMining = square(4))
)
out <- harmonizeList(disturbances, whatNotToCombine = "potential")
#> Harmonizing mining
#> Returning mining merged.
names(out$mining)
#> [1] "potentialMining" "claims"         
nrow(out$mining$claims)
#> [1] 2
```
