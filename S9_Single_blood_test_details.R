# Script 9: Blood test details for single participant (Section 8.3) 
# Change the participant number highlighted below to the participant in which you are interested.

# This script is provided as is with no guarantees of completeness or accuracy
# Hemoglobin test results for a single participant 

library(readr) 
library(dplyr)

# Load table into a data frame
setwd ("C:\\PPMI")
Blood_Chemistry <- read_csv ("Blood_Chemistry___Hematology.csv")

# Fix date formatting
Blood_Chemistry <- mutate(Blood_Chemistry, LCOLLDT = as.Date(paste("01/", as.character(LCOLLDT)), "%d/%m/%Y"))

# Count the number of distinct participants with each type of blood test
filter (Blood_Chemistry, PATNO == 9002 & LTSTCODE == "HMT40") %>%
  select (EVENT_ID, LCOLLDT, LTSTNAME, LVISTYPE, LSIRES, LSIUNIT, LUSRES, LUSUNIT) %>%
  arrange (LCOLLDT)