rm(list=ls())
setwd("C:/Users/SF515-51T/Desktop/Dissertation")

library(stringr)

serm.pol <- read.csv('sermon_final_active_learn_political.csv', 
                     stringsAsFactors = F)
colnames(serm.pol)
pol.var <- serm.pol$political_final_active_pred # whatever the political variable is named
rm(serm.pol)

serm.rights <- read.csv('sermon_final_active_learn_rights.csv', 
                     stringsAsFactors = F)
rights.var <- serm.rights$rights_final_active_pred # whatever the rights variable is named
rm(serm.rights)

serm.final <- read.csv('sermon_final_active_learn_attack.csv', 
                        stringsAsFactors = F)
serm.final$rights.var <- rights.var
serm.final$pol.var <- pol.var

rm(rights.var,pol.var)
