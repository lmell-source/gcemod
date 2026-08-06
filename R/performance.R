#' Discrimination (C-index) for a GCE model
#'
#' @description
#' Reports the cause-specific concordance (C-index) of the GCE risk score for
#' the event of interest. For calibration (predicted vs. observed
#' \eqn{\omega^{+}}), see \code{\link{gce_calibration}}.
#'
#' @param object a \code{"gcemod"} object.
#' @param conf.level confidence level for the C-index interval (default
#'   \code{0.95}).
#'
#' @details
#' The C-index is computed with \code{\link[survival]{concordance}} using the
#' event of interest as the outcome and the GCE risk score as the predictor.
#' Higher risk scores denote higher risk; the statistic is oriented so that
#' values above 0.5 indicate discrimination in the expected direction.
#'
#' @return Invisibly, a named numeric vector \code{cindex} (estimate, se, lower,
#'   upper). The value is also printed.
#'
#' @examples
#' \donttest{
#' data(hn)
#' Ind <- data.frame(event = as.integer(hn$status == 1),
#'                   competing = as.integer(hn$status == 2))
#' fit <- gcecox(hn$time, Ind, hn[, c("age", "t_cat", "p16")], M = 5, t = 5)
#' gce_performance(fit)
#' }
#' @seealso \code{\link{gce_calibration}}
#' @export
gce_performance <- function(object, conf.level = 0.95) {
  if (!inherits(object, "gcemod")) stop("'object' must be a gcemod object.", call. = FALSE)

  time <- object$time
  ev   <- as.integer(object$cause == 1)
  rs   <- object$riskscore

  cc <- survival::concordance(Surv(time, ev) ~ rs)
  Cval <- unname(cc$concordance)
  v    <- unname(cc$var)
  flipped <- FALSE
  if (is.finite(Cval) && Cval < 0.5) { Cval <- 1 - Cval; flipped <- TRUE }
  zc <- stats::qnorm(1 - (1 - conf.level) / 2)
  cindex <- c(estimate = Cval, se = sqrt(v),
              lower = Cval - zc * sqrt(v), upper = Cval + zc * sqrt(v))

  cat(sprintf("C-index (event of interest): %.3f (95%% CI %.3f-%.3f)%s\n",
              cindex["estimate"], cindex["lower"], cindex["upper"],
              if (flipped) "  [risk-score orientation flipped]" else ""))
  invisible(cindex)
}
