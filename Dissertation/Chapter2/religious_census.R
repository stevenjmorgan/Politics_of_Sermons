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
census2000 <- read.xlsx('Religious Congregations and Membership Study, 2000 (Counties File).xlsx',
                        sheetIndex = 1, stringsAsFactors = FALSE)



