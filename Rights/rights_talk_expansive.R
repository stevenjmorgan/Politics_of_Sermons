rm(list=ls())
setwd("C:/Users/steve/Dropbox/PoliticsOfSermons")

library(datasets)
library(stargazer)

load('serms_cleaned_df.RData')

pat <- paste(c('individual right', 'individual liberty', 'individual liberties', 
               'supreme court', 'fetus right', 'religious freedom', 
               'freedom religion','civil liberty', 'civil liberties',
               'fundamental right', 'life liberty', 'morality', 'unborn',
               'protect right', 'individual mandate', 'right life',
               'individuals right'), collapse='|')
serms.merge$rights <- grepl(pat, serms.merge$sermon.clean)
summary(serms.merge$rights)
serms.merge$rights.count <- str_count(serms.merge$sermon.clean, pat)
serms.merge$rights.stringent <- ifelse(serms.merge$rights.count < 2, 0, 1)
serms.merge$rights.tr <- ifelse(serms.merge$rights.count < 2, FALSE, TRUE)
serms.merge$ind.lib <- str_count(serms.merge$sermon.clean, 'religious freedom')

# Most rights-talk
max(serms.merge$ind.lib)
x <- serms.merge[which(serms.merge$ind.lib == max(serms.merge$ind.lib)),]

### Geographic covariates
# Subset data to only include obs. w/ geographic info
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

# Group states by Census region
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

# Create dichotomous variables for region
serms.merge$south <- recode(serms.merge$region, "'South' = 1; else = 0")
serms.merge$west <- recode(serms.merge$region, "'West' = 1; else = 0")
serms.merge$ne <- recode(serms.merge$region, "'Northeast' = 1; else = 0")
serms.merge$nc <- recode(serms.merge$region, "'North Central' = 1; else = 0")
table(serms.merge$region)

### Temporal Covariates
### Check to ensure all obs. have dates
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

tab_sum_pol <- serms.merge %>% group_by(year) %>%
  filter(rights) %>%
  summarise(trues = n())

ggplot(tab_sum_pol, aes(year, trues, group = 1)) + geom_point(color='steelblue', size = 2) + geom_line(color='steelblue', size = 1) +
  labs(x = "Year", y = 'Number of Sermons', 
       title = 'Number of Sermons Containing Rights-Talk by Year') + geom_vline(xintercept=2014, linetype="dotted")
ggsave('rights_bi.pdf')

tab_sum_pol <- serms.merge %>% group_by(year) %>%
  filter(rights.tr) %>%
  summarise(trues = n())

ggplot(tab_sum_pol, aes(year, trues, group = 1)) + geom_point(color='steelblue', size = 2) + geom_line(color='steelblue', size = 1) +
  labs(x = "Year", y = 'Number of Sermons', 
       title = 'Number of Sermons Containing at least Two Instances of Rights-Talk by Year') + geom_vline(xintercept=2014, linetype="dotted")
ggsave('rights_str.pdf')

# Group number of sermons by denomination
denom.group <- count(serms.merge, 'denom')
denom.group$rel <- round(100 * denom.group$freq / sum(denom.group$freq),2)

# Create table
stargazer(denom.group, type ='latex', summary = FALSE, rownames = FALSE,
          covariate.labels = c('Denomination', '# of Sermons', '% of Corpus'), 
          column.sep.width = '10pt', digits=2, header = FALSE)

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

# Group number of sermons by tradition
denom.group <- count(serms.merge, 'rel.trad')
denom.group$rel <- round(100 * denom.group$freq / sum(denom.group$freq),2)

# Create table
stargazer(denom.group, type ='latex', summary = FALSE, rownames = FALSE,
          covariate.labels = c('Religious Tradition', '# of Sermons', '% of Corpus'), 
          column.sep.width = '10pt', digits=2, header = FALSE)
