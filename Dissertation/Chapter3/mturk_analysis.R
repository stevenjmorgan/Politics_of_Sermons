# This script analyzes data from an MTurk experiment probing
# the relationship between framing and political attitudes.

rm(list=ls())
setwd("C:/Users/SF515-51T/Desktop/Dissertation/Ch3")

library(car)

mturk <- read.csv('Rights_Talk_First50.csv', stringsAsFactors = F)

# Remove first two rows (extra headers)
mturk <- mturk[3:nrow(mturk),]

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
                                              'Prefer not to say' = NA")
unique(mturk$educ)

# Age
class(mturk$Q3_1)
mturk$age <- as.numeric(mturk$Q3_1)

# Income
unique(mturk$Q4)
mturk$income <- car::recode(mturk$Q4, as.factor = F, "'Less than $30,000' = 0;
                                                '$30,001-50,000' = 1;
                                                '$50,001-75,000' = 2;
                                                '$75,001-100,000' = 3;
                                                '$100,001-150,000' = 4;
                                                'Over $150,000' = 5;
                                                'Prefer not to say' = NA")
unique(mturk$income)

# Hispanic
unique(mturk$Q5)
mturk$hisp <- car::recode(mturk$Q5, as.factor = F, "'Yes' = 1; 'No' = 0;
                                                'Prefer not to say' = NA")
unique(mturk$hisp)
summary(mturk$hisp==1)

# Race - Black
unique(mturk$Q6)
mturk$black <- car::recode(mturk$Q6, as.factor = F, "'Black or African American' = 1;
                                                'Prefer not to say' = NA;
                                                else = 0")
unique(mturk$black)

# Race - White
mturk$white <- car::recode(mturk$Q6, as.factor = F, "'White' = 1;
                                                'Prefer not to say' = NA;
                                                else = 0")
unique(mturk$white)

# Race - Asian
mturk$asian <- car::recode(mturk$Q6, as.factor = F, "'Asian' = 1;
                                                'Prefer not to say' = NA;
                                                else = 0")
unique(mturk$asian)

# Race - Other
mturk$other.race <- car::recode(mturk$Q6, as.factor = F, "'American Indian or Alaska Native' = 1;
                                                'Native Hawaiian or Pacific Islander' = 1;
                                                'Other' = 1;
                                                'Prefer not to say' = NA;
                                                else = 0")
unique(mturk$other.race)

# Know a gay person
unique(mturk$Q7)
mturk$gay.know <- car::recode(mturk$Q7, as.factor = F, "'Yes' = 1; 'No' = 0; 'Prefer not to say' = NA")
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
hist(mturk$PID)

# Ideology -> 0 Strong liberal, 6 Strong conservatie
unique(mturk$Q10)
mturk$ideo <- car::recode(mturk$Q10, as.factor = F, "'Strongly Liberal' = 0;
                    'Moderately Liberal' = 1; 'Somewhat Liberal' = 2;
                    'Neither Conservative nor Liberal' = 3; 
                    'Somewhat Conservative' = 4; 'Moderately Conservative' = 5;
                    'Strongly Conservative' = 6; else = NA")
summary(mturk$ideo)
hist(mturk$ideo)

### State to region -> come back to
library(tidyverse)
st_crosswalk <- tibble(state = state.name) %>%
  bind_cols(tibble(abb = state.abb))

#left_join(mturk, st_crosswalk, by = "state")


# Religious affiliation
unique(mturk$Q42)
mturk$cath <- car::recode(mturk$Q42, as.factor = F, "'Roman Catholic' = 1;
                     'Prefer not to say' = NA; else = 0")
unique(mturk$cath)

main <- "Protestant (including Baptist, Lutheran, Methodist, Presbyterian, Episcopalian, Pentecostal, Jehovah's Witness, Church of Christ, etc.)"
mturk$prot <- car::recode(mturk$Q42, as.factor = F, "main = 1;
                     'Prefer not to say' = NA; else = 0")
unique(mturk$prot)

mturk$jew <- car::recode(mturk$Q42, as.factor = F, "'Jewish' = 1; 'Prefer not to say' = NA;
                         else = 0")
unique(mturk$jew)

mturk$none <- car::recode(mturk$Q42, as.factor = F, "'No religion, not a believer, atheist, agnostic' = 1;
                          'Prefer not to say' = NA; else = 0")
unique(mturk$none)

mturk$other.religion <- car::recode(mturk$Q42, as.factor = F, "'Jewish' = 0; 'Roman Catholic' = 0;
                                    main = 0; 'No religion, not a believer, atheist, agnostic' = 0;
                                    'Prefer not to say' = NA; else = 1")
unique(mturk$other.religion)

# Evangelical self-identification
unique(mturk$Q13)
mturk$evang.self.ident <- car::recode(mturk$Q13, as.factor = F, "'Yes, would' = 1;
                                      'No, would not' = 0; else = NA")
unique(mturk$evang.self.ident)
summary(mturk$evang.self.ident==1)

# Religious service attendance: 0-5 scale, 0 Never 5 more than once a week
unique(mturk$Q14)
mturk$rel.attend <- car::recode(mturk$Q14, as.factor = F, "'Never' = 0;
                                'Seldom' = 1; 'A few times a year' = 2;
                                'Once or twice a month' = 3; 'Once a week' = 4;
                                'More than once a week' = 5")
unique(mturk$rel.attend)


### Evangelical identity-belief
# Biblical inerrancy -> 0-2
unique(mturk$Q16)
mturk$bible <- car::recode(mturk$Q16, as.factor = F, "'The Bible is an ancient book of fables, legends, history, and moral precepts recorded by men.' = 0;
                           'The Bible is the inspired Word of God but not everything in it should be taken literally, word for word.' = 0;
                           'The Bible is the actual Word of God and is to be taken literally, word for word.' = 1; else = 0")
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
