# This script analyzes data from an MTurk experiment probing
# the relationship between framing and political attitudes.

rm(list=ls())
setwd("C:/Users/SF515-51T/Desktop/Dissertation/Ch3")

library(car)
library(tidyverse)
library(RCurl)

#mturk <- read.csv('Rights_Talk_First50.csv', stringsAsFactors = F)
mturk <- read.csv('MTurk_Rights_Final_12-30.csv', stringsAsFactors = F)

# Remove first two rows (extra headers)
mturk <- mturk[3:nrow(mturk),]

# Remove checks I made after initial sample of 50
mturk <- mturk[which(mturk$Q43 != 'This is a test ensuring condition names are correct.'),]

# Remove individuals that did not make it to randomization stage
unique(mturk$group)
mturk <- mturk[which(mturk$group != ''),]

nrow(mturk[which(mturk$group == 'Control'),])  # 311
nrow(mturk[which(mturk$group == 'Moral'),])    # 313
nrow(mturk[which(mturk$group == 'Rights'),])   # 314
nrow(mturk[which(mturk$group == 'Attack'),])   # 310


### Convert variables
# Gender
unique(mturk$Q1)
mturk$female <- car::recode(mturk$Q1, as.factor = F, "'Female' = 1; 'Male' = 0;
                                                'Prefer not to say' = NA;
                                                else = NA")
unique(mturk$female)

# Sexual pref
unique(mturk$Q41)
# Make sure no 'Prefer not to say' (spelling/format)
mturk$gay <- car::recode(mturk$Q41, as.factor = F, "'Heterosexual or straight' = 0;
                                              'Prefer not to say' = NA;
                                              else = 1")
unique(mturk$gay)

# Education
unique(mturk$Q2)
mturk$educ <- car::recode(mturk$Q2, as.factor = F, "'Did not graduate high school' = 0;
                                              'High School Degree/GED Equivalent' = 1;
                                              'Technical School Certification' = 2;
                                              'Some College' = 3;
                                              'College Degree' = 4;
                                              'Graduate or Professional Degree' = 5;
                                              'Prefer not to say' = NA;
                                              else = NA")
unique(mturk$educ)

# Age
class(mturk$Q3_1)
mturk$age <- as.numeric(mturk$Q3_1)
summary(mturk$age)

# Income
unique(mturk$Q4)
mturk$income <- car::recode(mturk$Q4, as.factor = F, "'Less than $30,000' = 0;
                                                '$30,001-50,000' = 1;
                                                '$50,001-75,000' = 2;
                                                '$75,001-100,000' = 3;
                                                '$100,001-150,000' = 4;
                                                'Over $150,000' = 5;
                                                'Prefer not to say' = NA;
                                                else = NA")
unique(mturk$income)

# Hispanic
unique(mturk$Q5)
mturk$hisp <- car::recode(mturk$Q5, as.factor = F, "'Yes' = 1; 'No' = 0;
                                                'Prefer not to say' = NA; else = NA")
unique(mturk$hisp)
summary(mturk$hisp==1)

# Race - Black
unique(mturk$Q6)
mturk$black <- car::recode(mturk$Q6, as.factor = F, "'Black or African American' = 1;
                                                'Prefer not to say' = NA; '' = NA;
                                                else = 0")
unique(mturk$black)

# Race - White
mturk$white <- car::recode(mturk$Q6, as.factor = F, "'White' = 1;
                                                'Prefer not to say' = NA; '' = NA;
                                                else = 0")
unique(mturk$white)

# Race - Asian
mturk$asian <- car::recode(mturk$Q6, as.factor = F, "'Asian' = 1;
                                                'Prefer not to say' = NA; '' = NA;
                                                else = 0")
unique(mturk$asian)

# Race - Other
mturk$other.race <- car::recode(mturk$Q6, as.factor = F, "'American Indian or Alaska Native' = 1;
                                                'Native Hawaiian or Pacific Islander' = 1;
                                                'Other' = 1;
                                                'Prefer not to say' = NA; '' = NA;
                                                else = 0")
unique(mturk$other.race)

# Know a gay person
unique(mturk$Q7)
mturk$gay.know <- car::recode(mturk$Q7, as.factor = F, "'Yes' = 1; 'No' = 0; 'Prefer not to say' = NA;'' = NA")
unique(mturk$gay.know)

# PID -> 7 point scale, 0 strong Dem, 6 strong GOP
unique(mturk$Q8)
mturk$PID <- NA
# GOP
mturk$PID <- ifelse(mturk$Q8 == 'A Republican' & mturk$Q9a == 'Strong', 6, mturk$PID)
mturk$PID <- ifelse(mturk$Q8 == 'A Republican' & mturk$Q9a == 'Not very strong', 5, mturk$PID)
# Dem
mturk$PID <- ifelse(mturk$Q8 == 'A Democrat' & mturk$Q9b == 'Strong', 0, mturk$PID)
mturk$PID <- ifelse(mturk$Q8 == 'A Democrat' & mturk$Q9b == 'Not very strong', 1, mturk$PID)
# Independent: Leaners and true independents
mturk$PID <- ifelse(mturk$Q8 == 'An Independent' & mturk$Q9c == 'Closer to Democratic Party', 2, mturk$PID)
mturk$PID <- ifelse(mturk$Q8 == 'An Independent' & mturk$Q9c == 'Closer to Republican Party', 4, mturk$PID)
mturk$PID <- ifelse(mturk$Q8 == 'An Independent' & mturk$Q9c == 'Neither', 3, mturk$PID)
mturk$PID <- ifelse(mturk$Q8 == 'An Independent' & mturk$Q9c == '', 3, mturk$PID)
# Other ?????
mturk$PID <- ifelse(mturk$Q8 == 'Other Party' | mturk$Q8 == 'Prefer not to say', NA, mturk$PID)
summary(mturk$PID)
#hist(mturk$PID)

# Ideology -> 0 Strong liberal, 6 Strong conservatie
unique(mturk$Q10)
mturk$ideo <- car::recode(mturk$Q10, as.factor = F, "'Strongly Liberal' = 0;
                    'Moderately Liberal' = 1; 'Somewhat Liberal' = 2;
                    'Neither Conservative nor Liberal' = 3; 
                    'Somewhat Conservative' = 4; 'Moderately Conservative' = 5;
                    'Strongly Conservative' = 6; else = NA")
summary(mturk$ideo)
#hist(mturk$ideo)

# State to region
url <- 'https://raw.githubusercontent.com/cphalpert/census-regions/master/us%20census%20bureau%20regions%20and%20divisions.csv'
state.region <- read.csv(url, stringsAsFactors = F)
colnames(state.region)[which(colnames(state.region) == 'State.Code')] <- 'Q11_1'
mturk <- left_join(mturk, state.region, by = 'Q11_1')
rm(url,state.region)

mturk$midwest <- car::recode(mturk$Region, as.factor = F, "'Midwest' = 1; 
                             'South' = 0; 'West' = 0; 'Northeast' = 0; else = NA")
mturk$south <- car::recode(mturk$Region, as.factor = F, "'Midwest' = 0; 
                             'South' = 1; 'West' = 0; 'Northeast' = 0; else = NA")
mturk$northeast <- car::recode(mturk$Region, as.factor = F, "'Midwest' = 0; 
                             'South' = 0; 'West' = 0; 'Northeast' = 1; else = NA")
mturk$west <- car::recode(mturk$Region, as.factor = F, "'Midwest' = 0; 
                             'South' = 0; 'West' = 1; 'Northeast' = 0; else = NA")
unique(mturk$midwest)
unique(mturk$northeast)
unique(mturk$south)
unique(mturk$west)

# Religious affiliation
unique(mturk$Q42)
mturk$cath <- car::recode(mturk$Q42, as.factor = F, "'Roman Catholic' = 1;
                     'Prefer not to say' = NA; '' = NA; else = 0")
unique(mturk$cath)

main <- "Protestant (including Baptist, Lutheran, Methodist, Presbyterian, Episcopalian, Pentecostal, Jehovah's Witness, Church of Christ, etc.)"
mturk$prot <- car::recode(mturk$Q42, as.factor = F, "main = 1;
                     'Prefer not to say' = NA; '' = NA; else = 0")
unique(mturk$prot)

mturk$jew <- car::recode(mturk$Q42, as.factor = F, "'Jewish' = 1; 'Prefer not to say' = NA; '' = NA;
                         else = 0")
unique(mturk$jew)

mturk$none <- car::recode(mturk$Q42, as.factor = F, "'No religion, not a believer, atheist, agnostic' = 1;
                          'Prefer not to say' = NA; '' = NA; else = 0")
unique(mturk$none)

mturk$other.religion <- car::recode(mturk$Q42, as.factor = F, "'Jewish' = 0; 'Roman Catholic' = 0;
                                    main = 0; 'No religion, not a believer, atheist, agnostic' = 0;
                                    'Prefer not to say' = NA; '' = NA; else = 1")
unique(mturk$other.religion)

# Evangelical self-identification
unique(mturk$Q13)
mturk$evang.self.ident <- car::recode(mturk$Q13, as.factor = F, "'Yes, would' = 1;
                                      'No, would not' = 0; '' = NA; else = NA")
unique(mturk$evang.self.ident)
summary(mturk$evang.self.ident==1)

# Religious service attendance: 0-5 scale, 0 Never 5 more than once a week
unique(mturk$Q14)
mturk$rel.attend <- car::recode(mturk$Q14, as.factor = F, "'Never' = 0;
                                'Seldom' = 1; 'A few times a year' = 2;
                                'Once or twice a month' = 3; 'Once a week' = 4;
                                'More than once a week' = 5; else = NA")
unique(mturk$rel.attend)


### Evangelical identity-belief
# Biblical inerrancy -> 0-2
unique(mturk$Q16)
mturk$bible <- car::recode(mturk$Q16, as.factor = F, "'The Bible is an ancient book of fables, legends, history, and moral precepts recorded by men.' = 0;
                           'The Bible is the inspired Word of God but not everything in it should be taken literally, word for word.' = 0;
                           'The Bible is the actual Word of God and is to be taken literally, word for word.' = 1; else = NA")
unique(mturk$bible)
hist(mturk$bible)

mturk$bible.dontuse <- car::recode(mturk$Q16, as.factor = F, "'The Bible is an ancient book of fables, legends, history, and moral precepts recorded by men.' = 0;
                           'The Bible is the inspired Word of God but not everything in it should be taken literally, word for word.' = 1;
                           'The Bible is the actual Word of God and is to be taken literally, word for word.' = 2; else = NA")


# If agree or strongly agree -> 1 on Barna Group scale (Margolis 2019)
unique(mturk$Barna.Scale_1)
mturk$evangelize <- ifelse(mturk$Barna.Scale_1 == 'Strongly Agree' | mturk$Barna.Scale_1 == 'Agree', 1, 0)
unique(mturk$Barna.Scale_2)
mturk$heaven <- ifelse(mturk$Barna.Scale_2 == 'Strongly Agree' | mturk$Barna.Scale_2 == 'Agree', 1, 0)
unique(mturk$Barna.Scale_3)
mturk$jesus.sin <- ifelse(mturk$Barna.Scale_3 == 'Strongly Disagree' | mturk$Barna.Scale_3 == 'Disagree', 1, 0) # Reverse coded
unique(mturk$Barna.Scale_4)
mturk$faith.import <- ifelse(mturk$Barna.Scale_4 == 'Strongly Agree' | mturk$Barna.Scale_4 == 'Agree', 1, 0)
unique(mturk$Barna.Scale_5)
mturk$devil <- ifelse(mturk$Barna.Scale_5 == 'Strongly Disagree' | mturk$Barna.Scale_5 == 'Disagree', 1, 0) # Reverse coded
unique(mturk$Barna.Scale_6)
mturk$belief.god <- ifelse(mturk$Barna.Scale_6 == 'Strongly Agree' | mturk$Barna.Scale_6 == 'Agree', 1, 0)

# Index Evangelical belief score (0-7) w/ higher values indicating higher evang. identity
mturk$evang.belief.score <- mturk$bible + mturk$evangelize + mturk$heaven + mturk$jesus.sin + mturk$faith.import + mturk$devil + mturk$belief.god
hist(mturk$evang.belief.score)

# Pol. Knowledge -> ordinal 0, 1, or 2
unique(mturk$Q17)
unique(mturk$Q18)
mturk$pol.know <- 0
mturk$pol.know <- ifelse(mturk$Q17 == 'Republicans', mturk$pol.know + 1, mturk$pol.know)
mturk$pol.know <- ifelse(mturk$Q18 == 'Democrats', mturk$pol.know + 1, mturk$pol.know)
unique(mturk$pol.know)
summary(mturk$pol.know)

# Support for gay rights -> ordinal 0, 1, 2
unique(mturk$Q19)
unique(mturk$Q20)
mturk$support.gays <- 0
mturk$support.gays <- ifelse(mturk$Q19 == 'Yes, new laws needed', mturk$support.gays + 1, mturk$support.gays)
mturk$support.gays <- ifelse(mturk$Q20 == 'No', mturk$support.gays + 1, mturk$support.gays) # Reverse coded
unique(mturk$support.gays)
summary(mturk$support.gays)

# Pol. interest -> ordinal 0 (not at all) to 4 (extremely)
unique(mturk$Q21)
mturk$pol.int <- car::recode(mturk$Q21, as.factor = F, "'Not interested at all' = 0;
                             'Slightly interested' = 1; 'Moderately interested' = 2;
                             'Very interested' = 3; 'Extremely interested' = 4; else = NA")
unique(mturk$pol.int)
summary(mturk$pol.int)

# Manipulation check
unique(mturk$Q23)
mturk$manip <- ifelse(mturk$Q23 == 'HIV', 1, 0)
summary(mturk$manip==1)

# Treatment group
unique(mturk$group)
barplot(table(mturk$group))


### DV's
# Candidate FT (0-100)
mturk$cand.ft <- as.numeric(mturk$Q25_1)
summary(mturk$cand.ft)

# Vote for candidate -> ordinal 0 (very unlikely) 4 (Very likely)
unique(mturk$Q26)
mturk$cand.vote <- car::recode(mturk$Q26, as.factor = F, "'Very unlikely' = 0; 
                               'Somewhat unlikely' = 1; 'Neither likely nor unlikely' = 2;
                               'Somewhat likely' = 3; 'Very likely' = 4; else = NA")
unique(mturk$cand.vote)
summary(mturk$cand.vote==4)

# Agree w/ refusal -> ordinal 0 (strongly disagree) 4 (strongly agree)
unique(mturk$Q27)
mturk$cand.agree <- car::recode(mturk$Q27, as.factor = F, "'Strongly Disagree' = 0; 
                                'Disagree' = 1; 'Neither agree nor disagree' = 2;
                                'Agree' = 3; 'Strongly Agree' = 4; else = NA")
unique(mturk$cand.agree)
summary(mturk$cand.agree==3)

# Open-ended response
class(mturk$Q43)
mturk$text <- mturk$Q43

# Candidate ideol. perception -> 0-10 (0 very liberal, 10 very conservative)
unique(mturk$Q45)
mturk$cand.ideo <- as.numeric(mturk$Q45)
summary(mturk$cand.ideo)

# Binarize treatment groups
mturk$moral <- ifelse(mturk$group == 'Moral', 1, 0)
mturk$attack <- ifelse(mturk$group == 'Attack', 1, 0)
mturk$rights <- ifelse(mturk$group == 'Rights', 1, 0)
mturk$control <- ifelse(mturk$group == 'Control', 1, 0)
summary(mturk$moral==1)
summary(mturk$attack==1)
summary(mturk$rights==1)
summary(mturk$control==1)


### Subset variables for analysis
vars <- c('group', 'female', 'gay', 'educ', 'age', 'income', 'hisp', 'black', 'white', 
          'asian', 'other.race','gay.know', 'PID', 'ideo', 'midwest', 'south', 
          'northeast', 'west', 'cath', 'prot', 'jew', 'none', 'other.religion', 
          'evang.self.ident', 'rel.attend', 'bible', 'evangelize', 'heaven', 'jesus.sin', 
          'faith.import', 'devil', 'belief.god', 'Barna.Scale_1', 'Barna.Scale_2', 
          'Barna.Scale_3', 'Barna.Scale_4', 'Barna.Scale_5', 'Barna.Scale_6', 
          'evang.belief.score', 'pol.know', 'support.gays', 'pol.int', 'manip', 'cand.ft', 
          'cand.vote', 'cand.agree', 'text', 'cand.ideo', 'moral', 'rights', 'attack', 'control')
mturk.sub <- mturk[vars]

write.csv(mturk.sub, 'cleaned_mturk_final.csv', row.names = F)
save(mturk.sub, file = 'final_cleaned_mturk.RData')



######################################################################################################
### Imputation
######################################################################################################
rm(list=ls())
load('final_cleaned_mturk.RData')
mturk <- mturk.sub
rm(mturk.sub)

# Last value carried forward (for now)
library(zoo)
mturk <- na.locf(mturk)

# Imputed evang. belief score
mturk$evang.belief.imp <- mturk$bible + mturk$evangelize + mturk$heaven + mturk$jesus.sin + 
   mturk$faith.import + mturk$devil + mturk$belief.god
summary(mturk$evang.belief.imp)
cor(mturk$evang.belief.imp, mturk$evang.belief.score) #0.97


# # Amelia-based multiple imputation
# library(Amelia)
# 
# # Multiple imputation assuming multivariate normal distribution
# drops <- c('group', 'Barna.Scale_1', 'Barna.Scale_2', 'Barna.Scale_3', 'Barna.Scale_4',
#            'Barna.Scale_5', 'Barna.Scale_6','text', 'control', 'evang.belief.score', 'other.religion',
#            'other.race', 'west', 'control')
# mturk.a <- mturk[,!(names(mturk) %in% drops)]
# a.out <- amelia(mturk.a)
# a.out
# 
# #hist(a.out$imputations[[3]]$evangelize, col="grey", border="white")
# 
# mturk.mi <- a.out[[1]]$imp3
# rm(mturk.a, a.out, drops)

# Correlation of MI evang. belief score versus original
#mturk.mi$evang.belief.imp <- mturk.mi$bible + mturk.mi$evangelize + mturk.mi$heaven + mturk.mi$jesus.sin + 
#  mturk.mi$faith.import + mturk.mi$devil + mturk.mi$belief.god
#cor(mturk.mi$evang.belief.imp, mturk$evang.belief.score, use = 'complete.obs') #1
#mturk.mi$evang.belief.imp <- round(mturk.mi$evang.belief.imp, 0)
#cor(mturk.mi$evang.belief.imp, mturk$evang.belief.score, use = 'complete.obs') #1

#mturk <- mturk.mi
#rm(mturk.mi)
#mturk$control <- ifelse(mturk$rights == 0 & mturk$moral == 0 & mturk$attack == 0, 1, 0)
#summary(mturk$control==1)

# mturk$group <- NA
# mturk$group <- ifelse(mturk$rights == 1, 'Rights', mturk$group)
# mturk$group <- ifelse(mturk$moral == 1, 'Moral', mturk$group)
# mturk$group <- ifelse(mturk$attack == 1, 'Attack', mturk$group)
# mturk$group <- ifelse(mturk$control == 1, 'Control', mturk$group)
# 
# mturk$evang.self.ident <- round(mturk$evang.self.ident,0)

######################################################################################################
### Analysis
######################################################################################################

### T tests
# Candidate support
t.test(mturk$cand.ft[which(mturk$group == 'Rights')], mturk$cand.ft[which(mturk$group == 'Control')])
t.test(mturk$cand.ft[which(mturk$group == 'Rights')], mturk$cand.ft[which(mturk$group == 'Moral')]) # Significant at p<0.05
t.test(mturk$cand.ft[which(mturk$group == 'Rights')], mturk$cand.ft[which(mturk$group == 'Attack')])

t.test(mturk$cand.ft[which(mturk$group == 'Moral')], mturk$cand.ft[which(mturk$group == 'Control')])
t.test(mturk$cand.ft[which(mturk$group == 'Moral')], mturk$cand.ft[which(mturk$group == 'Attack')])

t.test(mturk$cand.ft[which(mturk$group == 'Attack')], mturk$cand.ft[which(mturk$group == 'Control')])

# Candidate vote
t.test(mturk$cand.vote[which(mturk$group == 'Rights')], mturk$cand.vote[which(mturk$group == 'Control')])
t.test(mturk$cand.vote[which(mturk$group == 'Rights')], mturk$cand.vote[which(mturk$group == 'Moral')])# Significant at p=0.05
t.test(mturk$cand.vote[which(mturk$group == 'Rights')], mturk$cand.vote[which(mturk$group == 'Attack')])

t.test(mturk$cand.vote[which(mturk$group == 'Moral')], mturk$cand.vote[which(mturk$group == 'Control')])
t.test(mturk$cand.vote[which(mturk$group == 'Moral')], mturk$cand.vote[which(mturk$group == 'Attack')])

t.test(mturk$cand.vote[which(mturk$group == 'Attack')], mturk$cand.vote[which(mturk$group == 'Control')])

# Candidate ideological perception
t.test(mturk$cand.ideo[which(mturk$group == 'Rights')], mturk$cand.ideo[which(mturk$group == 'Control')])
t.test(mturk$cand.ideo[which(mturk$group == 'Rights')], mturk$cand.ideo[which(mturk$group == 'Moral')])
t.test(mturk$cand.ideo[which(mturk$group == 'Rights')], mturk$cand.ideo[which(mturk$group == 'Attack')])

t.test(mturk$cand.ideo[which(mturk$group == 'Moral')], mturk$cand.ideo[which(mturk$group == 'Control')])
t.test(mturk$cand.ideo[which(mturk$group == 'Moral')], mturk$cand.ideo[which(mturk$group == 'Attack')]) #p=0.08 (more conservative w/ attack)

t.test(mturk$cand.ideo[which(mturk$group == 'Attack')], mturk$cand.ideo[which(mturk$group == 'Control')])

# Agree w/ candidate stance
t.test(mturk$cand.agree[which(mturk$group == 'Rights')], mturk$cand.agree[which(mturk$group == 'Control')])
t.test(mturk$cand.agree[which(mturk$group == 'Rights')], mturk$cand.agree[which(mturk$group == 'Moral')]) # p = 0.06 (rights more likely to agree)
t.test(mturk$cand.agree[which(mturk$group == 'Rights')], mturk$cand.agree[which(mturk$group == 'Attack')])

t.test(mturk$cand.agree[which(mturk$group == 'Moral')], mturk$cand.agree[which(mturk$group == 'Control')])
t.test(mturk$cand.agree[which(mturk$group == 'Moral')], mturk$cand.agree[which(mturk$group == 'Attack')])

t.test(mturk$cand.agree[which(mturk$group == 'Attack')], mturk$cand.agree[which(mturk$group == 'Control')])


### Plot differences in DV for each treatment group
## Candidate FT
require(dplyr)
alpha <- 0.15

x <- mturk %>% 
  group_by(group) %>% 
  summarize(mean = mean(cand.ft),
            lower = mean(cand.ft) - qt(1- alpha/2, (n() - 1))*sd(cand.ft)/sqrt(n()),
            upper = mean(cand.ft) + qt(1- alpha/2, (n() - 1))*sd(cand.ft)/sqrt(n()))
y <- mturk %>% 
  group_by(group, evang.self.ident) %>% 
  summarize(mean = mean(cand.ft),
            lower = mean(cand.ft) - qt(1- alpha/2, (n() - 1))*sd(cand.ft)/sqrt(n()),
            upper = mean(cand.ft) + qt(1- alpha/2, (n() - 1))*sd(cand.ft)/sqrt(n()))

x %>%
  ggplot(aes(x = group, y = mean)) + geom_point(
    #aes(color = evang.self.ident, fill = evang.self.ident),
    stat = "identity", position = position_dodge(0.8), size = 3
  ) +
  #geom_bar(stat = "identity", position = "dodge") +
  geom_errorbar(aes(ymin = lower, ymax = upper), position = "dodge") + theme_bw() +
  xlab('') + ylab('Candidate Feeling Thermometer') #+ ggtitle('Mean Candidate FT Scores by Treatment')
ggsave('Mean Candidate FT Scores by Treatment.png')


# y %>%
#   ggplot(aes(x = group, y = mean)) +
#   #geom_bar(stat = "identity", position = "dodge") +
#   geom_errorbar(aes(ymin = lower, ymax = upper), position = "dodge") + theme_bw() +
#   xlab('') + ylab('Candidate Feeling Thermometer')

x$evang.self.ident <- 999
evang.plus.sample <- as.data.frame(rbind(as.data.frame(x), as.data.frame(y)))
evang.plus.sample$evang.self.ident <- ifelse(evang.plus.sample$evang.self.ident==1, 'Evangelical', evang.plus.sample$evang.self.ident)
evang.plus.sample$evang.self.ident <- ifelse(evang.plus.sample$evang.self.ident==0, 'Non-Evangelical', evang.plus.sample$evang.self.ident)
evang.plus.sample$evang.self.ident <- ifelse(evang.plus.sample$evang.self.ident==999, 'Total Sample', evang.plus.sample$evang.self.ident)

#evang.plus.sample %>%
#  ggplot(aes(x = group, y = mean)) +
#  #geom_bar(stat = "identity", position = "dodge") +
#  geom_errorbar(aes(ymin = lower, ymax = upper), position = "dodge") + theme_bw() +
#  xlab('') + ylab('Candidate Feeling Thermometer')

# Broken out by subgroup
ggplot(evang.plus.sample, aes(x = group, y = mean, color=as.factor(evang.self.ident), shape=as.factor(evang.self.ident))) +
  geom_point(
    #aes(color = evang.self.ident, fill = evang.self.ident),
    stat = "identity", position = position_dodge(0.8), size = 3
  ) + theme_bw() + xlab('') + ylab('Candidate Feeling Thermometer') +
  geom_errorbar(aes(ymin = lower, ymax = upper), position = position_dodge(0.8)) +
  theme(legend.position="bottom", legend.title = element_blank())
ggsave('candidate ft subgroup.png')


## Candidate Likely to vote
rm(x, y, evang.plus.sample)
x <- mturk %>% 
  group_by(group) %>% 
  summarize(mean = mean(cand.vote),
            lower = mean(cand.vote) - qt(1- alpha/2, (n() - 1))*sd(cand.vote)/sqrt(n()),
            upper = mean(cand.vote) + qt(1- alpha/2, (n() - 1))*sd(cand.vote)/sqrt(n()))
y <- mturk %>% 
  group_by(group, evang.self.ident) %>% 
  summarize(mean = mean(cand.vote),
            lower = mean(cand.vote) - qt(1- alpha/2, (n() - 1))*sd(cand.vote)/sqrt(n()),
            upper = mean(cand.vote) + qt(1- alpha/2, (n() - 1))*sd(cand.vote)/sqrt(n()))

x %>%
  ggplot(aes(x = group, y = mean)) + geom_point(
    #aes(color = evang.self.ident, fill = evang.self.ident),
    stat = "identity", position = position_dodge(0.8), size = 3
  ) +
  geom_errorbar(aes(ymin = lower, ymax = upper), position = "dodge") + theme_bw() +
  xlab('') + ylab('Likely Vote For Candidate') 
ggsave('Mean Likely Vote by Treatment.png')

x$evang.self.ident <- 999
evang.plus.sample <- as.data.frame(rbind(as.data.frame(x), as.data.frame(y)))
evang.plus.sample$evang.self.ident <- ifelse(evang.plus.sample$evang.self.ident==1, 'Evangelical', evang.plus.sample$evang.self.ident)
evang.plus.sample$evang.self.ident <- ifelse(evang.plus.sample$evang.self.ident==0, 'Non-Evangelical', evang.plus.sample$evang.self.ident)
evang.plus.sample$evang.self.ident <- ifelse(evang.plus.sample$evang.self.ident==999, 'Total Sample', evang.plus.sample$evang.self.ident)

# Broken out by subgroup
ggplot(evang.plus.sample, aes(x = group, y = mean, color=as.factor(evang.self.ident), shape=as.factor(evang.self.ident))) +
  geom_point(
    stat = "identity", position = position_dodge(0.8), size = 3
  ) + theme_bw() + xlab('') + ylab('Likely Vote For Candidate') +
  geom_errorbar(aes(ymin = lower, ymax = upper), position = position_dodge(0.8)) +
  theme(legend.position="bottom", legend.title = element_blank())
ggsave('likely vote subgroup.png')


## Agree w/ candidate stance
rm(x, y, evang.plus.sample)
x <- mturk %>% 
  group_by(group) %>% 
  summarize(mean = mean(cand.agree),
            lower = mean(cand.agree) - qt(1- alpha/2, (n() - 1))*sd(cand.agree)/sqrt(n()),
            upper = mean(cand.agree) + qt(1- alpha/2, (n() - 1))*sd(cand.agree)/sqrt(n()))
y <- mturk %>% 
  group_by(group, evang.self.ident) %>% 
  summarize(mean = mean(cand.agree),
            lower = mean(cand.agree) - qt(1- alpha/2, (n() - 1))*sd(cand.agree)/sqrt(n()),
            upper = mean(cand.agree) + qt(1- alpha/2, (n() - 1))*sd(cand.agree)/sqrt(n()))

x %>%
  ggplot(aes(x = group, y = mean)) + geom_point(
    #aes(color = evang.self.ident, fill = evang.self.ident),
    stat = "identity", position = position_dodge(0.8), size = 3
  ) +
  geom_errorbar(aes(ymin = lower, ymax = upper), position = "dodge") + theme_bw() +
  xlab('') + ylab('Agree with Candidate Stance') 
ggsave('Mean agree stance by Treatment.png')

x$evang.self.ident <- 999
evang.plus.sample <- as.data.frame(rbind(as.data.frame(x), as.data.frame(y)))
evang.plus.sample$evang.self.ident <- ifelse(evang.plus.sample$evang.self.ident==1, 'Evangelical', evang.plus.sample$evang.self.ident)
evang.plus.sample$evang.self.ident <- ifelse(evang.plus.sample$evang.self.ident==0, 'Non-Evangelical', evang.plus.sample$evang.self.ident)
evang.plus.sample$evang.self.ident <- ifelse(evang.plus.sample$evang.self.ident==999, 'Total Sample', evang.plus.sample$evang.self.ident)

# Broken out by subgroup
ggplot(evang.plus.sample, aes(x = group, y = mean, color=as.factor(evang.self.ident), shape=as.factor(evang.self.ident))) +
  geom_point(
    stat = "identity", position = position_dodge(0.8), size = 3
  ) + theme_bw() + xlab('') + ylab('Agree with Candidate Stance') +
  geom_errorbar(aes(ymin = lower, ymax = upper), position = position_dodge(0.8)) +
  theme(legend.position="bottom", legend.title = element_blank())
ggsave('agree stance subgroup.png')


## Candidate ideology
rm(x, y, evang.plus.sample)
x <- mturk %>% 
  group_by(group) %>% 
  summarize(mean = mean(cand.ideo),
            lower = mean(cand.ideo) - qt(1- alpha/2, (n() - 1))*sd(cand.ideo)/sqrt(n()),
            upper = mean(cand.ideo) + qt(1- alpha/2, (n() - 1))*sd(cand.ideo)/sqrt(n()))
y <- mturk %>% 
  group_by(group, evang.self.ident) %>% 
  summarize(mean = mean(cand.ideo),
            lower = mean(cand.ideo) - qt(1- alpha/2, (n() - 1))*sd(cand.ideo)/sqrt(n()),
            upper = mean(cand.ideo) + qt(1- alpha/2, (n() - 1))*sd(cand.ideo)/sqrt(n()))

x %>%
  ggplot(aes(x = group, y = mean)) +
  geom_errorbar(aes(ymin = lower, ymax = upper), position = "dodge") + theme_bw() +
  xlab('') + ylab('Perceived Candidate Ideology') 
ggsave('Mean candidate ideology by Treatment.png')

x$evang.self.ident <- 999
evang.plus.sample <- as.data.frame(rbind(as.data.frame(x), as.data.frame(y)))
evang.plus.sample$evang.self.ident <- ifelse(evang.plus.sample$evang.self.ident==1, 'Evangelical', evang.plus.sample$evang.self.ident)
evang.plus.sample$evang.self.ident <- ifelse(evang.plus.sample$evang.self.ident==0, 'Non-Evangelical', evang.plus.sample$evang.self.ident)
evang.plus.sample$evang.self.ident <- ifelse(evang.plus.sample$evang.self.ident==999, 'Total Sample', evang.plus.sample$evang.self.ident)

# Broken out by subgroup
ggplot(evang.plus.sample, aes(x = group, y = mean, color=as.factor(evang.self.ident), shape=as.factor(evang.self.ident))) +
  geom_point(
    stat = "identity", position = position_dodge(0.8), size = 3
  ) + theme_bw() + xlab('') + ylab('Perceived Candidate Ideology') +
  geom_errorbar(aes(ymin = lower, ymax = upper), position = position_dodge(0.8)) +
  theme(legend.position="bottom", legend.title = element_blank())
ggsave('candidate ideology subgroup.png')



### OLS regression
# IV's
variables <- c('moral', 'rights', 'attack', 'female', 'gay', 'educ', 'age', 'income', 'hisp', 'black', 'other.race',
               'asian', 'gay.know', 'PID', 'ideo', 'midwest', 'south', 'northeast', 'cath', 'prot', 'jew', 'none', 
               'evang.self.ident', 
               'rel.attend', 'pol.know', 'support.gays', 'pol.int', 'manip')
f <- paste(variables, collapse = " + ")

evang.belief.vars <- c('moral', 'rights', 'attack', 'female', 'gay', 'educ', 'age', 'income', 'hisp', 'black', 
                       'gay.know', 'PID', 'ideo', 'other.race', 'asian',
                       'midwest', 'south', 'northeast', 'cath', 'prot', 'jew', 'none', 'evang.belief.imp', 
                       'rel.attend', 'pol.know', 'support.gays', 'pol.int', 'manip')
f.evan <- paste(evang.belief.vars, collapse = " + ")

cand.support.full <- lm(as.formula(paste('cand.ft', f, sep = '~')), data = mturk)
summary(cand.support.full)

# Evang. belief
cand.support.belief <- lm(as.formula(paste('cand.ft', f.evan, sep = '~')), data = mturk)
summary(cand.support.belief)

# Self-ident w/ interactions w/ treatment
cand.ident.int <- lm(cand.ft ~ moral + rights + attack + female + gay + educ + age + 
                       income + hisp + black + asian + other.race + gay.know + PID + ideo + midwest + 
                       south + northeast + cath + prot + jew + none + evang.self.ident + 
                       rel.attend + pol.know + support.gays + pol.int + manip +
                       moral:evang.self.ident + rights:evang.self.ident +
                       attack:evang.self.ident, data = mturk)
summary(cand.ident.int)

# Belief scale w/ interactions w/ treatment
cand.bel.int <- lm(cand.ft ~ moral + rights + attack + female + gay + educ + age + 
                     income + hisp + black + asian + other.race + gay.know + PID + ideo + midwest + 
                     south + northeast + cath + prot + jew + none + evang.belief.imp + 
                     rel.attend + pol.know + support.gays + pol.int + manip +
                     moral:evang.belief.imp + rights:evang.belief.imp +
                     attack:evang.belief.imp, data = mturk)
summary(cand.bel.int)

library(stargazer)
stargazer(cand.support.full, cand.ident.int, cand.support.belief, cand.bel.int,
          no.space=TRUE, dep.var.labels.include = F, 
          covariate.labels=c('Moral', 'Rights', 'Attack', 'Female', 'LGBTQ-Identifying', 'Education',
                             'Age', 'Income', 'Hispanic', 'Black', 'Know LGBTQ', 'PID', 'Ideology',
                             'Midwest', 'South', 'Northeast', 'Catholic', 'Protestant', 'Jewish',
                             'No Religion', 'Evang. Ident', 'Evang. Belief', 'Rel. Attend.','Pol. Knowledge', 'Support LGBTQ',
                             'Pol. Interest', 'Manipulation', 'Moral*Evang. Ident.', 'Rights*Evang. Ident.',
                             'Attack*Evang. Ident.', 'Moral*Evang. Belief', 'Rights*Evang. Belief',
                             'Attack*Evang. Belief'))


### Candidate vote
#cand.vote <- lm(cand.vote~moral+rights+attack, data = mturk)
#summary(cand.vote)

cand.vote.full <- lm(as.formula(paste('cand.vote', f, sep = '~')), data = mturk)
summary(cand.vote.full)

# Evang. belief
cand.vote.belief <- lm(as.formula(paste('cand.vote', f.evan, sep = '~')), data = mturk)
summary(cand.vote.belief)

# Self-ident w/ interactions w/ treatment
cand.vote.int <- lm(cand.vote ~ moral + rights + attack + female + gay + educ + age + 
                       income + hisp + black + gay.know + PID + ideo + midwest + 
                       south + northeast + cath + prot + jew + none + evang.self.ident + 
                       rel.attend + pol.know + support.gays + pol.int + manip +
                       moral:evang.self.ident + rights:evang.self.ident +
                       attack:evang.self.ident, data = mturk)
summary(cand.vote.int)

# Belief scale w/ interactions w/ treatment
cand.bel.int.vote <- lm(cand.vote ~ moral + rights + attack + female + gay + educ + age + 
                     income + hisp + black + gay.know + PID + ideo + midwest + 
                     south + northeast + cath + prot + jew + none + evang.belief.imp + 
                     rel.attend + pol.know + support.gays + pol.int + manip +
                     moral:evang.belief.imp + rights:evang.belief.imp +
                     attack:evang.belief.imp, data = mturk)
summary(cand.bel.int.vote)

stargazer(cand.vote.full, cand.vote.int, cand.vote.belief, cand.bel.int.vote,
          no.space=TRUE, dep.var.labels.include = F, 
          covariate.labels=c('Moral', 'Rights', 'Attack', 'Female', 'LGBTQ-Identifying', 'Education',
                             'Age', 'Income', 'Hispanic', 'Black', 'Know LGBTQ', 'PID', 'Ideology',
                             'Midwest', 'South', 'Northeast', 'Catholic', 'Protestant', 'Jewish',
                             'No Religion', 'Evang. Ident', 'Evang. Belief', 'Rel. Attend.','Pol. Knowledge', 'Support LGBTQ',
                             'Pol. Interest', 'Manipulation', 'Moral*Evang. Ident.', 'Rights*Evang. Ident.',
                             'Attack*Evang. Ident.', 'Moral*Evang. Belief', 'Rights*Evang. Belief',
                             'Attack*Evang. Belief'))


### Cand. vote -> ordinal logit
library(MASS)

mturk$cand.vote.ord <- factor(mturk$cand.vote, levels = c(0, 1, 2, 3, 4), ordered = TRUE) 

cand.vote.full.ord <- polr(as.formula(paste('cand.vote.ord', f, sep = '~')), data = mturk, Hess=TRUE)
summary(cand.vote.full.ord)

# Evang. belief
cand.vote.belief.ord <- polr(as.formula(paste('cand.vote.ord', f.evan, sep = '~')), data = mturk, Hess=TRUE)
summary(cand.vote.belief.ord)

# Self-ident w/ interactions w/ treatment
cand.vote.int.ord <- polr(cand.vote.ord ~ moral + rights + attack + female + gay + educ + age + 
                      income + hisp + black + gay.know + PID + ideo + midwest + 
                      south + northeast + cath + prot + jew + none + evang.self.ident + 
                      rel.attend + pol.know + support.gays + pol.int + manip +
                      moral:evang.self.ident + rights:evang.self.ident +
                      attack:evang.self.ident, data = mturk, Hess=TRUE)
summary(cand.vote.int.ord)

# Belief scale w/ interactions w/ treatment
cand.bel.int.vote.ord <- polr(cand.vote.ord ~ moral + rights + attack + female + gay + educ + age + 
                          income + hisp + black + gay.know + PID + ideo + midwest + 
                          south + northeast + cath + prot + jew + none + evang.belief.imp + 
                          rel.attend + pol.know + support.gays + pol.int + manip +
                          moral:evang.belief.imp + rights:evang.belief.imp +
                          attack:evang.belief.imp, data = mturk, Hess=TRUE)
summary(cand.bel.int.vote.ord)


stargazer(cand.vote.full.ord, cand.vote.int.ord, cand.vote.belief.ord, cand.bel.int.vote.ord,
          no.space=TRUE, dep.var.labels.include = F, 
          covariate.labels=c('Moral', 'Rights', 'Attack', 'Female', 'LGBTQ-Identifying', 'Education',
                             'Age', 'Income', 'Hispanic', 'Black', 'Know LGBTQ', 'PID', 'Ideology',
                             'Midwest', 'South', 'Northeast', 'Catholic', 'Protestant', 'Jewish',
                             'No Religion', 'Evang. Ident', 'Evang. Belief', 'Rel. Attend.','Pol. Knowledge', 'Support LGBTQ',
                             'Pol. Interest', 'Manipulation', 'Moral*Evang. Ident.', 'Rights*Evang. Ident.',
                             'Attack*Evang. Ident.', 'Moral*Evang. Belief', 'Rights*Evang. Belief',
                             'Attack*Evang. Belief'))


### Candidate ideological perception
#cand.ideo.lm <- lm(cand.ideo~moral+rights+attack, data = mturk)
#summary(cand.ideo.lm)



### Plot coefficients
library(dotwhisker)
library(broom)
library(dplyr)

## Candidate FT
cand.support.full_df <- tidy(cand.support.full) %>% filter(term == "moral" | term == 'rights' | term == 'attack') %>%
  relabel_predictors(c(moral = "Moral",                      # relabel predictors
                      rights = "Rights",          
                      attack = "Attack"))
dwplot(cand.support.full_df, conf.level = .95, 
       vline = geom_vline(xintercept = 0, colour = "grey60", linetype = 2))+ theme_bw() +
  xlab("Coefficient Estimate") + theme(legend.position="none")
ggsave('cand_ft_dotplot.png')

## Candidate Vote
cand.vote.full_df <- tidy(cand.vote.full.ord) %>% filter(term == "moral" | term == 'rights' | term == 'attack') %>%
  relabel_predictors(c(moral = "Moral",                      # relabel predictors
                       rights = "Rights",          
                       attack = "Attack"))
dwplot(cand.vote.full_df, conf.level = .95, 
       vline = geom_vline(xintercept = 0, colour = "grey60", linetype = 2))+ theme_bw() +
  xlab("Coefficient Estimate") + theme(legend.position="none")
ggsave('cand_vote_dotplot.png')


### Marginal effects
## Candidate FT
library(sjPlot)
library(sjmisc)
#plot_model(cand.ident.int, type = "pred", terms = c("moral", 'rights', 'attack', "evang.self.ident"))

ex <- tidy(cand.ident.int) %>% filter(term == "moral" | term == 'rights' | term == 'attack' | term == 'moral:evang.self.ident'
                                      | term == 'rights:evang.self.ident' | term == 'attack:evang.self.ident') 
ex$term <- c('Non-Evangelical: Moral', "Non-Evangelical: Rights", "Non-Evangelical: Attack", 'Evangelical: Moral',
            'Evangelical: Rights', 'Evangelical: Attack')
ex

dwplot(ex, conf.level = .90, 
       vline = geom_vline(xintercept = 0, colour = "grey60", linetype = 2))+ theme_bw() +
  xlab("Coefficient Estimate") + theme(legend.position="none")
ggsave('cand_ft_dotplot_evang.png')

## Cand vote
ex1 <- tidy(cand.vote.int.ord) %>% filter(term == "moral" | term == 'rights' | term == 'attack' | term == 'moral:evang.self.ident'
                                      | term == 'rights:evang.self.ident' | term == 'attack:evang.self.ident') 
ex1$term <- c('Non-Evangelical: Moral', "Non-Evangelical: Rights", "Non-Evangelical: Attack", 'Evangelical: Moral',
             'Evangelical: Rights', 'Evangelical: Attack')
ex1

dwplot(ex1, conf.level = .90, 
       vline = geom_vline(xintercept = 0, colour = "grey60", linetype = 2))+ theme_bw() +
  xlab("Coefficient Estimate") + theme(legend.position="none")
ggsave('cand_vote_dotplot_evang.png')


# Belief interaction
# Cand FT
plot_model(cand.bel.int, type = "pred", terms = c("evang.belief.imp", "moral"), legend.title = 'Moral',
           axis.title = c('Evangelical Belief Index','Candidate FT'), p.threshold = c(0.05), title = "")
ggsave('cand_ft_marg_moral.png')
plot_model(cand.bel.int, type = "pred", terms = c("evang.belief.imp", "rights"), legend.title = 'Rights',
           axis.title = c('Evangelical Belief Index','Candidate FT'), p.threshold = c(0.05), title = "")
ggsave('cand_ft_marg_rights.png')
plot_model(cand.bel.int, type = "pred", terms = c("evang.belief.imp", "attack"), legend.title = 'Attack',
           axis.title = c('Evangelical Belief Index','Candidate FT'), p.threshold = c(0.05), title = "")
ggsave('cand_ft_marg_attack.png')


stargazer(mturk, summary = T, nobs = FALSE, mean.sd = TRUE, median = TRUE,
          iqr = FALSE, omit.summary.stat = c("p25", "p75"))

# ## Cand vote
# plot_model(cand.bel.int.vote.ord, type = "pred", terms = c("evang.belief.imp", "moral"), legend.title = 'Moral',
#            axis.title = c('Evangelical Belief Index','Candidate FT'), p.threshold = c(0.05), title = "")
# ggsave('cand_ft_marg_moral.png')
# plot_model(cand.bel.int, type = "pred", terms = c("evang.belief.imp", "rights"), legend.title = 'Rights',
#            axis.title = c('Evangelical Belief Index','Candidate FT'), p.threshold = c(0.05), title = "")
# ggsave('cand_ft_marg_rights.png')
# plot_model(cand.bel.int, type = "pred", terms = c("evang.belief.imp", "attack"), legend.title = 'Attack',
#            axis.title = c('Evangelical Belief Index','Candidate FT'), p.threshold = c(0.05), title = "")
# ggsave('cand_ft_marg_attack.png')
