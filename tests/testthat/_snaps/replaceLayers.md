# replaceLayers() stops on layers it cannot place

    Code
      replaceLayers(disturbanceList, list(square(1)))
    Condition
      Error:
      ! `layers` must be a list of lists of layers, with unique sector and class names.

---

    Code
      replaceLayers(disturbanceList, list(mining = square(1)))
    Condition
      Error:
      ! `layers` must be a list of lists of layers, with unique sector and class names.

