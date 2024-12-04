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

#colnames(t4_uv) <- c("Characteristic","HR", "95% CI", "p-value")

# create and assign more descriptive labels
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

#colnames(t4_mv) <- c("Characteristic","HR", "95% CI", "p-value")

# create and assign more descriptive labels
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

# Stick them together to make table 3
t4 <- gtsummary::as_tibble(
  gtsummary::tbl_merge(
    list(t4_uv, t4_mv),
    tab_spanner = c("Crude", "Adjusted")
  )
)

# Temporarily rename columns for flextable compatibility
temp_colnames <- make.unique(colnames(t4))  # Create unique names
colnames(t4) <- temp_colnames  # Apply temporary names

# Create the flextable
ft <- flextable::flextable(t4)

# Restore the original column names in the display header
ft <- flextable::set_header_labels(ft, 
                                   values = setNames(colnames(t4), temp_colnames))

# Manually force the duplicate names for display
original_names <- c("Characteristic", "HR", "95% CI", "p-value", 
                    "HR", "95% CI", "p-value")
ft <- flextable::set_header_labels(ft, values = setNames(original_names, temp_colnames))

# Display the flextable
ft

# i think this works








colnames(t4) <- c("Characteristic","HR", "95% CI", "p-value", 
                  "aHR", "95% CI", "p.value")

t4 <- dplyr::distinct(t4)

# Convert the data frame to a flextable
t4_flex <- flextable::flextable(t4)
t4_flex$header$dataset$`a95% CI` <- "95% CI"
t4_flex$header$col_keys <- c("Characteristic","HR", "95% CI", "p-value", 
                  "aHR", "95% CI", "p-value")
t4_flex$footer$col_keys <- c("Characteristic","HR", "95% CI", "p-value", 
                             "aHR", "95% CI", "p-value")
t4_flex <- flextable::fontsize(t4_flex, size = 7.5, part = "all")
# Save the flextable object as RDS
saveRDS(t4_flex, file = here::here("results/tables", "t4.rds"))
