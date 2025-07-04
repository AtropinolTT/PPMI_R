# Script 2: Count of enrolled/withdrawn/complete participants by cohort and sex (Section 4.1)

# This script is provided as is with no guarantees of completeness or accuracy
# Number PD and Prodromal enrolled/withdrawn/complete participants by cohort and sex

library(readr)
library(dplyr)

# Load tables into data frames
setwd ("C:\\PPMI")
Participant_Status <- read_csv ("Participant_Status.csv")
Demographics <- read_csv ("Demographics.csv")
Codes <- read_csv ("Code_List_-_Harmonized.csv")

# Filter based on cohort and enrollment status
Participant_Status_Filtered <- filter(Participant_Status, tolower(ENROLL_STATUS) %in% c("enrolled", "withdrew", "complete") & substr(COHORT_DEFINITION,1, 1)== "P")

# Extract the sex decode values from the Codes data frame, noting that a type conversion to integer is needed
Sex <- filter(Codes,ITM_NAME =="SEX") %>% select(CODE,DECODE) %>% transmute(CODE = as.numeric(as.character(CODE)), DECODE)

# Join the tables, group, aggregate and order the results
Participant_Status_Filtered %>% 
  left_join (Demographics, by = "PATNO") %>%
  left_join (Sex,c("SEX"= "CODE")) %>% 
  group_by (COHORT_DEFINITION, DECODE) %>%
  summarize(PATIENT_COUNT = n()) %>% 
  arrange (COHORT_DEFINITION, DECODE) %>%
  rename (SEX = DECODE)
