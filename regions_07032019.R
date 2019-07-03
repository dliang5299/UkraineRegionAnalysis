# import packages
library(tidyverse)
library(survey)
library(Hmisc)

# set working directory
# setwd("C:/Users/12088/Dropbox/UkraineREU2019/data/regions")

# import data set for households from UNICEF ukraine 2005 
hh <- read.csv("hh.csv")

# get a feel for regions -- are there 26 oblasts? 
length(unique(hh$HH7)) 

# summary of that region variable HH7 -- unweighted though
regions_freq <- as.data.frame(table(hh$HH7))

# initial check of proportions
regions_freq <- regions_freq %>%
  mutate(prop = Freq / sum(Freq)) 

# look at average proportions
describe(regions_freq$prop)

## TODO: check weighting

