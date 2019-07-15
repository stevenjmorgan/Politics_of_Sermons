# This script merges the sermon dataset with the pastors dataset and plots
# descriptives.

rm(list=ls())
setwd("C:/Users/sum410/Dropbox/Dissertation/Data")

library(tidyr)
library(tidyverse)
library(lubridate)
library(stargazer)

# Read in sermons dataset
#load('final_sermons_deduped.RData')
load('sermsDF.RData')
colnames(serms)

# Remove duplicate sermons
serms <- serms[!duplicated(serms[,c('sermon')]),]

# Add year variable
serms$year <- sapply(strsplit(serms$date, split=', ', 
                              fixed=TRUE), `[`, 2)

# Read in pastors dataset
pastors <- read.csv('pastors/pastor_meta7-8.csv', stringsAsFactors = F)
#write.csv(pastors, 'pastor_meta7-8.csv', row.names = F)

# Convert NA to 0
pastors[is.na(pastors)] <- 0

# Convert incorrect scraping to NA
for (i in 1:nrow(pastors)) {
  
  if (nchar(pastors$address[i]) < 3) {
    pastors$address[i] <- NA
  }
  
  if (nchar(pastors$church[i]) < 3) {
    pastors$church[i] <- NA
  }
  
  if (nchar(pastors$job[i]) < 3) {
    pastors$job[i] <- NA
  }  

  if (nchar(pastors$denom[i]) < 3) {
    pastors$denom[i] <- NA
  }
  
  if (nchar(pastors$location[i]) < 3) {
    pastors$location[i] <- NA
  }
}

# Merge datasets
dim(serms)
dim(pastors)
pastors <- pastors[!duplicated(pastors[,c('name', 'denom', 'church')]),]
dim(pastors)
serms.merge <- merge(serms, pastors, by.x = c('author'),#c('author', 'denom')
                     by.y = c('name'), all.x = TRUE, all.y = FALSE)
dim(serms.merge)
serms.merge <- serms.merge[!duplicated(serms.merge[,c('sermon')]),]
dim(serms.merge)

summary(is.na(serms.merge$address))
summary(is.na(serms.merge$location))


# Remove non-US sermons
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

dim(serms.merge) #117153 x 15



x <- subset(serms.merge, select = -c(sermon))
rm(serms)

# Split out first name
#serms.merge <- read.csv('us_sermons_7-15-19.csv')
#serms.merge$author <- as.character(serms.merge$author)
serms.merge$first.name <- ''
for (i in 1:nrow(serms.merge)) {
  serms.merge$first.name[i] <- strsplit(serms.merge$author[i], ' ')[[1]][1]
}

unique(serms.merge$first.name)
save(serms.merge, file = 'final_data_serms_7-15-19.RData')
write.csv(serms.merge, 'us_sermons_7-15-19.csv')


### Descriptives

# Group number of sermons in each year
year.group <- plyr::count(serms.merge, "year")
year.group$rel <- round(100 * year.group$freq / sum(year.group$freq),2)

# Table of sermons by year
stargazer(year.group, type = 'latex', summary = FALSE, rownames = FALSE,
          covariate.labels = c('Year', '# of Sermons', '% of Corpus'), 
          column.sep.width = '10pt', digits = 2, header = FALSE)

pdf('sermons_by_year.pdf')
ggplot(data=year.group, aes(x=year, y=freq)) +
  geom_bar(stat="identity") + theme_bw() + xlab('Year') + ylab('# of Sermons')
dev.off()

# Convert dates
serms.merge$date.conv <- as.Date(serms.merge$date, '%b %d, %Y')

# Parse month and group by month, save to new df
serms.merge$month <- as.Date(cut(serms.merge$date.conv, breaks = "month"))
month.group <- plyr::count(serms.merge, 'month')
month.group$relat <- round(100 * month.group$freq / sum(month.group$freq),2)

# Plot by month
pdf('sermons_by_month.pdf')
ggplot(data=month.group, aes(x=month, y=freq)) +
  geom_bar(stat="identity") + theme_bw() + xlab('Month') + ylab('# of Sermons')
dev.off()

# Group number of sermons by denomination
denom.group2 <- plyr::count(serms.merge, 'denom.x')
denom.group2$rel <- round(100 * denom.group2$freq / sum(denom.group2$freq),2)
#denom.group3 <- plyr::count(serms.merge, 'denom.y')
#denom.group3$rel <- round(100 * denom.group3$freq / sum(denom.group3$freq),2)

# Create table
stargazer(denom.group, type ='latex', summary = FALSE, rownames = FALSE,
          covariate.labels = c('Denomination', '# of Sermons', '% of Corpus'), 
          column.sep.width = '10pt', digits=2, header = FALSE)

# Group number of sermons per pastor
pastor.group <- plyr::count(serms.merge, 'author')

# Plot distribution of sermons per pastor
pdf('sermons_by_pastor.pdf')
ggplot(pastor.group[which(pastor.group$freq < 35),], aes(x=freq)) + 
  geom_histogram(binwidth=1) +
  labs(x = '# of Sermons', y = "Pastors") + theme_bw()# + 
  #ggtitle("Distribution of Sermons Uploaded by Pastor")
dev.off()

# Word count
serms.merge$wc <- sapply(strsplit(serms.merge$sermon, " "), length)
#serms$unique <- lengths(lapply(strsplit(serms$sermon, 
#                                        split = ' '), unique))
pdf('word_count.pdf')
ggplot(serms.merge[which(serms.merge$wc <8000),], aes(x=wc)) +
  geom_histogram(binwidth=500, color="darkblue", fill="lightblue") +
  labs(x = '# of Words', y = 'Sermons') #+ 
  #ggtitle("Distribution of Word Counts across Sermons")
