### This script implements an STM on the sermons dataset.

rm(list=ls())
#setwd("C:/Users/steve/Dropbox/Dissertation/Data")
setwd("C:/Users/sum410/Dropbox/Dissertation/Data")
#setwd('C:/Users/steve/Desktop/sermon_dataset')

library(stm)

#load('final_dissertation_dataset7-27.RData')
data <- read.csv('sermons_processed.csv', stringsAsFactors = FALSE)
colnames(data)

summary(data$word.count)
data <- data[which(data$word.count > 75),]
#set.seed(24519)
#serms.merge <- data[sample(nrow(data), 200),]
serms.merge <- data

# Final cleaning
for(i in 1:nrow(serms.merge)){
  serms.merge$clean[i] <- gsub(',',' ', serms.merge$clean[i])
  serms.merge$clean[i] <- gsub('[[:punct:]]', '', serms.merge$clean[i])
  serms.merge$clean[i] <- gsub("\\s+", " ", serms.merge$clean[i])
}

## Create dtm
gc()
memory.limit()
memory.limit(size=10000000000000)


#quanteda_dtm <- quanteda::dfm(serms.merge$clean, stem = FALSE, tolower = FALSE)


# Remove original text
serms.merge <- serms.merge[,-7]
serms.merge <- serms.merge[,-7]
serms.merge <- serms.merge[,-42]

serms.merge <- serms.merge[which(serms.merge$spanish.count < 3),]

# Break out race and denom. into binary variables
serms.merge <- serms.merge[!is.na(serms.merge$gender.final),]
serms.merge <- serms.merge[which(serms.merge$gender.final != ''),]
serms.merge$female.final <- ifelse(serms.merge$gender.final == 'female', 1, 0)
unique(serms.merge$race)
serms.merge$black.final <- ifelse(serms.merge$race == 'black', 1, 0)
serms.merge$hispanic.final <- ifelse(serms.merge$race == 'hispanic', 1, 0)
serms.merge$api.final <- ifelse(serms.merge$race == 'api', 1, 0)
serms.merge$white.final <- ifelse(serms.merge$race == 'white', 1, 0)


# Convert data for stm
processed <- textProcessor(serms.merge$clean, metadata = serms.merge,
                           removestopwords = F, removenumbers = F,
                           removepunctuation = T, stem = F, lowercase = F,
                           wordLengths = c(3,Inf), striphtml = T,
                           language = 'en')
out <- prepDocuments(processed$documents, processed$vocab, processed$meta)
#docs <- out$documents
#vocab <- out$vocab
#meta <-out$meta

# Remove infrequent terms (min. 5 occurences)
#plotRemoved(processed$documents, lower.thresh = seq(1, 200, by = 100))
out <- prepDocuments(processed$documents, processed$vocab,
                     processed$meta, lower.thresh = 5)
docs <- out$documents
vocab <- out$vocab
meta <- out$meta


# Estimate stm
set.seed(24519)
poliblogPrevFit <- stm(documents = out$documents, vocab = out$vocab,
                       K = 20, prevalence =~ female.final + black.final + hispanic.final + api.final + denom.fixed,
                       max.em.its = 75, data = out$meta,
                       init.type = "Spectral")
save(poliblogPrevFit, file = 'stm_model.RData')

# Plot topics
pdf('plot_topics.pdf')
plot(poliblogPrevFit, type = "summary", xlim = c(0, .5))
dev.off()

# Analyze model
labelTopics(poliblogPrevFit, c(3, 4, 5))

prep <- estimateEffect(1:20 ~ female.final + black.final + hispanic.final + api.final + denom.fixed, poliblogPrevFit,
                       meta = out$meta, uncertainty = "Global")
summary(prep)
save(prep, 'model_results.RData')

