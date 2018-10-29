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
#save(serms.merge, file = 'serms_merged.RData')

### Lexical level analysis ###
# Create dictionary of explicitly political unigrams
pat <- paste(c('abortion', 'republican', 'democrat', 'gun right', 'gun rights',  
               'candidate', 'campaign',
               'congress', 'democracy', 'obama', 'clinton', 
               'government', 'constituent', 'capitalism', 'socialism',
               'liberal', 'conservative', 'beltway', 'healthcare', 
               'LGBTQ', 'obamacare', 'partisan',
               'progressive', 'constituent', 'george bush', 'john kerry',
               'senate', 'bureaucracy', 'liberties',
               'constitution', 'legislation', 'gay marriage', 'donald trump',
               'same sex marriage'), collapse='|')
# 'economy', 'economic', 'policy', 'gop', 'election', 'poll', 'vote', 'politics', 'political'


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

# Measure rights-talk
# Search for political speech in cleaned sermons (non-stemmed)
serms.merge$court <- grepl('supreme court', serms.merge$sermon.clean)
summary(serms.merge$court)
serms.merge$roberts <- grepl('justice roberts', serms.merge$sermon.clean)
summary(serms.merge$roberts)
#min(which(serms.merge$roberts==1))
serms.merge$breyer <- grepl('justice breyer', serms.merge$sermon.clean)
summary(serms.merge$breyer)
serms.merge$alito <- grepl('justice alito', serms.merge$sermon.clean)
summary(serms.merge$alito)
serms.merge$ginsburg <- grepl('justice ginsburg', serms.merge$sermon.clean)
summary(serms.merge$ginsburg)
serms.merge$thomas <- grepl('justice thomas', serms.merge$sermon.clean)
summary(serms.merge$thomas)
serms.merge$sotomayor <- grepl('justice sotomayor', serms.merge$sermon.clean)
summary(serms.merge$sotomayor)
serms.merge$sotomayor <- grepl('justice kagan', serms.merge$sermon.clean)
summary(serms.merge$sotomayor)


serms.merge$justice <- grepl('court justice', serms.merge$sermon.clean)
summary(serms.merge$justice)
serms.merge$jud <- grepl('judiciary', serms.merge$sermon.clean)
summary(serms.merge$jud)

