# List the layers of a disturbance list that are not potential layers

Potential layers, whose class name starts with `"potential"`, show where
a disturbance may happen; the other layers show where one has happened.

## Usage

``` r
extractNonPotentialLayers(disturbanceList)
```

## Arguments

- disturbanceList:

  A list of lists of layers, named by sector and then by class.

## Value

A `data.table` with columns `Sector` and `dataClass`, one row per sector
and class whose name does not start with `"potential"`. Unnamed sectors,
sectors that are not lists and `NA` class names are skipped, and
repeated rows are dropped.

## Author

Tati Micheletti, Ronald Kilian

## Examples

``` r
disturbanceList <- list(
  mining = list(mining = NULL, potentialMining = NULL),
  roads = list(roads = NULL)
)
extractNonPotentialLayers(disturbanceList)
#>    Sector dataClass
#>    <char>    <char>
#> 1: mining    mining
#> 2:  roads     roads
```
