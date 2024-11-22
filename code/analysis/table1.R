# Table 1: Clinicopathological Characteristics by Breast Cancer Subtype
# (unadjusted associations between covariates and exposure)

# Declare dependencies
box::use(
  readr,
  here,
  gt,
  gtExtras,
  gtsummary,
  modelsummary,
  dplyr,
  webshot2,
  tidyr,
  ggplot2,
  Hmisc
)

# load data
seer <- readRDS("data/processed/seer_tab.rds")
attach(seer)

t1 <-
  seer |>
  gtsummary::tbl_summary(
    by = subtype,
    include = c(agecat, race, marriage_status, n_stage, m_stage,
                gradecat, radiation, chemotherapy, surgery),
    label = list(
      agecat ~ "Age (years)",
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
    statistic_header = "**Statistic**"
  ) |>
  gtsummary::add_overall() |>
  gtsummary::add_p() |>
  gtsummary::modify_caption(
    "Table 1: Clinicopathological characteristics by cancer subtype"
  ) |>
  gtsummary::as_gt()

gt::gtsave(
  data = t1,
  filename = here::here("results/tables", "t1.png"),
  vwidth = 2400,
  vheight = 1350
)

t4b |>
  gt::rm_caption() |>
  gt::gtsave(
    filename = here::here("results", "paper-t1.png"),
    vwidth = 2400,
    vheight = 1350
  )
