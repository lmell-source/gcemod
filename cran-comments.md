## Submission

This is the first CRAN submission of gcemod (0.3.0).

gcemod fits generalized competing event (GCE) models and estimates covariate
effects on omega-plus (the ratio of the hazard for an event of interest to the
hazard for a competing event) on the cause-specific (Cox) and subdistribution
(Fine-Gray) scales, with inference from the Lunn-McNeil (1995) stacked-data
approach.

It is a rewritten and re-scoped successor to the maintainer's existing CRAN
package 'gcerisk': it models omega-plus only, adds a Lunn-McNeil-style estimator
on the subdistribution scale, and adds risk-score cutpoints, cumulative-incidence
("alligator") plots, calibration plots, and a covariate-effects comparison table
(`gce_tidy(effects = TRUE)`). It is intended as a separate package, not a
replacement for 'gcerisk'.

A previous auto-pretest of this version flagged a stray `.github` directory
(an R-hub CI workflow) that was inadvertently included; it is now excluded via
`.Rbuildignore`.

## Test environments

* local: <your OS>, R <your version>
* win-builder: R-devel and R-release (devtools::check_win_devel(), check_win_release())
* macOS builder: R-release (devtools::check_mac_release())

## R CMD check results

0 errors | 0 warnings | 1 note

The note is the expected "New submission" note, together with "possibly
misspelled words in DESCRIPTION". Those words are surnames (Carmona, Lunn,
McNeil, Mell), the acronym GCE, "et" and "al" from "et al.", and the
competing-risks technical term "subdistribution"; all are intentional and
spelled correctly.

## Reverse dependencies

There are no reverse dependencies.
