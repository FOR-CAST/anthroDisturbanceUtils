# wrapTerraList() stops on a list it cannot write

    Code
      wrapTerraList(list(line), gp)
    Condition
      Error:
      ! `terraList` must be a list of lists of layers, with unique sector names.

---

    Code
      wrapTerraList(list(roads = line), gp)
    Condition
      Error:
      ! `terraList$roads` must be a list of layers, with unique class names.

---

    Code
      wrapTerraList(list(roads = list(roads = data.frame(x = 1))), gp)
    Condition
      Error:
      ! `terraList$roads$roads` is a data.frame, not a SpatVector.

---

    Code
      wrapTerraList(list(roads = list(roads = line, roads = line)), gp)
    Condition
      Error:
      ! `terraList$roads` must be a list of layers, with unique class names.

