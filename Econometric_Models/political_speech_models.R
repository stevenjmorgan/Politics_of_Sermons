# This script cleans covariate data from the merged sermon-pastor dataset and
# models political speech of sermons as a function of covariates.

rm(list=ls())

#setwd("C:/Users/steve/Dropbox/PoliticsOfSermons")
setwd("C:/Users/sum410/Dropbox/PoliticsOfSermons")

library(tidyverse)
library(car)
library(datasets)
library(lubridate)

load('political_sermons_data.RData')

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

save(serms.merge,file='final_clean.RData')
#####


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

# Calculate dates 1-, 3-, and 6-months out from presidential elections
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

# 3 month
serms.merge$pre2016.3 <- ifelse(is.between(serms.merge$date.con, election[1], pre2016.3), 1, 0)
serms.merge$pre2012.3 <- ifelse(is.between(serms.merge$date.con, election[2], pre2012.3), 1, 0)
serms.merge$pre2008.3 <- ifelse(is.between(serms.merge$date.con, election[3], pre2008.3), 1, 0)
serms.merge$pre2004.3 <- ifelse(is.between(serms.merge$date.con, election[4], pre2004.3), 1, 0)
serms.merge$pre2000.3 <- ifelse(is.between(serms.merge$date.con, election[5], pre2000.3), 1, 0)
serms.merge$elect.szn.3 <- rowSums(serms.merge[,c("pre2016.3", "pre2012.3", "pre2008.3", "pre2004.3", "pre2000.3")])

# 1 month
serms.merge$pre2016.1 <- ifelse(is.between(serms.merge$date.con, election[1], pre2016.1), 1, 0)
serms.merge$pre2012.1 <- ifelse(is.between(serms.merge$date.con, election[2], pre2012.1), 1, 0)
serms.merge$pre2008.1 <- ifelse(is.between(serms.merge$date.con, election[3], pre2008.1), 1, 0)
serms.merge$pre2004.1 <- ifelse(is.between(serms.merge$date.con, election[4], pre2004.1), 1, 0)
serms.merge$pre2000.1 <- ifelse(is.between(serms.merge$date.con, election[5], pre2000.1), 1, 0)
serms.merge$elect.szn.1 <- rowSums(serms.merge[,c("pre2016.1", "pre2012.1", "pre2008.1", "pre2004.1", "pre2000.1")])

# 2 weeks
serms.merge$pre2016.2wk <- ifelse(is.between(serms.merge$date.con, election[1], pre2016.2wk), 1, 0)
serms.merge$pre2012.2wk <- ifelse(is.between(serms.merge$date.con, election[2], pre2012.2wk), 1, 0)
serms.merge$pre2008.2wk <- ifelse(is.between(serms.merge$date.con, election[3], pre2008.2wk), 1, 0)
serms.merge$pre2004.2wk <- ifelse(is.between(serms.merge$date.con, election[4], pre2004.2wk), 1, 0)
serms.merge$pre2000.2wk <- ifelse(is.between(serms.merge$date.con, election[5], pre2000.2wk), 1, 0)
serms.merge$elect.szn.2wk <- rowSums(serms.merge[,c("pre2016.2wk", "pre2012.2wk", "pre2008.2wk", "pre2004.2wk", "pre2000.2wk")])

# 2 weeks after
serms.merge$pre2016.after <- ifelse(is.between(serms.merge$date.con, pre2016.after, election[1]), 1, 0)
serms.merge$pre2012.after <- ifelse(is.between(serms.merge$date.con, pre2012.after, election[2]), 1, 0)
serms.merge$pre2008.after <- ifelse(is.between(serms.merge$date.con, pre2008.after, election[3]), 1, 0)
serms.merge$pre2004.after <- ifelse(is.between(serms.merge$date.con, pre2004.after, election[4]), 1, 0)
serms.merge$pre2000.after <- ifelse(is.between(serms.merge$date.con, pre2000.after, election[5]), 1, 0)
serms.merge$elect.szn.after <- rowSums(serms.merge[,c("pre2016.after", "pre2012.after", "pre2008.after", "pre2004.after", "pre2000.after")])

# Midterm (1 month prior)
serms.merge$mid2014 <- ifelse(is.between(serms.merge$date.con, election[6], mid2014), 1, 0)
serms.merge$mid2010 <- ifelse(is.between(serms.merge$date.con, election[7], mid2010), 1, 0)
serms.merge$mid2006 <- ifelse(is.between(serms.merge$date.con, election[8], mid2006), 1, 0)
serms.merge$mid2002 <- ifelse(is.between(serms.merge$date.con, election[9], mid2002), 1, 0)
serms.merge$midterm <- rowSums(serms.merge[,c("mid2014", "mid2010", "mid2006", "mid2002")])


### Denomination covariates
# Bin denominations by religious traditions
unique(serms.merge$denom)

# Based on: Kellstedt, Lyman A., and John C. Green. 1993. "Knowing God's Many
# People: Denominational Preference and Political Behavior." In Rediscovering 
# the Religious Factor in American Politics, ed. David C. Leege and Lyman A. 
# Kellstedt. Armonk, NY: M.E. Sharpe.
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
table(serms.merge$rel.trad)

# Create dichotomous variables for religious traditions
serms.merge$evang <- recode(serms.merge$rel.trad, "'evang' = 1; else = 0")
serms.merge$main <- recode(serms.merge$rel.trad, "'mainline' = 1; else = 0")
serms.merge$cath <- recode(serms.merge$rel.trad, "'cath' = 1; else = 0")
serms.merge$other <- recode(serms.merge$rel.trad, "'other' = 1; else = 0")

save(serms.merge, file = 'sermons_covariates_final.RData')
colnames(serms.merge)
serms.merge <- serms.merge[,-c(20:55)] 
colnames(serms.merge)

# Dictionary-based approach to measuring rights talk
pat <- paste(c('individual right', 'individual liberty', 'individual liberties', 
               'supreme court', 'fetus right', 'religious freedom', 
               'freedom religion','civil liberty', 'civil liberties',
               'fundamental right', 'life liberty', 'unborn', 'abortion',
               'protect right', 'individual mandate', 'right life',
               'individuals right', 'our right', 'your right', 'liberals',
               'my right'), collapse='|')

serms.merge$rights.talk.count <- str_count(serms.merge$sermon.clean, pat)
summary(serms.merge$rights.talk.count)
serms.merge$rights.stringent <- ifelse(serms.merge$rights.talk.count < 1, 0, 1)
summary(serms.merge$rights.stringent==1)


### Model political content overall
# Logit model
logit.pc <- glm(pol.docs ~ evang + other + cath + south + west + nc, 
                family = binomial(link = 'logit'), data = serms.merge)
summary(logit.pc)

#logit.main <- glm(pol.docs ~ evang + main + cath + south + west + nc, 
#                family = binomial(link = 'logit'), data = serms.merge)
#summary(logit.main)

# Logit model w/ 6-month pre-election covariates
logit.6mo <- glm(pol.docs ~ evang + other + cath + south + west + nc + 
                 elect.szn, family = binomial(link = 'logit'), 
                 data = serms.merge)
summary(logit.6mo)

# Logit model w/ 6-month pre-election covariates interacted w/ evangelical
logit.6mo.evan <- glm(pol.docs ~ evang + other + cath + south + west + nc + 
                   elect.szn + evang:elect.szn, 
                   family = binomial(link = 'logit'), data = serms.merge)
summary(logit.6mo.evan)

# Logit model w/ 3-month pre-election covariates
logit.3mo <- glm(pol.docs ~ evang + other + cath + south + west + nc + 
                   elect.szn.3, family = binomial(link = 'logit'), 
                 data = serms.merge)
summary(logit.3mo)

# Logit model w/ 3-month pre-election interacted w/ evangelical
logit.3mo.evan <- glm(pol.docs ~ evang + other + cath + south + west + nc + 
                        elect.szn.3 + evang:elect.szn.3, 
                      family = binomial(link = 'logit'), data = serms.merge)
summary(logit.3mo.evan)

# Logit model w/ 1-month pre-election covariates
logit.1mo <- glm(pol.docs ~ evang + other + cath + south + west + nc + 
                   elect.szn.1, family = binomial(link = 'logit'), 
                 data = serms.merge)
summary(logit.1mo)

# Logit model w/ 1-month pre-election interacted w/ evangelical
logit.1mo.evan <- glm(pol.docs ~ evang + other + cath + south + west + nc + 
                   elect.szn.1 + evang:elect.szn.1, 
                   family = binomial(link = 'logit'), data = serms.merge)
summary(logit.1mo.evan)

# Logit model w/ 2-week pre-election covariate
logit.2wk <- glm(pol.docs ~ evang + other + cath + south + west + nc + 
                 elect.szn.2wk, 
                 family = binomial(link = 'logit'), data = serms.merge)
summary(logit.2wk)


# Logit model w/ 2 week pre-election interacted w/ evangelical
logit.2wk.evan <- glm(pol.docs ~ evang + other + south + west + nc + 
                        elect.szn.2wk + evang:elect.szn.2wk, 
                      family = binomial(link = 'logit'), data = serms.merge)
summary(logit.2wk.evan)
stargazer(logit.2wk.evan, no.space=TRUE)

# Logit model w/ after election covariate
logit.after <- glm(pol.docs ~ evang + other + cath + south + west + nc + 
                   elect.szn.after, 
                 family = binomial(link = 'logit'), data = serms.merge)
summary(logit.after)


# Logit model w/ after election interacted w/ evangelical
logit.after.evan <- glm(pol.docs ~ evang + other + cath + south + west + nc + 
                          elect.szn.after + evang:elect.szn.after, 
                      family = binomial(link = 'logit'), data = serms.merge)
summary(logit.after.evan)


### Modeling abortion-speak
# Logit model
logit.abort <- glm(abort ~ evang + cath + other+ south + west + nc, 
                family = binomial(link = 'logit'), data = serms.merge)
summary(logit.abort)

# Six-months out of election
logit.abort.6 <- glm(abort ~ evang + cath + other+ south + west + nc + elect.szn, 
                   family = binomial(link = 'logit'), data = serms.merge)
summary(logit.abort.6)

# 2 weeks before elction interacted w/ evangelical
logit.abort.2wk.int <- glm(abort ~ evang + cath + other+ south + west + nc + 
                        elect.szn.2wk + evang:elect.szn.2wk, 
                     family = binomial(link = 'logit'), data = serms.merge)
summary(logit.abort.2wk.int)

# Model by year
logit.pc.yr <- glm(pol.docs ~ evang + other + cath + south + west + nc + y2016 +
                     y2015 + y2014 + y2013 + y2012 + y2011 + y2010 + y2009 + 
                     y2008 + y2007 + y2006 + y2005 + y2004 + y2003 + y2002 +
                     y2001 + y2000, 
                family = binomial(link = 'logit'), data = serms.merge)
summary(logit.pc.yr)


# Model 1-month prior to midterm elections
logit.mid <- glm(pol.docs ~ evang + other + cath + south + west + nc + 
                     midterm, 
                   family = binomial(link = 'logit'), data = serms.merge)
summary(logit.mid)

# Model 1-month prior to midterm elections interacted w/ evangelical
logit.mid.int <- glm(pol.stringent.bi ~ evang + other + cath + south + west + nc + 
                   midterm + evang:midterm, 
                 family = binomial(link = 'logit'), data = serms.merge)
summary(logit.mid.int)


### Model rule of three-based measure of political speech
library(Zelig)
serms.merge$stringent.dich <- ifelse(serms.merge$pol.stringent.bi == TRUE, 1, 0)
re.logit <- zelig(stringent.dich ~ evang + other + south + west + nc +
                    elect.szn.2wk + evang:elect.szn.2wk, model = 'relogit', 
                  data = serms.merge,
                  tau = 3432/86723, case.control = c('weighting'))
summary(re.logit)

tab_sum_pol <- serms.merge %>% group_by(year) %>%
  filter(pol.stringent.bi) %>%
  summarise(trues = n())

ggplot(tab_sum_pol, aes(year, trues, group = 1)) + geom_point(color='steelblue', size = 2) + geom_line(color='steelblue', size = 1) +
  labs(x = "Year", y = 'Number of Sermons', 
       title = 'Number of Sermons with Political Content by Year')
ggsave('pol_binary_stringent_sermon.pdf')

library(dotwhisker)
dwplot(logit.2wk.evan, conf.level = .90,
       vline = geom_vline(xintercept = 0, colour = "grey60", linetype = 2)) %>% # plot line at zero _behind_ coefs
  relabel_predictors(c(evang = "Evangelical",                       
                       other = "Other/Non-Denom.", 
                       south = "South", 
                       west = "West", 
                       nc = "North Central", 
                       elect.szn.2wk = "Election in 4 Weeks",
                       'evang:elect.szn.2wk' = "Evangelical * Election"))
ggsave('logit_dotplot.pdf')

save(serms.merge, file = 'merge_geo.RData')

keep <- c('sermon.clean', 'pol.docs')
subSerms <- serms.merge[, which(names(serms.merge) %in% keep)]
save(subSerms, file = 'subsetSerms.RData')
