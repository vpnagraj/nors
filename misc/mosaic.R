# script to create a mosaic plot showing the relative number of illnesses by etiology

# load libraries
library(tidyverse)

# load combo data from ../prep.R
load("../data/combo.rda")

# aggregate combo data by type and count number of illnesses
ill <-
  combo %>%
  group_by(Type) %>%
  summarise(illnesses = sum(Illnesses, na.rm = TRUE)) %>%
  arrange(desc(illnesses))

# prepare data for plotting
formosaic <- rbind(Illness = ill$illnesses)
colnames(formosaic) <- ill$Type

# open plot device to save figure
png("../plots/mosaic.png", width = 9, height = 12, units = "in", res = 400)

# generate plot
mosaicplot(formosaic, 
           dir = rep("v",5), 
           color = "firebrick", 
           off = c(15:20), 
           las = 1,
           cex.axis = 1,
           border = NA,
           main = "Number of Illnesses by Etiology\nUnited States (1998-2016)",
           sub = "Data Source: NORS")

# turn off plot device
dev.off()
