### This script randomly samples 500 documents to hand code.

rm(list=ls())
#setwd("C:/Users/sum410/Dropbox/Dissertation/Data/Census")
setwd("C:/Users/steve/Dropbox/Dissertation/Data/Census")

load('C:/Users/steve/Dropbox/Dissertation/Data/model_sermons_subset.RData')

serms.merge <- serms.merge[which(serms.merge$word.count > 100),]
serms.merge$zip.clean[1:10]
length(unique(serms.merge$zip.clean))