rm(list=ls())
setwd("C:/Users/steve/Desktop/sermon_dataset")
#setwd("C:/Users/sum410/Dropbox/Dissertation/Data")

#serms <- read.csv('sermons_pol_variable7-31.csv')
#summary(serms$pol_count)
#summary(serms$pol_count>3)
#nrow(serms[which(serms$pol_count>3),])/nrow(serms)


load('final_dissertation_dataset7-27.RData')
#write.csv(serms.merge, 'sermons_dataset.csv', row.names = F)

serms.merge <- read.csv('sermons_processed.csv', stringsAsFactors = F)

nrow(serms.merge)
serms.merge <- serms.merge[which(serms.merge$word.count > 75),]
nrow(serms.merge)

###############################################################################
### Political
#serms.merge <- read.csv('sermons_pol_variable7-31.csv', stringsAsFactors = F)
colnames(serms.merge)

serms.merge$clean <- gsub('[[:punct:]]+', '', serms.merge$clean)
#serms.merge$clean[1]

library(stringr)
pol.dict <- paste(c('republican', 'democrat', 'congress', 'senate', 'gop', 'dem', 
              'mcconel', 'schumer', 'trumpcar', 'lawmak', 'senat', 'legisl', 
              'obama', 'racist', 'constitut', 'immigr', 'dreamer', 'daca', 
              'deport', 'muslim', 'racism', 'lgbtq', 'transgend', 'activist',
              'freedom', 'constitut', 'antilgbtq', 'liberti', 'civil', 
              'anticivil','bigotri', 'judici', 'nomine', 'gorusch', 'clinton', 
              'kennedi', 'feder','protest', 'pelosi','policymak', 'bipartisan',
              'bipartisanship','congress', 'legisl', 'medicaid', 'medicar', 
              'aca', 'democraci', 'lgbt', 'lgbtq', 'filibust', 'capitol',
              'antiimigr','obamacar','migrant', 'sanctuaryc', 'refuge','asylum',
              'salvadoran', 'elsalvador', 'detent', 'deport', 'incarcer',
              'detain','border', 'discriminatori', 'antiabort', 'welfar', 
              'grassley','politician', 'aclu', 'partisan', 'delegitim',
              'transgend', 'unborn', 'abort', 'kamala', 'vote', 'ballot', 
              'voter', 'elect','abort', 'prolif', 'environ','ideolog', 
              'kavanaugh','unconstitut', 'ideologu', 'proabort','antiabort',
              'legislatur'), collapse='|')
serms.merge$pol_count <- str_count(serms.merge$clean[1], pol.dict)

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

######### Election coding ############

summary(is.na(serms.merge$date))
class(serms.merge$date)
serms.merge$date.con <- as.Date(serms.merge$date,format='%B %d, %Y')
serms.merge$year <- year(serms.merge$date.con)
serms.merge$y2018 <- ifelse(serms.merge$year == 2018, 1, 0)
serms.merge$y2017 <- ifelse(serms.merge$year == 2017, 1, 0)
serms.merge$y2016 <- ifelse(serms.merge$year == 2016, 1, 0)
serms.merge$y2015 <- ifelse(serms.merge$year == 2015, 1, 0)
serms.merge$y2014 <- ifelse(serms.merge$year == 2014, 1, 0)
serms.merge$y2013 <- ifelse(serms.merge$year == 2013, 1, 0)
serms.merge$y2012 <- ifelse(serms.merge$year == 2012, 1, 0)
serms.merge$y2011 <- ifelse(serms.merge$year == 2011, 1, 0)
serms.merge$y2010 <- ifelse(serms.merge$year == 2010, 1, 0)
serms.merge$y2009 <- ifelse(serms.merge$year == 2009, 1, 0)
serms.merge$y2008 <- ifelse(serms.merge$year == 2008, 1, 0)
serms.merge$y2007 <- ifelse(serms.merge$year == 2007, 1, 0)
serms.merge$y2006 <- ifelse(serms.merge$year == 2006, 1, 0)
serms.merge$y2005 <- ifelse(serms.merge$year == 2005, 1, 0)
serms.merge$y2004 <- ifelse(serms.merge$year == 2004, 1, 0)
serms.merge$y2003 <- ifelse(serms.merge$year == 2003, 1, 0)
serms.merge$y2002 <- ifelse(serms.merge$year == 2002, 1, 0)
serms.merge$y2001 <- ifelse(serms.merge$year == 2001, 1, 0)
serms.merge$y2000 <- ifelse(serms.merge$year == 2000, 1, 0)

election <- as.Date(c('2016-11-08', '2012-11-06', '2008-11-04', '2004-11-02', 
                      '2000-11-07', '2014-11-04', '2010-11-02', '2006-11-07',
                      '2002-11-05'))
pre2016 <- seq(election[1], length = 2, by = "-6 months")[2]
pre2012 <- seq(election[2], length = 2, by = "-6 months")[2]
pre2008 <- seq(election[3], length = 2, by = "-6 months")[2]
pre2004 <- seq(election[4], length = 2, by = "-6 months")[2]
pre2000 <- seq(election[5], length = 2, by = "-6 months")[2]
pre2016.3 <- seq(election[1], length = 2, by = "-3 months")[2]
pre2012.3 <- seq(election[2], length = 2, by = "-3 months")[2]
pre2008.3 <- seq(election[3], length = 2, by = "-3 months")[2]
pre2004.3 <- seq(election[4], length = 2, by = "-3 months")[2]
pre2000.3 <- seq(election[5], length = 2, by = "-3 months")[2]
pre2016.1 <- seq(election[1], length = 2, by = "-1 months")[2]
pre2012.1 <- seq(election[2], length = 2, by = "-1 months")[2]
pre2008.1 <- seq(election[3], length = 2, by = "-1 months")[2]
pre2004.1 <- seq(election[4], length = 2, by = "-1 months")[2]
pre2000.1 <- seq(election[5], length = 2, by = "-1 months")[2]
pre2016.2wk <- seq(election[1], length = 2, by = "-2 weeks")[2]
pre2012.2wk <- seq(election[2], length = 2, by = "-2 weeks")[2]
pre2008.2wk <- seq(election[3], length = 2, by = "-2 weeks")[2]
pre2004.2wk <- seq(election[4], length = 2, by = "-2 weeks")[2]
pre2000.2wk <- seq(election[5], length = 2, by = "-2 weeks")[2]
pre2016.after <- seq(election[1], length = 2, by = "+2 weeks")[2]
pre2012.after <- seq(election[2], length = 2, by = "+2 weeks")[2]
pre2008.after <- seq(election[3], length = 2, by = "+2 weeks")[2]
pre2004.after <- seq(election[4], length = 2, by = "+2 weeks")[2]
pre2000.after <- seq(election[5], length = 2, by = "+2 weeks")[2]

# Calculate for midterms (1 month prior)
mid2014 <- seq(election[6], length = 2, by = "-1 months")[2]
mid2010 <- seq(election[7], length = 2, by = "-1 months")[2]
mid2006 <- seq(election[8], length = 2, by = "-1 months")[2]
mid2002 <- seq(election[9], length = 2, by = "-1 months")[2]

# Function to determine if sermon date is between election and pre-election period
is.between <- function(x,a,b){ 
  x < a & x >= b 
} 

# 6 month
serms.merge$pre2016 <- ifelse(is.between(serms.merge$date.con, election[1], pre2016), 1, 0)
serms.merge$pre2012 <- ifelse(is.between(serms.merge$date.con, election[2], pre2012), 1, 0)
serms.merge$pre2008 <- ifelse(is.between(serms.merge$date.con, election[3], pre2008), 1, 0)
serms.merge$pre2004 <- ifelse(is.between(serms.merge$date.con, election[4], pre2004), 1, 0)
serms.merge$pre2000 <- ifelse(is.between(serms.merge$date.con, election[5], pre2000), 1, 0)
serms.merge$elect.szn <- rowSums(serms.merge[,c("pre2016", "pre2012", "pre2008", "pre2004", "pre2000")])

pres <- serms.merge[which(serms.merge$elect.szn == 1),]
non <- serms.merge[which(serms.merge$elect.szn == 0),]









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
