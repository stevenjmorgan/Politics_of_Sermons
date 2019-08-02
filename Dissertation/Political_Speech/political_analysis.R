rm(list=ls())
setwd("C:/Users/steve/Desktop/sermon_dataset")
#setwd("C:/Users/sum410/Dropbox/Dissertation/Data")

#serms <- read.csv('sermons_pol_variable7-31.csv')
#summary(serms$pol_count)
#summary(serms$pol_count>3)
#nrow(serms[which(serms$pol_count>3),])/nrow(serms)


load('final_dissertation_dataset7-27.RData')
#write.csv(serms.merge, 'sermons_dataset.csv', row.names = F)

nrow(serms.merge)
serms.merge <- serms.merge[which(serms.merge$word.count > 75),]
nrow(serms.merge)

###############################################################################
### Political
serms.merge <- read.csv('sermons_pol_variable7-31.csv', stringsAsFactors = F)
colnames(serms.merge)

summary(serms.merge$pol_count >= 5)
pastors <- serms.merge[which(serms.merge$pol_count >= 5),]
length(unique(pastors$author))
length(unique(serms.merge$author))

serms.merge$is.pol <- ifelse(serms.merge$pol_count >= 5, 1, 0)

library(car)
serms.merge$rel.trad <- recode(serms.merge$denom.fixed, 
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

unique(serms.merge$rel.trad)
serms.merge$cath <- ifelse(serms.merge$rel.trad == 'cath', 1, 0)
serms.merge$main <- ifelse(serms.merge$rel.trad == 'mainline', 1, 0)
serms.merge$evang <- ifelse(serms.merge$rel.trad == 'evang', 1, 0)
serms.merge$other <- ifelse(serms.merge$rel.trad == 'other', 1, 0)
unique(serms.merge$race)
serms.merge$black.final <- ifelse(serms.merge$race == 'black', 1, 0)
serms.merge$hispanic.final <- ifelse(serms.merge$race == 'hispanic', 1, 0)
serms.merge$white.final <- ifelse(serms.merge$race == 'white', 1, 0)
serms.merge$api.final <- ifelse(serms.merge$race == 'api', 1, 0)

colnames(serms.merge)
unique(serms.merge$state_parse)

unique(serms.merge$gender.final)
serms.merge <- serms.merge[which(serms.merge$gender.final != ''),]
serms.merge$gender.final <- ifelse(serms.merge$gender.final == 'female', 1, 0)

# Census
# Group states by Census region
library(datasets)
state.data <- as.data.frame(matrix(c(state.name, state.abb, as.character(state.region)), 
                                   nrow = 50))
temp <- as.data.frame(matrix(c("District of Columbia", "DC", "South"), 
                             nrow = 1))
state.data <- rbind(state.data, temp)
colnames(state.data) <- c('name', 'abb', 'region')
rm(temp)

# Merge by Census region
serms.merge <- merge(serms.merge, state.data, by.x = c('state_parse'), 
                     by.y = c('name'))
serms.merge$region <- as.character(serms.merge$region)


# Models
fit <- glm(is.pol~gender.final+black.final+hispanic.final+api.final+cath+
             evang+other+region+as.factor(year), data = serms.merge,
           family = "binomial")
summary(fit)

library(stargazer)
stargazer(fit, dep.var.labels = 'Political Sermon', 
          covariate.labels= c('Female','Black', 'Hispanic', 'Asian', 'Catholic','Evangelical',
                              'Other','Northeast','South','West'))


###############################################################################

unique(serms.merge$author[which(serms.merge$gender.final == 'female')])

nrow(serms.merge[which(serms.merge$gender.final == 'female'),])
nrow(serms.merge[which(serms.merge$gender.final == 'male'),])

nrow(serms.merge[which(serms.merge$race == 'black'),])
unique(serms.merge$author[which(serms.merge$race == 'black')])

nrow(serms.merge[which(serms.merge$race == 'hispanic'),])
unique(serms.merge$author[which(serms.merge$race == 'hispanic')])

nrow(serms.merge[which(serms.merge$race == 'api'),])
unique(serms.merge$author[which(serms.merge$race == 'api')])


summary(serms.merge$word.count)
nrow(serms.merge)
serms.merge <- serms.merge[which(serms.merge$word.count<25000),]
nrow(serms.merge)

library(tidyverse)
library(ggplot2)
#gender <- serms.merge %>%
#  group_by(gender.final) %>%
#  summarise(word.count, mean)
#  summarise_at(vars(-Month), funs(mean(., na.rm=TRUE)))

library(effsize)
library(plyr)

### Male vs. female
x <- ddply(serms.merge[which(!is.na(serms.merge$gender.final)),],~gender.final,summarise,mean=mean(word.count),sd=sd(word.count))
x$gender.final[x$gender.final=='female'] = 'Female'
x$gender.final[x$gender.final=='male'] = 'Male'

t.test(serms.merge$word.count[which(serms.merge$gender.final=='male')], serms.merge$word.count[which(serms.merge$gender.final=='female')])
y <- cohen.d(serms.merge$word.count[which(serms.merge$gender.final=='male')], serms.merge$word.count[which(serms.merge$gender.final=='female')])
y$estimate
y$magnitude

t.test(word.count ~ gender.final, data=serms.merge, conf.level=.95)

ggplot(x, aes(x = gender.final, y = mean, fill = gender.final)) + 
  geom_bar(stat = "identity", position = "dodge") + theme_bw() + xlab('') + ylab('Mean Word Count') +
  guides(fill=FALSE) + ylim(c(0,2300))
ggsave('gender_wc.png')

#ggplot(x) +
#  geom_bar( aes(x=gender.final, y=mean), stat="identity", fill="skyblue", alpha=0.7) +
#  geom_errorbar( aes(x=gender.final, ymin=mean-(0.5*sd), ymax=mean+(0.5*sd)), width=0.4, colour="orange", alpha=0.9, size=1.3)


### Black vs. Non-Black
serms.merge$black.fixed <- ifelse(serms.merge$race == 'black', 'Black', 'Non-Black')
y <- ddply(serms.merge,~black.fixed,summarise,mean=mean(word.count),sd=sd(word.count))

t.test(serms.merge$word.count[which(serms.merge$black.fixed=='Black')], serms.merge$word.count[which(serms.merge$black.fixed=='Non-Black')])

ggplot(y, aes(x = black.fixed, y = mean, fill = black.fixed)) + 
  geom_bar(stat = "identity", position = "dodge") + theme_bw() + xlab('') + ylab('Mean Word Count') +
  guides(fill=FALSE) + ylim(c(0,2300))
ggsave('black_wc.png')


z <- serms.merge[which(serms.merge$race == 'black' | serms.merge$race == 'white'),]
unique(z$race)
z$race <- ifelse(z$race == 'black', 'Black', 'White')
y <- ddply(z,~race,summarise,mean=mean(word.count),sd=sd(word.count))

t.test(z$word.count[which(z$race=='Black')], z$word.count[which(z$race=='White')])


ggplot(y, aes(x = race, y = mean, fill = race)) + 
  geom_bar(stat = "identity", position = "dodge") + theme_bw() + xlab('') + ylab('Mean Word Count') +
  guides(fill=FALSE) + ylim(c(0,2300))
ggsave('black_white_wc.png')



### Hispanic
serms.merge$hispanic.fixed <- ifelse(serms.merge$race == 'hispanic', 'Hispanic', 'Non-Hispanic')
y <- ddply(serms.merge,~hispanic.fixed,summarise,mean=mean(word.count),sd=sd(word.count))

t.test(serms.merge$word.count[which(serms.merge$hispanic.fixed=='Hispanic')], serms.merge$word.count[which(serms.merge$hispanic.fixed=='Non-Hispanic')])

ggplot(y, aes(x = hispanic.fixed, y = mean, fill = hispanic.fixed)) + 
  geom_bar(stat = "identity", position = "dodge") + theme_bw() + xlab('') + ylab('Mean Word Count') +
  guides(fill=FALSE) + ylim(c(0,2300))
ggsave('hispanic_wc.png')


z <- serms.merge[which(serms.merge$race == 'hispanic' | serms.merge$race == 'white'),]
unique(z$race)
z$race <- ifelse(z$race == 'white', 'White', 'Hispanic')
y <- ddply(z,~race,summarise,mean=mean(word.count),sd=sd(word.count))

t.test(z$word.count[which(z$race=='Hispanic')], z$word.count[which(z$race=='White')])


ggplot(y, aes(x = race, y = mean, fill = race)) + 
  geom_bar(stat = "identity", position = "dodge") + theme_bw() + xlab('') + ylab('Mean Word Count') +
  guides(fill=FALSE) + ylim(c(0,2300))
ggsave('hispanic_white_wc.png')


z <- serms.merge[which(serms.merge$race == 'hispanic' | serms.merge$race == 'white'),]
unique(z$race)
unique(z$denom.fixed)
z <- z[which(z$denom.fixed != 'Catholic'),]
z$race <- ifelse(z$race == 'white', 'White', 'Hispanic')
y <- ddply(z,~race,summarise,mean=mean(word.count),sd=sd(word.count))

t.test(z$word.count[which(z$race=='Hispanic')], z$word.count[which(z$race=='White')])


ggplot(y, aes(x = race, y = mean, fill = race)) + 
  geom_bar(stat = "identity", position = "dodge") + theme_bw() + xlab('') + ylab('Mean Word Count') +
  guides(fill=FALSE) + ylim(c(0,2300))
ggsave('hispanic_white_wc.png')



###
z <- serms.merge[which(serms.merge$race == 'hispanic' | serms.merge$race == 'white'),]
unique(z$race)
unique(z$denom.fixed)
z <- z[which(z$spanish.count < 4),]
z$race <- ifelse(z$race == 'white', 'White', 'Hispanic')
y <- ddply(z,~race,summarise,mean=mean(word.count),sd=sd(word.count))

t.test(z$word.count[which(z$race=='Hispanic')], z$word.count[which(z$race=='White')])


ggplot(y, aes(x = race, y = mean, fill = race)) + 
  geom_bar(stat = "identity", position = "dodge") + theme_bw() + xlab('') + ylab('Mean Word Count') +
  guides(fill=FALSE) + ylim(c(0,2300))
ggsave('hispanic_white_wc.png')


### Number of uploads per pastor by year
unique.pastors <- numeric(20)
uploads.per.pastor <- numeric(20)
years <- unique(serms.merge$year)

for (i in 1:length(unique(serms.merge$year))) {
  
  year <- serms.merge[which(serms.merge$year == unique(serms.merge$year)[i]),]
  unique.pastors[i] <- length(unique(year$author))
  uploads.per.pastor[i] <- nrow(year)/unique.pastors[i]
  print(unique(serms.merge$year)[i])
    
}

x <- as.data.frame(cbind(years,unique.pastors,uploads.per.pastor))
x <- x[order(x$years),]
colnames(x) <- c('Year', 'Unique Pastors', 'Average # of Uploads Per Pastor')
x$Year <- as.character(x$Year)
stargazer(x, summary = F, rownames = F)
