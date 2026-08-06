# Build the bundled GCE example datasets from the source CSVs.
#
# Run once from the package root:
#   source("data-raw/make_sample.R")     # writes data/hn.rda and data/prostate.rda
#
# Both datasets code the competing-risks outcome as
#   status: 0 = censored, 1 = event of interest, 2 = competing event.
# In `hn` the event of interest is cancer recurrence (recurrence-dominant);
# in `prostate` it is prostate-cancer death (competing-death-dominant).
# These are example datasets for illustrating the package; they do not
# represent real patients. Subject IDs are sequential integers.

## ---- head and neck cohort ----
hn_raw <- read.csv("data-raw/hn.clean.csv", stringsAsFactors = FALSE)
hn <- data.frame(
  id        = as.integer(hn_raw$id),
  time      = as.numeric(hn_raw$time),               # follow-up time (years)
  status    = as.integer(hn_raw$status),             # 0 cens, 1 recurrence, 2 death w/o recurrence
  age       = as.numeric(hn_raw$age),
  ps        = factor(hn_raw$ps, levels = 0:2),       # ECOG performance status
  female    = as.integer(hn_raw$female),
  smoker    = as.integer(hn_raw$smoker),             # >10 pack-years = 1
  t_cat     = factor(hn_raw$t_cat, levels = 1:4),    # T category
  n_cat     = factor(hn_raw$n_cat, levels = 0:3),    # N category (0,1,2,3)
  p16       = as.integer(hn_raw$p16),                # 1 = p16 positive
  site      = factor(hn_raw$site,
                     levels = c("oropharynx", "larynx", "hypopharynx", "oralcavity"))
)

## ---- prostate cohort ----
pr_raw <- read.csv("data-raw/prostate.clean.csv", stringsAsFactors = FALSE)
prostate <- data.frame(
  id          = as.integer(pr_raw$id),
  time        = as.numeric(pr_raw$time),             # follow-up time (years)
  status      = as.integer(pr_raw$status),           # 0 cens, 1 prostate-cancer death, 2 competing death
  age         = as.numeric(pr_raw$age),
  ps          = factor(pr_raw$ps, levels = 0:1),     # performance status
  psa         = as.numeric(pr_raw$psa),              # pre-treatment PSA (ng/mL, capped at 20)
  gleason     = factor(pr_raw$gleason,
                       levels = c("<=6", "3+4", "4+3", ">=8")),
  t2b         = as.integer(pr_raw$t2b),              # 1 = stage T2b or higher
  comorbidity = as.integer(pr_raw$comorbidity)       # 1 = significant comorbidity
)

for (d in list(hn = hn, prostate = prostate)) {
  stopifnot(!anyDuplicated(d$id), all(d$status %in% 0:2), !anyNA(d))
}

dir.create("data", showWarnings = FALSE)
save(hn,       file = "data/hn.rda",       compress = "xz")
save(prostate, file = "data/prostate.rda", compress = "xz")
message("Wrote data/hn.rda (", nrow(hn), " rows; ", sum(hn$status == 1),
        " recurrences, ", sum(hn$status == 2), " competing) and ",
        "data/prostate.rda (", nrow(prostate), " rows; ", sum(prostate$status == 1),
        " cancer deaths, ", sum(prostate$status == 2), " competing).")
