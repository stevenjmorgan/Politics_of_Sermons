# This code reads in pastor meta data and merges to the sermon dataframe

rm(list=ls())
setwd("C:/Users/sum410/Dropbox/PoliticsOfSermons")
#setwd("~/GitHub/Politics_of_Sermons/Clean")

pastors <- read.csv('pastor_meta_hc.csv', stringsAsFactors = FALSE)
load('dedupedSerms.RData')

dim(deduped.serms)

# Merge pastor meta data into sermon df based on pastor name and denomination
serms.merge <- merge(deduped.serms, pastors, by.x = c('author', 'denom'), 
                     by.y = c('name', 'denom'), all.x = TRUE)

dim(serms.merge)

# Too many rows
#sum(!is.na(serms.merge$sermon))
serms.merge <- serms.merge[!duplicated(serms.merge$sermon),]

save(serms.merge, file = 'serms_merged.RData')
