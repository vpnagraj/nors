# script to prepare data for visualization

# load pkgs
library(tidyverse)
library(lubridate)

# read in data exported from NORS
dat <- read_csv("data/NationalOutbreakPublicDataTool.csv")

# etiologies of interest
etiologies <- c("Norovirus", "Salmonella", "Clostridium", "Campylobacter", "Staph")

# create empty list to store data during loop
l <- list()

# loop through data to find etiologies and add a column for each 'type'
# note that this 'type' will be genus rather than species level
for (etiology in etiologies) {
  
  tmp <-
    dat %>%
    filter(grepl(etiology, Etiology)) %>%
    mutate(Type = etiology)
    
  l[[etiology]] <- tmp
  
}

# combine all etiologies into a single data frame
combo <-
  # rbind all elementso of the list
  do.call("rbind", l) %>%
  # keep only laboratory confirmed foodborne outbreaks
  filter(`Etiology Status` == "Confirmed",
         `Primary Mode` == "Food") %>%
  # handle dates
  mutate(Day = 1,
         Date = as.Date(paste(Year, Month, Day, sep = "-")),
         Month_Name = month(Date, label = TRUE)) %>%
  # keep columns of interest
  select(Date, 
         Day, 
         Month_Name, 
         Year:Etiology,
         Illnesses,
         Hospitalizations,
         Deaths,
         Type)

# write combo data frame to compressed r object
save(combo, file = "data/combo.rda")

# write out data for stata plots

# by etiology
combo %>%
  group_by(Type) %>%
  tally() %>%
  rename(Etiology = Type,
         Count = n) %>%
  write_csv("data/count_by_etiology.csv")

# by month wide
combo %>%
  group_by(Type, Month) %>%
  tally() %>%
  rename(Etiology = Type,
         Count = n) %>%
  spread(Etiology, Count) %>%
  mutate(Total = Campylobacter + Clostridium + Norovirus + Salmonella + Staph) %>%
  write_csv("data/count_by_month_wide.csv")