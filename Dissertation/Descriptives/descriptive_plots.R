### This script plots basic descriptive plots for the sermons dataset.

rm(list=ls())
#setwd("C:/Users/sum410/Dropbox/Dissertation/Data")
#setwd("C:/Users/steve/Dropbox/Dissertation/Data")
setwd('C:/Users/steve/Desktop/sermon_dataset')

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
ggplot(data=month.group[which(month.group$month > "2000-10-01"),], aes(x=month, y=freq)) +
  geom_bar(stat="identity") + theme_bw() + xlab('Month') + ylab('# of Sermons')
dev.off()

# Group number of sermons by denomination
denom.group <- plyr::count(serms.merge, 'denom.x')
denom.group$rel <- round(100 * denom.group$freq / sum(denom.group$freq),2)
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
summary(serms.merge$word.count)
pdf('word_count.pdf')
ggplot(serms.merge[which(serms.merge$word.count <8000),], aes(x=word.count)) +
  geom_histogram() + theme_bw() +
  labs(x = '# of Words', y = 'Sermons') #+ 
dev.off()


### Barplot by race
summary(serms.merge$race=='white')
race.group <- plyr::count(serms.merge, 'race')

pdf('sermons_by_race.pdf')
ggplot(race.group, aes(x=race, y=freq)) +
  geom_bar(stat="identity") + theme_bw() + ylab('Sermons Preached') +
  scale_x_discrete(labels=c("Asian", "Black", 'Hispanic', 'White')) +
  xlab('Race/Ethnicity')
dev.off()


### Barplot by gender
summary(serms.merge$gender.final == 'female')
gen.group <- plyr::count(serms.merge, 'gender.final')
gen.group <- gen.group[1:2,]

pdf('sermons_by_gender.pdf')
ggplot(gen.group, aes(x=gender.final, y=freq)) +
  geom_bar(stat="identity") + theme_bw() + ylab('Sermons Preached') +
  scale_x_discrete(labels=c('Female', 'Male')) + xlab('Gender')
dev.off()

### Education
#serms.merge$phd <- 



## Recode denom. to reltrad.
serms.merge$rel.trad <- recode(serms.merge$denom, 
                               "'Evangelical/Non-Denominational' = 'evang'; 
                               'Baptist' = 'evang'; 'Apostolic' = 'evang';
                               'Lutheran' = 'mainline'; 
                               'Christian/Church Of Christ' = 'evang';
                               'Methodist' = 'mainline';
                               'Independent/Bible' = 'other'; 
                               'Pentecostal' = 'evang'; 'Nazarene' = 'evang';
                               '*other' = 'other'; 
                               'Presbyterian/Reformed' = 'mainline';
                               'Bible Church' = 'evang'; 'Catholic' = 'cath';
                               'Evangelical Free' = 'evang'; 
                               'Holiness' = 'evang'; 'Adventist' = 'evang';
                               'Assembly Of God' = 'evang';
                               'Church Of God' = 'evang';
                               'Christian Church' = 'other';
                               'United Methodist' = 'mainline';
                               'Christian Missionary Alliance' = 'evang';
                               'Foursquare' = 'evang';
                               'Seventh-Day Adventist' = 'evang';
                               'Wesleyan' = 'evang';
                               'Episcopal/Anglican' = 'mainline';
                               'Orthodox' = 'other';
                               'Charismatic' = 'evang';
                               'Free Methodist' = 'evang';
                               'Calvary Chapel' = 'evang';
                               'Brethren' = 'evang';
                               'Vineyard' = 'evang';
                               'Mennonite' = 'evang';
                               'Friends' = 'other';
                               'Anglican' = 'mainline';
                               'Congregational' = 'mainline';
                               'Disciples Of Christ' = 'mainline';
                               'Salvation Army' = 'evang';
                               'Grace Brethren' = 'other';
                               'Episcopal' = 'mainline';
                               'Other' = 'other'; else = 'other'")

### Gendered differences

x <- t.test(serms.merge$word.count[which(serms.merge$gender.final == 'female')],
            serms.merge$word.count[which(serms.merge$gender.final == 'male')])
x$statistic
x$parameter
x$p.value
x$estimate[1]
x$estimate[2]
#x$