# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# dviz :  research trends using R // anton.marx@psy.lmu.de

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

#### SCOPE ####

# This is a quick and easy annotated data visualization exercise based on code by Dan Quintana:
# (1) read data directly from the web
# (2) use basic ggplot2 to visualize research trends over time 
# (3) apply more advanced ggplot2 skills to modify the resulting plot
# (4) use additional text annotations within the plot
# (5) print the final plot as png-file 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

#### PREP ####

# clear environment
rm(list = ls())

# working directory
setwd("/Users/amx/data_local/R/dviz/researchtrends/")

# packages
install.packages("europepmc")
install.packages("cowplot")
install.packages("dplyr")
install.packages("ggplot2")

library(europepmc)
library(cowplot)
library(dplyr)
library(ggplot2)

# disable scientific notation
options(scipen = 999)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

#### ORIGINAL CODE (by Dan Quintana) ####

# source: https://gist.github.com/dsquintana/b512b715786088339b61a7fb79367d5e # Dan Quintana

# tutorial: https://www.youtube.com/watch?v=_IlK7eK1jkY&feature=youtu.be

# define research trend
ot_trend <- europepmc::epmc_hits_trend(query = "oxytocin", 
                                       period = 2008:2018)
# Standard plot
ot_trend %>% 
  ggplot(aes(year, query_hits / all_hits)) + 
  geom_point() + 
  geom_line()

# Nicer plot
ot_trend %>%
  ggplot(aes(x = factor(year), y = (query_hits / all_hits))) +
  geom_col(fill = "#56B4E9", width = 0.6, alpha = 0.9) +
  scale_y_continuous(expand = c(0, 0)) +
  theme_minimal_hgrid(12) +
  labs(x = "Year", y = "Proportion of all published articles") +
  ggtitle("Interest in oxytocin research over the past decade")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

#### ALTERNATIVE NON-TIDYVERSE SOLUTION USING GGPLOT2 #### 

### READ DATA 
ec_trend <- europepmc::epmc_hits_trend(query = "emotional contagion", # database europepmc
                                       period = 1985:2020) # time period

### STANDARD PLOTS
# standard plot using baseR
ec_trend_hits <- ec_trend$query_hits / ec_trend$all_hits # percentage query hits in all hits
plot(ec_trend_hits) # plot datapoints

# standard plot using ggplot
ggplot(ec_trend, # data
       aes(x = year, # x axis
           y = query_hits / all_hits)) + # y axis
  geom_line() # type of graph

### ADVANCED PLOT USING GGPLOT 
ect <- ggplot(ec_trend, # data
              aes(y = (query_hits / all_hits))) + # y axis
  # plot type = columns
  geom_col(aes(x = year), # x axis
           size = 2, # size of columns
           color = "white", # line color
           fill = "grey50", # fill color
           alpha = .9) + # opacity
  # plot type = smoothed line
  geom_smooth(aes(x = year), # x axis
              method = "loess", # smooth method
              se = FALSE, # standard error
              size = 1, # size of line
              color="grey10", # color of line
              alpha = .9) + # opacity
  # titles and labels
  labs(x = "Year of publication", # x axis title
       y = "Proportion of all published articles (%)", # y axis title
       title = "Interest in emotional contagion research since 1985", # plot title
       caption = "Source: https://europepmc.org") + # plot caption
  # theme
  theme_classic() + 
  theme(
    # titles and labels
    plot.title = element_text(size = 55, # text size
                              face = "bold", # bold, plain, italic
                              color = "black"),
    axis.title.x = element_text(size = 32, 
                                face = "plain", 
                                color = "black"),
    axis.title.y = element_text(size = 32, 
                                face = "plain", 
                                color = "black"),
    plot.caption = element_text(size = 24, 
                                face = "plain", 
                                color = "black", 
                                hjust = 1), # hjust = 1 align to right (0 left, 0.5 center)
    # axis design
    axis.line.y = element_blank(), # remove axis line
    axis.ticks.y = element_blank(), # remove axis ticks
    axis.text.x = element_text(size = 20), # size of axis text
    axis.text.y = element_text(size = 20), # size of axis text
    # background design
    panel.grid.major.y = element_line(colour = "grey90"),
    panel.background = element_rect(fill = "#FAFAFA"),
    plot.background = element_rect(fill = "#FAFAFA")) +
  # axis breaks
  scale_x_continuous(breaks = c(1985, 1990, 1995, 2000, 2005, 2010, 2015, 2020))
ect # view plot

### ANNOTATIONS IN PLOT
# define headline text
headline <- paste(strwrap("Over the past 35 years, scientific interest in emotional contagion has been growing steadily", 
                          40), # characters in one line
                  collapse = "\n")

# annotate headline to plot
ect_an <- ect + annotate("text", # type of annotation
                         x = 1985, # position x axis
                         y = 0.0003, # position y axis
                         hjust = 0, # horizontal justification
                         vjust = 0.5, # vertical justification
                         label = headline, # deinfe label
                         size = 14) # size of text
ect_an # view annotated plot

# print
setwd("/Users/amx/data_local/R/dviz/researchtrends/")

png(bg = "white", # background color equal to color of plots
    filename="ec_trend.png", width=1024*1.5, height=1024*1.5*.5, units="px")
par(mfrow=c(1,1))

ect_an # final annotated plot

dev.off()

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

#
