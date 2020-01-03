### Robustness check: Mean/Median imputation

rm(list=ls())
load('final_cleaned_mturk.RData')
mturk <- mturk.sub
rm(mturk.sub)

### Mean/Median imputation
colnames(mturk)

# Mean imputation -> Continous variables
summary(mturk$cand.ft)
mturk$cand.ft[is.na(mturk$cand.ft)] <- mean(mturk$cand.ft, na.rm = TRUE)
summary(mturk$cand.ft)
mturk$age[is.na(mturk$age)] <- mean(mturk$age, na.rm = TRUE)


# Median-imputation -> categorical and ordinal variables
mturk$female[is.na(mturk$female)] <- median(mturk$female, na.rm = TRUE)
mturk$gay[is.na(mturk$gay)] <- median(mturk$gay, na.rm = TRUE)
mturk$income[is.na(mturk$income)] <- median(mturk$income, na.rm = TRUE)
mturk$educ[is.na(mturk$educ)] <- median(mturk$educ, na.rm = TRUE)
mturk$hisp[is.na(mturk$hisp)] <- median(mturk$hisp, na.rm = TRUE)
mturk$black[is.na(mturk$black)] <- median(mturk$black, na.rm = TRUE)
mturk$white[is.na(mturk$white)] <- median(mturk$white, na.rm = TRUE)
mturk$asian[is.na(mturk$asian)] <- median(mturk$asian, na.rm = TRUE)
mturk$other.race[is.na(mturk$other.race)] <- median(mturk$other.race, na.rm = TRUE)
mturk$gay.know[is.na(mturk$gay.know)] <- median(mturk$gay.know, na.rm = TRUE)
mturk$PID[is.na(mturk$PID)] <- median(mturk$PID, na.rm = TRUE)
mturk$ideo[is.na(mturk$ideo)] <- median(mturk$ideo, na.rm = TRUE)
mturk$midwest[is.na(mturk$midwest)] <- median(mturk$midwest, na.rm = TRUE)
mturk$south[is.na(mturk$south)] <- median(mturk$south, na.rm = TRUE)
mturk$northeast[is.na(mturk$northeast)] <- median(mturk$northeast, na.rm = TRUE)
mturk$west[is.na(mturk$west)] <- median(mturk$west, na.rm = TRUE)
mturk$cath[is.na(mturk$cath)] <- median(mturk$cath, na.rm = TRUE)
mturk$prot[is.na(mturk$prot)] <- median(mturk$prot, na.rm = TRUE)
mturk$jew[is.na(mturk$jew)] <- median(mturk$jew, na.rm = TRUE)
mturk$none[is.na(mturk$none)] <- median(mturk$none, na.rm = TRUE)
mturk$other.religion[is.na(mturk$other.religion)] <- median(mturk$other.religion, na.rm = TRUE)
mturk$evang.self.ident[is.na(mturk$evang.self.ident)] <- median(mturk$evang.self.ident, na.rm = TRUE)
mturk$rel.attend[is.na(mturk$rel.attend)] <- median(mturk$rel.attend, na.rm = TRUE)
mturk$bible[is.na(mturk$bible)] <- median(mturk$bible, na.rm = TRUE)
mturk$evangelize[is.na(mturk$evangelize)] <- median(mturk$evangelize, na.rm = TRUE)
mturk$heaven[is.na(mturk$heaven)] <- median(mturk$heaven, na.rm = TRUE)
mturk$jesus.sin[is.na(mturk$jesus.sin)] <- median(mturk$jesus.sin, na.rm = TRUE)
mturk$faith.import[is.na(mturk$faith.import)] <- median(mturk$faith.import, na.rm = TRUE)
mturk$devil[is.na(mturk$devil)] <- median(mturk$devil, na.rm = TRUE)
mturk$belief.god[is.na(mturk$belief.god)] <- median(mturk$belief.god, na.rm = TRUE)
mturk$pol.know[is.na(mturk$pol.know)] <- median(mturk$pol.know, na.rm = TRUE)
mturk$support.gays[is.na(mturk$support.gays)] <- median(mturk$support.gays, na.rm = TRUE)
mturk$pol.int[is.na(mturk$pol.int)] <- median(mturk$pol.int, na.rm = TRUE)
mturk$manip[is.na(mturk$manip)] <- median(mturk$manip, na.rm = TRUE)
mturk$cand.vote[is.na(mturk$cand.vote)] <- median(mturk$cand.vote, na.rm = TRUE)



x <- mturk[is.na(mturk),]

# Imputed evang. belief score
mturk$evang.belief.imp <- mturk$bible + mturk$evangelize + mturk$heaven + mturk$jesus.sin + 
  mturk$faith.import + mturk$devil + mturk$belief.god
summary(mturk$evang.belief.imp)
cor(mturk$evang.belief.imp, mturk$evang.belief.score) #0.97



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