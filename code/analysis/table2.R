# Table 2: Schoenfeld residual and ranked survival time correlations 

library(survival)
library(dplyr)
library(gtsummary)
library(gt)

# load data
seer <- readRDS("data/processed/seer.rds")
attach(seer)

# fit the full cox proportional hazards model
model <- coxph(
  Surv(survival_months, survival_status) ~ 
    relevel(factor(subtype), ref = '0') +
    relevel(factor(age), ref = '0') + 
    relevel(factor(race), ref = '0') +
    relevel(factor(marriage_status),ref='0') + 
    relevel(factor(n_stage),ref='0') + 
    relevel(factor(m_stage),ref='0') +
    relevel(factor(grade), ref='0') +
    relevel(factor(radiation), ref='0') + 
    relevel(factor(chemotherapy), ref='0') +
    relevel(factor(surgery), ref='0'),
  data = seer, 
  method = "breslow")

# extract Schoenfeld residuals
resid <- cox.zph(model, terms = FALSE)

# clean up to present in table
covariates <- c("Luminal B", "Triple Negative", "HER2 Positive", 
                "50-69 years", ">=70 years",
                "Black", "Other",
                "Married",
                "N1", "N2", "N3",
                "M1",
                "Grade: III/IV",
                "Radiation: Yes",
                "Chemotherapy: Yes",
                "Surgery: Yes")

# get the correlations between residuals and ranked survival times
cor <- data.frame(
  Variable = covariates,
  Correlation = apply(resid$y, 2, \(x) round(cor.test(rank(resid$time), x)$estimate, 3)),
  `p-value` = apply(resid$y, 2, \(x) {
    p <- round(cor.test(rank(resid$time), x)$p.value, 3)
    ifelse(p == 0, "<0.001", p)
  })
)

t2 <- gtsummary::as_tibble(cor)

# Convert to a flextable
t2_flex <- flextable::flextable(t2)
t2_flex <- flextable::fontsize(t2_flex, size = 7.5, part = "all")
# Save the flextable object as RDS
saveRDS(t2_flex, file = here::here("results/tables", "t2.rds"))

