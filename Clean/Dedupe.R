### Testing for text duplicates
### Code last updated 07/19/2018

rm(list=ls())
setwd("C:/Users/smorgan/Desktop/serm") # Where sermons .txt files are saved


# Load desired packages
library(tm)

# Read in documents stored locally; create corpus
serms <- Corpus(DirSource("C:/Users/smorgan/Desktop/serm/"), 
               readerControl = list(language='Utf-8')) #Latin
summary(serms)
length(serms)

# Remove duplicates
removeDup <- function(x) unique(x)
serms <- tm_map(serms, removeDup)

# Create dtm
serm.dtm <- DocumentTermMatrix(serms, 
                              control = list(wordLengths=c(1,Inf)))
rm(serms)
dim(serm.dtm)[1]
