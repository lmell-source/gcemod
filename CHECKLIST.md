# Local build & check checklist

This package was written and reviewed statically (no R was available in the
authoring environment). Run the following on a machine with R to build,
document, and check it. Steps 1-2 are one-time setup.

## 0. Prerequisites

```r
install.packages(c("survival", "cmprsk", "ggplot2", "patchwork",
                   "devtools", "roxygen2", "testthat", "knitr", "rmarkdown"))
```

## 1. Create the demo dataset (required)

`data/` ships empty. From the package root:

```r
source("data-raw/make_sample.R")     # writes data/hn.rda and data/prostate.rda
```

This must be done before `check()` because the help examples and the `LazyData`
field expect the `hn` and `prostate` datasets to exist.

## 2. Regenerate docs and NAMESPACE from the roxygen headers (REQUIRED)

This release ships **no `man/` directory** --- the help files are generated from
the roxygen headers. You must run this before `check()`:

```r
devtools::document()     # or roxygen2::roxygenise()
```

This (re)creates `man/*.Rd` and `NAMESPACE`. If you are unzipping over an older
gcemod folder, `document()` overwrites the previous help files, so there is no
stale-doc mismatch.

## 3. Build, install, check

```r
devtools::check()        # R CMD check --as-cran equivalent
# or, from a shell:
#   R CMD build gcemod
#   R CMD check gcemod_0.1.0.tar.gz --as-cran
```

## 4. Run tests only (fast)

```r
devtools::test()
```

The tests are self-contained (they synthesize their own competing-risks data)
so they pass regardless of step 1.

## What to watch for

* **`cluster` argument to `coxph`.** `lunnmcneil()` passes `cluster = <id vector>`
  to `coxph()`, which requires survival >= ~2.44 (2019+). For the Cox scale you
  can fall back to `cluster.se = FALSE`; the Fine-Gray scale needs it.
* **Fine-Gray Lunn-McNeil.** `type = "finegray"` uses `survival::finegray()` to
  build risk-set-weighted data, then one stratified weighted `coxph`. This is an
  extension of Lunn-McNeil to the subdistribution scale --- the piece most worth
  checking against your own expectations.
* **Example execution.** Help examples are wrapped in `\donttest{}` and use
  `hn`/`prostate`; they run during `check()` once step 1 is done.

## Key correctness check built into the tests

`tests/testthat/test-lunnmcneil.R` verifies the central identity: the
Lunn-McNeil event-type interaction equals the difference between two separate
cause-specific Cox fits (which it must, because the stratified partial
likelihood factorizes). If that test passes, the omega+ estimation is wired up
correctly.
