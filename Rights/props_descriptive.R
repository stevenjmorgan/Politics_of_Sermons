rm(list=ls())

setwd("C:/Users/steve/Dropbox/PoliticsOfSermons")
#setwd("C:/Users/sum410/Dropbox/PoliticsOfSermons")

load('final_clean.RData')

unique(serms.merge$state_parse)

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
serms.merge <- serms.merge[serms.merge$state_parse!="District of Columbia",]

##Need to create "Region" variable with lowercase state names
serms.merge$state.lower <- tolower(serms.merge$state_parse)

group.state <- serms.merge %>% group_by(state.lower) %>%
  summarise(trues = n())

# Plot sermons by state
ggplot() + geom_map(data=us, map=us, aes(long, lat, map_id=region), color="#2b2b2b", fill=NA, size=0.15) +
  geom_map(data=group.state, map=us, aes(fill=trues, map_id=state.lower), color="#ffffff", size=0.15) + labs(x=NULL, y=NULL) +
  scale_fill_continuous(low='gray80', high='gray20',  guide='colorbar') +
  theme(panel.border = element_blank(), panel.background = element_blank(), 
        plot.title = element_text(hjust = 0.5,size = 25, face = "bold"), axis.ticks = element_blank(),
        axis.text = element_blank()) + guides(fill = guide_colorbar(title=NULL)) + coord_map() + 
  ggtitle("Number of Sermons by State")
ggsave('sermons_state.png')


state.pop <- read.csv('state_pop.csv')
state.pop$state.lower <- tolower(state.pop$State..federal.district..or.territory)
test <- merge(group.state, state.pop, by = 'state.lower', all.x = TRUE)
test <- test[,-3]
test$prop <- test$trues/test$Population.estimate..July.1..2018.1.

# Plot sermons per person by state
ggplot() + geom_map(data=us, map=us, aes(long, lat, map_id=region), color="#2b2b2b", fill=NA, size=0.15) +
  geom_map(data=test, map=us, aes(fill=prop, map_id=state.lower), color="#ffffff", size=0.15) + labs(x=NULL, y=NULL) +
  scale_fill_continuous(low='gray80', high='gray20',  guide='colorbar') +
  theme(panel.border = element_blank(), panel.background = element_blank(), 
        plot.title = element_text(hjust = 0.5,size = 25, face = "bold"), axis.ticks = element_blank(),
        axis.text = element_blank()) + guides(fill = guide_colorbar(title=NULL)) + coord_map() + 
  ggtitle("Number of Sermons per Person by State")
ggsave('sermons_person_state.png')


serms.merge$rights.count <- str_count(serms.merge$sermon.clean, 'right')
serms.merge$rights.count.bi <- ifelse(serms.merge$rights.count < 10, FALSE, TRUE)
summary(serms.merge$rights.count.bi)

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

t.test(pres$rights.count.bi, non$rights.count.bi)

library(effsize)
cohen.d(as.numeric(pres$rights.count.bi), as.numeric(non$rights.count.bi))
