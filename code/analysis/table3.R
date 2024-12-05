###
# Table 3: Survival for IBC by Clinicopathological Characteristics
# MJ 2024-12-04
# This script creates table 3 of the manuscript, presenting the median, 1-, 5-,
# and 10- year survival for each covariate.
###

## Setup =======================================================================
library(survival)
library(gtsummary)
library(dplyr)

# Load data
seer <- readRDS("data/processed/seer.rds")
attach(seer)

## Create table with 1, 5, and 10 year survival ================================
# Note that we create a filler column of 0-year survival to be replaced with
# median survival later.
t3 <- gtsummary::as_tibble(
  seer |>
  gtsummary::tbl_survfit(
  y = "Surv(survival_months, survival_status)",
  include = c(subtype, age, race, marriage_status, n_stage, m_stage,
              grade, radiation, chemotherapy, surgery),
  label = list(
    subtype ~ "Subtype",
    age ~ "Age",
    race ~ "Race",
    marriage_status ~ "Marital Status",
    n_stage ~ "N Stage",
    m_stage ~ "M Stage",
    grade ~ "Grade",
    radiation ~ "Radiation",
    chemotherapy ~ "Chemotherapy",
    surgery ~ "Surgery"),
  statistic = "{estimate}",
  times = c(0, 12, 60, 120)
  ) |>
  add_p()
)

# Assign cleaner column names
colnames(t3) <- c("Characteristic","Median Survival (years)", "1 Year", "5 Year", "10 Year", "p-value")

# Create and assign more descriptive labels
t3$Characteristic = c(
  "Subtype", "Luminal A", "Luminal B", "Triple Negative", "HER2 Positive",
  "Age", "20-49 years", "50-69 years", ">=70 years",
  "Race", "White", "Black", "Other",
  "Marital Status", "Unmarried", "Married",
  "N Stage", "N0", "N1", "N2", "N3",
  "M Stage", "M0", "M1",
  "Grade", "I/II", "III/IV",
  "Radiation", "No/Unknown", "Yes",
  "Chemotherapy", "No/Unknown", "Yes",
  "Surgery", "No/Unknown", "Yes")

## Create a separate table with median survival ================================
t3_med <- gtsummary::as_tibble(
  seer |>
    gtsummary::tbl_survfit(
      y = "Surv(survival_months, survival_status)",
      include = c(subtype, age, race, marriage_status, n_stage, m_stage,
                  grade, radiation, chemotherapy, surgery),
      label = list(
        subtype ~ "Subtype",
        age ~ "Age",
        race ~ "Race",
        marriage_status ~ "Marital Status",
        n_stage ~ "N Stage",
        m_stage ~ "M Stage",
        grade ~ "Grade",
        radiation ~ "Radiation",
        chemotherapy ~ "Chemotherapy",
        surgery ~ "Surgery"),
      statistic = "{estimate}",
      probs = 0.5,
      label_header = "Median Survival (years)"
    )
)

# Assign cleaner column names
colnames(t3_med) <- c("Characteristic","med_survival")
# Ensure that median survival is numeric
t3_med$med_survival <- as.numeric(t3_med$med_survival)
# Tranform the median survival from month to years
t3_med$med_survival <- round(as.numeric(t3_med$med_survival / 12), 1)

## Replace the filler column in the first table with median survival ===========
t3$`Median Survival (years)` <- t3_med$med_survival

## Convert the data frame to a flextable =======================================
t3_flex <- flextable::flextable(t3)
t3_font <- flextable::fontsize(t3_flex, size = 9, part = "all")

## Save as RDS =================================================================
saveRDS(t3_font, file = here::here("results/tables", "t3.rds"))

## End of script ===============================================================