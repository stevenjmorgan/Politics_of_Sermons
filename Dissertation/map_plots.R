rm(list=ls())
setwd("C:/Users/steve/Dropbox/PoliticsOfSermons")

library(zipcode)
library(tidyverse)
library(maps)
library(viridis)
library(ggthemes)
library(albersusa)#installed via github

load('final_serms.RData')

setwd("C:/Users/steve/Dropbox/Dissertation/Data")

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
  geom_point(aes(color = count),size=.15,alpha=.25) + labs(colour = "Count")  +
  xlim(-125,-65)+ylim(20,50) + xlab('Longitude') + ylab('Latitude') + 
  theme_bw()
ggsave('sermons_by_zipcode.png', width = 6, height = 3.2)


library(plyr)

pastor.group <- count(serms.merge, 'author')
ggplot(pastor.group[which(pastor.group$freq < 35), ], aes(x=freq)) + 
  geom_histogram(binwidth=1, color="darkblue", fill="lightblue") +
  labs(x = 'Number of Sermons', y = "Pastors") + 
  ggtitle("Distribution of Sermons Uploaded by Pastor") + theme_bw()

ggsave("sermonspastor.pdf")
