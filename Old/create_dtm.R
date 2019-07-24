# This code creates a document-term matrix of the sermon corpus.

rm(list=ls())
setwd("C:/Users/sum410/Dropbox/PoliticsOfSermons")
#setwd("~/GitHub/Politics_of_Sermons/Clean")

library(tm)
library(qdap)
library(dplyr)
library(ggplot2)
library(stringr)

# Create vector source
serms.merge$sermon_usable <- str_replace_all(serms.merge$sermon,"[^[:graph:]]", " ")
serms.merge$sermon_usable <- iconv(serms.merge$sermon, "ASCII", "UTF-8", sub="")
serm.source <- VectorSource(serms.merge$sermon)

# Create a volatile corpus: coffee_corpus (memory efficient)
serm.corpus <- VCorpus(serm.source)

# Print data on the 15th doc. in serm.corpus
serm.corpus[[15]]
#serm.corpus[[15]]$content

# Fix bad characters, create the toSpace content transformer
toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern," ",
                                                                  x))})
# Apply it for substituting the regular expression given in one of the former answers by " "
serm.corpus <- tm_map(serm.corpus,toSpace,"[^[:graph:]]")
#urlPat<-function(x) gsub("(ftp|http)(s?)://.*\\b", "", x)
#SampCrps<-tm_map(SampCrps, urlPat)

# Lowercase all documents
serm.corpus <- tm_map(serm.corpus, content_transformer(tolower))

# Remove standard English stop words
serm.corpus <- tm_map(serm.corpus, removeWords, stopwords("english"))

# Remove numbers and punctuation
serm.corpus <- tm_map(serm.corpus, content_transformer(removeNumbers))
#serm.corpus <- tm_map(serm.corpus, removeNumbers)
serm.corpus <- tm_map(serm.corpus, content_transformer(removePunctuation))

# Remove words less than three characters and strip extra whitespace
short <- function(x) gsub('\\b\\w{1,2}\\b','', x)
serm.corpus <- tm_map(serm.corpus, content_transformer(short))
serm.corpus <- tm_map(serm.corpus, content_transformer(stripWhitespace))

# Create document-term matrix
serm.dtm <- DocumentTermMatrix(serm.corpus)
save(serm.dtm, file = 'sermsDTM.RData')

# Convert serm.dtm to a matrix
serm.m <- as.matrix(serm.dtm)
