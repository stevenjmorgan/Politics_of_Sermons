### This script downloads the 2000 and 2010 Religious Census dataset, plots
### descriptives, and merges with the sermon dataset.

rm(list=ls())
#setwd("C:/Users/sum410/Dropbox/Dissertation/Data/Census")
#setwd("C:/Users/steve/Dropbox/Dissertation/Data/Census")
setwd("C:/Users/SF515-51T/Desktop/Dissertation")

#library(foreign)
library(xlsx)

#census2010 <- read.spss('U.S. Religion Census Religious Congregations and Membership Study, 2010 (County File).SAV', 
#                        to.data.frame=TRUE)
census2010 <- read.xlsx('U.S. Religion Census Religious Congregations and Membership Study, 2010 (County File).xlsx',
                          sheetIndex = 1, stringsAsFactors = FALSE)

# Total number of congregations (2010): All denominations/groups
summary(census2010$TOTCNG)
sd(census2010$TOTCNG, na.rm = T)

# Total number of adherents (2010): All denominations/groups
summary(census2010$TOTADH)
sd(census2010$TOTADH, na.rm = T)

# Rates of adherence per 1,000 population (2010): All denominations/groups
summary(census2010$TOTRATE)
sd(census2010$TOTRATE, na.rm = T)

# State Abbreviation & Name
unique(census2010$STABBR)
unique(census2010$STNAME)

# County Code & Name
unique(census2010$CNTYCODE)
unique(census2010$CNTYNAME)
length(unique(census2010$CNTYCODE)) ### 327
length(unique(census2010$CNTYNAME)) ### 1883

# County Pop.
summary(census2010$POP2010)

# Create county-state variable
census2010$county.state <- paste(census2010$CNTYNAME, census2010$STABBR, sep = ', ')
unique(census2010$county.state)
length(unique(census2010$county.state))


#library(usmap)
library(socviz)
library(ggplot2)

#county.data <- usmap::us_map(regions = "counties")
#county.data$county.state <- paste(county.data$county, county.data$full, sep = ', ')

# Merge religion census data w/ map df
#dim(county.data)
#county.data.merge <- merge(county.data, census2010, by = 'county.state', all.x = T)
#dim(county.data.merge)

library(ggthemes)
library(tidyverse)
county_full <- left_join(county_map, county_data, by = "id")
county_full$county.state <- paste(county_full$name, county_full$state, sep = ', ')
county.data.merge <- merge(county_full, census2010, by = 'county.state', all.x = T)
summary(county.data.merge$TOTCNG)

county.data.merge$TOTCNG[is.na(county.data.merge$TOTCNG)] <- min(county.data.merge$TOTCNG, na.rm = T)
summary(county.data.merge$TOTCNG)

### Raw # of congregations by county, 2010
p <- ggplot(data = county.data.merge,
            mapping = aes(x = long, y = lat,
                          fill = TOTCNG, 
                          group = group))
p1 <- p + geom_polygon(color = "gray90", size = 0.05) + coord_equal()

p2 <- p1 + scale_fill_gradient(low="lightblue",high="darkblue")
p2 + labs(fill = "Congregations by County - 2010") +
  theme_map() +
  guides(fill = guide_legend(nrow = 1)) + 
  theme(legend.position = "bottom")
ggsave('raw_congregations_count_2010.png')


### # of congregations divided by population by county, 2010
county.data.merge$cong.by.pop <- county.data.merge$TOTCNG / county.data.merge$pop
p <- ggplot(data = county.data.merge,
            mapping = aes(x = long, y = lat,
                          fill = cong.by.pop, 
                          group = group))
p1 <- p + geom_polygon(color = "gray90", size = 0.05) + coord_equal()
p2 <- p1 + scale_fill_gradient(low="green",high="darkgreen")
p2 + labs(fill = "Congregations Density (Normalized by County Population) - 2010") +
  theme_map() +
  guides(fill = guide_legend(nrow = 1)) + 
  theme(legend.position = "bottom")
ggsave('norm_congregations_count_2010.png')


options(scipen = 999)
### Raw # of adherents by county, 2010
p <- ggplot(data = county.data.merge,
            mapping = aes(x = long, y = lat,
                          fill = TOTADH, 
                          group = group))
p1 <- p + geom_polygon(color = "gray90", size = 0.05) + coord_equal()
p2 <- p1 + scale_fill_gradient(low = "#009999", high = "#0000FF")
p2 + labs(fill = "Total Adherents Per County - 2010") +
  theme_map() +
  guides(fill = guide_legend(nrow = 1)) + 
  theme(legend.position = "bottom")
ggsave('raw_adherents_count_2010.png')


### Proportion of adherents by county (per 1,000 people), 2010
p <- ggplot(data = county.data.merge,
            mapping = aes(x = long, y = lat,
                          fill = TOTRATE, 
                          group = group))
p1 <- p + geom_polygon(color = "gray90", size = 0.05) + coord_equal()
p2 <- p1 + scale_fill_gradient(low = "#F4A582", high = "#B2182B")
p2 + labs(fill = "Rates of adherence per 1,000 population  by County - 2010") +
  theme_map() +
  guides(fill = guide_legend(nrow = 1)) + 
  theme(legend.position = "bottom")
ggsave('norm_adherents_count_2010.png')



######################################################################################################
### 2000 US Religion Census Data
######################################################################################################
#census2000 <- read.csv('Religious Congregations and Membership Study, 2000 (Counties File).csv',
#                        stringsAsFactors = FALSE)





#########################################################################################################
### Presidential Vote Share ###
#########################################################################################################
#setwd('C:/Users/sum410/Dropbox/Dissertation/Data/Vote_Share')
setwd('C:/Users/steve/Dropbox/Dissertation/Data/Vote_Share')


load('countypres_2000-2016.RData')
vote.share <- x
rm(x)

# Unique id for county and state
vote.share$county.state <- paste(vote.share$county, vote.share$state_po, sep = ', ')


### Convert from long to wide
library(tidyr)
no.candidate <- subset(vote.share, select=-c(candidate))
data_wide <- spread(no.candidate, party, candidatevotes)
rm(no.candidate, vote.share)
data_wide$dem_2pvote <- data_wide$democrat / (data_wide$democrat + data_wide$republican)
dem_vote_wide <- subset(data_wide, select=-c(republican, democrat, green))
dem_vote_wide <- dem_vote_wide[,-10]
rm(data_wide)

#x <- spread(dem_vote_wide, year, dem_2pvote)

library(reshape2)

y <- dem_vote_wide[,c(1,5,9,10)]
y <- y[!duplicated(y[c(1,3)]),]
vote.share.wide <- dcast(y, county.state + FIPS ~ year, value.var="dem_2pvote")
dem_vote_long <- dem_vote_wide
rm(dem_vote_wide, dem_vote_long, y, p, p1, p2)


#########################################################################################################
# Merge voting data to merged county file
county.data.merge <- merge(county_full, census2010, by = 'county.state', all.x = T)
rm(county_full)

dim(county.data.merge)
county.data.merge <- merge(county.data.merge, vote.share.wide, by.x = 'fips', by.y = 'FIPS', all.x = T)
dim(county.data.merge)
summary(county.data.merge$`2000`)

colnames(county.data.merge)[colnames(county.data.merge)=='2000'] <- 'dem.vote.2000'
colnames(county.data.merge)[colnames(county.data.merge)=='2004'] <- 'dem.vote.2004'
colnames(county.data.merge)[colnames(county.data.merge)=='2008'] <- 'dem.vote.2008'
colnames(county.data.merge)[colnames(county.data.merge)=='2012'] <- 'dem.vote.2012'
colnames(county.data.merge)[colnames(county.data.merge)=='2016'] <- 'dem.vote.2016'
summary(county.data.merge$TOTCNG)
rm(vote.share.wide, county_full, census2010)


#########################################################################################################
### Aggregate sermon data to county level w/ Mizzou toolkit ###
#########################################################################################################
#load('C:/Users/sum410/Dropbox/Dissertation/Data/sermons_mfd_7-30.RData')
load('C:/Users/steve/Dropbox/Dissertation/Data/sermons_mfd_7-30.RData')

serms.merge <- serms.merge[which(serms.merge$word.count > 100),]
serms.merge$zip.clean[1:10]
length(unique(serms.merge$zip.clean))

# Read in zip-to-county data
#geocorr.data <- read.csv('C:/Users/sum410/Dropbox/Dissertation/Data/Census/geocorr2014.csv', stringsAsFactors = F)
geocorr.data <- read.csv('C:/Users/steve/Dropbox/Dissertation/Data/Census/geocorr2014.csv', stringsAsFactors = F)
geocorr.data <- geocorr.data[-1,]

# Subset geocorr data to include zip code, county name, and coutny population
geocorr.data <- geocorr.data[,c('county','zcta5','cntyname','pop10', 'cntysc')]


serms.merge <- merge(serms.merge, geocorr.data, by.x = 'zip.clean', by.y = 'zcta5', all.x = T, all.y = F)
dim(serms.merge)
dim(serms.county)

serms.merge <- serms.merge[!duplicated(serms.merge$sermon),]
dim(serms.county)
unique(serms.merge$cntyname)
summary(is.na(serms.merge$cntyname))
serms.merge$cntyname[1:10]
serms.merge$zip.clean[1:10]

# Drop non-matched counties
serms.merge <- serms.merge[!is.na(serms.merge$cntyname),]
dim(serms.merge)
rm(geocorr.data)


### Merge to sermon data
colnames(serms.merge)
colnames(county.data.merge)
serms.merge$fair <- serms.merge$fairness.vice + serms.merge$fairness.virtue
unique(serms.merge$cntyname)[1:10]
unique(county.data.merge$county.state.x)[1:10]

# Remove county in county merge data, add comma in sermon dataset
county.data.merge$county.name.fixed <- gsub(' County', '', county.data.merge$county.state.x)
serms.merge$county.name.fixed <- gsub("(.*) ","\\1, \\2",serms.merge$cntyname)

#serms.merge$parish <- 0
#for (i in 1:nrow(serms.merge)) {
#  if (grepl('Parish', serms.merge$cntyname[i])) {
#    serms.merge$parish[i] <- 1
#  }
#}
#yo <- serms.merge[which(serms.merge$parish == 1),]

dim(serms.merge)
colnames(county.data.merge)

# Select variables to retain
myvars <- c('fips', 'county.state.x', 'name', 'state', 'census_region', 'pop_dens', 'pct_black',
            'pop', 'female', 'white', 'hh_income', 'su_gun4', 'TOTCNG', 'TOTADH', 'TOTRATE',
            'EVANCNG', 'EVANADH', 'EVANRATE', 'FIPS', 'STCODE', 'STABBR', 'STNAME', 'CNTYCODE', 
            'CNTYNAME', 'POP2010', 'county.state.y', 'dem.vote.2000', 'dem.vote.2004', 'dem.vote.2008',
            'dem.vote.2012', 'dem.vote.2016')
county.data.merge <- county.data.merge[myvars]
summary(county.data.merge$TOTCNG)
summary(county.data.merge$dem.vote.2000)
summary(county.data.merge$county.state.x == county.data.merge$county.state.y)


dim(county.data.merge)
deduped.county <- county.data.merge[!duplicated(county.data.merge[c(1,2)]),]
dim(deduped.county)

gc()
#memory.limit(64000)
serms.merge <- merge(serms.merge, deduped.county, by.x = 'county.name.fixed', 
           by.y = 'county.state.y', all.x = T, all.y = F)
dim(serms.merge)

summary(serms.merge$dem.vote.2016)

#### Save df
save(serms.merge, file = 'model_sermons_subset.RData')

serms.rights <- write.csv('sermon_final_rights_ml.csv', stringsAsFactors = F)


########################################################################################################
##### Rights measure
########################################################################################################

serms.rights <- read.csv('sermon_final_rights_ml.csv', stringsAsFactors = F)
serms.merge <- serms.rights
rm(serms.rights)

#summary(lm(fair~dem.vote.2000+dem.vote.2004+dem.vote.2008+dem.vote.2012+dem.vote.2016, data = serms.merge))


#### Democratic vote share variable
serms.merge$dem.share <- NA       ###
for (i in 1:nrow(serms.merge)) {
  
  if (serms.merge$year[i] < 2004) {
    serms.merge$dem.share[i] <- serms.merge$dem.vote.2000[i]
  }
  
  if (serms.merge$year[i] >= 2004 & serms.merge$year[i] < 2008) {
    serms.merge$dem.share[i] <- serms.merge$dem.vote.2004[i]
  }
  
  if (serms.merge$year[i] >= 2008 & serms.merge$year[i] < 2012) {
    serms.merge$dem.share[i] <- serms.merge$dem.vote.2008[i]
  }
  
  if (serms.merge$year[i] >= 2012 & serms.merge$year[i] < 2016) {
    serms.merge$dem.share[i] <- serms.merge$dem.vote.2012[i]
  }
  
  if (serms.merge$year[i] >= 2016) {
    serms.merge$dem.share[i] <- serms.merge$dem.vote.2016[i]
  }
}
summary(serms.merge$dem.share)
serms.merge$dem.share <- serms.merge$dem.share * 100


### Two-vote competitiveness
serms.merge$dem.comp <- abs(serms.merge$dem.share - 50)
summary(serms.merge$dem.comp)
library(scales)
serms.merge$comp.rescale <- rescale(serms.merge$dem.comp, to = c(0, 100))
summary(serms.merge$comp.rescale)


# Code rel. trad
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

serms.merge$cath <- ifelse(serms.merge$rel.trad == 'cath', 1, 0)
serms.merge$main <- ifelse(serms.merge$rel.trad == 'mainline', 1, 0)
serms.merge$evang <- ifelse(serms.merge$rel.trad == 'evang', 1, 0)
serms.merge$other <- ifelse(serms.merge$rel.trad == 'other', 1, 0)
unique(serms.merge$race)
serms.merge$black.final <- ifelse(serms.merge$race == 'black', 1, 0)
serms.merge$hispanic.final <- ifelse(serms.merge$race == 'hispanic', 1, 0)
serms.merge$white.final <- ifelse(serms.merge$race == 'white', 1, 0)
serms.merge$api.final <- ifelse(serms.merge$race == 'api', 1, 0)

### Variables for models
colnames(serms.merge)
myvars <- c('gender.final', 'pop10', 'Parenth', 'census_region',
            'pop_dens', 'pct_black', 'white.y', 'female', 'hh_income', 'su_gun4', 'TOTCNG', 
            'TOTADH', 'TOTRATE', 'EVANCNG', 'EVANADH', 'EVANRATE', 'STNAME', 'dem.share', 'year', 'fair',
            'cath', 'main', 'evang', 'other', 'black.final', 'hispanic.final', 'white.final', 'api.final',
            'rights_talk_xgboost', 'comp.rescale')
model.data <- serms.merge[myvars]

non.miss <- model.data[complete.cases(model.data),]
dim(non.miss)
non.miss$female.pastor <- ifelse(non.miss$gender.final == 'female', 1, 0)

library(stargazer)

# Dem vote share
fit1 <- glm(rights_talk_xgboost~dem.share+TOTCNG+cath+main+other+black.final+hispanic.final+api.final+female.pastor+census_region+log(pop10),
           data = non.miss)
summary(fit1)

# Competitive districts
fit2 <- glm(rights_talk_xgboost~comp.rescale+TOTCNG+cath+main+other+black.final+hispanic.final+api.final+female.pastor+census_region+log(pop10),
            data = non.miss)
summary(fit2)

stargazer(fit1, fit2, no.space = T, covariate.labels = c('Dem. Vote', 'Two Party Comp.', 'Total Churches',
                                                           'Catholic', 'Mainline Prot', 'Other Christian',
                                                           'Black', 'Hispanic', 'Asian', 'Female','Northeast',
                                                           'South','West','Log Pop.','Constant'))




##########################################################################################################
### Political events
##########################################################################################################
### Temporal Covariates

library(lubridate)

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

# Function to determine if sermon date is between election and pre-election period
is.between <- function(x,a,b){ 
  x < a & x >= b 
} 

# 3 month
#serms.merge$pre2016.3 <- ifelse(is.between(serms.merge$date.con, election[1], pre2016.3), 1, 0)
#serms.merge$pre2012.3 <- ifelse(is.between(serms.merge$date.con, election[2], pre2012.3), 1, 0)
#serms.merge$pre2008.3 <- ifelse(is.between(serms.merge$date.con, election[3], pre2008.3), 1, 0)
#serms.merge$pre2004.3 <- ifelse(is.between(serms.merge$date.con, election[4], pre2004.3), 1, 0)
#serms.merge$pre2000.3 <- ifelse(is.between(serms.merge$date.con, election[5], pre2000.3), 1, 0)
#serms.merge$elect.szn.3 <- rowSums(serms.merge[,c("pre2016.3", "pre2012.3", "pre2008.3", "pre2004.3", "pre2000.3")])

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

### Election response
serms.merge$female.pastor <- ifelse(serms.merge$gender.final == 'female', 1, 0)
fit3 <- glm(rights_talk_xgboost~elect.szn.2wk+dem.share+TOTCNG+cath+main+other+black.final+hispanic.final+api.final+female.pastor+census_region+log(pop10),
            data = serms.merge)
summary(fit3)

stargazer(fit3, no.space = T, covariate.labels = c('Elect. Season', 'Dem. Vote', 'Total Churches',
                                                         'Catholic', 'Mainline Prot', 'Other Christian',
                                                         'Black', 'Hispanic', 'Asian', 'Female','Northeast',
                                                         'South','West','Log Pop.','Constant'))



#####################################################################################################
### Religious competition
#####################################################################################################
