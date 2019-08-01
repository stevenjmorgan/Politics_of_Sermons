rm(list=ls())
setwd("C:/Users/steve/Desktop/sermon_dataset")

serms <- read.csv('sermons_pol_variable7-31.csv')
summary(serms$pol_count)
summary(serms$pol_count>3)
nrow(serms[which(serms$pol_count>3),])/nrow(serms)


load('final_dissertation_dataset7-27.RData')
write.csv(serms.merge, 'sermons_dataset.csv', row.names = F)
