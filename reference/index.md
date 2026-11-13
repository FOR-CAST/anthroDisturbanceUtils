# Package index

## Reading and writing

Write a list of disturbance layers to disk, and read it back.

- [`wrapTerraList()`](https://for-cast.github.io/anthroDisturbanceUtils/reference/wrapTerraList.md)
  [`unwrapTerraList()`](https://for-cast.github.io/anthroDisturbanceUtils/reference/wrapTerraList.md)
  : Write a list of disturbance layers to disk, and read it back

## Disturbance lists

Work with a list of disturbance layers, grouped by sector and then by
class.

- [`cleanupList()`](https://for-cast.github.io/anthroDisturbanceUtils/reference/cleanupList.md)
  :

  Remove `NULL` and empty elements from a disturbance list

- [`extractNonPotentialLayers()`](https://for-cast.github.io/anthroDisturbanceUtils/reference/extractNonPotentialLayers.md)
  : List the layers of a disturbance list that are not potential layers

- [`flattenTerra()`](https://for-cast.github.io/anthroDisturbanceUtils/reference/flattenTerra.md)
  : Collect the terra layers from a nested list

- [`harmonizeList()`](https://for-cast.github.io/anthroDisturbanceUtils/reference/harmonizeList.md)
  : Combine the layers of a disturbance list that share a class name

- [`replaceLayers()`](https://for-cast.github.io/anthroDisturbanceUtils/reference/replaceLayers.md)
  : Replace layers in a disturbance list

## Maps

- [`disturbancePresenceRaster()`](https://for-cast.github.io/anthroDisturbanceUtils/reference/disturbancePresenceRaster.md)
  : Map where any disturbance is present
