# This script impliments an STM on the open-ended responses
# to MTurk survey experiment data.

rm(list=ls())
setwd("C:/Users/SF515-51T/Desktop/Dissertation/Ch3")

library(stm)
library(ggplot2)

load('final_cleaned_mturk.RData')
mturk <- mturk.sub
rm(mturk.sub)



# Remove observations w/ no open-ended answer
mturk <- mturk[which(mturk$text != ''),] #1196 (from 1248)

### Impute missing values -> just do this in the analysis script and load in the DF
#install.packages("VIM")
#library(VIM)

#mice_plot <- aggr(mturk, col=c('navyblue','yellow'),
#                  numbers=TRUE, sortVars=TRUE,
#                  labels=names(mturk), cex.axis=.7,
#                  gap=3, ylab=c("Missing data","Pattern"))


# Last value carried forward (for now)
library(zoo)
mturk <- na.locf(mturk)


