### This script downloads the 2000 and 2010 Religious Census dataset, plots
### descriptives, and merges with the sermon dataset.

rm(list=ls())
setwd("C:/Users/sum410/Dropbox/Dissertation/Data/Census")

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
setwd('C:/Users/sum410/Dropbox/Dissertation/Data/Vote_Share')

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
load('C:/Users/sum410/Dropbox/Dissertation/Data/sermons_mfd_7-30.RData')

serms.merge <- serms.merge[which(serms.merge$word.count > 100),]
serms.merge$zip.clean[1:10]
length(unique(serms.merge$zip.clean))

# Read in zip-to-county data
geocorr.data <- read.csv('C:/Users/sum410/Dropbox/Dissertation/Data/Census/geocorr2014.csv', stringsAsFactors = F)
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


### Variables for models
colnames(serms.merge)
myvars <- c('api', 'black', 'hispanic', 'white.x', 'gender.final', 'pop10', 'Parenth', 'census_region',
            'pop_dens', 'pct_black', 'white.y', 'female', 'hh_income', 'su_gun4', 'TOTCNG',
            'TOTADH', 'TOTRATE', 'EVANCNG', 'EVANADH', 'EVANRATE', 'STNAME', 'dem.share', 'year', 'fair')
model.data <- serms.merge[myvars]

non.miss <- model.data[complete.cases(model.data),]
dim(non.miss)

fit1 <- lm(fair~)
