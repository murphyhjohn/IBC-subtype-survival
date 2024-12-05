###
# Figure 2: Log minus plots to check Proportional Hazards assumption
# MJ 2024-12-05
# This script creates Figure 2 log minus log plots
###

## Setup =======================================================================
library(gridExtra)
library(survminer)
library(survival)

# load data
seer <- readRDS("data/processed/seer.rds")
attach(seer)

## Create each plot ============================================================
plot_subtype <- ggsurvplot(
  survfit(Surv(time = survival_months, event = survival_status) ~ subtype), 
  data = seer, 
  fun ="cloglog",
  ylab = "log(-log(S(t))",
  xlab = "log(Time)",
  legend.labs = c("Luminal A", "Luminal B", "HER2 Positive", "Triple Negative"),
  legend.title = "Subtype:")

plot_agecat <- ggsurvplot(
  survfit(Surv(time = survival_months, event = survival_status) ~ age), 
  data = seer, 
  fun="cloglog",
  ylab = "log(-log(S(t))",
  xlab = "log(Time)",
  legend.labs = c("20-49 years", "50-69 years", ">= 70 years"),
  legend.title = "Age:")

plot_race <- ggsurvplot(
  survfit(Surv(time = survival_months, event = survival_status) ~ race), 
  data = seer, 
  fun="cloglog",
  ylab = "log(-log(S(t))",
  xlab = "log(Time)",
  legend.labs = c("White", "Black", "Other"),
  legend.title = "Race:")

plot_marriage <- ggsurvplot(
  survfit(Surv(time = survival_months, event = survival_status) ~ marriage_status), 
  data = seer, 
  fun="cloglog",
  ylab = "log(-log(S(t))",
  xlab = "log(Time)",
  legend.labs = c("Unmarried", "Married"),
  legend.title = "Marital Status:")

plot_n_stage <- ggsurvplot(
  survfit(Surv(time = survival_months, event = survival_status) ~ n_stage), 
  data = seer, 
  fun="cloglog",
  ylab = "log(-log(S(t))",
  xlab = "log(Time)",
  legend.labs = c("N0", "N1", "N2", "N3"),
  legend.title = "N Stage:")

plot_m_stage <- ggsurvplot(
  survfit(Surv(time = survival_months, event = survival_status) ~ m_stage), 
  data = seer, 
  fun="cloglog",
  ylab = "log(-log(S(t))",
  xlab = "log(Time)",
  legend.labs = c("M0", "M1"),
  legend.title = "M Stage:")

plot_grade <- ggsurvplot(
  survfit(Surv(time = survival_months, event = survival_status) ~ grade), 
  data = seer, 
  fun="cloglog",
  ylab = "log(-log(S(t))",
  xlab = "log(Time)",
  legend.labs = c("I/II", "III/IV"),
  legend.title = "Grade:")

plot_radiation <- ggsurvplot(
  survfit(Surv(time = survival_months, event = survival_status) ~ radiation), 
  data = seer, 
  fun="cloglog",
  ylab = "log(-log(S(t))",
  xlab = "log(Time)",
  legend.labs = c("No/Unknown", "Yes"),
  legend.title = "Radiation:")

plot_chemotherapy <- ggsurvplot(
  survfit(Surv(time = survival_months, event = survival_status) ~ chemotherapy), 
  data = seer, 
  fun="cloglog",
  ylab = "log(-log(S(t))",
  xlab = "log(Time)",
  legend.labs = c("No/Unknown", "Yes"),
  legend.title = "Chemotherapy:")

plot_surgery <- ggsurvplot(
  survfit(Surv(time = survival_months, event = survival_status) ~ surgery), 
  data = seer, 
  fun="cloglog",
  ylab = "log(-log(S(t))",
  xlab = "log(Time)",
  legend.labs = c("No/Unknown", "Yes"),
  legend.title = "Surgery:")

## Arrange on one grid and save as png =========================================
png("results/figures/loglog_plot.png", width = 900, height = 1100)

grid.arrange(plot_subtype$plot, plot_agecat$plot, plot_race$plot, plot_marriage$plot, plot_n_stage$plot,
             plot_m_stage$plot, plot_grade$plot, plot_radiation$plot, plot_chemotherapy$plot, plot_surgery$plot,
             ncol = 2, nrow = 5)

dev.off()

## End of script ===============================================================