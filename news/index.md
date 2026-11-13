# Changelog

## anthroDisturbanceUtils (development version)

### New features

- More helpers move here from the anthropogenic disturbance modules.
  Their tests, by Ronald Kilian, move with them.
- [`cleanupList()`](https://for-cast.github.io/anthroDisturbanceUtils/reference/cleanupList.md)
  removes `NULL` and empty elements from a disturbance list (from
  anthroDisturbance_Generator). Its argument `outter` is now `outer`.
- [`disturbancePresenceRaster()`](https://for-cast.github.io/anthroDisturbanceUtils/reference/disturbancePresenceRaster.md)
  maps where any layer of a disturbance list is present, and
  [`flattenTerra()`](https://for-cast.github.io/anthroDisturbanceUtils/reference/flattenTerra.md)
  collects the terra layers of a nested list (from the FOR-CAST fork of
  anthroDisturbance_Generator).
- [`extractNonPotentialLayers()`](https://for-cast.github.io/anthroDisturbanceUtils/reference/extractNonPotentialLayers.md)
  lists the sectors and classes of a disturbance list that are not
  potential layers (from anthroDisturbance_Generator). When there are
  none, it returns an empty table that still has its two columns.
- [`harmonizeList()`](https://for-cast.github.io/anthroDisturbanceUtils/reference/harmonizeList.md)
  combines the layers of a sector that share a class name (from
  anthroDisturbance_DataPrep). Unlike the module’s copy, it does not
  return a sector’s other layers twice when only excluded classes
  repeat, and with `whatNotToCombine = NULL` it combines every repeated
  class instead of none.
- [`replaceLayers()`](https://for-cast.github.io/anthroDisturbanceUtils/reference/replaceLayers.md)
  replaces layers in a disturbance list, by sector and class. It
  generalizes `replaceList()` of potentialResourcesNT_DataPrep and
  potentialResourcesYT_DataPrep, which replaced four fixed layers.

## anthroDisturbanceUtils 0.0.1

### New features

- Initial version. The archive writer and reader of the anthropogenic
  disturbance modules move here, so the modules share one copy
  (tati-micheletti/anthroDisturbance_DataPrep#8).
- [`unwrapTerraList()`](https://for-cast.github.io/anthroDisturbanceUtils/reference/wrapTerraList.md)
  reads a disturbance list back from `theList.rds` or from
  `disturbanceList.zip`. It looks for the layers in `generalPath`,
  whatever directory the index names, and it works with terra attached
  (the fixes of tati-micheletti/anthroDisturbance_DataPrep#7,
  tati-micheletti/anthroDisturbance_Generator#5 and
  tati-micheletti/potentialResourcesNT_DataPrep#5).
- [`wrapTerraList()`](https://for-cast.github.io/anthroDisturbanceUtils/reference/wrapTerraList.md)
  writes a disturbance list as one `.rds` file per layer plus the index
  `theList.rds`, and optionally `disturbanceList.zip`. Layer files are
  named after their sector and class, not at random, and the index holds
  file names, not full paths.
