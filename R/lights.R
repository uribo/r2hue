#' Set light state
#' @param id light id as numeric.
#' @param ... Pass to body arguments.
#' @param quiet logical; suppress info on light state.
#' @seealso [https://developers.meethue.com/develop/hue-api/lights-api/](https://developers.meethue.com/develop/hue-api/lights-api/)
#' @rdname hue_lights_state
#' @export
hue_lights_state <- function(id, ...,  quiet = FALSE) {
  body <-
    light_state_params(...)
  httr::PUT(glue::glue("http://{bridge_ip_address}/api/{username}/lights/{id}/state"),
            body = jsonlite::toJSON(body,
                                    auto_unbox = TRUE))
  if (quiet == FALSE) {
    if (body$on) {
      cli::cli_alert_success("Turn on a light.")
    } else {
      cli::cli_alert_danger("Turn off a light.")
    }
  }
}

light_state_params <- function(...) {
  # rlang::arg_match(alert,
  #                  c("none", "select", "lselect"))
  res <-
    list(...)
  res[which(names(res) %in% c("on",
                              "xy",
                              "hue", "sat", "bri",
                              "alert", "effect",
                              "ct",
                              "transitiontime",
                              "bri_inc",
                              "sat_inc",
                              "hue_inc",
                              "ct_inc",
                              "xy_inc"))]
}

#' Turn on/off on light a function later
#' @inheritParams later::later
#' @inheritParams hue_lights_state
#' @param on logical; Whether to turn on the lights or not.
#' @rdname light_switch
#' @export
light_switch <- function(func, id, on = TRUE, quiet = FALSE, ..., delay = 0) {
  later::later(
    ~ hue_lights_state(id = id,
                       on = on,
                       quiet = quiet,
                       ...),
    delay = delay
  )
  rlang::eval_tidy(rlang::exprs(func)[[1]])
}
