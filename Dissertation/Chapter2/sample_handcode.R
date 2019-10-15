### This script randomly samples 500 documents to hand code.

rm(list=ls())
#setwd("C:/Users/sum410/Dropbox/Dissertation/Data/Census")
setwd("C:/Users/steve/Dropbox/Dissertation/Data/handcode")

library(stringr)

gc()
load('C:/Users/steve/Dropbox/Dissertation/Data/handcode/model_sermons_subset.RData')
gc()

# Check -> should not change
dim(serms.merge)
serms.merge <- serms.merge[which(serms.merge$word.count > 100),]
dim(serms.merge)

# Remove spanish
summary(serms.merge$spanish.count)
serms.merge <- serms.merge[which(serms.merge$spanish.count < 5),]

serms.merge$zip.clean[1:10]
length(unique(serms.merge$zip.clean))

# Select on liberty
serms.merge$clean[1]
serms.merge$liberty <- str_count('liberty', serms.merge$clean)


# Sample
set.seed(24519)
smp <- serms.merge[sample(nrow(serms.merge),500),]


serms.merge$hand_labeled <- 0
for (i in 1:nrow(serms.merge)) {
  
  for (j in 1:nrow(smp)) {
    
    if (serms.merge$clean[i] == smp$clean[j]) {
      serms.merge$hand_labeled[i] <- 1
    }
  }
}

summary(serms.merge$hand_labeled == 1)

save(serms.merge, file = 'model_sermons_hand_label_indicator.RData')

smp$sermon[1]
smp$clean[1]
smp$handcode_id <- seq(1,nrow(smp))
summary(smp$fair>0.51)
smp$fair_thresh <- ifelse(smp$fair>0.51, 1, 0)

write.csv(smp, 'hand_code_sample.csv', row.names = F)
