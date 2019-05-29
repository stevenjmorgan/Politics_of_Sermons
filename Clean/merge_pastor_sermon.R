# This code reads in pastor meta data and merges to the sermon dataframe

rm(list=ls())
setwd("C:/Users/steve/Dropbox/PoliticsOfSermons")
#setwd("C:/Users/sum410/Dropbox/PoliticsOfSermons")
#setwd("~/GitHub/Politics_of_Sermons/Clean")

library(tm)
library(qdap)
library(dplyr)
library(ggplot2)
library(stringr)

# Read in data on pastor profiles
pastors <- read.csv('pastor_meta_hc.csv', stringsAsFactors = FALSE)
load('dedupedSerms.RData')

deduped.serms <- serms
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
save(serms.merge, file = 'serms_cleaned_df.RData')

# Search for political speech in cleaned sermons (non-stemmed)
serms.merge$abort <- grepl('abortion', serms.merge$sermon.clean)
summary(serms.merge$abort)
serms.merge$rep <- grepl('republican', serms.merge$sermon.clean)
summary(serms.merge$rep)
serms.merge$dem <- grepl('democrat', serms.merge$sermon.clean)
summary(serms.merge$dem)
serms.merge$gun <- grepl('gun right', serms.merge$sermon.clean)
summary(serms.merge$gun)
serms.merge$candidate <- grepl('candidate', serms.merge$sermon.clean)
summary(serms.merge$candidate)
serms.merge$campaign <- grepl('campaign', serms.merge$sermon.clean)
summary(serms.merge$campaign)
serms.merge$congress <- grepl('congress', serms.merge$sermon.clean)
summary(serms.merge$congress)
serms.merge$democracy <- grepl('democracy', serms.merge$sermon.clean)
summary(serms.merge$democracy)
serms.merge$obama <- grepl('obama', serms.merge$sermon.clean)
summary(serms.merge$obama)
serms.merge$clinton <- grepl('clinton', serms.merge$sermon.clean)
summary(serms.merge$clinton)
serms.merge$government <- grepl('government', serms.merge$sermon.clean)
summary(serms.merge$government)
serms.merge$constituent <- grepl('constituent', serms.merge$sermon.clean)
summary(serms.merge$constituent)
serms.merge$capitalism <- grepl('capitalism', serms.merge$sermon.clean)
summary(serms.merge$capitalism)
serms.merge$social <- grepl('socialism', serms.merge$sermon.clean)
summary(serms.merge$social)
serms.merge$liberal <- grepl('liberal', serms.merge$sermon.clean)
summary(serms.merge$liberal)
serms.merge$conservative <- grepl('conservative', serms.merge$sermon.clean)
summary(serms.merge$conservative)
serms.merge$beltway <- grepl('beltway', serms.merge$sermon.clean)
summary(serms.merge$beltway)
serms.merge$healthcare <- grepl('healthcare', serms.merge$sermon.clean)
summary(serms.merge$healthcare)
serms.merge$LGBTQ <- grepl('LGBTQ', serms.merge$sermon.clean)
summary(serms.merge$LGBTQ)
serms.merge$obamacare <- grepl('obamacare', serms.merge$sermon.clean)
summary(serms.merge$obamacare)
serms.merge$partisan <- grepl('partisan', serms.merge$sermon.clean)
summary(serms.merge$partisan)
serms.merge$progressive <- grepl('progressive', serms.merge$sermon.clean)
summary(serms.merge$progressive)
serms.merge$bush <- grepl('george bush', serms.merge$sermon.clean)
summary(serms.merge$bush)
serms.merge$gore <- grepl('al gore', serms.merge$sermon.clean)
summary(serms.merge$gore)
serms.merge$romney <- grepl('romney', serms.merge$sermon.clean)
summary(serms.merge$romney)
serms.merge$kerry <- grepl('john kerry', serms.merge$sermon.clean)
summary(serms.merge$kerry)
serms.merge$senate <- grepl('senate', serms.merge$sermon.clean)
summary(serms.merge$senate)
serms.merge$bureaucracy <- grepl('bureaucracy', serms.merge$sermon.clean)
summary(serms.merge$bureaucracy)
serms.merge$liberties <- grepl('liberties', serms.merge$sermon.clean)
summary(serms.merge$liberties)
serms.merge$constitution <- grepl('constitution', serms.merge$sermon.clean)
summary(serms.merge$constitution)
serms.merge$legislation <- grepl('legislation', serms.merge$sermon.clean)
summary(serms.merge$legislation)
serms.merge$gay <- grepl('gay marriage', serms.merge$sermon.clean)
summary(serms.merge$gay)
serms.merge$djt <- grepl('donald trump', serms.merge$sermon.clean)
summary(serms.merge$djt)
serms.merge$ssm <- grepl('same sex marriage', serms.merge$sermon.clean)
summary(serms.merge$ssm)
serms.merge$mccain <- grepl('john mccain', serms.merge$sermon.clean)
summary(serms.merge$mccain)


# Binary measure of whether sermons contain any political content
serms.merge$pol.docs <- grepl(pat, serms.merge$sermon.clean)
serms.merge$pol.count <- str_count(serms.merge$sermon.clean, pat)
# 3 or more pol. terms as criteria for binary: 3.8%
serms.merge$pol.stringent.bi <- ifelse(serms.merge$pol.count < 3, FALSE, TRUE) 
summary(serms.merge$pol.docs)
summary(serms.merge$pol.count)
summary(serms.merge$pol.stringent.bi)

drops <- c('job','social', 'congress', 'poll', 'liber', 'pol.gen')
serms.merge <- serms.merge[, !names(serms.merge) %in% drops]
colnames(serms.merge)

save(serms.merge, file = 'political_sermons_data.RData')

# Visualize distribution of political speech across time
# Might want to normalize by total number of sermons in each year
tab_sum_pol <- serms.merge %>% group_by(year) %>%
  filter(pol.docs) %>%
  summarise(trues = n())

ggplot(tab_sum_pol, aes(year, trues, group = 1)) + geom_point(color='steelblue', size = 2) + geom_line(color='steelblue', size = 1) +
  labs(x = "Year", y = 'Number of Sermons', 
       title = 'Number of Sermons with Political Content by Year')
ggsave('pol_binary_sermon.pdf')

count.pol.words <- aggregate(serms.merge$pol.count, by=list(Category=serms.merge$year), FUN=sum)
ggplot(count.pol.words, aes(Category, x, group = 1)) + geom_point(color='steelblue', size = 2) + geom_line(color='steelblue', size = 1) +
  labs(x = "Year", y = 'Count of Political Words', 
       title = 'Count of Political Words by Year')
ggsave('pol_count_sermon.pdf')



# Sermons on socialism
tab_sum <- serms.merge %>% group_by(year) %>%
  filter(social) %>%
  summarise(trues = n())

ggplot(tab_sum, aes(year, trues, group = 1)) + geom_point(color='steelblue', size = 2) + geom_line(color='steelblue', size = 1) +
      labs(x = "Year", y = 'Frequency of "Socialism"', 
      title = 'Number of Occurences of "Socialism" in Dataset of 160,000 Sermons')
ggsave('socialism_sermon.pdf')

