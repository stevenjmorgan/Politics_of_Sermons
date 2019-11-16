### This script downloads the 2000 and 2010 Religious Census dataset, plots
### descriptives, and merges with the sermon dataset.

rm(list=ls())
#setwd("C:/Users/sum410/Dropbox/Dissertation/Data/Census")
#setwd("C:/Users/steve/Dropbox/Dissertation/Data/Census")
setwd("C:/Users/SF515-51T/Desktop/Dissertation")

library(foreign)
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
length(unique(census2010$STABBR))
length(unique(census2010$STNAME))

# County Code & Name
unique(census2010$CNTYCODE)
unique(census2010$CNTYNAME)
length(unique(census2010$CNTYCODE)) ### 327
length(unique(census2010$CNTYNAME)) ### 1883

# FIPS
unique(census2010$FIPS)
length(unique(census2010$FIPS)) ### 3149
nrow(census2010) ### 3149

# County Pop.
summary(census2010$POP2010) # NA = 6

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

#### Maybe merge on FIPS???
county_full <- left_join(county_map, county_data, by = "id")
county_full$county.state <- paste(county_full$name, county_full$state, sep = ', ')
#county.data.merge <- merge(county_full, census2010, by = 'county.state', all.x = T)
#dim(county.data.merge) #191382 x 607
#summary(county.data.merge$TOTCNG) # NA = 1414
#rm(county.data.merge)

# Add zero to front of four digit characters
census2010$FIPS <- as.character(census2010$FIPS)
summary(nchar(census2010$FIPS)==4) #320
for (i in 1:nrow(census2010)) {
  if (nchar(census2010$FIPS[i]) == 4) {
    census2010$FIPS[i] <- paste(0,census2010$FIPS[i],sep='')
  }
}
summary(nchar(census2010$FIPS)==4) #0
summary(nchar(census2010$FIPS)==5) #3149


county.data.merge <- merge(county_full, census2010, by.x = 'id', by.y = 'FIPS', all.x = T)
dim(county.data.merge) #191382 x 607
summary(county.data.merge$TOTCNG) # NA = 0!!!

summary(!is.na(county.data.merge$TOTCNG)) # NA = 0
summary(!is.na(county.data.merge$POP2010)) # NA = 0
#x <- county.data.merge[!duplicated(county.data.merge$id),]
#summary(!is.na(x$TOTCNG)) # NA = 0

#county.data.merge$TOTCNG[is.na(county.data.merge$TOTCNG)] <- min(county.data.merge$TOTCNG, na.rm = T)
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
ggsave('raw_congregations_count_2010_11-15.png')


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
ggsave('norm_congregations_count_2010_11-15.png')


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
ggsave('raw_adherents_count_2010_11-15.png')


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
ggsave('norm_adherents_count_2010_11-15.png')



######################################################################################################
### 2000 US Religion Census Data
######################################################################################################
#census2000 <- read.csv('Religious Congregations and Membership Study, 2000 (Counties File).csv',
#                        stringsAsFactors = FALSE)




#########################################################################################################
### Presidential Vote Share ###
#########################################################################################################
#setwd('C:/Users/sum410/Dropbox/Dissertation/Data/Vote_Share')
#setwd('C:/Users/steve/Dropbox/Dissertation/Data/Vote_Share')
setwd("C:/Users/SF515-51T/Desktop/Dissertation/Vote_Share")

# Read in county-by-county presidential vote share
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
### AGAIN -> I'd use FIPS here!
#county.data.merge1 <- merge(county_full, census2010, by = 'county.state', all.x = T)
#county.data.merge1 <- merge(county_full, census2010, by.x = 'id', by.y = 'FIPS', all.x = T)
#dim(county.data.merge1)
#setdiff(colnames(county.data.merge), colnames(county.data.merge1))
#dim(county.data.merge)
rm(county_full)

dim(county.data.merge)


# Add zero to front of four digit characters
county.data.merge$fips <- as.character(county.data.merge$fips)
summary(nchar(county.data.merge$fips)==4) #34044
for (i in 1:nrow(county.data.merge)) {
  if (nchar(county.data.merge$fips[i]) == 4) {
    county.data.merge$fips[i] <- paste(0,county.data.merge$fips[i],sep='')
  }
}
summary(nchar(county.data.merge$fips)==4) #0
summary(nchar(county.data.merge$fips)==5) #all


vote.share.wide$FIPS <- as.character(vote.share.wide$FIPS)
summary(nchar(vote.share.wide$FIPS)==4) #327
for (i in 1:nrow(vote.share.wide)) {
  if (nchar(vote.share.wide$FIPS[i]) == 4 & !is.na(vote.share.wide$FIPS[i])) {
    vote.share.wide$FIPS[i] <- paste(0,vote.share.wide$FIPS[i],sep='')
  }
}
summary(nchar(vote.share.wide$FIPS)==4) #0
summary(nchar(vote.share.wide$FIPS)==5) #all

vote.share.wide <- vote.share.wide[!is.na(vote.share.wide$FIPS),]
summary(nchar(vote.share.wide$FIPS)==5) #all

# Merge voting data
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
rm(vote.share.wide, census2010)

summary(county.data.merge$TOTCNG) # NA = 0
unique(county.data.merge$state)
unique(county.data.merge$STABBR)
length(unique(county.data.merge$STABBR))

# Deduplicated df
length(unique(county.data.merge$fips)) # 3143
dedup.county <- county.data.merge[!duplicated(county.data.merge$fips),]
nrow(dedup.county) #3143
save(dedup.county, file = 'deduped_merge_county.RData')


### Maybe calculate religious economies measure here???


#########################################################################################################
### Aggregate sermon data to county level w/ Mizzou toolkit ###
#########################################################################################################
#load('C:/Users/sum410/Dropbox/Dissertation/Data/sermons_mfd_7-30.RData')
#load('C:/Users/steve/Dropbox/Dissertation/Data/sermons_mfd_7-30.RData')
load("C:/Users/SF515-51T/Desktop/Dissertation/sermons_mfd_7-30.RData")

serms.merge <- serms.merge[which(serms.merge$word.count > 100),]
serms.merge$zip.clean[1:10]
length(unique(serms.merge$zip.clean))
unique(serms.merge$zip.clean)
summary(nchar(serms.merge$zip.clean)==4)

### Remove sermons w/o zip codes
serms.merge <- serms.merge[!is.na(serms.merge$zip.clean),]
serms.merge <- serms.merge[which(nchar(serms.merge$zip.clean)==5),]

### Remove spanish sermons
summary(serms.merge$spanish.count)
serms.merge <- serms.merge[which(serms.merge$spanish.count < 3),]
nrow(serms.merge) #126,422


# Read in zip-to-county data
#geocorr.data <- read.csv('C:/Users/sum410/Dropbox/Dissertation/Data/Census/geocorr2014.csv', stringsAsFactors = F)
#geocorr.data <- read.csv('C:/Users/steve/Dropbox/Dissertation/Data/Census/geocorr2014.csv', stringsAsFactors = F)
geocorr.data <- read.csv('C:/Users/SF515-51T/Desktop/Dissertation/geocorr2014.csv', stringsAsFactors = F)
geocorr.data <- geocorr.data[-1,]

# Subset geocorr data to include zip code, county name, and coutny population
geocorr.data <- geocorr.data[,c('county','zcta5','cntyname','pop10', 'cntysc')]

# Fix zip codes w/ 4 numbers
class(geocorr.data$zcta5)
summary(nchar(geocorr.data$zcta5)==4)
for (i in 1:nrow(geocorr.data)) {
  if (nchar(geocorr.data$zcta5[i])==4) {
    geocorr.data$zcta5[i] <- paste('0',geocorr.data$zcta5[i],sep='')
  }
}

summary(nchar(geocorr.data$zcta5)==4) #0
summary(nchar(geocorr.data$zcta5)==5) #ALL!!!

# Fix FIPS w/ 4 numbers
class(geocorr.data$county)
summary(nchar(geocorr.data$county))
summary(nchar(geocorr.data$county)==4)
for (i in 1:nrow(geocorr.data)) {
  if (nchar(geocorr.data$county[i])==4) {
    geocorr.data$county[i] <- paste('0',geocorr.data$county[i],sep='')
  }
}

summary(nchar(geocorr.data$county)==4) #0
summary(nchar(geocorr.data$county)==5) #ALL!!!

# Merge sermon and county data w/ zip code
dim(serms.merge)
serms.merge <- merge(serms.merge, geocorr.data, by.x = 'zip.clean', by.y = 'zcta5', all.x = T, all.y = F)
serms.merge <- serms.merge[!duplicated(serms.merge$sermon),]
dim(serms.merge)
summary(is.na(serms.merge$county))

unique(serms.merge$county)
length(unique(serms.merge$county))

summary(is.na(serms.merge$county))
serms.merge$cntyname[1:10]
serms.merge$zip.clean[1:10]

# Drop non-matched counties
serms.merge <- serms.merge[!is.na(serms.merge$county),]
nrow(serms.merge) # 121,827
rm(geocorr.data)


### AGAIN USE FREAKING FIPS (county)
### Merge to sermon data
colnames(serms.merge)
colnames(county.data.merge)
serms.merge$fair <- serms.merge$fairness.vice + serms.merge$fairness.virtue
#unique(serms.merge$cntyname)[1:10]
#unique(county.data.merge$county.state.x)[1:10]

# Remove county in county merge data, add comma in sermon dataset
###county.data.merge$county.name.fixed <- gsub(' County', '', county.data.merge$county.state.x)
###serms.merge$county.name.fixed <- gsub("(.*) ","\\1, \\2",serms.merge$cntyname)

#serms.merge$parish <- 0
#for (i in 1:nrow(serms.merge)) {
#  if (grepl('Parish', serms.merge$cntyname[i])) {
#    serms.merge$parish[i] <- 1
#  }
#}
#yo <- serms.merge[which(serms.merge$parish == 1),]

dim(serms.merge)
colnames(county.data.merge)


########################################################################################################
### Merge by fips/county (retain all vars)
dim(serms.merge)
serms.merge <- merge(serms.merge, dedup.county, by.x = 'county', 
                     by.y = 'fips', all.x = T, all.y = F)
dim(serms.merge) # 121,827 x 689
summary(serms.merge$cong.by.pop)

write.csv(serms.merge, 'sermon_final.csv', row.names = F)

########################################################################################################
### Variable selection



##################### Religious economies measures HERE



# Select variables to retain
# myvars <- c('fips', 'county.state.x', 'name', 'state', 'census_region', 'pop_dens', 'pct_black',
#             'pop', 'female', 'white', 'hh_income', 'su_gun4', 'TOTCNG', 'TOTADH', 'TOTRATE',
#             'EVANCNG', 'EVANADH', 'EVANRATE', 'FIPS', 'STCODE', 'STABBR', 'STNAME', 'CNTYCODE', 
#             'CNTYNAME', 'POP2010', 'county.state.y', 'dem.vote.2000', 'dem.vote.2004', 'dem.vote.2008',
#             'dem.vote.2012', 'dem.vote.2016')
# county.data.merge <- county.data.merge[myvars]
# summary(county.data.merge$TOTCNG)
# summary(county.data.merge$dem.vote.2000)
# summary(county.data.merge$county.state.x == county.data.merge$county.state.y)
# 
# 
# dim(county.data.merge)
# deduped.county <- county.data.merge[!duplicated(county.data.merge[c(1,2)]),]
# dim(deduped.county) #3143 x 31
# 
# gc()
# #memory.limit(64000)
# serms.merge <- merge(serms.merge, deduped.county, by.x = 'county.name.fixed', 
#            by.y = 'county.state.y', all.x = T, all.y = F)
# dim(serms.merge)
# 
# summary(serms.merge$dem.vote.2016) ### Deal w/ NA's

#### Save df
#save(serms.merge, file = 'model_sermons_subset.RData')

#serms.rights <- write.csv('sermon_final_rights_ml.csv', stringsAsFactors = F)


########################################################################################################
##### Rights measure
########################################################################################################
setwd("C:/Users/SF515-51T/Desktop/Dissertation")

#serms.rights <- read.csv('sermon_final_rights_ml.csv', stringsAsFactors = F)
serms.merge <- read.csv('sermon_final_rights_ml_11-15.csv', stringsAsFactors = F)

# Map of rights talk by state
rights.state <- plyr::count(serms.merge[which(serms.merge$rights_talk_xgboost == 1),], 'state_parse')
non.rights.state <- plyr::count(serms.merge[which(serms.merge$rights_talk_xgboost == 0),], 'state_parse')

comb.rights <- merge(rights.state, non.rights.state, by = 'state_parse', all.x = T, all.y = T)
comb.rights$prop <- comb.rights$freq.x / comb.rights$freq.y ### THIS MEANS STATES ARE MISSING
rm(rights.state, non.rights.state)


#serms.merge <- serms.rights ### This will need fixed if original merged data is different (maybe just handle in python?)
#rm(serms.rights)

#summary(lm(fair~dem.vote.2000+dem.vote.2004+dem.vote.2008+dem.vote.2012+dem.vote.2016, data = serms.merge))


########################################################################################################
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
                    'antiimigr','obamacar','migrant', 'refuge','asylum',
                    'salvadoran', 'elsalvador', 'detent', 'deport', 'incarcer',
                    'detain','border', 'discriminatori', 'antiabort', 'welfar', 
                    'grassley','politician', 'aclu', 'partisan', 'delegitim',
                    'transgend', 'unborn', 'abort', 'kamala', 'vote', 'ballot', 
                    'voter','abort', 'prolif', 'environ','ideolog', 
                    'kavanaugh','unconstitut', 'ideologu', 'proabort','antiabort',
                    'legislatur'), collapse='|')
serms.merge$pol_count <- str_count(serms.merge$clean, pol.dict)
serms.merge$is.pol <- ifelse(serms.merge$pol_count >= 7, 1, 0)
summary(serms.merge$is.pol == 1) #8.0%

cor(serms.merge$is.pol, serms.merge$rights_talk_xgboost) # 0.27

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
summary(serms.merge$dem.share)


### Two-vote competitiveness
serms.merge$dem.comp <- abs(serms.merge$dem.share - 50)
summary(serms.merge$dem.comp)
library(scales)
serms.merge$comp.rescale <- rescale(serms.merge$dem.comp, to = c(0, 100))
summary(serms.merge$comp.rescale)

serms.merge$rights_talk_xgboost <- serms.merge$rights_talk_xgboost * 100
summary(serms.merge$rights_talk_xgboost)


## Consider dropping catholics and creating a dummy for top 10 most popular denomin's in dataset?

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


##########################################################################################################
### Attack on religion
attack.dict <- paste(c('nation', 'murder', 'govern', 'abort', 'freedom',  # remove america?
                    'persecut', 'liberti', 'state', 'kill', 'religion', 'war',
                    'polit', 'countri'), collapse='|')
serms.merge$attack_count <- str_count(serms.merge$clean, attack.dict)
summary(serms.merge$attack_count)
serms.merge$is.attack <- ifelse(serms.merge$attack_count >= 15, 1, 0)
summary(serms.merge$is.attack == 1) #10.0%


cor(serms.merge$dem.share, serms.merge$comp.rescale, use = 'complete.obs') #-0.263
cor(serms.merge$is.pol, serms.merge$rights_talk_xgboost, use = 'complete.obs') #0.269
cor(serms.merge$is.pol, serms.merge$is.attack, use = 'complete.obs') #0.310
cor(serms.merge$rights_talk_xgboost, serms.merge$is.attack, use = 'complete.obs') #0.282


### Religious adherence and rhetoric measures
cor(serms.merge$is.pol, serms.merge$TOTADH, use = 'complete.obs') #0.020
cor(serms.merge$rights_talk_xgboost, serms.merge$TOTADH, use = 'complete.obs') #0.005
cor(serms.merge$is.attack, serms.merge$TOTADH, use = 'complete.obs') #0.037

### Evangelical adherence and rhetoric measures
cor(serms.merge$is.pol, serms.merge$EVANADH, use = 'complete.obs') #0.010
cor(serms.merge$rights_talk_xgboost, serms.merge$EVANADH, use = 'complete.obs') #0.000
cor(serms.merge$is.attack, serms.merge$EVANADH, use = 'complete.obs') #0.013


### Examples of attack on religion
attack.ex <- serms.merge[order(serms.merge$attack_count,decreasing = TRUE),]
attack.ex <- attack.ex[5:8,]

fileConn<-file("attack_ex1.txt")
writeLines(attack.ex$sermon[1], fileConn)
close(fileConn)

fileConn<-file("attack_ex2.txt")
writeLines(attack.ex$sermon[2], fileConn)
close(fileConn)

fileConn<-file("attack_ex3.txt")
writeLines(attack.ex$sermon[3], fileConn)
close(fileConn)


##########################################################################################################
### Merge in rural/urban/suburban measures
rural <- read.csv('rural_urban_fips.csv', stringsAsFactors = F)
rural <- rural[,c(1,5)]

for (i in 1:nrow(rural)) {
  if (nchar(rural$FIPS[i])==4) {
    rural$FIPS[i] <- paste('0',rural$FIPS[i],sep='')
  }
}
summary(nchar(rural$FIPS))

summary(nchar(serms.merge$county))
for (i in 1:nrow(serms.merge)) {
  if (nchar(serms.merge$county[i])==4) {
    serms.merge$county[i] <- paste('0',serms.merge$county[i],sep='')
  }
}
summary(nchar(serms.merge$county))

dim(serms.merge)
serms.merge <- merge(serms.merge, rural, by.x = 'county', by.y = 'FIPS', all.x = T, all.y = F)
dim(serms.merge)
summary(is.na(serms.merge$RUCC_2013))

# Recode rural/urban/suburban -> FIX
# serms.merge$urban <- ifelse(serms.merge$RUCC_2013 < 4, 1, 0)
# serms.merge$rural <- ifelse(serms.merge$RUCC_2013 > 7, 1, 0)
# serms.merge$suburb <- ifelse(serms.merge$RUCC_2013 > 3 & serms.merge$RUCC_2013 < 8, 1, 0)
# summary(serms.merge$suburb==1)
# summary(serms.merge$rural==1)
# summary(serms.merge$urban==1)

serms.merge$rural <- ifelse(serms.merge$RUCC_2013 > 3, 1, 0)
summary(serms.merge$rural==1)

save(serms.merge, file = 'serms_with_measures.RData')


##########################################################################################################
### Baseline model - rights talk
base <- lm(rights_talk_xgboost~dem.share, data = serms.merge)
summary(base)

base1 <- lm(rights_talk_xgboost~comp.rescale, data = serms.merge)
summary(base1)

base2 <- lm(rights_talk_xgboost~TOTRATE, data = serms.merge)
summary(base2)

base3 <- lm(rights_talk_xgboost~EVANRATE, data = serms.merge)
summary(base3)


### Baseline models - political speech
base.pol <- lm(is.pol~dem.share, data = serms.merge)
summary(base.pol)

base1.pol <- lm(is.pol~comp.rescale, data = serms.merge)
summary(base1.pol)


### Baseline models - attacks on religion speech
base.attack <- lm(is.attack~dem.share, data = serms.merge)
summary(base.attack)

base1.attack <- lm(is.attack~comp.rescale, data = serms.merge)
summary(base1.attack)



##########################################################################################################


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
#census2010 <- read.xlsx('U.S. Religion Census Religious Congregations and Membership Study, 2010 (County File).xlsx',
#                        sheetIndex = 1, stringsAsFactors = FALSE)
census2010 <- read.spss('U.S. Religion Census Religious Congregations and Membership Study, 2010 (County File).SAV', 
                        to.data.frame=TRUE)
census2010[is.na(census2010)] <- 0
census2010$hhi <- (census2010$EVANRATE/1000)^2 + (census2010$BPRTRATE/1000)^2 + (census2010$MPRTRATE/1000)^2 + (census2010$CATHRATE/1000)^2 +
  (census2010$ORTHRATE/1000)^2 + (census2010$OTHRATE/1000)^2 + (census2010$AMERATE/1000)^2 + (census2010$AMEZRATE/1000)^2 + (census2010$ALBRATE/1000)^2 +
  (census2010$AWMCRATE/1000)^2 + (census2010$AMANRATE/1000)^2 + (census2010$AAMRATE/1000)^2 + (census2010$AMANRATE/1000)^2 + (census2010$AAMRATE/1000)^2 +
  (census2010$ABARATE/1000)^2 + (census2010$ACRORATE/1000)^2 + (census2010$AMSHRATE/1000)^2 + (census2010$AFMRATE/1000)^2 + (census2010$ACCARATE/1000)^2
summary(census2010$hhi)

census2010$plurality <- 1 - census2010$hhi
summary(census2010$plurality)
census2010$plurality <- ifelse(census2010$plurality < 0, 0, census2010$plurality)
summary(census2010$plurality)

census2010$CNTYNAME <- as.character(census2010$CNTYNAME)
census2010$CNTYNAME <- trimws(census2010$CNTYNAME)
census2010$STABBR <- as.character(census2010$STABBR)
census2010$county.state <- paste(census2010$CNTYNAME, census2010$STABBR, sep = ', ')

county_full <- left_join(county_map, county_data, by = "id")
county_full$county.state <- paste(county_full$name, county_full$state, sep = ', ')
county.data.merge <- merge(county_full, census2010, by = 'county.state', all.x = T)
summary(county.data.merge$TOTCNG)

serms.merge$county.name.fixed


deduped.county <- county.data.merge[!duplicated(county.data.merge[c(1,2)]),]
yolo <- merge(serms.merge, deduped.county, by.x = 'county.name.fixed', by.y = 'county.state', all.x = T)
summary(is.na(yolo$plurality))
yolo1 <- yolo[!duplicated(yolo$cleaned),]
dim(yolo1)

fit4 <- glm(rights_talk_xgboost~plurality+elect.szn.2wk+cath+main+other+black.final+hispanic.final+api.final+female.pastor+census_region.x+log(pop10),
            data = yolo) #elect.szn.2wk+dem.share
summary(fit4)
stargazer(fit4, no.space = T, covariate.labels = c('Religious Pluralism', 'Elect. Season',
                                                   'Catholic', 'Mainline Prot', 'Other Christian',
                                                   'Black', 'Hispanic', 'Asian', 'Female','Northeast',
                                                   'South','West','Log Pop.','Constant'))
