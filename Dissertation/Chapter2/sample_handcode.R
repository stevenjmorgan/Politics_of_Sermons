### This script randomly samples 500 documents to hand code.

rm(list=ls())
#setwd("C:/Users/sum410/Dropbox/Dissertation/Data/Census")
setwd("C:/Users/steve/Dropbox/Dissertation/Data/handcode")

gc()
load('C:/Users/steve/Dropbox/Dissertation/Data/handcode/model_sermons_subset.RData')
gc()

# Check -> should not change
dim(serms.merge)
serms.merge <- serms.merge[which(serms.merge$word.count > 100),]
dim(serms.merge)

serms.merge$zip.clean[1:10]
length(unique(serms.merge$zip.clean))

# Sample
set.seed(24519)
smp <- serms.merge[sample(nrow(serms.merge),500),]

smp$sermon[1]
smp$clean[1]
write.csv(smp, 'hand_code_sample.csv', row.names = F)
