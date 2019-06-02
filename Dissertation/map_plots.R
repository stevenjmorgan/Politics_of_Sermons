rm(list=ls())
setwd("C:/Users/steve/Dropbox/Dissertation/Data")

library(zipcode)
library(tidyverse)
library(maps)
library(viridis)
library(ggthemes)
library(albersusa)#installed via github

load('final_serms.RData')

# Extract zip codes
serms.merge$zip[1]
serms.merge$zip.clean <- clean.zipcodes(serms.merge$zip)
serms.merge$zip.clean[1]

# Size by zip
fm.zip <- aggregate(data.frame(count=serms.merge$doc_id),list(zip=serms.merge$zip.clean),length)
data(zipcode)
fm <- merge(fm.zip, zipcode, by='zip')

us <- map_data('state')

# Plot map
ggplot(fm,aes(longitude,latitude)) +
  geom_polygon(data=us,aes(x=long,y=lat,group=group),color='gray',fill=NA,alpha=.35)+
  geom_point(aes(color = count),size=.15,alpha=.25) +
  xlim(-125,-65)+ylim(20,50)
ggsave('sermons_by_zipcode.png', width = 6, height = 3.2)
