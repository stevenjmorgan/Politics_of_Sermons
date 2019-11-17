# This script implements models for Ch. 2.

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


### Table w/ correlations (in Latex)
## Rights
cor(serms.merge$rights_talk_xgboost, serms.merge$dem.share, use = 'complete.obs')
cor.test(serms.merge$rights_talk_xgboost, serms.merge$dem.share, use = 'complete.obs')
cor.test(serms.merge$rights_talk_xgboost, serms.merge$comp.rescale, use = 'complete.obs')
cor.test(serms.merge$rights_talk_xgboost, serms.merge$tot.rate.fix, use = 'complete.obs')
cor.test(serms.merge$rights_talk_xgboost, serms.merge$evan.rate.fix, use = 'complete.obs')
cor.test(serms.merge$rights_talk_xgboost, serms.merge$elect.szn.2wk, use = 'complete.obs')
cor.test(serms.merge$rights_talk_xgboost, serms.merge$muslim.rate.fix, use = 'complete.obs')

library(ltm)
biserial.cor(serms.merge$dem.share, serms.merge$rights_talk_xgboost, use = 'complete.obs')

## Attack
cor.test(serms.merge$is.attack, serms.merge$dem.share, use = 'complete.obs')
cor.test(serms.merge$is.attack, serms.merge$comp.rescale, use = 'complete.obs')
cor.test(serms.merge$is.attack, serms.merge$tot.rate.fix, use = 'complete.obs')
cor.test(serms.merge$is.attack, serms.merge$evan.rate.fix, use = 'complete.obs')
cor.test(serms.merge$is.attack, serms.merge$elect.szn.2wk, use = 'complete.obs')
cor.test(serms.merge$is.attack, serms.merge$muslim.rate.fix, use = 'complete.obs')

#cor.test(serms.merge$is.attack, serms.merge$elect.szn.2wk, use = 'complete.obs', method='kendall')

## Political
cor.test(serms.merge$is.pol, serms.merge$dem.share, use = 'complete.obs')
cor.test(serms.merge$is.pol, serms.merge$comp.rescale, use = 'complete.obs')
cor.test(serms.merge$is.pol, serms.merge$tot.rate.fix, use = 'complete.obs')
cor.test(serms.merge$is.pol, serms.merge$evan.rate.fix, use = 'complete.obs')
cor.test(serms.merge$is.pol, serms.merge$elect.szn.2wk, use = 'complete.obs')
cor.test(serms.merge$is.pol, serms.merge$muslim.rate.fix, use = 'complete.obs')


### Baseline models
# Rights
base.rights <- glm(rights_talk_xgboost~dem.share+comp.rescale+tot.rate.fix+evan.rate.fix+elect.szn.2wk+
                     muslim.rate.fix+as.factor(STABBR), 
                   data = serms.merge)
summary(base.rights)

# Attacks
base.attacks <- glm(is.attack~dem.share+comp.rescale+tot.rate.fix+evan.rate.fix+elect.szn.2wk+
                      muslim.rate.fix+as.factor(STABBR), 
                    data = serms.merge)
summary(base.attacks)

# Political
base.pol <- glm(is.pol~dem.share+comp.rescale+tot.rate.fix+evan.rate.fix+elect.szn.2wk+
                  muslim.rate.fix+as.factor(STABBR), 
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
full.rights <- glm(rights_talk_xgboost~dem.share+comp.rescale+tot.rate.fix+evan.rate.fix+elect.szn.2wk+
                     muslim.rate.fix+female.pastor+log(pop10)+census_region+other+evang+black.final+hispanic.final+
                     api.final+hh_income+as.factor(STABBR), 
                   data = serms.merge)
summary(full.rights)

full.attacks <- glm(is.attack~dem.share+comp.rescale+tot.rate.fix+evan.rate.fix+elect.szn.2wk+
                     muslim.rate.fix+female.pastor+log(pop10)+census_region+other+evang+black.final+hispanic.final+
                     api.final+hh_income+as.factor(STABBR), 
                   data = serms.merge)
summary(full.attacks)

full.pol <- glm(is.pol~dem.share+comp.rescale+tot.rate.fix+evan.rate.fix+elect.szn.2wk+
                      muslim.rate.fix+female.pastor+log(pop10)+census_region+other+evang+black.final+hispanic.final+
                      api.final+hh_income+as.factor(STABBR), 
                    data = serms.merge)
summary(full.pol)


stargazer(full.rights,full.attacks,full.pol, dep.var.labels = c('Rights Talk','Attacks','Political'),
          single.row =  T, covariate.labels = c('Dem. Vote Share', 'Electoral Competition', 
                                                'Total Rate of Adherence', 'Evangelical Rate of Adherence',
                                                'Election Season', 'Muslim Rate of Adherence','Female Pastor',
                                                'Logged Pop.', 'Northeast', 'South', 'West', 'Other Christian Pastor',
                                                'Evangelical Pastor', 'Black Pastor','Hispanic Pastor','Asian Pastor',
                                                'Average County Income'),
          star.cutoffs = c(.05, .01),star.char = c("*", "**"))




####################################################################################################################

myvars <- c('gender.final', 'pop10', 'Parenth', 'census_region',
            'pop_dens', 'pct_black', 'white.y', 'female', 'hh_income', 'su_gun4', 'TOTCNG', 
            'TOTADH', 'TOTRATE', 'EVANCNG', 'EVANADH', 'EVANRATE', 'STNAME', 'dem.share', 'year', 'fair',
            'cath', 'main', 'evang', 'other', 'black.final', 'hispanic.final', 'white.final', 'api.final',
            'rights_talk_xgboost', 'comp.rescale')