# Replace layers in a disturbance list

For each sector and class in `layers`, removes every layer of that class
from the sector in `disturbanceList`, then adds the new layer at the end
of the sector. A `NULL` layer only removes the class. A sector not yet
in `disturbanceList` is added.

## Usage

``` r
replaceLayers(disturbanceList, layers)
```

## Arguments

- disturbanceList:

  A list of lists of layers, named by sector and then by class.

- layers:

  The new layers: a list of lists, named by sector and then by class,
  like `disturbanceList`.

## Value

`disturbanceList`, with the layers replaced.

## Author

Tati Micheletti, Alex M. Chubaty

## Examples

``` r
square <- terra::vect("POLYGON ((0 0, 1 0, 1 1, 0 1, 0 0))", crs = "EPSG:3857")
disturbanceList <- list(mining = list(mining = square, potentialMining = NULL))
newLayers <- list(
  mining = list(potentialMining = square),
  forestry = list(potentialCutblocks = square)
)
str(replaceLayers(disturbanceList, newLayers), max.level = 2)
#> List of 2
#>  $ mining  :List of 2
#>   ..$ mining         :S4 class 'SpatVector' [package "terra"]
#>   ..$ potentialMining:S4 class 'SpatVector' [package "terra"]
#>  $ forestry:List of 1
#>   ..$ potentialCutblocks:S4 class 'SpatVector' [package "terra"]
```
