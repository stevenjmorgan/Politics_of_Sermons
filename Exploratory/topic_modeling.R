# This code takes in the data frame created in loadJSON.R, creates a dtm and
# then runs LDA models.

rm(list=ls())
setwd("C:/Users/sum410/Dropbox/PoliticsOfSermons")

library(devtools)
#slam_url <- "https://cran.r-project.org/src/contrib/Archive/slam/slam_0.1-37.tar.gz"
#install_url(slam_url)
library(tm)
library(stringr)
library(topicmodels)

load('dedupedSerms.RData')

# Remove all non-graphical characters
#deduped.serms$usableText = str_replace_all(deduped.serms$sermon,"[^[:graph:]]", " ") #might need to use ""
deduped.serms$usableText <- sapply(deduped.serms$sermon,function(row) iconv(row, "latin1", "ASCII", sub=""))

# Create corpus
serm.Corp <- Corpus(VectorSource(deduped.serms$sermon))
#inspect(serm.Corp[1])

# Pre-process corpus
serm.Corp <- tm_map(serm.Corp, stripWhitespace)
serm.Corp <- tm_map(serm.Corp, content_transformer(tolower))
serm.Corp <- tm_map(serm.Corp, removeWords, stopwords("english"))
serm.Corp <- tm_map(serm.Corp, stemDocument)

# Create dtm
serm.dtm <- DocumentTermMatrix(serm.Corp)

# Look at the data
findFreqTerms(serm.dtm, 1000)

# inspect(removeSparseTerms(serm.dtm, 0.4))

### LDA

#Set parameters for Gibbs sampling
burnin <- 4000
iter <- 2000
thin <- 500
seed <-list(2003,5,63,100001,765)
nstart <- 5
best <- TRUE

#Number of topics
k <- 25

# Run LDA using Gibbs sampling
ldaOut <-LDA(serm.dtm, k, method='Gibbs', control=list(nstart=nstart, 
                                                       seed = seed, best=best, burnin = burnin, iter = iter, thin=thin))

# Write out results
# Docs to topics
ldaOut.topics <- as.matrix(topics(ldaOut))

# Top 6 terms in each topic
ldaOut.terms <- as.matrix(terms(ldaOut, 6))


### Increment topics and re-run lda
out <- NULL
topics <- NULL
terms <- NULL

for(i in seq(25,200,25)){
  k <- i
  out[[i]] <- LDA(serm.dtm, k, method='Gibbs', control=list(nstart=nstart, 
                                                            seed = seed, 
                                                            best=best, 
                                                            burnin = burnin, 
                                                            iter = iter, 
                                                            thin=thin))
  topics[[i]] <- as.matrix(topics(out[[i]))
  terms[[i]] <- as.matrix(terms(out[[i]], 6))
}

save(out, 'ldamodels.rda')
save(topics, 'topics.rda')
save(terms, 'topic_words.rda')
# Write out results
# Docs to topics
ldaOut.topics <- as.matrix(topics(ldaOut))

# Top 6 terms in each topic
ldaOut.terms <- as.matrix(terms(ldaOut,6))
