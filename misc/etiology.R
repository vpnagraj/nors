# script to generate stacked barplot of count by etiology

# load libraries
library(tidyverse)
library(ggthemes)

# load combo data from ../prep.R
load("../data/combo.rda")

combo %>%
  mutate(index = "x") %>%
  group_by(Type, index) %>%
  tally() %>%
  ggplot(aes(index, n, fill = factor(Type, levels = .$Type), label = n)) +
  geom_bar(stat = "identity", position = "stack", width = 0.25) +
  scale_y_reverse() +
  coord_flip() +
  theme_classic() + 
  scale_fill_colorblind() +
  theme(axis.line = element_blank(), 
        axis.title = element_blank(), 
        axis.ticks = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        legend.title = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        legend.position = "bottom", 
        text = element_text(size = 16)) +
  labs(
    title = "Number of Foodborne Illness Outbreaks by Etiology",
    subtitle = "United States (1998-2016)",
    caption = "Data Source: NORS")

ggsave("../plots/etiology_count_stacked.png", width = 12, height = 9)
