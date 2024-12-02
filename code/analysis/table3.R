# Table 3: Survival for IBC by Clinicopathological Characteristics

library(survival)
library(gtsummary)
library(dplyr)

# load data
seer <- readRDS("data/processed/seer.rds")
attach(seer)

# 1, 5, and 10 year survival
t3 <- tbl_survfit(
  seer,
  y = "Surv(survival_months, survival_status)",
  include = c(subtype, age, race, marriage_status, n_stage, m_stage,
              grade, radiation, chemotherapy, surgery),
  label = list(
    subtype ~ "Subtype",
    age ~ "Age at diagnosis",
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

# create and assign more descriptive labels
labels = c(
  "Subtype", "Luminal A", "Luminal B", "Triple Negative", "HER2 Positive",
  "Age at diagnosis", "20-49 years", "50-69 years", ">=70 years",
  "Race", "White", "Black", "Other",
  "Marital Status", "Unmarried", "Married",
  "N Stage", "N0", "N1", "N2", "N3",
  "M Stage", "M0", "M1",
  "Grade", "I/II", "III/IV",
  "Radiation", "No/Unknown", "Yes",
  "Chemotherapy", "No/Unknown", "Yes",
  "Surgery", "No/Unknown", "Yes")

t3$table_body$label[1:36] <- labels
t3$table_styling$header$label[6:9] <- c("**Median Survival (years)**", "**1 Year**", "**5 Year**", "**10 Year**")

# since we can't do both median survival and specific times,
# create a seperate table with median survival
t3_med <- tbl_survfit(
  seer,
  y = "Surv(survival_months, survival_status)",
  include = c(subtype, age, race, marriage_status, n_stage, m_stage,
              grade, radiation, chemotherapy, surgery),
  label = list(
    subtype ~ "Subtype",
    age ~ "Age at diagnosis",
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
  label_header = "**Median Survival (years)**"
)

# we want survival to be in years instead on months
t3_med$table_body$stat_1[1:36] <- round(as.numeric(t3_med$table_body$stat_1[1:36]) / 12, 1)

# overwrite the first stats column in table 2 with median survival information
t3$table_body$stat_1 <- t3_med$table_body$stat_1

# Convert the gtsummary table to a gt table
t3_gt <- as_gt(t3)

# save to png
gt::gtsave(
  data = t3_gt,
  filename = here::here("results/tables", "t3.png"),
  vwidth = 2400,
  vheight = 1350
)
