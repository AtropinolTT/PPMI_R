# Script 5: Sex and total UPSIT score by participant (Section 6.2)

# This script is provided as is with no guarantees of completeness or accuracy
# Extract sex and total UPSIT score at baseline for PD participants

library(readr)
library(dplyr)

# Load tables into data frames
setwd ("C:\\PPMI")
Participant_Status <- read_csv ("Participant_Status.csv")
Demographics <- read_csv ("Demographics.csv")
UPSIT <- read_csv 
("University_of_Pennsylvania_Smell_Identification_Test_UPSIT_.csv")
Codes <- read_csv ("Code_List_-_Harmonized.csv")

# Filter based on cohort and enrollment status
Participant_Status_Filtered <- filter(Participant_Status, tolower(ENROLL_STATUS) %in% c("enrolled", "withdrew", "complete") & substr(COHORT_DEFINITION,1, 4)== "Park")

# Extract the sex decode values from the Codes data frame, noting that a type conversion to integer is needed
Sex <- filter(Codes,ITM_NAME =="SEX") %>% select(CODE,DECODE) %>% 
transmute(CODE = as.numeric(as.character(CODE)), DECODE)

# Join the data frames filtering out the patients with NULL values in the total UPSIT score
Participant_Status_Filtered %>% 
  inner_join (filter(UPSIT,!is.na(TOTAL_CORRECT)), by = "PATNO") %>%
  inner_join (Demographics, by = "PATNO") %>%
  inner_join (Sex,c("SEX"= "CODE")) %>%
  select (PATNO, SEX=DECODE, TOTAL_CORRECT)