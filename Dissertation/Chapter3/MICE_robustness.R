### Robustness check: MICE imputation

rm(list=ls())
load('final_cleaned_mturk.RData')
mturk <- mturk.sub
rm(mturk.sub)

library(mice)

### MICE
colnames(mturk)
variables <- c('moral', 'rights', 'attack', 'female', 'gay', 'educ', 'income', 'hisp', 'black', 'other.race',
               'asian', 'gay.know', 'PID', 'ideo', 'midwest', 'south', 'northeast', 'cath', 'prot', 'jew', 'none', 
               'evang.self.ident','evang.belief.score',
               'rel.attend', 'pol.know', 'support.gays', 'pol.int', 'manip', 'cand.vote', 'age', 'cand.ft')
mturk <- subset(mturk, select = variables)
colnames(mturk)

#transfer type of binary & categorical data into factor (from numeric)
for(i in c(1:29)){
  mturk[,i]<-as.factor(mturk[,i])
}
str(mturk)

#imputation method for each variable
impmethod<-c("polr", "polr", "polr", "polr", "polr", "polr", "polr", "polr", "polr", "polr", "polr", "polr", 
             "polr", "polr", "polr", "polr", "polr", "polr", "polr", "polr", "polr", "polr", "polr", "polr"
             , "polr", "polr", "polr", "polr", "polr", 'logreg','logreg')
tempData <- mice(mturk,m=5,maxit=100,seed=24519)
summary(tempData)


# Imputed evang. belief score
#mturk$evang.belief.imp <- mturk$bible + mturk$evangelize + mturk$heaven + mturk$jesus.sin + 
#  mturk$faith.import + mturk$devil + mturk$belief.god
#summary(mturk$evang.belief.imp)
#cor(mturk$evang.belief.imp, mturk$evang.belief.score) #0.97

mturk <- tempData
mturk$evang.belief.imp <- mturk$evang.belief.score

### OLS: Candidate Evaluation
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
                             'Age', 'Income', 'Hispanic', 'Black', 'Other Race', 'Asian', 'Know LGBTQ', 'PID', 'Ideology',
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
                            income + hisp + black + other.race + asian + gay.know + PID + ideo + midwest + 
                            south + northeast + cath + prot + jew + none + evang.self.ident + 
                            rel.attend + pol.know + support.gays + pol.int + manip +
                            moral:evang.self.ident + rights:evang.self.ident +
                            attack:evang.self.ident, data = mturk, Hess=TRUE)
summary(cand.vote.int.ord)

# Belief scale w/ interactions w/ treatment
cand.bel.int.vote.ord <- polr(cand.vote.ord ~ moral + rights + attack + female + gay + educ + age + 
                                income + hisp + black + other.race + asian + gay.know + PID + ideo + midwest + 
                                south + northeast + cath + prot + jew + none + evang.belief.imp + 
                                rel.attend + pol.know + support.gays + pol.int + manip +
                                moral:evang.belief.imp + rights:evang.belief.imp +
                                attack:evang.belief.imp, data = mturk, Hess=TRUE)
summary(cand.bel.int.vote.ord)


stargazer(cand.vote.full.ord, cand.vote.int.ord, cand.vote.belief.ord, cand.bel.int.vote.ord,
          no.space=TRUE, dep.var.labels.include = F, 
          covariate.labels=c('Moral', 'Rights', 'Attack', 'Female', 'LGBTQ-Identifying', 'Education',
                             'Age', 'Income', 'Hispanic', 'Black', 'Other Race', 'Asian', 'Know LGBTQ', 'PID', 'Ideology',
                             'Midwest', 'South', 'Northeast', 'Catholic', 'Protestant', 'Jewish',
                             'No Religion', 'Evang. Ident', 'Evang. Belief', 'Rel. Attend.','Pol. Knowledge', 'Support LGBTQ',
                             'Pol. Interest', 'Manipulation', 'Moral*Evang. Ident.', 'Rights*Evang. Ident.',
                             'Attack*Evang. Ident.', 'Moral*Evang. Belief', 'Rights*Evang. Belief',
                             'Attack*Evang. Belief'))