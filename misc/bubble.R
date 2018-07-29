# script to generate bubble chart of number of illnesses

# load libraries
library(tidyverse)
library(ggthemes)
library(ggrepel)

# load combo data from ../prep.R
load("../data/combo.rda")

# aggregate combo data by type and count number of illnesses
combo %>%
  group_by(Type) %>%
  summarise(illnesses = sum(Illnesses, na.rm = TRUE)) %>%
  arrange(desc(illnesses)) %>%
  ungroup() %>%
  mutate(index = 1:nrow(.),
         y = 1) %>%
  # start ggplot of points sized by nubmer of illnesses
  ggplot(aes(index, y)) +
  geom_point(aes(size = illnesses, col = Type), alpha = 0.8) +
  scale_x_reverse(limits = c(5.2,0)) +
  coord_flip() +
  scale_size(range = c(5,35)) +
  theme_classic() + 
  theme(axis.line = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        legend.position = "none", 
        text = element_text(size = 16)
        ) +
  scale_y_continuous(limits = c(0,2.5)) +
  scale_colour_colorblind() +
  geom_text_repel(aes(index, y, label=paste0(Type, " (", formatC(illnesses, format = "d", big.mark = ","), ")")), 
                  nudge_y = 0.5, 
                  size = 5, 
                  segment.size = 0.5, 
                  segment.alpha = 0.5) +
  labs(
    title = "Number of Foodborne Illnesses by Etiology",
    subtitle = "United States (1998-2016)",
    caption = "Data Source: NORS")

ggsave("../plots/bubble.png", width = 12, height = 9)