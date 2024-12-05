###
# Table 4: Cox Proportional Hazards Model Regression Results
# MJ 2024-12-04
# This script creates table 4 of the manuscript, presenting the crude and 
# adjusted cox proportional hazards models.
###

## Setup =======================================================================
library(survival)
library(dplyr)

# Load data
seer <- readRDS("data/processed/seer.rds")
attach(seer)


## Create the univariate coxph model and table =================================
t4_uv <- gtsummary::tbl_uvregression(
  data = seer,
  method = coxph,
  y = Surv(survival_months, survival_status),
  exponentiate = TRUE,
  include = c(subtype, age, race, marriage_status, n_stage, m_stage, grade, 
              radiation, chemotherapy, surgery),
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
    surgery ~ "Surgery"
  ),
  hide_n = TRUE,
  )

# Create and assign more descriptive labels
t4_uv$table_body$label[1:36] = c(
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

## Create the multivariate coxph model and table ===============================
t4_mv <- coxph(
    Surv(survival_months, survival_status) ~ 
      subtype + 
      age + 
      race + 
      marriage_status + 
      n_stage + 
      m_stage + 
      grade + 
      radiation + 
      chemotherapy + 
      surgery,
    data = seer, 
    method = "breslow") |>
    gtsummary::tbl_regression(
      exp = TRUE,
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
        surgery ~ "Surgery"
      )
    )

# Create and assign more descriptive labels
t4_mv$table_body$label = c(
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

## Stick the univariate and multivariate tables together to make table 4 =======
t4_merge <- gtsummary::as_tibble(
  gtsummary::tbl_merge(
    list(t4_uv, t4_mv),
    tab_spanner = c("Crude", "Adjusted")
  )
)

# Temporarily rename columns for flextable compatibility
temp_colnames <- make.unique(colnames(t4_merge))
colnames(t4_merge) <- temp_colnames

# Replace cells with a dash only if they come after an NA in the same column
t4_dash <- t4_merge %>%
  mutate(across(
    -1, # Exclude the "Characteristic" column
    ~ ifelse(is.na(.) & lag(is.na(.), default = FALSE), "-", .)
  ))

# Create the flextable
t4_flex <- flextable::flextable(t4_dash)

# Restore the original column names
og_names <- c("Characteristic", "HR", "95% CI", "p-value", 
              "aHR", "95% CI", "p-value")
t4_og <- flextable::set_header_labels(t4_flex, 
                                   values = setNames(og_names, temp_colnames))
t4 <- flextable::fontsize(t4_og, size = 9, part = "all")

## Save as rds =================================================================
saveRDS(t4, file = here::here("results/tables", "t4.rds"))

## End of script ===============================================================