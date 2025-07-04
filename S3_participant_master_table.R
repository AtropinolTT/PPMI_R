# Script 3: Create participant master table (Section 4.2)

# This script is provided as is with no guarantees of completeness or accuracy
# Create a "participants master" data frame

library(readr)
library(dplyr)

# Load tables into data frames
setwd ("C:\\PPMI")
Participant_Status <- read_csv ("Participant_Status.csv")
Demographics <- read_csv ("Demographics.csv")
Codes <- read_csv ("Code_List_-_Harmonized.csv")
PD_Diagnosis_History <- read_csv ("PD_Diagnosis_History.csv")

# Filter on status and cohort and determine genetic subgroup
Participant_Status_Filtered <- filter(Participant_Status, tolower(ENROLL_STATUS) %in% c("enrolled", "withdrew", "complete") & substr(COHORT_DEFINITION,1, 1)== "P") %>%
  mutate(GENETIC_SUBGROUP = factor(case_when(
    ENRLPINK1 + ENRLPRKN + ENRLSRDC + ENRLHPSM + ENRLRBD + ENRLLRRK2 + ENRLSNCA + ENRLGBA > 1 ~ 'Multiple factors',
    ENRLPINK1 == 1 ~ 'PINK1', ENRLPRKN == 1 ~ 'PARKIN', ENRLSRDC == 1 ~ 'SRDC',
    ENRLHPSM == 1 ~ 'HPSM', ENRLRBD == 1 ~ 'RBD', ENRLLRRK2 == 1 ~ 'LRRK2',
    ENRLSNCA == 1 ~ 'SNCA', ENRLGBA == 1 ~ 'GBA', TRUE ~ '' )))

# Extract the sex and handedness decode values from the Codes data frame, noting that a type conversion to integer is needed
Sex <- filter(Codes,ITM_NAME =="SEX") %>% select(CODE,DECODE) %>% transmute(CODE = as.numeric(as.character(CODE)), DECODE)
Handed <- filter(Codes,ITM_NAME =="HANDED") %>% select(CODE,DECODE) %>% transmute(CODE = as.numeric(as.character(CODE)), DECODE)

# PD Diagnosis date - tidy up date format and select earliest date for each patient
PD_Diagnosis_History <- mutate(PD_Diagnosis_History, PD_Diagnosis_Date = as.Date(paste("01/", as.character(PDDXDT)), "%d/%m/%Y")) %>%
  group_by(PATNO) %>% 
  summarize (PD_Diagnosis_Date = min(PD_Diagnosis_Date))

# Create the Patient_Master data frame
Participant_Master <- Participant_Status_Filtered %>% 
  left_join (Demographics, by = "PATNO") %>%
  left_join (Sex,c("SEX"= "CODE")) %>%
  left_join (Handed,c("HANDED" = "CODE")) %>%
  left_join (PD_Diagnosis_History, by = "PATNO") %>%
  select (PATNO, BIRTHDT, COHORT_DEFINITION, GENETIC_SUBGROUP, ENROLL_AGE, 
          ENROLL_DATE, ENROLL_STATUS, SEX = DECODE.x, HANDED = DECODE.y, PD_Diagnosis_Date) %>%
  arrange (PATNO)

#Fix date formats
Participant_Master <- mutate(Participant_Master, BIRTHDT = as.Date(paste("01/", as.character(BIRTHDT)), "%d/%m/%Y"))
Participant_Master <- mutate(Participant_Master, ENROLL_DATE = as.Date(paste("01/", as.character(ENROLL_DATE)), "%d/%m/%Y"))

#Display data frame
Participant_Master
