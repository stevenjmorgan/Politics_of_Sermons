# This code loads in .JSON file and calculates initial descriptive statistics
# to discern representativeness of the corpus.

library(readtext)
library(plyr)
library(stargazer)
library(ggplot2)
library(ngram)

# Read in .JSON of sermons and change variable names
file <- 'C:/Users/sum410/Documents/GitHub/Politics_of_Sermons/Clean/sermon.JSON'
serms <- readtext(file, text_field = 'sermonData')
colnames(serms) <- c('doc_id', 'date', 'denom', 'title', 'sermon', 'author')

# Remove duplicates (apparently none?)
deduped.serms <- unique(serms)
#deduped.serms <- serms[!duplicated(serms),]

# Add year variable
deduped.serms$year <- sapply(strsplit(deduped.serms$date, split=', ', 
                                      fixed=TRUE), `[`, 2)

# Subset from 2011-2018
deduped.serms <- deduped.serms[which(as.integer(deduped.serms$year) >= 2011),]

# Group number of sermons in each year
year.group <- count(deduped.serms, "year")
year.group$rel <- round(100 * year.group$freq / sum(year.group$freq),2)

# Table of sermons by year
stargazer(year.group, type ='text', summary = FALSE, rownames = FALSE,
          covariate.labels = c('Year', '# of Sermons', '% of Corpus'), 
          column.sep.width = '10pt', digits=2)

# Group number of sermons by denomination
denom.group <- count(deduped.serms, 'denom')
denom.group$rel <- round(100 * denom.group$freq / sum(denom.group$freq),2)

# Create table
stargazer(denom.group, type ='text', summary = FALSE, rownames = FALSE,
          covariate.labels = c('Denomination', '# of Sermons', '% of Corpus'), 
          column.sep.width = '10pt', digits=2)

# Group number of sermons per pastor
pastor.group <- count(deduped.serms, 'author')

# Plot distribution of sermons per pastor
ggplot(pastor.group[which(pastor.group$freq < 150), ], aes(x=freq)) + 
  geom_histogram(binwidth=5, color="darkblue", fill="lightblue") +
  labs(x = 'Number of Sermons', y = "Pastors") + 
  ggtitle("Distribution of Sermons Uploaded by Pastor")

# Count number of words in each sermon
#deduped.serms$wc <- wordcount(deduped.serms$sermon, sep = " ", 
#                              count.function = sum)
deduped.serms$wc <- sapply(strsplit(deduped.serms$sermon, " "), length)
deduped.serms$unique <- lengths(lapply(strsplit(deduped.serms$sermon, 
                                                split = ' '), unique))

# Plot distribution of word counts and unique word counts for each sermon
ggplot(deduped.serms[which(deduped.serms$wc <10000),], aes(x=wc)) + 
  geom_histogram(binwidth=500, color="darkblue", fill="lightblue") +
  labs(x = 'Number of Sermons', y = "Number of Words") + 
  ggtitle("Distribution of Word Counts in Sermons")

ggplot(deduped.serms[which(deduped.serms$unique < 3000),], aes(x=unique)) + 
  geom_histogram(binwidth=50, color="red", fill="orange") +
  labs(x = 'Number of Sermons', y = "Number of Unique Words") + 
  ggtitle("Distribution of Unique Word Counts in Sermons")

