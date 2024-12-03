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
  p.value = apply(resid$y, 2, \(x) {
    p <- round(cor.test(rank(resid$time), x)$p.value, 3)
    ifelse(p == 0, "<0.001", p)
  })
)

t2 <- cor %>% gt()

# save as png
gtsave(data = t2, filename = "results/tables/t2.png")

