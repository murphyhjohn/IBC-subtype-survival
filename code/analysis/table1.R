###
# Table 1: Clinicopathological Characteristics by Breast Cancer Subtype
# MJ 2024-12-05
# This script creates Table 1 of the manuscript. That is, the unadjusted 
# associations between covariates and exposure (subtype)
###

## Setup =======================================================================
library(here)
library(readr)
library(gt)
library(gtsummary)
library(gtExtras)
library(flextable)
library(stringr)

# load data
seer <- readRDS("data/processed/seer_tab.rds")
attach(seer)

## Create table 1 ==============================================================
t1 <- gtsummary::as_tibble(
  seer |>
  gtsummary::tbl_summary(
    by = subtype,
    include = c(agecat, race, marriage_status, n_stage, m_stage,
                gradecat, radiation, chemotherapy, surgery),
    label = list(
      agecat ~ "Age",
      race ~ "Race",
      marriage_status ~ "Marital Status",
      n_stage ~ "N Stage",
      m_stage ~ "M Stage",
      gradecat ~ "Grade",
      radiation ~ "Radiation",
      chemotherapy ~ "Chemotherapy",
      surgery ~ "Surgery"
    ),
    type = list(
      marriage_status ~ "categorical",
      n_stage ~ "categorical",
      m_stage ~ "categorical",
      gradecat ~ "categorical",
      radiation ~ "categorical",
      chemotherapy ~ "categorical",
      surgery ~ "categorical"
    ),
    digits = c(agecat, race, marriage_status, n_stage, m_stage,
               gradecat, radiation, chemotherapy, surgery) ~ c(0, 1),
  ) |>
  gtsummary::add_overall() |>
  gtsummary::add_p()
)

# Remove Markdown bold (`**`) from the tibble text
colnames(t1) <- stringr::str_remove_all(colnames(t1), "\\*\\*")

# Convert the tibble to a flextable
t1_flex <- flextable::flextable(t1)
t1_flex <- flextable::fontsize(t1_flex, size = 8.5, part = "all")

## Save as RDS ================================================================
saveRDS(t1_flex, file = here::here("results/tables", "t1.rds"))

# End of script ================================================================