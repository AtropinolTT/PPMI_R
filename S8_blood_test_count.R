# Script 8: Numbers of participants with each blood test (Section 8.3) 

# This script is provided as is with no guarantees of completeness or accuracy
# Determine which blood tests have been captured for all participants 

library(readr)
library(dplyr)

# Load table into a data frame
setwd ("C:\\PPMI")
Blood_Chemistry <- read_csv ("Blood_Chemistry___Hematology.csv")

# Count the number of distinct participants with each type of blood test
Blood_Chemistry %>% group_by (LTSTCODE, LTSTNAME) %>%
  summarize (PATIENT_COUNT = n_distinct(PATNO)) %>%
  arrange (desc(PATIENT_COUNT), LTSTNAME) %>% 
  print (n = Inf)