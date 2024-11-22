# Figure 1: Flowchart of IBC patients screening on SEER database

library(Gmisc, quietly = TRUE)
library(glue)
library(htmlTable)
library(grid)
library(magrittr)


eligible <- boxGrob(glue("Breast cencer patients diagnosed with \ninflammatory breast carcinoma between 2010-2021",
                         "N = {pop}",
                         pop = txtInt(5986),
                         .sep = "\n"))

included <- boxGrob(glue("Eligible inflammatory breast \ncancer patients",
                         "n = {incl}",
                         incl = txtInt(4140),
                         .sep = "\n"))

excluded <- boxGrob(glue("Excluded (n = {tot}):",
                         " - Age at diagnosis < 20 years: {age}",
                         " - Male sex: {male}",
                         " - Survival time < 1 month: {survival}",
                         " - Unknown or competing \ncause of death: {cod}",
                         " - Incomplete or unknown \nclinicopathological characteristics: {incomplete}",
                         tot = txtInt(1846),
                         age = 1,
                         male = 16,
                         survival = 165,
                         cod = 487,
                         incomplete = txtInt(1177),
                         .sep = "\n"),
                    just = "left")

png("results/figures/flowchart.png", width = 700, height = 500)

grid.newpage()

vert <- spreadVertical(eligible = eligible,
                       included = included,
                       .from = .9,
                       .to = .1,
                       .type = "center")

excluded <- moveBox(excluded,
                    x = .8,
                    y = coords(vert$included)$top + 
                      distance(vert$eligible, 
                               vert$included, half = TRUE, center = FALSE))

for (i in 1:(length(vert) - 1)) {
  connectGrob(vert[[i]], vert[[i + 1]], type = "vert") %>%
    print
}

connectGrob(vert$eligible, excluded, type = "L")
grid.rect(gp = gpar(col = "black", fill = NA, lwd = 2))  # Adjust color and line width as needed

# Print boxes
vert
excluded

dev.off()
