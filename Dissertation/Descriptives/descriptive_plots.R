### This script plots basic descriptive plots for the sermons dataset.

rm(list=ls())
#setwd("C:/Users/sum410/Dropbox/Dissertation/Data")
#setwd('C:/Users/steve/Desktop/sermon_dataset')
setwd("C:/Users/steve/Dropbox/Dissertation/Data")

library(ggplot2)
library(dplyr)
library(plyr)

load('final_dissertation_dataset7-27.RData')

setwd('C:/Users/steve/Desktop/sermon_dataset/Plots')

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
#serms.merge$wc <- sapply(strsplit(serms.merge$sermon, " "), length)
#serms$unique <- lengths(lapply(strsplit(serms$sermon, 
#                                        split = ' '), unique))
pdf('word_count.pdf')
ggplot(serms.merge[which(serms.merge$wc <8000),], aes(x=wc)) +
  geom_histogram(binwidth=500, color="darkblue", fill="lightblue") +
  labs(x = '# of Words', y = 'Sermons') #+ 
#ggtitle("Distribution of Word Counts across Sermons")









# Remove duplicates and save
serms <- serms.merge[!duplicated(serms.merge[,c('author','date','denom', 'title','sermon')]),]
save(serms, file = 'final_sermons_deduped.RData')
rm(serms.merge)

# Group by year and plot
year.group <- count(serms, "year")
ggplot(data=year.group, aes(x=year, y=freq)) +
  geom_bar(stat="identity") + theme_bw() +xlab('Year')  + ylab('# of Sermons') 
ggsave('sermons_by_year.png')

# Group by month and plot
month.group <- count(serms, 'month')
ggplot(data=month.group, aes(x=month, y=freq)) +
  geom_bar(stat="identity") + theme_bw() +xlab('Month')  + ylab('# of Sermons') 
ggsave('sermons_by_month.png')



















### Gendered differences

x <- t.test(serms.merge$word.count[which(serms.merge$gender.final == 'female')],
            serms.merge$word.count[which(serms.merge$gender.final == 'male')])
x$statistic
x$parameter
x$p.value
x$estimate[1]
x$estimate[2]
x$