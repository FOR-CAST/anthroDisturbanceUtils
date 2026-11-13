# Remove `NULL` and empty elements from a disturbance list

Cleans a list of lists, such as a disturbance list (layers grouped by
sector and then by class), in four optional steps, applied in this
order: `inner`, `outer`, `nullEmpty`, `cleanEmpty`.

## Usage

``` r
cleanupList(
  aList,
  outer = FALSE,
  inner = TRUE,
  cleanEmpty = FALSE,
  nullEmpty = TRUE
)
```

## Arguments

- aList:

  A list, usually of lists.

- outer:

  Logical. Remove the `NULL` elements of `aList`?

- inner:

  Logical. Remove the `NULL` elements of each list in `aList`?

- cleanEmpty:

  Logical. Remove the elements of `aList` that are `NULL` or empty
  lists?

- nullEmpty:

  Logical. Replace the elements of `aList` that are empty lists with
  `NULL`?

## Value

`aList`, cleaned.

## Author

Tati Micheletti, Ronald Kilian

## Examples

``` r
aList <- list(roads = list(1, NULL, 2), mining = list(), wind = NULL)
str(cleanupList(aList))
#> List of 3
#>  $ roads :List of 2
#>   ..$ : num 1
#>   ..$ : num 2
#>  $ mining: NULL
#>  $ wind  : NULL
str(cleanupList(aList, outer = TRUE, cleanEmpty = TRUE, nullEmpty = FALSE))
#> List of 1
#>  $ roads:List of 2
#>   ..$ : num 1
#>   ..$ : num 2
```
