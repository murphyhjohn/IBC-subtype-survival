# Table 3: Survival for IBC by Clinicopathological Characteristics

library(survival)
library(gtsummary)
library(dplyr)

# load data
seer <- readRDS("data/processed/seer.rds")
attach(seer)

# 1, 5, and 10 year survival
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

colnames(t3) <- c("Characteristic","Median Survival (years)", "1 Year", "5 Year", "10 Year", "p-value")

# create and assign more descriptive labels
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

# since we can't do both median survival and specific times,
# create a seperate table with median survival
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

colnames(t3_med) <- c("Characteristic","med_survival")
t3_med$med_survival <- as.numeric(t3_med$med_survival)

# we want survival to be in years instead on months
t3_med$med_survival <- round(as.numeric(t3_med$med_survival / 12), 1)

# overwrite the first stats column in table 2 with median survival information
t3$`Median Survival (years)` <- t3_med$med_survival

# Convert the data frame to a flextable
t3_flex <- flextable::flextable(t3)
t3_flex <- flextable::fontsize(t3_flex, size = 7.5, part = "all")
# Save the flextable object as RDS
saveRDS(t3_flex, file = here::here("results/tables", "t3.rds"))
