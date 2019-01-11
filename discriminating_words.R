# Create dtm w/ covariates

rm(list=ls())
setwd("C:/Users/sum410/Dropbox/PoliticsOfSermons")

library(tm)

load('merge_geo.RData')

# Alter order of columns for DataframeSource and change second column name
serms.merge <- serms.merge[,c(4, 19, 2, 3, 9, 8, 10, 11, 20)]
colnames(serms.merge)[2] <- 'text'

# Read into a corpus object from dataframe
sermon.corp <- VCorpus(DataframeSource(serms.merge))

# Stem words in documents
sermon.corp <- tm_map(sermon.corp, stemDocument)

# Create dtm from corpus object
sermon.dtm <- DocumentTermMatrix(sermon.corp)

# Inspect corpus
inspect(DocumentTermMatrix(sermon.corp,
                          list(dictionary = c("abort"))))
abort.assoc <- findAssocs(sermon.dtm, "abort", 0.1)
#findFreqTerms(sermon.dtm, 15000)

library(tidytext)
DF <- tidy(sermon.dtm)
