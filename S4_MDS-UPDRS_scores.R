# Script 4: Progression of MDS-UPDRS scores (Section 6.1) 
# Change the participant number highlighted below to the participant in which you are interested

# This script is provided as is with no guarantees of completeness or accuracy
# Extract progression of total scores and Hoehn and Yahr sate from each section of MDS-UPDRS for a single participant

library(readr)
library(dplyr)

# Load tables into data frames
setwd ("C:\\PPMI")
MDS_UPDRS_Part_1 <- read_csv ("MDS-UPDRS_Part_I.csv")
MDS_UPDRS_Part_1P <- read_csv ("MDS-UPDRS_Part_I_Patient_Questionnaire.csv")
MDS_UPDRS_Part_2P <- read_csv ("MDS_UPDRS_Part_II__Patient_Questionnaire.csv")
MDS_UPDRS_Part_3 <- read_csv ("MDS-UPDRS_Part_III.csv")

#Fix date formats
MDS_UPDRS_Part_1 <- mutate(MDS_UPDRS_Part_1, INFODT = as.Date(paste("01/", as.character(INFODT)), "%d/%m/%Y"))
MDS_UPDRS_Part_1P <- mutate(MDS_UPDRS_Part_1P, INFODT = as.Date(paste("01/", as.character(INFODT)), "%d/%m/%Y"))
MDS_UPDRS_Part_2P <- mutate(MDS_UPDRS_Part_2P, INFODT = as.Date(paste("01/", as.character(INFODT)), "%d/%m/%Y"))
MDS_UPDRS_Part_3 <- mutate(MDS_UPDRS_Part_3, INFODT = as.Date(paste("01/", as.character(INFODT)), "%d/%m/%Y"))

# Join the data frames filtering on a single participant and take the maximum scores across each INFODT/EVENT_ID
filter(MDS_UPDRS_Part_1, PATNO == 9300) %>% 
  inner_join (MDS_UPDRS_Part_1P, by = c("PATNO","INFODT","EVENT_ID")) %>% 
  inner_join (MDS_UPDRS_Part_2P, by = c("PATNO","INFODT","EVENT_ID")) %>% 
  inner_join (MDS_UPDRS_Part_3, by = c("PATNO","INFODT","EVENT_ID")) %>% 
  filter(!is.na(NP1RTOT), !is.na(NP1PTOT) & !is.na(NP2PTOT) & !is.na(NP3TOT) & !is.na(NHY)) %>% 
  select (INFODT, EVENT_ID, NP1RTOT, NP1PTOT, NP2PTOT, NP3TOT, NHY) %>%
  group_by (INFODT, EVENT_ID) %>%
  summarize (Part1 = max(NP1RTOT), Part1P = max(NP1PTOT), Part2 = max(NP2PTOT), Part3 = max(NP3TOT), HY_Stage = max(NHY)) %>%
  arrange (INFODT, EVENT_ID)
