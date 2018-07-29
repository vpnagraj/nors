# script to produce coxcomb plots

# load libraries
library(tidyverse)

# load combo data from ../prep.R
load("../data/combo.rda")

# prepare subset of combo data and aggregate by month
coxdata <-
  combo %>%
  filter(Type == "Salmonella" | Type == "Norovirus") %>%
  group_by(Month_Name, Type) %>%
  summarise(Illnesses = sum(Illnesses, na.rm = TRUE),
            Outbreaks = n())

# create coxcomb plot
coxdata %>%
  ggplot(aes(x = Month_Name, y = Outbreaks, label = as.character(Outbreaks))) +
  geom_bar(col = "black", stat = "identity", width = 1) +
  facet_wrap(~ Type) +
  coord_polar() +
  theme_classic() + 
  theme(axis.line = element_blank(), 
        axis.title = element_blank(), 
        axis.ticks = element_blank(), 
        axis.text.y = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        text = element_text(size = 16)) +
  labs(title = "Distribution of Norovirus and Salmonella Outbreaks by Month",
       subtitle = "United States (1998-2016)",
       caption = "Data Source: NORS")

ggsave("../plots/coxcomb.png", width = 12, height = 9)
