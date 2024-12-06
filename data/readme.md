---
editor_options: 
  markdown: 
    wrap: 72
---

# Data

This folder contains the raw and processed data used for analysis.

`raw` contains a .csv file of the raw data extracted from Seer\*Stat and
the .dic file of the exact schema used to generate the .csv file. Within
the `seerstat` folder are files that Seer\*Stat saved when I asked it to
save my session. They can be uploaded directly in the Seer\*Stat program
to get my data.

`processed` contains the clean data that was created by the
`processing-script.R` file, located in the `code/processing` folder. The
`seer_tab.rds` file was used to create Table 1 of my analysis. The
`seer.rds` file was used for all other analyses. They are the same thing
aside from some conventional variable names.
