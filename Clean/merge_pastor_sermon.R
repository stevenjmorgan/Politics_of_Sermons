# This code reads in pastor meta data and merges to the sermon dataframe

rm(list=ls())
setwd("C:/Users/sum410/Dropbox/PoliticsOfSermons")
#setwd("~/GitHub/Politics_of_Sermons/Clean")

library(tm)
library(qdap)
library(dplyr)
library(ggplot2)
library(stringr)

# Read in data on pastor profiles
pastors <- read.csv('pastor_meta_hc.csv', stringsAsFactors = FALSE)
load('dedupedSerms.RData')

dim(deduped.serms)

# Merge pastor meta data into sermon df based on pastor name and denomination
serms.merge <- merge(deduped.serms, pastors, by.x = c('author', 'denom'), 
                     by.y = c('name', 'denom'), all.x = TRUE)
dim(serms.merge)

# Too many rows
#sum(!is.na(serms.merge$sermon))
serms.merge <- serms.merge[!duplicated(serms.merge$sermon),]
save(serms.merge, file = 'serms_merged.RData')

### Lexical level analysis ###
# Create dictionary of explicitly political unigrams
pat <- paste(c('abortion', 'republican', 'democrat', 'vote', 
               'candidate', 'campaign', 'gop', 'politic',
               'congress', 'poll', 'democracy', 'obama', 'clinton', 
               'government', 'constituent', 'capitalism', 'socialism',
               'liberal', 'conservative', 'beltway', 'healthcare', 
               'LGBTQ', 'policy', 'obamacare', 'partisan', 'welfare',
               'progressive', 'economic', 'economy', 'constituent',
               'senate', 'bureaucracy', 'liberties',
               'constitution', 'politics', 'legislation', 'gay marriage',
               'same sex marriage', 'political'), collapse='|')

#test <- serms.merge[0:10,]
#test$sermon <- iconv(test$sermon, "latin1", "ASCII", sub="")
#test$sermon <- tolower(test$sermon)
#test$sermon <- gsub('[[:punct:]]+',' ', test$sermon)
#test$sermon <- gsub('[[:digit:]]+', ' ', test$sermon)
#stopwords('english') <- stopwords('english')[!170]
#test$sermon <- removeWords(test$sermon, stopwords('english'))
#test$sermon <- gsub('\\b\\w{1,2}\\b', ' ', test$sermon)
#test$sermon <- stripWhitespace(test$sermon)
#test$sermon <- trimws(test$sermon)
#test$sermon[1]
#pattern <- paste(c('rejoice', 'grace'), collapse='|')
#test$find.word <- grepl(pattern, test$sermon)

# Clean full dataframe of sermons
serms.merge$sermon.clean <- iconv(serms.merge$sermon, "latin1", "ASCII", sub="") #utf-8 instead of ASCII?
serms.merge$sermon.clean <- tolower(serms.merge$sermon.clean)
serms.merge$sermon.clean <- gsub('[[:punct:]]+',' ', serms.merge$sermon.clean)
serms.merge$sermon.clean <- gsub('[[:digit:]]+', ' ', serms.merge$sermon.clean)
stopwords.new <- stopwords("english")[which(stopwords("english") != 'same')]
serms.merge$sermon.clean <- removeWords(serms.merge$sermon.clean, stopwords.new)
serms.merge$sermon.clean <- gsub('\\b\\w{1,2}\\b', ' ', serms.merge$sermon.clean)
serms.merge$sermon.clean <- stripWhitespace(serms.merge$sermon.clean)
serms.merge$sermon.clean <- trimws(serms.merge$sermon.clean)
#serms.merge$sermon.clean[1]
save(serms.merge, file = 'serms_cleaned_df.RData')

# Search for political speech in cleaned sermons (non-stemmed)
serms.merge$political <- grepl('abortion', serms.merge$sermon.clean)
summary(serms.merge$political)
serms.merge$social <- grepl('socialism', serms.merge$sermon.clean)
summary(serms.merge$social)
serms.merge$congress <- grepl('congress', serms.merge$sermon.clean)
summary(serms.merge$congress)
serms.merge$gay <- grepl('same sex marriage', serms.merge$sermon.clean)
summary(serms.merge$gay)
min(which(serms.merge$gay == TRUE))
serms.merge$poll <- grepl('poll', serms.merge$sermon.clean)

# Visualize distribution of political speech across time
tab_sum <- serms.merge %>% group_by(year) %>%
  filter(social) %>%
  summarise(trues = n())

ggplot(tab_sum, aes(year, trues, group = 1)) + geom_point(color='steelblue', size = 2) + geom_line(color='steelblue', size = 1) +
      labs(x = "Year", y = 'Frequency of "Socialism"', 
      title = 'Number of Occurences of "Socialism" in Dataset of 160,000 Sermons')
ggsave('socialism_sermon.pdf')

