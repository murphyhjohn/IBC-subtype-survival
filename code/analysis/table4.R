# Table 4: Cox Proportional Hazards Model Regression Results

# load data
seer <- readRDS("data/processed/seer.rds")
attach(seer)

# first univariate table
t4_uv <- gtsummary::tbl_uvregression(
  data = seer,
  method = coxph,
  y = Surv(survival_months, survival_status),
  exponentiate = TRUE,
  include = c(subtype, age, race, marriage_status, n_stage, m_stage, grade, radiation, chemotherapy, surgery),
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

t4_uv$table_body$label[1:36] <- labels

# next multivariable table
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
  
# assign more descriptive labels
t4_mv$table_body$label[1:36] <- labels

# Stick them together to make table 3
t4 <-
  gtsummary::tbl_merge(
    list(t4_uv, t4_mv),
    tab_spanner = c("Crude", "Adjusted")
  )

gt::gtsave(
  data = t4 |> gtsummary::as_gt(),
  filename = here::here("results/tables", "t4.png"),
  vwidth = 2400,
  vheight = 1350
)
