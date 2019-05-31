# This code loads in .JSON file and calculates initial descriptive statistics
# to discern representativeness of the corpus.

rm(list=ls())
#setwd("~/GitHub/Politics_of_Sermons/Clean")
#setwd("C:/Users/Steve/Dropbox/PoliticsOfSermons")
#setwd("C:/Users/sum410/Dropbox/PoliticsOfSermons")
#setwd("C:/Users/sum410/Dropbox/Dissertation/Data")
setwd("C:/Users/steve/Dropbox/Dissertation/Data")

library(readtext)
library(rjson)
library(jsonlite)
library(plyr)
library(stargazer)
library(ggplot2)
library(tidyverse)
library(car)
library(datasets)
library(lubridate)
#library(ngram)

# Read in .JSON of sermons and change variable names
#file <- 'C:/Users/sum410/Documents/GitHub/Politics_of_Sermons/Clean/sermon.JSON'
#file <- 'C:/Users/Steve/Dropbox/PoliticsOfSermons/Data/sermon_10-21.JSON'
#file <- 'C:/Users/sum410/Dropbox/PoliticsOfSermons/Data/sermon_10-21.JSON'
#file <- 'C:/Users/sum410/Dropbox/Dissertation/Data/sermon5-27.JSON'
file <- 'C:/Users/steve/Dropbox/Dissertation/Data/sermon5-27.JSON'
serms <- readtext(file, text_field = 'sermonData', encoding = "latin1")
#serms <- read.csv('sermon_dataset5-27.csv')

# Rename columns
colnames(serms) <- c('doc_id', 'author', 'date', 'denom', 'title', 'sermon')

# Replace blanks with NA
serms$denom[serms$denom==""] <- "NA"

# Remove duplicates
serms <- serms[!duplicated(serms[,c('author','date','denom', 'title','sermon')]),]

save(serms, file = 'sermsDF.RData')
#load('sermsDF.RData')


# Add year variable
serms$year <- sapply(strsplit(serms$date, split=', ', 
                                      fixed=TRUE), `[`, 2)


### Remove non-US sermons
pastors <- read.csv('pastor_meta_hc.csv', stringsAsFactors = FALSE)
serms.merge <- merge(serms, pastors, by.x = c('author', 'denom'), 
                     by.y = c('name', 'denom'), all.x = TRUE)
summary(is.na(serms.merge$address))
summary(is.na(serms.merge$location))
serms.merge <- serms.merge[which(!is.na(serms.merge$address)),]

# Subset data w/ geolocators outside the U.S.
serms.merge <- serms.merge[which(!grepl('*Province', serms.merge$address)),]

# Split out State location and Zip code
serms.merge <- separate(data = serms.merge, col = address, 
                        into = c("town", "state"), sep = "\\,", remove = FALSE)
serms.merge$state <- trimws(serms.merge$state)
serms.merge <- separate(data = serms.merge, col = state, 
                        into = c('state_parse', 'zip'), sep = "(?<=[a-zA-Z])\\s*(?=[0-9])", remove = FALSE)

# Remove obs. w/o zip codes
serms.merge <- serms.merge[!nchar(as.character(serms.merge$zip)) < 5,]
serms.merge <- serms.merge[which(!is.na(serms.merge$zip)),]

# Remove obs. w/ incorrect state names
serms.merge <- serms.merge[!nchar(as.character(serms.merge$state_parse)) < 3,]
serms.merge <- within(serms.merge, rm(state))

dim(serms.merge) #130380 x 17
save(serms.merge, file = 'final_serms.RData')
write.csv(serms.merge, 'us_sermons.csv')
####


# Subset from 2011-2018
#deduped.serms <- deduped.serms[which(as.integer(deduped.serms$year) >= 2011),]

# Group number of sermons in each year
year.group <- count(serms, "year")
year.group$rel <- round(100 * year.group$freq / sum(year.group$freq),2)

# Table of sermons by year
stargazer(year.group, type = 'latex', summary = FALSE, rownames = FALSE,
          covariate.labels = c('Year', '# of Sermons', '% of Corpus'), 
          column.sep.width = '10pt', digits = 2, header = FALSE)


## Month
# Convert dates to R style dates (this could be done above in lieu of sapply())
serms$date.conv <- as.Date(serms$date, '%b %d, %Y')

# Drop observations with no date
serms <- serms[!is.na(serms$date.conv),]

# Parse month and group by month, save to new df
serms$month <- as.Date(cut(serms$date.conv, breaks = "month"))
month.group <- count(serms, 'month')
month.group$relat <- round(100 * month.group$freq / sum(month.group$freq),2)

# Table of sermons by month
#stargazer(month.group, type ='text', summary = FALSE, rownames = FALSE,
#          covariate.labels = c('Month', '# of Sermons', '% of Corpus'), 
#          column.sep.width = '10pt', digits=2, header = FALSE)

# Plot by month
ggplot(data=month.group, aes(x=month, y=freq)) +
  geom_bar(stat="identity") # Make nicer


## Week
# Parse by week and group, save to new df
serms$week <- as.Date(serms$date.conv, breaks = 'week')
week.group <- count(serms, 'week')
week.group$relat <- round(100 * week.group$freq / sum(week.group$freq),2)

# Plot of sermons by week
ggplot(data=week.group, aes(x=week, y=freq)) + ylim(0, 200) +
  geom_bar(stat="identity") # Make nicer


# Group number of sermons by denomination
denom.group <- count(serms, 'denom')
denom.group$rel <- round(100 * denom.group$freq / sum(denom.group$freq),2)

# Create table
stargazer(denom.group, type ='latex', summary = FALSE, rownames = FALSE,
          covariate.labels = c('Denomination', '# of Sermons', '% of Corpus'), 
          column.sep.width = '10pt', digits=2, header = FALSE)

# Group number of sermons per pastor
pastor.group <- count(serms, 'author')

# Plot distribution of sermons per pastor
#sermonspastor<- ggplot(pastor.group[which(pastor.group$freq < 100), ], aes(x=freq)) + 
ggplot(pastor.group[which(pastor.group$freq < 35), ], aes(x=freq)) + 
  geom_histogram(binwidth=1, color="darkblue", fill="lightblue") +
  labs(x = 'Number of Sermons', y = "Pastors") + 
  ggtitle("Distribution of Sermons Uploaded by Pastor")

ggsave("sermonspastor.pdf")

# Count number of words in each sermon
# WARNING: Takes a few minutes to run
#deduped.serms$wc <- wordcount(deduped.serms$sermon, sep = " ", 
#                              count.function = sum)
serms$wc <- sapply(strsplit(serms$sermon, " "), length)
serms$unique <- lengths(lapply(strsplit(serms$sermon, 
                                                split = ' '), unique))

# Plot distribution of word counts and unique word counts for each sermon
wc.plot <- ggplot(deduped.serms[which(deduped.serms$wc <8000),], aes(x=wc)) + 
  geom_histogram(binwidth=500, color="darkblue", fill="lightblue") +
  labs(x = 'Number of Words', y = 'Number of Sermons') + 
  ggtitle("Distribution of Word Counts across Sermons")
wc.plot

ggsave("wordcountplot.pdf")

uniquewc.plot <- ggplot(deduped.serms[which(deduped.serms$unique < 2200),], aes(x=unique)) + 
  geom_histogram(binwidth=50, color="red", fill="orange") +
  labs(x = 'Number of Unique Words', y = 'Number of Sermons') + 
  ggtitle("Distribution of Unique Word Counts across Sermons")

uniquewc.plot
ggsave("uniquewordcountplot.pdf")

### Save deduped sermons df
save(deduped.serms, file = 'dedupedSerms.RData')
