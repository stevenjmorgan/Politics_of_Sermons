# This script creates maps of church locations in the sermon dataset.

rm(list=ls())
setwd("C:/Users/steve/Dropbox/Dissertation/Data")


library(zipcode)
library(tidyverse)
library(maps)
library(viridis)
library(ggthemes)
library(albersusa)#installed via github

load('final_dissertation_dataset7-27.RData')


# Extract zip codes
#serms.merge$zip[1]
serms.merge$zip.clean <- clean.zipcodes(serms.merge$zip)
serms.merge$zip.clean[1]

# Size by zip
serms.merge$doc_id <- seq(1, nrow(serms.merge))
fm.zip <- aggregate(data.frame(count=serms.merge$doc_id),list(zip=serms.merge$zip.clean),length)
data(zipcode)
fm <- merge(fm.zip, zipcode, by='zip')

us <- map_data('state')

# Plot map -> raw sermon count
ggplot(fm,aes(longitude,latitude)) +
  geom_polygon(data=us,aes(x=long,y=lat,group=group),color='gray',fill=NA,alpha=.35)+
  geom_point(aes(color = count),size=.15,alpha=.25) + labs(colour = "Count")  +
  xlim(-125,-65)+ylim(20,50) + xlab('Longitude') + ylab('Latitude') + 
  theme_bw()
ggsave('sermons_state.png', width = 6, height = 3.2)



install.packages(c("maps", "mapdata"))

library(ggplot2)
#library(ggmap)
library(maps)
library(mapdata)
library(ggplot2); library(mapproj)
library(tidyverse)

##Name US State Map
us <- map_data("state")

##Read in Data; get rid of DC
serms.merge.no.dc <- serms.merge[serms.merge$state_parse!="District of Columbia",]

##Need to create "Region" variable with lowercase state names
serms.merge.no.dc$state.lower <- tolower(serms.merge.no.dc$state_parse)
group.state <- plyr::count(serms.merge.no.dc, 'state.lower')


# Plot sermons by state
ggplot() + geom_map(data=us, map=us, aes(long, lat, map_id=region), color="#2b2b2b", fill=NA, size=0.15) +
  geom_map(data=group.state, map=us, aes(fill=freq, map_id=state.lower), color="#ffffff", size=0.15) + labs(x=NULL, y=NULL) +
  scale_fill_continuous(low='gray80', high='gray20',  guide='colorbar') +
  theme(panel.border = element_blank(), panel.background = element_blank(), 
        plot.title = element_text(hjust = 0.5,size = 25, face = "bold"), axis.ticks = element_blank(),
        axis.text = element_blank()) + guides(fill = guide_colorbar(title=NULL)) + coord_map()
  #ggtitle("Number of Sermons by State")
ggsave('sermons_state.png')



#####################################################
state.pop <- read.csv('C:/Users/steve/Desktop/sermon_dataset/state_pop.csv')
state.pop$state.lower <- tolower(state.pop$State..federal.district..or.territory)
test <- merge(group.state, state.pop, by = 'state.lower', all.x = TRUE)
test <- test[,-3]
test$prop <- test$freq/test$Population.estimate..July.1..2018.1.

# Plot sermons per person by state
ggplot() + geom_map(data=us, map=us, aes(long, lat, map_id=region), color="#2b2b2b", fill=NA, size=0.15) +
  geom_map(data=test, map=us, aes(fill=prop, map_id=state.lower), color="#ffffff", size=0.15) + labs(x=NULL, y=NULL) +
  scale_fill_continuous(low='gray80', high='gray20',  guide='colorbar') +
  theme(panel.border = element_blank(), panel.background = element_blank(), 
        plot.title = element_text(hjust = 0.5,size = 25, face = "bold"), axis.ticks = element_blank(),
        axis.text = element_blank()) + guides(fill = guide_colorbar(title=NULL)) + coord_map() + 
  ggtitle("Number of Sermons per Person by State")
ggsave('sermons_person_state.png')

