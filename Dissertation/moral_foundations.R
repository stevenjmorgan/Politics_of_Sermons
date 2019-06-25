# This script runs the moral foundations dictionary on the sermons corpus.

rm(list=ls())
setwd("C:/Users/steve/Dropbox/Dissertation/Data")

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
mfd_scores <- liwcalike(serms$sermon, tolower = TRUE,
                        dictionary = data_dictionary_MFD)

mfd.df <- as.data.frame(matrix(nrow = length(serms$sermon), ncol = 28))
for (i in 1:length(serms$sermon[1:2])) {
  
  # Calculate MFD score for sermon
  mfd.scores <- liwcalike(serms$sermon[i], tolower = TRUE,
                          dictionary = data_dictionary_MFD)
  
  # Append values to dataframe
  mfd.df[i,] <- mfd.scores[1,]
}