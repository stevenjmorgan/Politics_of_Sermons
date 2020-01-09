library(tidyverse)
library(zoo)


# Plot rights talk over time by month
serms.merge$month.yr <- as.yearmon(as.Date(serms.merge$date.conv, '%Y-%m-%d'))
unique(serms.merge$month.yr)

mon.yr <- plyr::count(serms.merge, "month.yr")
mon.yr.rights <- plyr::count(serms.merge[which(serms.merge$rights.final == 1),], "month.yr")
mon.yr$rights <- mon.yr.rights$freq
rm(mon.yr.rights)
mon.yr$prop <- mon.yr$rights / mon.yr$freq

plot(mon.yr$month.yr, mon.yr$prop)
png('rights_talk_month_new1-9.png', width = 680)
ggplot(data=mon.yr, aes(x=month.yr, y=prop)) +
  geom_bar(stat="identity") + theme_bw() + xlab('Year') + ylab('# of Sermons w/ Rights Talk')
dev.off()

library(stringr)

mon.yr$year <- str_sub(mon.yr$month.yr,-4,-1)
mon.yr$year <- as.numeric(mon.yr$year)

png('rights_talk_month2006-08_new1-9.png', width = 680)
ggplot(data=mon.yr[which(mon.yr$year > 2005 & mon.yr$year < 2009),], aes(x=month.yr, y=prop)) +
  geom_bar(stat="identity") + theme_bw() + xlab('Year') + ylab('# of Sermons w/ Rights Talk')
dev.off()
