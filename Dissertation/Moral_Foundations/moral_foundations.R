# This script runs the moral foundations dictionary on the sermons corpus.

rm(list=ls())
#setwd("C:/Users/steve/Dropbox/Dissertation/Data")
setwd("C:/Users/sum410/Dropbox/Dissertation/Data")
#setwd('C:/Users/steve/Desktop/sermon_dataset')

library(quanteda)
library(devtools)
devtools::install_github("kbenoit/quanteda.dictionaries") 
library(quanteda.dictionaries)

load('final_dissertation_dataset7-27.RData')
serms.merge <- serms.merge[which(serms.merge$word.count > 75),]

# Test set
output_mfd <- liwcalike(serms.merge$clean[1:4], tolower = TRUE,
                        dictionary = data_dictionary_MFD) # 3741

mfd.df <- as.data.frame(matrix(nrow = nrow(serms.merge), ncol = 28))
colnames(mfd.df) <- colnames(output_mfd)
mfd.scores <- output_mfd[1,]
mfd.scores[1,] <- NA
rm(output_mfd)

# Calculate mf scores on each sermon
for (i in 1:length(serms.merge$clean)) {
  
  mfd.scores[1,] <- NA
  
  try(
  # Calculate MFD score for sermon
  mfd.scores <- liwcalike(serms.merge$clean[i], tolower = TRUE,
                          dictionary = data_dictionary_MFD))

  # Append values to dataframe
  mfd.df[i,] <- mfd.scores[1,]
  
  # Change doc number and segment
  mfd.df$docname[i] <- paste('sermon', as.character(i), sep = ' ')
  mfd.df$Segment[i] <- i
}

summary(is.na(mfd.df$fairness.vice))
save(mfd.df, file = 'mfd_scores_7-30.RData')


# Combine w/ sermon dataset
serms.merge <- cbind(serms.merge, mfd.df)
colnames(serms.merge)
save(serms.merge, file = 'sermons_mfd_7-30.RData')



# Plot distributions
hist(mfd.df$fairness.vice)
hist(mfd.df$fairness.virtue)
hist(mfd.df$care.virtue)
hist(mfd.df$care.vice)
hist(mfd.df$loyalty.virtue)
hist(mfd.df$loyalty.vice)
hist(mfd.df$authority.virtue)
hist(mfd.df$authority.vice)
hist(mfd.df$sanctity.virtue)
hist(mfd.df$sanctity.vice)

unique(serms$denom)

hist(serms$care.virtue[which(serms$denom == 'Evangelical/Non-Denominational')],
     xlab = 'Care - Virture', main = 'Evangelicals/Non-Denominational')
hist(serms$care.virtue[which(serms$denom == 'Baptist')],
     xlab = 'Care - Virture', main = 'Baptist')

t.test(serms$care.virtue[which(serms$denom == 'Evangelical/Non-Denominational')], # sign.
       serms$care.virtue[which(serms$denom == 'Baptist')])
t.test(serms$care.vice[which(serms$denom == 'Evangelical/Non-Denominational')],
       serms$care.vice[which(serms$denom == 'Baptist')])
t.test(serms$fairness.virtue[which(serms$denom == 'Evangelical/Non-Denominational')], # sign.
       serms$fairness.virtue[which(serms$denom == 'Baptist')])
t.test(serms$fairness.vice[which(serms$denom == 'Evangelical/Non-Denominational')],
       serms$fairness.vice[which(serms$denom == 'Baptist')])
