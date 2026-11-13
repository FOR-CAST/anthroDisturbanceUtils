# Collect the terra layers from a nested list

Collect the terra layers from a nested list

## Usage

``` r
flattenTerra(x)
```

## Arguments

- x:

  A `SpatRaster`, a `SpatVector`, or a list of them, nested to any depth
  (such as a disturbance list).

## Value

A flat, unnamed list of the `SpatRaster`s and `SpatVector`s in `x`, in
the order they appear. Other elements are dropped.

## Author

Alex M. Chubaty

## Examples

``` r
square <- terra::vect("POLYGON ((0 0, 1 0, 1 1, 0 1, 0 0))", crs = "EPSG:3857")
nested <- list(mining = list(mining = square, notes = "dropped"), roads = list())
flattenTerra(nested)
#> [[1]]
#> class       : SpatVector
#> geometry    : polygons
#> dimensions  : 1, 0  (geometries, attributes)
#> extent      : 0, 1, 0, 1  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / Pseudo-Mercator (EPSG:3857)
#> 
```
