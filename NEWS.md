# anthroDisturbanceUtils 0.0.1

## New features

* Initial version. The archive writer and reader of the anthropogenic disturbance modules move here, so the modules share one copy (tati-micheletti/anthroDisturbance_DataPrep#8).
* `unwrapTerraList()` reads a disturbance list back from `theList.rds` or from `disturbanceList.zip`. It looks for the layers in `generalPath`, whatever directory the index names, and it works with terra attached (the fixes of tati-micheletti/anthroDisturbance_DataPrep#7, tati-micheletti/anthroDisturbance_Generator#5 and tati-micheletti/potentialResourcesNT_DataPrep#5).
* `wrapTerraList()` writes a disturbance list as one `.rds` file per layer plus the index `theList.rds`, and optionally `disturbanceList.zip`. Layer files are named after their sector and class, not at random, and the index holds file names, not full paths.
