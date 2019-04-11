

load('final_clean.RData')

unique(serms.merge$state_parse)

install.packages(c("maps", "mapdata"))

library(ggplot2)
#library(ggmap)
library(maps)
library(mapdata)
library(ggplot2); library(mapproj)

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
