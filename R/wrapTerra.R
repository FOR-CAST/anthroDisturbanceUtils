#' Write a list of disturbance layers to disk, and read it back
#'
#' `wrapTerraList()` saves a list of vector layers grouped by sector and class,
#' such as the `disturbanceList` of the anthropogenic disturbance modules: one
#' `.rds` file per layer (a wrapped `SpatVector`), plus an index,
#' `theList.rds`, holding each layer's file name by sector and class. With
#' `zipFiles = TRUE` it also packs them into `disturbanceList.zip`, the archive
#' `unwrapTerraList()` downloads.
#'
#' `unwrapTerraList()` reads such a list back. It looks for the layers in
#' `generalPath`, whatever directory the index names, so an index written on
#' another machine, or one holding full paths, still works.
#'
#' @param terraList For `wrapTerraList()`, a list of lists of `SpatVector`s,
#'   named by sector and then by class.
#'
#'   For `unwrapTerraList()`, either the index (a list of lists of file names,
#'   as `wrapTerraList()` returns), or a character string. If `theList.rds` is
#'   in `generalPath`, the string is ignored and the index is read from there;
#'   otherwise the string is the URL of `disturbanceList.zip`, which is
#'   downloaded (unless it is already in `generalPath`) and extracted into
#'   `generalPath` by [reproducible::prepInputs()].
#' @param generalPath Directory that holds, or will hold, `theList.rds` and the
#'   layer files.
#' @param zipFiles Logical. Also write `disturbanceList.zip` to `generalPath`?
#'   Needs a `zip` program (see [utils::zip()]).
#'
#' @return `wrapTerraList()` returns the index invisibly: a list of lists of
#'   file names, named by sector and class. `unwrapTerraList()` returns a list
#'   of lists of `SpatVector`s with the same names.
#'
#' @author Tati Micheletti, Alex M. Chubaty
#' @export
#' @examples
#' disturbanceList <- list(
#'   mining = list(
#'     mining = terra::vect("POLYGON ((0 0, 1 0, 1 1, 0 1, 0 0))", crs = "EPSG:3857")
#'   ),
#'   roads = list(roads = terra::vect("LINESTRING (0 0, 2 2)", crs = "EPSG:3857"))
#' )
#' generalPath <- file.path(tempdir(), "disturbanceList")
#' index <- wrapTerraList(disturbanceList, generalPath)
#' str(index)
#'
#' layers <- unwrapTerraList("theList.rds", generalPath)
#' layers$roads$roads
wrapTerraList <- function(terraList, generalPath, zipFiles = FALSE) {
  checkTerraList(terraList)
  dir.create(generalPath, recursive = TRUE, showWarnings = FALSE)
  index <- Map(
    function(layers, files) {
      Map(
        function(layer, file) {
          saveRDS(terra::wrap(layer), file.path(generalPath, file))
          file
        },
        layers,
        files
      )
    },
    terraList,
    layerFileNames(terraList)
  )
  saveRDS(index, file.path(generalPath, "theList.rds"))

  if (isTRUE(zipFiles)) {
    zipFile <- file.path(generalPath, "disturbanceList.zip")
    unlink(zipFile)
    files <- file.path(generalPath, c("theList.rds", unlist(index, use.names = FALSE)))
    ## -j stores the files without their directories: unwrapTerraList() expects a flat archive
    status <- utils::zip(zipFile, files, flags = "-q -j")
    if (!identical(as.integer(status), 0L)) {
      stop("Could not write ", zipFile, " (zip exit status ", status, ").", call. = FALSE)
    }
  }

  invisible(index)
}

#' @rdname wrapTerraList
#' @export
unwrapTerraList <- function(terraList, generalPath) {
  indexFile <- file.path(generalPath, "theList.rds")
  if (!is.list(terraList)) {
    if (file.exists(indexFile)) {
      terraList <- readRDS(indexFile)
    } else {
      message(
        "The terraList file provided seems to be a link to the archive. ",
        "The contents will be downloaded and extracted before recovering."
      )
      terraList <- reproducible::prepInputs(
        url = terraList,
        archive = "disturbanceList.zip",
        targetFile = "theList.rds",
        destinationPath = generalPath, ## the layers are read from generalPath below
        fun = "base::readRDS"
      )
    }
  }

  lapply(terraList, function(files) {
    lapply(files, function(file) {
      ## the index may hold the directory it was written in (e.g., on another machine)
      file <- file.path(generalPath, basename(file))
      message("Recovering ", basename(file))
      layer <- readRDS(file)
      if (inherits(layer, "PackedSpatVector")) {
        layer <- terra::unwrap(layer)
      }
      layer
    })
  })
}

## Stop unless `terraList` is a list of lists of SpatVectors, named by sector and class.
checkTerraList <- function(terraList) {
  if (!isNamedList(terraList)) {
    stop("`terraList` must be a list of lists of layers, with unique sector names.", call. = FALSE)
  }
  for (sector in names(terraList)) {
    layers <- terraList[[sector]]
    if (!isNamedList(layers)) {
      msg <- sprintf("`terraList$%s` must be a list of layers, with unique class names.", sector)
      stop(msg, call. = FALSE)
    }
    for (class in names(layers)) {
      if (!inherits(layers[[class]], "SpatVector")) {
        msg <- sprintf(
          "`terraList$%s$%s` is a %s, not a SpatVector.",
          sector,
          class,
          class(layers[[class]])[1]
        )
        stop(msg, call. = FALSE)
      }
    }
  }
  invisible(terraList)
}

## A list (not a data.frame) whose elements all have distinct, non-empty names; or an empty list.
isNamedList <- function(x) {
  if (!is.list(x) || inherits(x, "data.frame")) {
    return(FALSE)
  }
  nms <- names(x)
  length(x) == 0L || (!is.null(nms) && !anyNA(nms) && all(nzchar(nms)) && !anyDuplicated(nms))
}

## One file name per layer, "<sector>_<class>.rds", made safe and unique, in terraList's structure.
layerFileNames <- function(terraList) {
  sectors <- rep(names(terraList), lengths(terraList))
  stems <- paste(sectors, unlist(lapply(terraList, names), use.names = FALSE), sep = "_")
  stems <- make.unique(gsub("[^A-Za-z0-9._-]", "_", stems), sep = "_")
  split(paste0(stems, ".rds"), factor(sectors, levels = names(terraList)))
}
