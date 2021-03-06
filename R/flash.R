#' Signal an error, warning, or message with light flash
#' @inheritParams hue_lights_state
#' @param type signal type. One of the following values:
#' "warn", "inform", or "abort".
#' @inheritParams rlang::abort
#' @importFrom rlang abort inform warn
#' @rdname flash
#' @export
flash <- function(id, type, message) {
  type <-
    rlang::arg_match(type,
                     c("abort", "inform", "warn"))
  col <-
    switch(type,
            "abort"  = "#FF0000",
            "inform" = "#08A0FF",
            "warn"   = "#ECE038")
  hue_lights_state(id = id,
                   on = TRUE,
                   xy = purrr::flatten_dbl(
                     colorinfo::col2xy(col)),
                   alert = "select",
                   quiet = TRUE)
  hue_lights_state(id = id, on = FALSE, quiet = TRUE)
  rlang::exec(type, message = message, class = "flash")
}
