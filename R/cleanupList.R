#' Remove `NULL` and empty elements from a disturbance list
#'
#' Cleans a list of lists, such as a disturbance list (layers grouped by sector
#' and then by class), in four optional steps, applied in this order:
#' `inner`, `outer`, `nullEmpty`, `cleanEmpty`.
#'
#' @param aList A list, usually of lists.
#' @param outer Logical. Remove the `NULL` elements of `aList`?
#' @param inner Logical. Remove the `NULL` elements of each list in `aList`?
#' @param cleanEmpty Logical. Remove the elements of `aList` that are `NULL` or
#'   empty lists?
#' @param nullEmpty Logical. Replace the elements of `aList` that are empty lists
#'   with `NULL`?
#'
#' @return `aList`, cleaned.
#'
#' @author Tati Micheletti, Ronald Kilian
#' @export
#' @examples
#' aList <- list(roads = list(1, NULL, 2), mining = list(), wind = NULL)
#' str(cleanupList(aList))
#' str(cleanupList(aList, outer = TRUE, cleanEmpty = TRUE, nullEmpty = FALSE))
cleanupList <- function(
  aList,
  outer = FALSE,
  inner = TRUE,
  cleanEmpty = FALSE,
  nullEmpty = TRUE
) {
  isEmptyList <- function(x) is.list(x) && length(x) == 0
  if (inner) {
    aList <- lapply(aList, function(innerList) {
      if (is.list(innerList)) Filter(Negate(is.null), innerList) else innerList
    })
  }
  if (outer) {
    aList <- Filter(Negate(is.null), aList)
  }
  if (nullEmpty) {
    aList <- lapply(aList, function(x) if (isEmptyList(x)) NULL else x)
  }
  if (cleanEmpty) {
    aList <- Filter(function(x) !(isEmptyList(x) || is.null(x)), aList)
  }
  aList
}
