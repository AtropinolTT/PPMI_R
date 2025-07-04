# Script 1: Count of enrolled/withdrawn/complete participants by cohort and genetic subgroup (Section 3.9) 

# This script is provided as is with no guarantees of completeness or accuracy
# Number of enrolled/completed/withdrawn Parkinson's and Prodromal participants by genetic subgroup

library(readr)
library(dplyr)

# Load table into data frame
setwd ("C:\\PPMI")
Participant_Status <- read_csv ("Participant_Status.csv") 

# Filter on status and cohort, determine genetic subgroup, then group by, aggregate and order results
filter(Participant_Status, tolower(ENROLL_STATUS) %in% c("enrolled", "withdrew", "complete") & substr(COHORT_DEFINITION,1, 1)== "P") %>%
transmute(PATNO, COHORT_DEFINITION, GENETIC_SUBGROUP = factor(case_when(
    ENRLPINK1 + ENRLPRKN + ENRLSRDC + ENRLHPSM + ENRLRBD + ENRLLRRK2 + ENRLSNCA + ENRLGBA > 1 ~ 'Multiple factors',
    ENRLPINK1 == 1 ~ 'PINK1',
    ENRLPRKN == 1 ~ 'PARKIN',
    ENRLSRDC == 1 ~ 'SRDC',
    ENRLHPSM == 1 ~ 'HPSM',
    ENRLRBD == 1 ~ 'RBD',
    ENRLLRRK2 == 1 ~ 'LRRK2', 
    ENRLSNCA == 1 ~ 'SNCA',
    ENRLGBA == 1 ~ 'GBA', 
    TRUE ~ '' ))) %>% 
  group_by(COHORT_DEFINITION, GENETIC_SUBGROUP) %>% 
  summarize(PATIENT_COUNT = n()) %>% 
  arrange(COHORT_DEFINITION, desc(PATIENT_COUNT))
