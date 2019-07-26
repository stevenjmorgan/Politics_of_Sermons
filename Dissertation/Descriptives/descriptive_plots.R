# This script plots basic descriptive plots for the sermons dataset.

rm(list=ls())
setwd("C:/Users/steve/Dropbox/PoliticsOfSermons")

library(ggplot2)
library(dplyr)
library(plyr)

load('final_serms.RData')

setwd("C:/Users/steve/Dropbox/Dissertation/Data")

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
