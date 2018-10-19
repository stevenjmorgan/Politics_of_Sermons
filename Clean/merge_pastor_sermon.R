# This code reads in pastor meta data and merges to the sermon dataframe

rm(list=ls())
setwd("C:/Users/sum410/Dropbox/PoliticsOfSermons")
#setwd("~/GitHub/Politics_of_Sermons/Clean")

library(tm)
library(qdap)
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
#political.words <- c('abortion', 'election', 'republican', 'democrat', 'vote', 
#                     'gay', 'candidate', 'campaign', 'gop', 'politic',
#                     'congress', 'poll', 'democracy', 'obama', 'clinton', 
#                     'government', 'constituent', 'capitalism', 'socialism',
#                     'liberal', 'conservative', 'beltway', 'healthcare', 
#                     'LGBTQ', 'policy', 'Obamacare', 'partisan', 'welfare',
#                     'progressive', 'economic', 'economy', 'constituent',
#                     'senate', 'bill', 'bureaucracy', 'liberties', 
#                     'constitution', 'Laissez-Faire', 'union', 'politics', 
#                     'political')

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
#serms.merge$political <- grepl(pat, serms.merge$sermon_usable)


test <- serms.merge[0:10,]
test$sermon <- iconv(test$sermon, "latin1", "ASCII", sub="")
test$sermon <- tolower(test$sermon)
test$sermon <- gsub('[[:punct:]]+',' ', test$sermon)
test$sermon <- gsub('[[:digit:]]+', ' ', test$sermon)
stopwords('english') <- stopwords('english')[!170]
test$sermon <- removeWords(test$sermon, stopwords('english'))
test$sermon <- gsub('\\b\\w{1,2}\\b', ' ', test$sermon)
test$sermon <- stripWhitespace(test$sermon)
test$sermon <- trimws(test$sermon)

test$sermon[1]

pattern <- paste(c('rejoice', 'grace'), collapse='|')
test$find.word <- grepl(pattern, test$sermon)

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

# Search for political speech in cleaned sermons (non-stemmed)
serms.merge$political <- grepl('abortion', serms.merge$sermon.clean)
summary(serms.merge$political)
serms.merge$social <- grepl('socialism', serms.merge$sermon.clean)
summary(serms.merge$social)
serms.merge$congress <- grepl('congress', serms.merge$sermon.clean)
summary(serms.merge$congress)
serms.merge$gay <- grepl('same sex marriages', serms.merge$sermon.clean)
summary(serms.merge$gay)


library(dplyr)
library(ggplot2)
tab_sum <- serms.merge %>% group_by(year) %>%
  filter(social) %>%
  summarise(trues = n())

ggplot(tab_sum, aes(year, trues, group = 1)) + geom_point(color='steelblue', size = 2) + geom_line(color='steelblue', size = 1) +
      labs(x = "Year", y = 'Frequency of "Socialism"', 
      title = 'Number of Occurences of "Socialism" in Dataset of 160,000 Sermons')
ggsave('socialism_sermon.pdf')

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
