### This script downloads the 2000 and 2010 Religious Census dataset, plots
### descriptives, and merges with the sermon dataset.

rm(list=ls())
setwd("C:/Users/sum410/Dropbox/Dissertation/Data/Census")

library(foreign)
#library(xlsx)

census2010 <- read.spss('U.S. Religion Census Religious Congregations and Membership Study, 2010 (County File).SAV', 
                        to.data.frame=TRUE)
#double.check <- read.xlsx('U.S. Religion Census Religious Congregations and Membership Study, 2010 (County File).xlsx',
#                          sheetIndex = 1)

# Total number of congregations (2010): All denominations/groups
summary(census2010$TOTCNG)
sd(census2010$TOTCNG, na.rm = T)

# Total number of adherents (2010): All denominations/groups
summary(census2010$TOTADH)
sd(census2010$TOTADH, na.rm = T)

# Rates of adherence per 1,000 population (2010): All denominations/groups
summary(census2010$TOTRATE)
sd(census2010$TOTRATE, na.rm = T)

