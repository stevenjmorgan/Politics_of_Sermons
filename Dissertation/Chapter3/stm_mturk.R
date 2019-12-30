# This script impliments an STM on the open-ended responses
# to MTurk survey experiment data.

rm(list=ls())
setwd("C:/Users/SF515-51T/Desktop/Dissertation/Ch3")

load('final_cleaned_mturk.RData')
mturk <- mturk.sub
rm(mturk.sub)

