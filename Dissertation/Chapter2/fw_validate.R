### This validates initial hand coding by comparing rights talk sermons
### to non-rights talk sermon via the Fightin words algorithm.

rm(list=ls())
#setwd("C:/Users/sum410/Dropbox/Dissertation/Data/Census")
#setwd("C:/Users/steve/Dropbox/Dissertation/Data/handcode")
setwd("C:/Users/SF515-51T/Desktop/Dissertation")

library(stringr)

# Read in hand label file
df <- read.csv('hand_code_sample_10-15_coded_no_text.csv', stringsAsFactors = F)

# Read in text files
load('text_hand_sample.RData')

df$text <- comb.df$clean
rm(comb.df)


