rm(list=ls())
setwd("C:/Users/steve/Desktop/sermon_dataset")

serms <- read.csv('sermons_pol_variable7-31.csv')
summary(serms$pol_count)
summary(serms$pol_count>3)
nrow(serms[which(serms$pol_count>3),])/nrow(serms)
