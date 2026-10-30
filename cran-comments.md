## Update

This update (0.3.1) replaces the estimator behind gcecif(). The previous version regressed jackknife
pseudo-values of the nonlinear ratio. The new estimator is a stacked pseudo-observation
regression whose estimating function is linear in per-cause, mean-type
jackknife pseudo-observations (log link, event-type interactions, subject-
clustered sandwich variance), for which conditional unbiasedness is covered by
established pseudo-observation theory. The `method` and `ridge` arguments of
gcecif() are removed.

We are submitting this update promptly after 0.3.0 because the change
corrects the gcecif() estimator's statistical properties, which we preferred
to fix before the package accrues users.

Two further additions: gcefg() and lunnmcneil(type = "finegray") gain an
optional subject-bootstrap variance (se = "boot") that accounts for
estimation of the censoring weights, and a new diagnostic plot function,
gce_omegatime(), displays a chosen GCE contrast over follow-up as a visual
check of the proportional relative-hazards assumption. No other
user-visible interfaces change.

Morten Overgaard is credited as a package contributor.

## Test environments

* local: macOS (x86_64-apple-darwin20), R 4.4.0
* win-builder: R-release and R-devel

## R CMD check results

0 errors | 0 warnings | 1 note

The single NOTE on the local check ("checking for future file timestamps:
unable to verify current time") reflects the unavailability of the external
time-verification service and is unrelated to the package.

## Reverse dependencies

There are no reverse dependencies.
