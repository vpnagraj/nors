# script to produce choropleth maps

# load libraries
library(tidyverse)
library(fiftystater)
library(choroplethr)
library(grid)
library(gridExtra)

# load combo data from ../prep.R
load("../data/combo.rda")

# get state geo data from fiftystater
data("fifty_states")

# prep data as outbreak counts by state
outbreaksbystate <-
  combo %>%
  # ignore multistate outbreaks
  filter(State !="Multistate" & State != "Puerto Rico") %>%
  # handle DC
  mutate(State = ifelse(State == "Washington DC", "district of columbia", State)) %>%
  group_by(State, Type) %>%
  tally() %>%
  ungroup() %>%
  # fill in missing states with 0
  complete(State,Type, fill = list(n = 0)) %>%
  rename(region = State,
         value = n) %>%
  mutate(region = tolower(region))

# create a total data frame to have one map of all outbreaks
total <-
  outbreaksbystate %>%
  group_by(region) %>%
  summarise(value = sum(value),
            Type = "Total")

# write function to generate choropleths
choroplether <- function(df, name) {
  
  ggplot(df, aes(map_id = region)) + 
    # map points to the fifty_states shape data
    geom_map(aes(fill = value), map = fifty_states) + 
    expand_limits(x = fifty_states$long, y = fifty_states$lat) +
    coord_map() +
    scale_x_continuous(breaks = NULL) + 
    scale_y_continuous(breaks = NULL) +
    xlab("") +
    ylab("") +
    ggtitle(name) +
    theme(panel.background = element_blank(), 
          legend.title = element_blank(), 
          legend.position = "bottom",
          text = element_text(size = 16),
          legend.text = element_text(size = 8))
  
}

# generate list of plots (one for each type)
outbreaks_nested <-
  outbreaksbystate %>%
  rbind(total) %>%
  group_by(Type) %>% 
  nest() %>% 
  mutate(plots = map2(data, Type, choroplether))

# arrange plots in grid
# nb facet_wrap won't work here since we want free scales for each map

craw <-
  grid.arrange(
  grobs = outbreaks_nested$plots[c(1,2,5,4,3,6)],
  nrow = 2,
  top = textGrob(
    label = "Number of Foodborne Illness Outbreaks By State\nUnited States (1998-2016)",
    gp=gpar(fontsize=20)),
  bottom = textGrob(
    label = "Data Source: NORS", 
    gp=gpar(fontsize=20))
  )

ggsave("../plots/choropleth.png", craw)

# normalized to population counts
# using df_pop_state from choroplethr package

data(df_pop_state)

outbreaks_nested_normalized <-
  outbreaksbystate %>%
  rbind(total) %>%
  rename(value2 = value) %>%
  left_join(df_pop_state) %>%
  # n outbreaks per 1 million residents
  mutate(value = (value2 / value) * 1000000) %>%
  group_by(Type) %>% 
  nest() %>% 
  mutate(plots = map2(data, Type, choroplether))

# arrange plots in grid
cnormalized <- 
  grid.arrange(
  grobs = outbreaks_nested_normalized$plots[c(1,2,5,4,3,6)],
  nrow = 2,
  top = textGrob(
    label = "Number of Foodborne Illness Outbreaks By State Per 1 Million Residents\nUnited States (1998-2016)",
    gp=gpar(fontsize=20)),
  bottom = textGrob(
    label = "Data Source: NORS", 
    gp=gpar(fontsize=20))
)

ggsave("../plots/choropleth_normalized.png", cnormalized)