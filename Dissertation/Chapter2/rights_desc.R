# Plot chapter 2 descriptives

library(tidyverse)
library(zoo)

rm(list=ls())
#setwd("C:/Users/sum410/Dropbox/Dissertation/Data/Census")
#setwd("C:/Users/steve/Dropbox/Dissertation/Data/handcode")
setwd("C:/Users/SF515-51T/Desktop/Dissertation")

serms.rights <- read.csv('sermon_final_rights_ml.csv', stringsAsFactors = F)

# Plot rights talk over time by month
serms.rights$month.yr <- as.yearmon(as.Date(serms.rights$date.conv, '%Y-%m-%d'))
unique(serms.rights$month.yr)

mon.yr <- plyr::count(serms.rights, "month.yr")
mon.yr.rights <- plyr::count(serms.rights[which(serms.rights$rights_talk_xgboost == 1),], "month.yr")
mon.yr$rights <- mon.yr.rights$freq
rm(mon.yr.rights)
mon.yr$prop <- mon.yr$rights / mon.yr$freq

plot(mon.yr$month.yr, mon.yr$prop)
png('rights_talk_month.png', width = 680)
ggplot(data=mon.yr, aes(x=month.yr, y=prop)) +
  geom_bar(stat="identity") + theme_bw() + xlab('Year') + ylab('# of Sermons w/ Rights Talk')
dev.off()
