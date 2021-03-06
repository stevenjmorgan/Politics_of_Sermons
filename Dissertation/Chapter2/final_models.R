# This script implements models for Ch. 2.

rm(list=ls())
setwd("C:/Users/SF515-51T/Desktop/Dissertation")
load('serms_with_measures.RData')

##########################################################################################################
### Political events
##########################################################################################################
### Temporal Covariates
library(lubridate)

### Check to ensure all obs. have dates
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

# Calculate dates 1-, 3-, and 6-months out from presidential elections
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

# Function to determine if sermon date is between election and pre-election period
is.between <- function(x,a,b){ 
  x < a & x >= b 
} 

# 3 month
#serms.merge$pre2016.3 <- ifelse(is.between(serms.merge$date.con, election[1], pre2016.3), 1, 0)
#serms.merge$pre2012.3 <- ifelse(is.between(serms.merge$date.con, election[2], pre2012.3), 1, 0)
#serms.merge$pre2008.3 <- ifelse(is.between(serms.merge$date.con, election[3], pre2008.3), 1, 0)
#serms.merge$pre2004.3 <- ifelse(is.between(serms.merge$date.con, election[4], pre2004.3), 1, 0)
#serms.merge$pre2000.3 <- ifelse(is.between(serms.merge$date.con, election[5], pre2000.3), 1, 0)
#serms.merge$elect.szn.3 <- rowSums(serms.merge[,c("pre2016.3", "pre2012.3", "pre2008.3", "pre2004.3", "pre2000.3")])

# 1 month
serms.merge$pre2016.1 <- ifelse(is.between(serms.merge$date.con, election[1], pre2016.1), 1, 0)
serms.merge$pre2012.1 <- ifelse(is.between(serms.merge$date.con, election[2], pre2012.1), 1, 0)
serms.merge$pre2008.1 <- ifelse(is.between(serms.merge$date.con, election[3], pre2008.1), 1, 0)
serms.merge$pre2004.1 <- ifelse(is.between(serms.merge$date.con, election[4], pre2004.1), 1, 0)
serms.merge$pre2000.1 <- ifelse(is.between(serms.merge$date.con, election[5], pre2000.1), 1, 0)
serms.merge$elect.szn.1 <- rowSums(serms.merge[,c("pre2016.1", "pre2012.1", "pre2008.1", "pre2004.1", "pre2000.1")])

# 2 weeks
serms.merge$pre2016.2wk <- ifelse(is.between(serms.merge$date.con, election[1], pre2016.2wk), 1, 0)
serms.merge$pre2012.2wk <- ifelse(is.between(serms.merge$date.con, election[2], pre2012.2wk), 1, 0)
serms.merge$pre2008.2wk <- ifelse(is.between(serms.merge$date.con, election[3], pre2008.2wk), 1, 0)
serms.merge$pre2004.2wk <- ifelse(is.between(serms.merge$date.con, election[4], pre2004.2wk), 1, 0)
serms.merge$pre2000.2wk <- ifelse(is.between(serms.merge$date.con, election[5], pre2000.2wk), 1, 0)
serms.merge$elect.szn.2wk <- rowSums(serms.merge[,c("pre2016.2wk", "pre2012.2wk", "pre2008.2wk", "pre2004.2wk", "pre2000.2wk")])

####################################################################################################################


serms.merge$evan.rate.fix <- serms.merge$EVANRATE / 100
serms.merge$tot.rate.fix <- serms.merge$TOTRATE / 100
serms.merge$MSLMRATE[is.na(serms.merge$MSLMRATE)] <- 0
serms.merge$muslim.rate.fix <- serms.merge$MSLMRATE / 100

# Remove catholics
serms.merge <- serms.merge[which(serms.merge$cath == 0),]

serms.merge$clean <- gsub('[[:punct:]]+', '', serms.merge$clean)
#serms.merge$clean[1]

### New Active Learning measures
colnames(serms.merge)

library(stringr)
pol.dict <- paste(c('republican', 'democrat', 'congress', 'senate', 'gop', 'dem', 
                    'mcconel', 'schumer', 'trumpcar', 'lawmak', 'senat', 'legisl', 
                    'obama', 'racist', 'constitut', 'immigr', 'dreamer', 'daca', 
                    'deport', 'muslim', 'racism', 'lgbtq', 'transgend', 'activist',
                    'freedom', 'constitut', 'antilgbtq', 'liberti', 'civil', 
                    'anticivil','bigotri', 'judici', 'nomine', 'gorusch', 'clinton', 
                    'kennedi', 'feder','protest', 'pelosi','policymak', 'bipartisan',
                    'bipartisanship','congress', 'legisl', 'medicaid', 'medicar', 
                    'aca', 'democraci', 'lgbt', 'lgbtq', 'filibust', 'capitol',
                    'antiimigr','obamacar','migrant', 'refuge','asylum',
                    'salvadoran', 'elsalvador', 'detent', 'deport', 'incarcer',
                    'detain','border', 'discriminatori', 'antiabort', 'welfar', 
                    'grassley','politician', 'aclu', 'partisan', 'delegitim',
                    'transgend', 'unborn', 'abort', 'kamala', 'vote', 'ballot', 
                    'voter','abort', 'prolif', 'environ','ideolog', 
                    'kavanaugh','unconstitut', 'ideologu', 'proabort','antiabort',
                    'legislatur', 'homosexual', 'president', 'abortion', 'voter',
                    'political', 'inequ', 'capit', 'fetu', 'govern', 'abortionist',
                    'amend', 'euthanasia', 'freedom', 'suprem court'), collapse='|')
serms.merge$pol.count.x <- str_count(serms.merge$clean, pol.dict)
summary(serms.merge$pol.count.x)

rights.dict <- paste(c('lgbtq', 'transgend', 'activist',
                       'freedom', 'constitut', 'antilgbtq', 'liberti', 'civil', 
                       'anticivil','bigotri', 'judici', 'nomine', 'gorusch', 'lgbtq', 
                       'abort', 'prolif', 'ideolog', 
                       'kavanaugh','unconstitut', 'ideologu', 'proabort','antiabort',
                       'abortion', 'abortionist', 'amend', 'euthanasia', 'freedom', 'suprem court'), collapse='|')
serms.merge$rights.count.x <- str_count(serms.merge$clean, rights.dict)
summary(serms.merge$rights.count.x)


cor(serms.merge$pol.count.x, serms.merge$rights.count.x)

# Change dictionary -> FW plots
attack.dict <- paste(c('persecut', 'murder', 'transgend', 'muslim', 'islam',
                       'rape', 'proabort', 'liber', 'hollywood', 'lgbtq', 
                       'bigotri', 'attack', 'abort', 'prolif', 'ideolog', 
                       'kavanaugh','unconstitut', 'ideologu', 'proabort','antiabort',
                       'abortion', 'abortionist'), collapse='|')

serms.merge$attack.count.x <- str_count(serms.merge$clean, attack.dict)
summary(serms.merge$attack.count.x)

cor(serms.merge$rights.count.x, serms.merge$attack.count.x)

### Final measures
serms.merge$pol.final <- ifelse(serms.merge$pol.count.x >5, 1, 0)
summary(serms.merge$pol.final==1) #12.8%

serms.merge$rights.final <- ifelse(serms.merge$rights.count.x>3, 1, 0)
summary(serms.merge$rights.final==1) #3.3%

cor(serms.merge$pol.final, serms.merge$rights.final) #0.43


serms.merge$attack.final <- ifelse(serms.merge$attack.count.x>5, 1, 0)
summary(serms.merge$attack.final==1) #3.7%

cor(serms.merge$rights.final, serms.merge$attack.final) # 0.22

cor(serms.merge$pol.final, serms.merge$attack.final) # 0.21


### Table w/ correlations (in Latex)
## Rights
# cor(serms.merge$rights_talk_xgboost, serms.merge$dem.share, use = 'complete.obs')
# cor.test(serms.merge$rights_talk_xgboost, serms.merge$dem.share, use = 'complete.obs')
# cor.test(serms.merge$rights_talk_xgboost, serms.merge$comp.rescale, use = 'complete.obs')
# cor.test(serms.merge$rights_talk_xgboost, serms.merge$tot.rate.fix, use = 'complete.obs')
# cor.test(serms.merge$rights_talk_xgboost, serms.merge$evan.rate.fix, use = 'complete.obs')
# cor.test(serms.merge$rights_talk_xgboost, serms.merge$elect.szn.2wk, use = 'complete.obs')
# cor.test(serms.merge$rights_talk_xgboost, serms.merge$muslim.rate.fix, use = 'complete.obs')

cor(serms.merge$rights.final, serms.merge$dem.share, use = 'complete.obs')
cor.test(serms.merge$rights.final, serms.merge$dem.share, use = 'complete.obs')
cor.test(serms.merge$rights.final, serms.merge$comp.rescale, use = 'complete.obs')
cor.test(serms.merge$rights.final, serms.merge$tot.rate.fix, use = 'complete.obs')
cor.test(serms.merge$rights.final, serms.merge$evan.rate.fix, use = 'complete.obs')
cor.test(serms.merge$rights.final, serms.merge$elect.szn.2wk, use = 'complete.obs')
cor.test(serms.merge$rights.final, serms.merge$muslim.rate.fix, use = 'complete.obs')

library(ltm)
biserial.cor(serms.merge$dem.share, serms.merge$rights.final, use = 'complete.obs')

## Attack
# cor.test(serms.merge$is.attack, serms.merge$dem.share, use = 'complete.obs')
# cor.test(serms.merge$is.attack, serms.merge$comp.rescale, use = 'complete.obs')
# cor.test(serms.merge$is.attack, serms.merge$tot.rate.fix, use = 'complete.obs')
# cor.test(serms.merge$is.attack, serms.merge$evan.rate.fix, use = 'complete.obs')
# cor.test(serms.merge$is.attack, serms.merge$elect.szn.2wk, use = 'complete.obs')
# cor.test(serms.merge$is.attack, serms.merge$muslim.rate.fix, use = 'complete.obs')

cor.test(serms.merge$attack.final, serms.merge$dem.share, use = 'complete.obs')
cor.test(serms.merge$attack.final, serms.merge$comp.rescale, use = 'complete.obs')
cor.test(serms.merge$attack.final, serms.merge$tot.rate.fix, use = 'complete.obs')
cor.test(serms.merge$attack.final, serms.merge$evan.rate.fix, use = 'complete.obs')
cor.test(serms.merge$attack.final, serms.merge$elect.szn.2wk, use = 'complete.obs')
cor.test(serms.merge$attack.final, serms.merge$muslim.rate.fix, use = 'complete.obs')

#cor.test(serms.merge$is.attack, serms.merge$elect.szn.2wk, use = 'complete.obs', method='kendall')

## Political
# cor.test(serms.merge$is.pol, serms.merge$dem.share, use = 'complete.obs')
# cor.test(serms.merge$is.pol, serms.merge$comp.rescale, use = 'complete.obs')
# cor.test(serms.merge$is.pol, serms.merge$tot.rate.fix, use = 'complete.obs')
# cor.test(serms.merge$is.pol, serms.merge$evan.rate.fix, use = 'complete.obs')
# cor.test(serms.merge$is.pol, serms.merge$elect.szn.2wk, use = 'complete.obs')
# cor.test(serms.merge$is.pol, serms.merge$muslim.rate.fix, use = 'complete.obs')

cor.test(serms.merge$pol.final, serms.merge$dem.share, use = 'complete.obs')
cor.test(serms.merge$pol.final, serms.merge$comp.rescale, use = 'complete.obs')
cor.test(serms.merge$pol.final, serms.merge$tot.rate.fix, use = 'complete.obs')
cor.test(serms.merge$pol.final, serms.merge$evan.rate.fix, use = 'complete.obs')
cor.test(serms.merge$pol.final, serms.merge$elect.szn.2wk, use = 'complete.obs')
cor.test(serms.merge$pol.final, serms.merge$muslim.rate.fix, use = 'complete.obs')


### Correlation of ch1 politics measure and ch2 politics measure
cor.test(serms.merge$pol.final, serms.merge$pol.count.x, use = 'complete.obs')
cor.test(serms.merge$pol.final, serms.merge$is.pol, use = 'complete.obs')


### Rescale key IV's to 0-100
library(scales)
serms.merge$dem.share.rescale <- rescale(serms.merge$dem.share, to = c(0, 100))
serms.merge$tot.rate.rescale <- rescale(serms.merge$tot.rate.fix, to = c(0, 100))
serms.merge$evan.rate.rescale <- rescale(serms.merge$evan.rate.fix, to = c(0, 100))
serms.merge$muslim.rate.rescale <- rescale(serms.merge$muslim.rate.fix, to = c(0, 100))



### Baseline models
# Rights
# base.rights <- glm(rights_talk_xgboost~dem.share.rescale+comp.rescale+tot.rate.rescale+evan.rate.rescale+elect.szn.2wk+
#                      muslim.rate.rescale+as.factor(STABBR), 
#                    data = serms.merge)
# summary(base.rights)

base.rights <- glm(rights.final~dem.share.rescale+comp.rescale+tot.rate.rescale+evan.rate.rescale+elect.szn.2wk+
                     muslim.rate.rescale+as.factor(STABBR), 
                   data = serms.merge)
summary(base.rights)

# Attacks
# base.attacks <- glm(is.attack~dem.share.rescale+comp.rescale+tot.rate.rescale+evan.rate.rescale+elect.szn.2wk+
#                       muslim.rate.rescale+as.factor(STABBR), 
#                     data = serms.merge)
# summary(base.attacks)

base.attacks <- glm(attack.final~dem.share.rescale+comp.rescale+tot.rate.rescale+evan.rate.rescale+elect.szn.2wk+
                      muslim.rate.rescale+as.factor(STABBR), 
                    data = serms.merge)
summary(base.attacks)

# Political
# base.pol <- glm(is.pol~dem.share.rescale+comp.rescale+tot.rate.rescale+evan.rate.rescale+elect.szn.2wk+
#                   muslim.rate.rescale+as.factor(STABBR), 
#                   data = serms.merge)
# summary(base.pol)

base.pol <- glm(pol.final~dem.share.rescale+comp.rescale+tot.rate.rescale+evan.rate.rescale+elect.szn.2wk+
                  muslim.rate.rescale+as.factor(STABBR), 
                data = serms.merge)
summary(base.pol)


library(stargazer)
stargazer(base.rights,base.attacks,base.pol, dep.var.labels = c('Rights Talk','Attacks','Political'),
          single.row =  T, covariate.labels = c('Dem. Vote Share', 'Electoral Competition', 
                                                'Total Rate of Adherence', 'Evangelical Rate of Adherence',
                                                'Election Season', 'Muslim Rate of Adherence'),
          star.cutoffs = c(.05, .01),star.char = c("*", "**"))




serms.merge$hh_income <- serms.merge$hh_income/1000
serms.merge$female.pastor <- ifelse(serms.merge$gender.final == 'female', 1, 0)

### Models w/ controls
#full.rights <- glm(rights_talk_xgboost~dem.share.rescale+comp.rescale+tot.rate.rescale+evan.rate.rescale+elect.szn.2wk+
#                     muslim.rate.rescale+female.pastor+log(pop10)+census_region+other+evang+black.final+hispanic.final+
#                     api.final+hh_income+rural+as.factor(STABBR), 
#                   data = serms.merge)
#summary(full.rights)
full.rights <- glm(rights.final~dem.share.rescale+comp.rescale+tot.rate.rescale+evan.rate.rescale+elect.szn.2wk+
                     muslim.rate.rescale+female.pastor+log(pop10)+census_region+other+evang+black.final+hispanic.final+
                     api.final+hh_income+rural+as.factor(STABBR), 
                   data = serms.merge)
summary(full.rights)

#full.attacks <- glm(is.attack~dem.share.rescale+comp.rescale+tot.rate.rescale+evan.rate.rescale+elect.szn.2wk+
#                     muslim.rate.rescale+female.pastor+log(pop10)+census_region+other+evang+black.final+hispanic.final+
#                     api.final+hh_income+rural+as.factor(STABBR), 
#                   data = serms.merge)
#summary(full.attacks)
full.attacks <- glm(attack.final~dem.share.rescale+comp.rescale+tot.rate.rescale+evan.rate.rescale+elect.szn.2wk+
                      muslim.rate.rescale+female.pastor+log(pop10)+census_region+other+evang+black.final+hispanic.final+
                      api.final+hh_income+rural+as.factor(STABBR), 
                    data = serms.merge)
summary(full.attacks)

#full.pol <- glm(is.pol~dem.share.rescale+comp.rescale+tot.rate.rescale+evan.rate.rescale+elect.szn.2wk+
#                      muslim.rate.rescale+female.pastor+log(pop10)+census_region+other+evang+black.final+hispanic.final+
#                      api.final+hh_income+rural+as.factor(STABBR), 
#                    data = serms.merge)
#summary(full.pol)
full.pol <- glm(pol.final~dem.share.rescale+comp.rescale+tot.rate.rescale+evan.rate.rescale+elect.szn.2wk+
                  muslim.rate.rescale+female.pastor+log(pop10)+census_region+other+evang+black.final+hispanic.final+
                  api.final+hh_income+rural+as.factor(STABBR), 
                data = serms.merge)
summary(full.pol)


stargazer(full.rights,full.attacks,full.pol, dep.var.labels = c('Rights Talk','Attacks','Political'),
          single.row =  T, covariate.labels = c('Dem. Vote Share', 'Electoral Competition', 
                                                'Total Rate of Adherence', 'Evangelical Rate of Adherence',
                                                'Election Season', 'Muslim Rate of Adherence','Female Pastor',
                                                'Logged Pop.', 'Northeast', 'South', 'West', 'Other Christian Pastor',
                                                'Evangelical Pastor', 'Black Pastor','Hispanic Pastor','Asian Pastor',
                                                'Average County Income','Rural County'),
          star.cutoffs = c(.05, .01),star.char = c("*", "**"))



### Break out top 9 denom's
# Group number of sermons by denomination
denom.group <- plyr::count(serms.merge, 'denom.fixed')
denom.group$rel <- round(100 * denom.group$freq / sum(denom.group$freq),2)
denom.group <- denom.group[order(denom.group$freq, decreasing = T),]

head(denom.group,9)

library(car)
serms.merge$denom.top9 <- recode(serms.merge$denom.fixed, 
                               "'Baptist' = 'Baptist'; 'Christian/Church Of Christ' = 'Christian/Church Of Christ';
                               'Evangelical/Non-Denominational' = 'Evangelical/Non-Denominational';
                               'Pentecostal' = 'Pentecostal'; 
                               'Assembly Of God' = 'Assembly Of God';
                               'Lutheran' = 'Lutheran';
                               'Presbyterian/Reformed' = 'Presbyterian/Reformed';
                               'Independent/Bible' = 'Independent/Bible';
                               'Methodist' = 'Methodist';
                               else = 'Other'")
unique(serms.merge$denom.top9)

serms.merge$baptist <- ifelse(serms.merge$denom.top9 == 'Baptist', 1, 0)
serms.merge$church.christ <- ifelse(serms.merge$denom.top9 == 'Christian/Church Of Christ', 1, 0)
serms.merge$non.denom <- ifelse(serms.merge$denom.top9 == 'Evangelical/Non-Denominational', 1, 0)
serms.merge$pentecostal <- ifelse(serms.merge$denom.top9 == 'Pentecostal', 1, 0)
serms.merge$assembly <- ifelse(serms.merge$denom.top9 == 'Assembly Of God', 1, 0)
serms.merge$lutheran <- ifelse(serms.merge$denom.top9 == 'Lutheran', 1, 0)
serms.merge$presybterian <- ifelse(serms.merge$denom.top9 == 'Presbyterian/Reformed', 1, 0)
serms.merge$bible <- ifelse(serms.merge$denom.top9 == 'Independent/Bible', 1, 0)
serms.merge$meth <- ifelse(serms.merge$denom.top9 == 'Methodist', 1, 0)


### Models w/ controls and denom's
denom.rights <- glm(rights.final~dem.share.rescale+comp.rescale+tot.rate.rescale+evan.rate.rescale+elect.szn.2wk+
                     muslim.rate.rescale+female.pastor+log(pop10)+census_region+baptist+church.christ+non.denom+
                      pentecostal+assembly+lutheran+presybterian+bible+meth+black.final+hispanic.final+
                     api.final+hh_income+rural+as.factor(STABBR), 
                   data = serms.merge)
summary(denom.rights)

denom.attacks <- glm(attack.final~dem.share.rescale+comp.rescale+tot.rate.rescale+evan.rate.rescale+elect.szn.2wk+
                      muslim.rate.rescale+female.pastor+log(pop10)+census_region+baptist+church.christ+non.denom+
                       pentecostal+assembly+lutheran+presybterian+bible+meth+black.final+hispanic.final+
                      api.final+hh_income+rural+as.factor(STABBR), 
                    data = serms.merge)
summary(denom.attacks)

denom.pol <- glm(pol.final~dem.share.rescale+comp.rescale+tot.rate.rescale+evan.rate.rescale+elect.szn.2wk+
                  muslim.rate.rescale+female.pastor+log(pop10)+census_region+baptist+church.christ+non.denom+
                   pentecostal+assembly+lutheran+presybterian+bible+meth+black.final+hispanic.final+
                  api.final+hh_income+rural+as.factor(STABBR), 
                data = serms.merge)
summary(denom.pol)

stargazer(denom.rights,denom.attacks,denom.pol, dep.var.labels = c('Rights Talk','Attacks','Political'),
          single.row =  T, covariate.labels = c('Dem. Vote Share', 'Electoral Competition', 
                                                'Total Rate of Adherence', 'Evangelical Rate of Adherence',
                                                'Election Season', 'Muslim Rate of Adherence','Female Pastor',
                                                'Logged Pop.', 'Northeast', 'South', 'West', 'Baptist', 'Church of Christ',
                                                'Non-Denominational', 'Pentecostal', 'Assembly of God', 'Lutheran', 
                                                'Presbyterian', 'Independent/Bible', 'Methodist', 'Black Pastor',
                                                'Hispanic Pastor','Asian Pastor', 'Average County Income','Rural County'),
          star.cutoffs = c(.05, .01),star.char = c("*", "**"))


### Correlation table -> rights talk, attack on religion, political speech
cor.test(serms.merge$rights_talk_xgboost, serms.merge$is.attack, use = 'complete.obs')
cor.test(serms.merge$rights_talk_xgboost, serms.merge$is.pol, use = 'complete.obs')

cor.table <- serms.merge[,c('rights_talk_xgboost', 'is.attack','is.pol')]
colnames(cor.table) <- c('Rights Talk', 'Attack Religion', 'Political')
mcor<-round(cor(cor.table),2)

# Hide upper triangle
upper<-mcor
upper[upper.tri(mcor)]<-""
upper<-as.data.frame(upper)
upper


library(xtable)
print(xtable(upper), type="latex")

library(Hmisc)

corstars <-function(x, method=c("pearson", "spearman"), removeTriangle=c("upper", "lower"),
                    result=c("none", "html", "latex")){
  #Compute correlation matrix
  require(Hmisc)
  x <- as.matrix(x)
  correlation_matrix<-rcorr(x, type=method[1])
  R <- correlation_matrix$r # Matrix of correlation coeficients
  p <- correlation_matrix$P # Matrix of p-value 
  
  ## Define notions for significance levels; spacing is important.
  mystars <- ifelse(p < .0001, "****", ifelse(p < .001, "*** ", ifelse(p < .01, "**  ", ifelse(p < .05, "*   ", "    "))))
  
  ## trunctuate the correlation matrix to two decimal
  R <- format(round(cbind(rep(-1.11, ncol(x)), R), 2))[,-1]
  
  ## build a new matrix that includes the correlations with their apropriate stars
  Rnew <- matrix(paste(R, mystars, sep=""), ncol=ncol(x))
  diag(Rnew) <- paste(diag(R), " ", sep="")
  rownames(Rnew) <- colnames(x)
  colnames(Rnew) <- paste(colnames(x), "", sep="")
  
  ## remove upper triangle of correlation matrix
  if(removeTriangle[1]=="upper"){
    Rnew <- as.matrix(Rnew)
    Rnew[upper.tri(Rnew, diag = TRUE)] <- ""
    Rnew <- as.data.frame(Rnew)
  }
  
  ## remove lower triangle of correlation matrix
  else if(removeTriangle[1]=="lower"){
    Rnew <- as.matrix(Rnew)
    Rnew[lower.tri(Rnew, diag = TRUE)] <- ""
    Rnew <- as.data.frame(Rnew)
  }
  
  ## remove last column and return the correlation matrix
  Rnew <- cbind(Rnew[1:length(Rnew)-1])
  if (result[1]=="none") return(Rnew)
  else{
    if(result[1]=="html") print(xtable(Rnew), type="html")
    else print(xtable(Rnew), type="latex") 
  }
} 

corstars(cor.table, result="latex")


####################################################################################################################
## In-sample predicted probabilities





####################################################################################################################

#myvars <- c('gender.final', 'pop10', 'Parenth', 'census_region',
#            'pop_dens', 'pct_black', 'white.y', 'female', 'hh_income', 'su_gun4', 'TOTCNG', 
#            'TOTADH', 'TOTRATE', 'EVANCNG', 'EVANADH', 'EVANRATE', 'STNAME', 'dem.share', 'year', 'fair',
#            'cath', 'main', 'evang', 'other', 'black.final', 'hispanic.final', 'white.final', 'api.final',
#            'rights_talk_xgboost', 'comp.rescale')