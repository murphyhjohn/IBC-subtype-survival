###
# Figure 1: Flowchart of IBC patients screening on SEER database
# MJ 2024-12-05
# This script created the Figure 1 flowchart describing our study population.
###

## Setup =======================================================================
library(Gmisc, quietly = TRUE)
library(glue)
library(htmlTable)
library(grid)
library(magrittr)

## Create the elgible, included, and excluded boxes of the flowchart ===========
eligible <- boxGrob(glue("Adult female patients diagnosed with \ninflammatory breast carcinoma between 2010-2021",
                         "N = {pop}",
                         pop = txtInt(5969),
                         .sep = "\n"))

included <- boxGrob(glue("Eligible adult female inflammatory \nbreast cancer patients",
                         "n = {incl}",
                         incl = txtInt(4140),
                         .sep = "\n"))

excluded <- boxGrob(glue("Excluded (n = {tot}):",
                         " - Survival time < 1 month: {survival}",
                         " - Unknown or competing \ncause of death: {cod}",
                         " - Incomplete or unknown \nclinicopathological characteristics: {incomplete}",
                         tot = txtInt(1829),
                         survival = 165,
                         cod = 487,
                         incomplete = txtInt(1177),
                         .sep = "\n"),
                    just = "left")

## Set up the png file where the flowchart will be saved =======================
png("results/figures/flowchart.png", width = 700, height = 500)

grid.newpage()
# Established the vertical spread of the figure
vert <- spreadVertical(eligible = eligible,
                       included = included,
                       .from = .9,
                       .to = .1,
                       .type = "center")
# Establishes the excluded box
excluded <- moveBox(excluded,
                    x = .8,
                    y = coords(vert$included)$top + 
                      distance(vert$eligible, 
                               vert$included, half = TRUE, center = FALSE))
# Draws the arrows on the flowchart
for (i in 1:(length(vert) - 1)) {
  connectGrob(vert[[i]], vert[[i + 1]], type = "vert") %>%
    print
}
connectGrob(vert$eligible, excluded, type = "L")
grid.rect(gp = gpar(col = "black", fill = NA, lwd = 2))

# Prints boxes
vert
excluded

dev.off()

## End of script ===============================================================