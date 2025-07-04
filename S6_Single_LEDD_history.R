# Script 6: LEDD medication history for single participant (Section 7.1) 
# Change the participant number highlighted below to the participant in which you are interested.

# This script is provided as is with no guarantees of completeness or accuracy
# LEDD medication history for participant 
library(readr)
library(dplyr)

# Load tables into data frames
setwd ("C:\\PPMI")
LEDD <- read_csv ("LEDD_Concomitant_Medication_Log.csv")

# Fix date formatting
LEDD <- mutate(LEDD, STARTDT = as.Date(paste("01/", as.character(STARTDT)), "%d/%m/%Y"),STOPDT = as.Date(paste("01/", as.character(STOPDT)), "%d/%m/%Y"))

# Select columns of interest from LEDD log for a single participant
LEDD %>% filter(PATNO == 9052) %>% 
  select (PATNO, EVENT_ID, PAG_NAME, LEDTRT, STARTDT, STOPDT, LEDD) %>%
  arrange (STARTDT)