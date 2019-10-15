### This script randomly samples 500 documents to hand code.

rm(list=ls())
#setwd("C:/Users/sum410/Dropbox/Dissertation/Data/Census")
#setwd("C:/Users/steve/Dropbox/Dissertation/Data/handcode")
setwd("C:/Users/SF515-51T/Desktop/Dissertation")

library(stringr)

gc()
#load('C:/Users/steve/Dropbox/Dissertation/Data/handcode/model_sermons_subset.RData')
load('model_sermons_subset.RData')
gc()

# Check -> should not change
dim(serms.merge)
serms.merge <- serms.merge[which(serms.merge$word.count > 100),]
dim(serms.merge)

# Remove spanish
summary(serms.merge$spanish.count)
serms.merge <- serms.merge[which(serms.merge$spanish.count < 5),]
dim(serms.merge)

serms.merge$zip.clean[1:10]
length(unique(serms.merge$zip.clean))

# Select on liberty
serms.merge$clean[1]
#serms.merge$sermon[1]
serms.merge$liberty <- str_count(serms.merge$clean, 'liberty')
summary(serms.merge$liberty)
serms.merge$abort <- str_count(serms.merge$clean, 'abortion')
summary(serms.merge$abort)

abort.rights <- serms.merge[which(serms.merge$liberty > 1 | serms.merge$abort > 1),]

# Sample 100 liberty and abortion sermons
set.seed(24519)
prob.rights <- abort.rights[sample(nrow(abort.rights), 100),]

# Sample 400 sermons randomly 
set.seed(3336)
prob.not.rights <- serms.merge[sample(nrow(serms.merge), 400),]

comb.df <- rbind(prob.rights, prob.not.rights)
comb.df$care <- comb.df$care.vice + comb.df$care.virtue
comb.df <- comb.df[,c('clean', 'fair', 'care','liberty','abort')]
colnames(comb.df)
comb.df$id <- seq(1,nrow(comb.df))
comb.df$fair[1:6]

save(comb.df, file = 'text_hand_sample.RData')
comb.df <- comb.df[,c('fair', 'care','liberty','abort')]
write.csv(comb.df, 'hand_code_sample_10-15.csv', row.names = F)


# Write to .txt files
for (i in 1:nrow(comb.df)) {
  
  fileConn<-file("output.txt")
  
}
fileConn<-file("output.txt")
writeLines(c("Hello","World"), fileConn)
close(fileConn)




##########################################################################
### END
##########################################################################

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
