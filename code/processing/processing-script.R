###
# Processing script
# MJ 2024-12-05
# This script cleans and processes the raw data pulled from the SEER database.
###

## Setup ======================================================================
library(dplyr)
library(stringr)
library(psych)
library(gmodels)
library(survival)
library(survminer)

# Load data
seer1 <- read.csv("data/raw/caselist_2024.11.csv", header = TRUE)

## Rename the columns for easier workflow ======================================
seer_name <- seer1 %>%
  dplyr::rename(
    age = Age.recode.with..1.year.olds,
    sex = Sex,
    year_diagnosis = Year.of.diagnosis,
    race = Race.ethnicity,
    marriage_status = Marital.status.at.diagnosis,
    tnm2015 = Derived.AJCC.T..7th.ed..2010.2015.,
    tnm2017 = Derived.SEER.Combined.T..2016.2017.,
    tnm2018 = Derived.EOD.2018.T..2018..,
    subtype = Breast.Subtype..2010..,
    grade2017 = Grade.Recode..thru.2017.,
    grade2018 = Derived.Summary.Grade.2018..2018..,
    n2015 = Derived.AJCC.N..7th.ed..2010.2015.,
    n2017 = Derived.SEER.Combined.N..2016.2017.,
    n2018 = Derived.EOD.2018.N..2018..,
    m2015 = Derived.AJCC.M..7th.ed..2010.2015.,
    m2017 = Derived.SEER.Combined.M..2016.2017.,
    m2018 = Derived.EOD.2018.M..2018..,
    radiation = Radiation.recode,
    chemotherapy = Chemotherapy.recode..yes..no.unk.,
    surgery = RX.Summ..Surg.Prim.Site..1998..,
    survival_months = Survival.months,
    survival_status = Vital.status.recode..study.cutoff.used.,
    survival_cause_cancer = SEER.cause.specific.death.classification,
    survival_cause_other = SEER.other.cause.of.death.classification,
    idc_type = Histologic.Type.ICD.O.3
  )

## Filter the data by exclusion criteria =======================================
# Restrict IDC code to 8500 - 8549
seer_idc <- seer_name %>%
  filter(
    idc_type %in% seq(8500, 8549) # 481 indiv exclude, 5986 remain
  )

# Restrict to adult females who survival longer than 1 month and whose cause of
# death, if dead, is attributable to IBC 
seer_filter <- seer_idc %>%
  filter(
    age != "00 years",
    age != "15-19 years", # 1 indiv exclude, 5985 remain
    sex == "Female", # 16 indiv exclude, 5969 remain
    survival_months >= 1, # 165 indiv exclude, 5804 remain
    
    # exclude those with unknown COD or competing risk
    survival_cause_cancer != "Dead (missing/unknown COD)",
    survival_cause_other != "Dead (attributable to causes other than this cancer dx)", # 487 indiv exclude, 5317 remain
  )

## Clean up existing variable categories and merge variables that were measured
# differently across years =====================================================
seer_clean <- seer_filter %>%
  mutate(
    # assign race as White, Black, or Other
    race = case_when(
      race == "White" ~ "White",
      race == "Black" ~ "Black",
      TRUE ~ "Other"
    ),
    # assign marriage_status as Yes or No
    marriage_status = case_when(
      marriage_status == "Married (including common law)" ~ "Yes",
      TRUE ~ "No"
    ),
    # assign blank tnm to NA
    tnm2015 = case_when(
      tnm2015 == "Blank(s)" ~ NA_character_,
      TRUE ~ tnm2015
    ),
    tnm2017 = case_when(
      tnm2017 == "Blank(s)" ~ NA_character_,
      TRUE ~ tnm2017
    ),
    tnm2018 = case_when(
      tnm2018 == "Blank(s)" ~ NA_character_,
      TRUE ~ tnm2018
    ),
    # merge tnm to ensure cross-validation
    tnm = coalesce(tnm2015, tnm2017, tnm2018),
    
    # assign breast cancer subtypes to their more commonly used names
    subtype = case_when(
      subtype == "HR-/HER2-" ~ "Triple Negative",
      subtype == "HR-/HER2+" ~ "HER2 Positive",
      subtype == "HR+/HER2-" ~ "Luminal A",
      subtype == "HR+/HER2+" ~ "Luminal B",
      TRUE ~ NA_character_
    ),
    # assign common grades between 2017 and 2018
    # "1" is well-differentiated, "2" is moderately-differentiated
    # "3" is poorly- differentiated, "4" is undifferentiated
    # see documentation for additional details on assignments
    grade2017 = case_when(
      grade2017 == "Well differentiated; Grade I" ~ "1",
      grade2017 == "Moderately differentiated; Grade II" ~ "2",
      grade2017 == "Poorly differentiated; Grade III" ~ "3",
      grade2017 == "Undifferentiated; anaplastic; Grade IV" ~ "4",
      grade2017 == "H" ~ "3",
      grade2017 == "Unknown" ~ NA_character_,
      TRUE ~ grade2017
    ),
    grade2018 = case_when(
      grade2018 == "A" ~ "1",
      grade2018 == "B" ~ "2",
      grade2018 == "C" ~ "3",
      grade2018 == "D" ~ "4",
      grade2018 == "H" ~ "3",
      grade2018 == "9" ~ NA_character_,
      grade2018 == "Blank(s)" ~ NA_character_,
      TRUE ~ grade2018
    ),
    # merge the 2017 and 2018 grade columns
    grade = coalesce(grade2017, grade2018),
    
    # assign N stage type for easier analysis
    n2015 = case_when(
      str_detect(n2015, "N0") ~ "N0",
      str_detect(n2015, "N1|N1N0S") ~ "N1",
      str_detect(n2015, "N2|N2N0S") ~ "N2",
      str_detect(n2015, "N3|N3N0S") ~ "N3",
      str_detect(n2015, "NX") ~ NA_character_,
      TRUE ~ NA_character_
    ),
    n2017 = case_when(
      str_detect(n2017, "c0|p0") ~ "N0",
      str_detect(n2017, "c1|p1") ~ "N1",
      str_detect(n2017, "c2|p2") ~ "N2",
      str_detect(n2017, "c3|p3") ~ "N3",
      str_detect(n2017, "cX") ~ NA_character_,
      TRUE ~ NA_character_
    ),
    n2018 = case_when(
      str_detect(n2018, "N0") ~ "N0",
      str_detect(n2018, "N1|N1N0S") ~ "N1",
      str_detect(n2018, "N2|N2N0S") ~ "N2",
      str_detect(n2018, "N3|N3N0S") ~ "N3",
      str_detect(n2018, "NX") ~ NA_character_,
      TRUE ~ NA_character_
    ),
    # merge the 2015, 2017, and 2018 N stage columns
    n_stage = coalesce(n2015, n2017, n2018),
    
    # assign M stage type for easier analysis
    m2015 = case_when(
      str_detect(m2015, "M0") ~ "M0",
      str_detect(m2015, "M1|M1M0S") ~ "M1",
      TRUE ~ NA_character_
    ),
    m2017 = case_when(
      str_detect(m2017, "c0") ~ "M0",
      str_detect(m2017, "c1|p1") ~ "M1",
      TRUE ~ NA_character_
    ),
    m2018 = case_when(
      str_detect(m2018, "M0") ~ "M0",
      str_detect(m2018, "M1|M1M0S") ~ "M1",
      TRUE ~ NA_character_
    ),
    
    # merge the 2015, 2017, and 2018 M stage columns
    m_stage = coalesce(m2015, m2017, m2018),
    
    # simplify the radiation and surgery variables
    radiation = case_when(
      str_detect(radiation, "None|Refused|unknown") ~ "No/Unknown",
      TRUE ~ "Yes"
    ),
    surgery = case_when(
      surgery == "0" ~ "No/Unknown",
      surgery == "99" ~ "No/Unknown",
      TRUE ~ "Yes"
    )
  )

## Restrict to complete observations only ======================================
seer_complete <- seer_clean %>%
  filter(
    !is.na(subtype), # 313 indiv excluded, 5004 remain
    !is.na(grade), # 758 indiv excluded, 4246 remain
    n_stage != "NX" # 106 indiv excluded, 4140 remain
  )

## Create the categories to be used in our analysis ============================

# Leave category names more descriptive for creating Table 1
seer_catclean <- seer_complete %>%
  mutate(subtype = factor(
    subtype, levels = c("Luminal A", "Luminal B", "HER2 Positive", "Triple Negative")
  )) %>%
  mutate(agecat = case_when(
    age %in% c("20-24 years", "25-29 years", "30-34 years", "35-39 years", "40-44 years", "45-49 years") ~ "20-49 years",
    age %in% c("50-54 years", "55-59 years", "60-64 years", "65-69 years") ~ "50-69 years",
    age %in% c("70-74 years", "75-79 years", "80-84 years", "85+ years") ~ ">=70 years",
    TRUE ~ NA_character_  # Keeps other values as NA if they don’t match any of the above groups
  )) %>%
  mutate(agecat = factor(
    agecat, levels = c("20-49 years", "50-69 years", ">=70 years")
  )) %>%
  mutate(race = factor(
      race, levels = c("White", "Black", "Other")
  )) %>%
  mutate(marriage_status = case_when(
    marriage_status == "Yes" ~ "Married",
    TRUE ~ "Unmarried"
  )) %>%
  mutate(marriage_status = factor(
    marriage_status, levels = c("Unmarried", "Married")
  )) %>%
  mutate(gradecat = case_when(
    grade %in% c(1, 2) ~ "I/II",
    grade %in% c(3, 4) ~ "III/IV",
    TRUE ~ NA_character_
  ))

# Save data with named categories for creating table 1
seer_tab <- seer_catclean %>%
  select(
    agecat,
    race,
    marriage_status,
    subtype,
    n_stage,
    m_stage,
    gradecat,
    radiation,
    chemotherapy,
    surgery,
    survival_months,
    survival_status,
  )

# Save as rds file
saveRDS(seer_tab, file = "data/processed/seer_tab.rds")

# Code the different categories numerically to be used in our analyses
seer_cat <- seer_complete %>%
  mutate(agecat = factor(
    case_when(
      age %in% c("20-24 years", "25-29 years", "30-34 years", "35-39 years", "40-44 years", "45-49 years") ~ 0,
      age %in% c("50-54 years", "55-59 years", "60-64 years", "65-69 years") ~ 1,
      age %in% c("70-74 years", "75-79 years", "80-84 years", "85+ years") ~ 2,
      TRUE ~ NA_real_  # Keeps other values as NA if they don’t match any of the above groups
      ))) %>%
  mutate(racecat = factor(
    case_when(
      race == "White" ~ 0,
      race == "Black" ~ 1,
      race == "Other" ~ 2,
      TRUE ~ NA_integer_
      ))) %>%
  mutate(marriage_status = factor(
    case_when(
      marriage_status == "Yes" ~ 1,
      TRUE ~ 0
      ))) %>%
  mutate(subtypecat = factor(
    case_when(
      subtype == "Luminal A" ~ 0,
      subtype == "Luminal B" ~ 1,
      subtype == "Triple Negative" ~ 2,
      subtype == "HER2 Positive" ~ 3,
      TRUE ~ NA_integer_
    ))) %>%
  mutate(gradecat = factor(
    case_when(
      grade %in% c(1, 2) ~ 0,
      grade %in% c(3, 4) ~ 1,
      TRUE ~ NA_integer_
    ))) %>%
  mutate(n_stage = factor(
    case_when(
      n_stage == "N0" ~ 0,
      n_stage == "N1" ~ 1,
      n_stage == "N2" ~ 2,
      n_stage == "N3" ~ 3,
      TRUE ~ NA_integer_
    ))) %>%
  mutate(m_stage = factor(
    case_when(
      m_stage == "M0" ~ 0,
      m_stage == "M1" ~ 1,
      TRUE ~ NA_integer_
    ))) %>%
  mutate(radiation = factor(
    case_when(
      radiation == "No/Unknown" ~ 0,
      radiation == "Yes" ~ 1,
      TRUE ~ NA_integer_
    ))) %>%
  mutate(chemotherapy = factor(
    case_when(
      chemotherapy == "No/Unknown" ~ 0,
      chemotherapy == "Yes" ~ 1,
      TRUE ~ NA_integer_
    ))) %>%
  mutate(surgery = factor(
    case_when(
      surgery == "No/Unknown" ~ 0,
      surgery == "Yes" ~ 1,
      TRUE ~ NA_integer_
    ))) %>%
  # The survival_status column is what we use for event/censoring
  # Recode Dead as 1 and Alive (censored) as 0
  mutate(status_cat = case_when(
      survival_status == "Dead" ~ 1,
      survival_status == "Alive" ~ 0
    ))

## Select only variables used in our analysis ==================================
seer <- seer_cat %>%
  select(
    age = agecat,
    race = racecat,
    marriage_status,
    subtype = subtypecat,
    n_stage,
    m_stage,
    grade = gradecat,
    radiation,
    chemotherapy,
    surgery,
    survival_months,
    survival_status = status_cat,
  )

## Save as rds file ============================================================
saveRDS(seer, file = "data/processed/seer.rds")

## End of script ===============================================================