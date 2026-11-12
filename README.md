# anthroDisturbanceUtils

<!-- badges: start -->
[![R-CMD-check](https://github.com/FOR-CAST/anthroDisturbanceUtils/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/FOR-CAST/anthroDisturbanceUtils/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Helpers shared by the anthropogenic disturbance SpaDES modules.
Each module used to carry its own copy of these functions; they now live here, so a fix is made once.

Documentation: <https://for-cast.github.io/anthroDisturbanceUtils/>

## Modules

The modules come in two versions: Tati Micheletti's, for the Northwest Territories, and the FOR-CAST forks of those, for Yukon, maintained by Alex M. Chubaty.

| Module | Northwest Territories | Yukon |
|---|---|---|
| Data preparation | [tati-micheletti/anthroDisturbance_DataPrep](https://github.com/tati-micheletti/anthroDisturbance_DataPrep) | [FOR-CAST/anthroDisturbance_DataPrep](https://github.com/FOR-CAST/anthroDisturbance_DataPrep) |
| Disturbance generator | [tati-micheletti/anthroDisturbance_Generator](https://github.com/tati-micheletti/anthroDisturbance_Generator) | [FOR-CAST/anthroDisturbance_Generator](https://github.com/FOR-CAST/anthroDisturbance_Generator) |
| Potential resources | [tati-micheletti/potentialResourcesNT_DataPrep](https://github.com/tati-micheletti/potentialResourcesNT_DataPrep) | [FOR-CAST/potentialResourcesYT_DataPrep](https://github.com/FOR-CAST/potentialResourcesYT_DataPrep) |

## Installation

``` r
# install.packages("pak")
pak::pak("FOR-CAST/anthroDisturbanceUtils")
```

## Usage

`wrapTerraList()` writes a disturbance list (vector layers grouped by sector and class) to disk, and `unwrapTerraList()` reads it back:

``` r
library(anthroDisturbanceUtils)

disturbanceList <- list(
  mining = list(mining = terra::vect("POLYGON ((0 0, 1 0, 1 1, 0 1, 0 0))", crs = "EPSG:3857")),
  roads = list(roads = terra::vect("LINESTRING (0 0, 2 2)", crs = "EPSG:3857"))
)
generalPath <- file.path(tempdir(), "disturbanceList")

wrapTerraList(disturbanceList, generalPath, zipFiles = TRUE)
layers <- unwrapTerraList("theList.rds", generalPath)
```

Given the URL of a `disturbanceList.zip` instead, `unwrapTerraList()` downloads the archive with `reproducible::prepInputs()` and extracts it into `generalPath` first.

## The archive

A disturbance list on disk is a flat directory, or a flat `disturbanceList.zip`, holding:

- `theList.rds`: the index, a list of lists of file names, by sector and then by class;
- one `.rds` file per layer: the `SpatVector` wrapped with `terra::wrap()`.

`unwrapTerraList()` reads each layer from `generalPath` using only the file name in the index, so indexes that hold full paths, as written by the modules' earlier `wrapTerraList()`, still work.

## Authors

The functions were written by Tati Micheletti for the anthropogenic disturbance modules, and moved here by Alex M. Chubaty (FOR-CAST), who maintains the package.
