# This script runs the moral foundations dictionary on the sermons corpus.

rm(list=ls())
setwd("C:/Users/steve/Dropbox/Dissertation/Data")
#setwd("C:/Users/sum410/Dropbox/Dissertation/Data")

library(quanteda)
library(quanteda.dictionaries)

load('final_sermons_deduped.RData')

output_mfd <- liwcalike(serms$sermon[1:4], tolower = TRUE,
                        dictionary = data_dictionary_MFD) # 4456

# sapply(strsplit(serms$sermon[1], " "), length) # 3732
# lengths(gregexpr("\\W+", serms$sermon[1])) + 1 #3999
# 
# require(stringr)
# str_count(serms$sermon[1], "\\S+") #3732

# y <- quanteda.corpora::data_corpus_movies
# y <- y$documents[[1]]
# y <- y[1]
# fileConn<-file("output.txt")
# writeLines(c(y), fileConn)
# close(fileConn)

# Run moral foundation dictionary on character vector of sermons
#mfd_scores <- liwcalike(serms$sermon, tolower = TRUE,
#                        dictionary = data_dictionary_MFD)



mfd.df <- as.data.frame(matrix(nrow = length(serms$sermon), ncol = 28))
colnames(mfd.df) <- colnames(output_mfd)
mfd.scores <- output_mfd[1,]
mfd.scores[1,] <- NA
rm(output_mfd)
for (i in 1:length(serms$sermon)) {
  
  mfd.scores[1,] <- NA
  
  try(
  # Calculate MFD score for sermon
  mfd.scores <- liwcalike(serms$sermon[i], tolower = TRUE,
                          dictionary = data_dictionary_MFD))#,
  #error = function(e) {print(paste("non-numeric argument", input));
   # NaN})
  
  
  # Append values to dataframe
  mfd.df[i,] <- mfd.scores[1,]
  
  # Change doc number and segment
  mfd.df$docname[i] <- paste('sermon', as.character(i), sep = ' ')
  mfd.df$Segment[i] <- i
}

summary(is.na(mfd.df$fairness.vice))
save(mfd.df, file = 'mfd.scores.RData')

# Combine w/ sermon dataset
serms <- cbind(serms, mfd.df)
save(serms, file = 'sermons_mfd.RData')

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
