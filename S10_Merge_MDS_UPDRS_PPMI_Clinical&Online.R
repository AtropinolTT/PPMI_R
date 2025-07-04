# Script 10: Merge MDS_UPDRS scores from PPMI Clinical and PPMI Online (Section 12) 
# Change the participant number highlighted below to the participant in which you are interested.

# This script is provided as is with no guarantees of completeness or accuracy
# Merge MDS-UPDRS Part 1 and Part 2 patient scores from PPMI Clinical and PPMI Online data for a single participant 

library(dplyr)

# Load tables into data frames
setwd ("C:\\PPMI")
MDS_UPDRS_Part_1P <- read.csv ("MDS-UPDRS_Part_I_Patient_Questionnaire.csv", stringsAsFactors = TRUE)
MDS_UPDRS_Part_2P <- read.csv ("MDS_UPDRS_Part_II__Patient_Questionnaire.csv", stringsAsFactors = TRUE)
MDS_UPDRS_Part_1_Online <- read.csv("MDS-UPDRS_Part_I_Non-Motor_Aspects__Online_.csv", stringsAsFactors = TRUE)
MDS_UPDRS_Part_2_Online <- read.csv("MDS-UPDRS_Part_II_Motor_Aspects__Online_.csv", stringsAsFactors = TRUE)

# Fix date formats
MDS_UPDRS_Part_1P <- mutate(MDS_UPDRS_Part_1P, INFODT = as.Date(paste("01/", as.character(INFODT)), "%d/%m/%Y"))
MDS_UPDRS_Part_2P <- mutate(MDS_UPDRS_Part_2P, INFODT = as.Date(paste("01/", as.character(INFODT)), "%d/%m/%Y"))
MDS_UPDRS_Part_1_Online <- mutate(MDS_UPDRS_Part_1_Online, INFODT = as.Date(paste("01/", as.character(CREATED_AT)), "%d/%m/%Y"))
MDS_UPDRS_Part_2_Online <- mutate(MDS_UPDRS_Part_2_Online, INFODT = as.Date(paste("01/", as.character(CREATED_AT)), "%d/%m/%Y"))

# Join the data frames for PPMI Clinical
MDS_UPDRS_Clinical <- filter(MDS_UPDRS_Part_1P, PATNO == 9030) %>% 
  inner_join (MDS_UPDRS_Part_2P, by = c("PATNO","INFODT","EVENT_ID")) %>% 
  select (INFODT, EVENT_ID, NP1SLPN, NP1SLPD, NP1PAIN, NP1URIN, NP1CNST, NP1LTHD, 
          NP1FATG, NP2SPCH, NP2SALV, NP2SWAL, NP2EAT, NP2DRES, NP2HYGN, NP2HWRT, NP2HOBB, 
          NP2TURN, NP2TRMR, NP2RISE, NP2WALK, NP2FREZ) %>%
  arrange (INFODT, EVENT_ID)

# Join the data frames for PPMI Online and rename columns to match PPMI Clinical data
MDS_UPDRS_Online <- filter(MDS_UPDRS_Part_1_Online, PATNO == 9030) %>% 
  inner_join (MDS_UPDRS_Part_2_Online, by = c("PATNO","INFODT","EVENT_ID")) %>% 
  select (INFODT, EVENT_ID, NP1SLPN_OL, NP1SLPD_OL, NP1PAIN_OL, NP1URIN_OL, 
          NP1CNST_OL, NP1LTHD_OL, NP1FATG_OL, NP2SPCH_OL, NP2SALV_OL, NP2SWAL_OL, NP2EAT_OL, 
          NP2DRES_OL, NP2HYGN_OL, NP2HWRT_OL, NP2HOBB_OL, NP2TURN_OL, NP2TRMR_OL, NP2RISE_OL, 
          NP2WALK_OL, NP2FREZ_OL) %>%
  rename (NP1SLPN = NP1SLPN_OL, NP1SLPD = NP1SLPD_OL, NP1PAIN = NP1PAIN_OL, NP1URIN = 
            NP1URIN_OL, NP1CNST = NP1CNST_OL, NP1LTHD = NP1LTHD_OL, NP1FATG = NP1FATG_OL, NP2SPCH 
          = NP2SPCH_OL, NP2SALV = NP2SALV_OL, NP2SWAL = NP2SWAL_OL, NP2EAT = NP2EAT_OL, NP2DRES 
          = NP2DRES_OL, NP2HYGN = NP2HYGN_OL, NP2HWRT = NP2HWRT_OL, NP2HOBB =NP2HOBB_OL, NP2TURN 
          = NP2TURN_OL, NP2TRMR = NP2TRMR_OL, NP2RISE = NP2RISE_OL, NP2WALK = NP2WALK_OL, 
          NP2FREZ = NP2FREZ_OL) %>%
  arrange (INFODT, EVENT_ID)

# Combine the two data frames
union(MDS_UPDRS_Clinical, MDS_UPDRS_Online) %>% arrange (INFODT, EVENT_ID)