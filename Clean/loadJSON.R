# This code loads in .JSON file and calculates initial descriptive statistics
# to discern representativeness of the corpus.

rm(list=ls())
#setwd("~/GitHub/Politics_of_Sermons/Clean")
setwd("C:/Users/Steve/Dropbox/PoliticsOfSermons")

library(readtext)
library(plyr)
library(stargazer)
library(ggplot2)
library(ngram)

# Read in .JSON of sermons and change variable names
#file <- 'C:/Users/sum410/Documents/GitHub/Politics_of_Sermons/Clean/sermon.JSON'
file <- 'C:/Users/Steve/Dropbox/PoliticsOfSermons/sermon.JSON'
serms <- readtext(file, text_field = 'sermonData')
colnames(serms) <- c('doc_id', 'date', 'denom', 'title', 'sermon', 'author')

save(serms, file = 'sermsDF.R')
load('sermsDF.R')

# Remove duplicates
deduped.serms <- serms[!duplicated(serms$sermon),]
rm(serms)

# Add year variable
deduped.serms$year <- sapply(strsplit(deduped.serms$date, split=', ', 
                                      fixed=TRUE), `[`, 2)

# Subset from 2011-2018
deduped.serms <- deduped.serms[which(as.integer(deduped.serms$year) >= 2011),]

# Group number of sermons in each year
year.group <- count(deduped.serms, "year")
year.group$rel <- round(100 * year.group$freq / sum(year.group$freq),2)

# Table of sermons by year
stargazer(year.group, type = 'latex', summary = FALSE, rownames = FALSE,
          covariate.labels = c('Year', '# of Sermons', '% of Corpus'), 
          column.sep.width = '10pt', digits = 2, header = FALSE)


## Month
# Convert dates to R style dates (this could be done above in liue of sapply())
deduped.serms$date.conv <- as.Date(deduped.serms$date, '%b %d, %Y')

# Parse month and group by month, save to new df
deduped.serms$month <- as.Date(cut(deduped.serms$date.conv, breaks = "month"))
month.group <- count(deduped.serms, 'month')
month.group$relat <- round(100 * month.group$freq / sum(month.group$freq),2)

# Table of sermons by month
stargazer(month.group, type ='text', summary = FALSE, rownames = FALSE,
          covariate.labels = c('Month', '# of Sermons', '% of Corpus'), 
          column.sep.width = '10pt', digits=2, header = FALSE)
# Plot by month
ggplot(data=month.group, aes(x=month, y=freq)) +
  geom_bar(stat="identity") # Make nicer


## Week
# Parse by week and group, save to new df
deduped.serms$week <- as.Date(deduped.serms$date.conv, breaks = 'week')
week.group <- count(deduped.serms, 'week')
week.group$relat <- round(100 * week.group$freq / sum(week.group$freq),2)

# Plot of sermons by week
ggplot(data=week.group, aes(x=week, y=freq)) +
  geom_bar(stat="identity") # Make nicer


# Group number of sermons by denomination
denom.group <- count(deduped.serms, 'denom')
denom.group$rel <- round(100 * denom.group$freq / sum(denom.group$freq),2)

# Create table
stargazer(denom.group, type ='latex', summary = FALSE, rownames = FALSE,
          covariate.labels = c('Denomination', '# of Sermons', '% of Corpus'), 
          column.sep.width = '10pt', digits=2, header = FALSE)

# Group number of sermons per pastor
pastor.group <- count(deduped.serms, 'author')

# Plot distribution of sermons per pastor
sermonspastor<- ggplot(pastor.group[which(pastor.group$freq < 100), ], aes(x=freq)) + 
ggplot(pastor.group[which(pastor.group$freq < 150), ], aes(x=freq)) + 
  geom_histogram(binwidth=5, color="darkblue", fill="lightblue") +
  labs(x = 'Number of Sermons', y = "Pastors") + 
  ggtitle("Distribution of Sermons Uploaded by Pastor")

ggsave("sermonspastor.pdf")

# Count number of words in each sermon
#deduped.serms$wc <- wordcount(deduped.serms$sermon, sep = " ", 
#                              count.function = sum)
deduped.serms$wc <- sapply(strsplit(deduped.serms$sermon, " "), length)
deduped.serms$unique <- lengths(lapply(strsplit(deduped.serms$sermon, 
                                                split = ' '), unique))

# Plot distribution of word counts and unique word counts for each sermon
wc.plot <- ggplot(deduped.serms[which(deduped.serms$wc <10000),], aes(x=wc)) + 
ggplot(deduped.serms[which(deduped.serms$wc <10000),], aes(x=wc)) + 
  geom_histogram(binwidth=500, color="darkblue", fill="lightblue") +
  labs(x = 'Number of Sermons', y = "Number of Words") + 
  ggtitle("Distribution of Word Counts in Sermons")

ggsave("wordcountplot.pdf")

uniquewc.plot <- ggplot(deduped.serms[which(deduped.serms$unique < 3000),], aes(x=unique)) + 
ggplot(deduped.serms[which(deduped.serms$unique < 3000),], aes(x=unique)) + 
  geom_histogram(binwidth=50, color="red", fill="orange") +
  labs(x = 'Number of Sermons', y = "Number of Unique Words") + 
  ggtitle("Distribution of Unique Word Counts in Sermons")

ggsave("uniquewordcountplot.pdf")
