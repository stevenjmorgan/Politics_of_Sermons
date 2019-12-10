# This script simulates survey experiment data and creates sample plots.

################################################################################
### Variable codings
################################################################################
# Education: 1-6
# Income: 1-6
# Age: 18-75
# Hispanic: 0 or 1
# Black: 0 or 1
# Other: 0 or 1
# Know LGBTQ: 0 or 1
# PID: 1-7
# Ideology: 1-7
# Region: NE, MW, SO, WC
# Religious Affiliation: 
# Evangelical: 0 or 1
# Church Attend: 1-6
# Rel. Importance: 1-7
# Bible: 1-3
# Pol. Knowledge: 0-2
# Discrim.: 0 or 1
# Fire: 0 or 1
# Interest: 1-5
# Rights: 0 or 1
# Morals: 0 or 1
# Rights and Attack: 0 or 1
# Manip.: 0 or 1
# Issue Pos: 1-5
# 
# 
# DV's:
# Cand. Eval: 0-100
# Vote: 1-5
################################################################################

  
#vars <- c('educ', 'income', 'gender', 'age', 'hisp', 'black', 'other',
#          'know.lgbtq', 'PID', 'ideo', 'region', 'rel.trad', 'evang', 'bible',
#          'rel.import', 'pol.know', 'discrim', 'fire', 'pol.interest', 
#          'rights.treat', 'moral.treat', 'rights.attack.treat', 'manip', 
#          'issue.agree', 'cand.eval.dv', 'cand.vote.dv')

set.seed(24519)
educ <- round(runif(1000, 1, 6), 0)
educ <- ifelse(educ > 6, 6, educ)
educ <- ifelse(educ < 1, 1, educ)

income <- round(runif(1000, 1, 6), 0)
income <- ifelse(income > 6, 6, income)
income <- ifelse(income < 1, 1, income)

gender <- rbinom(1000, 1, 0.50)

age <- round(runif(1000, 18, 70), 0)

hisp <- rbinom(1000, 1, 0.12)
black <- rbinom(1000, 1, 0.15)
other <- rbinom(1000, 1, 0.10)

know.lgbtq <- rbinom(1000, 1, 0.30)

PID <- round(runif(1000, 1, 6), 0)
PID <- ifelse(PID > 6, 6, PID)
PID <- ifelse(PID < 1, 1, PID)

ideo <- round(runif(1000, 1, 6), 0)
ideo <- ifelse(ideo > 6, 6, ideo)
ideo <- ifelse(ideo < 1, 1, ideo)


midwest <- rbinom(1000, 1, 0.30)
south <- rbinom(1000, 1, 0.30)
northeast <- rbinom(1000, 1, 0.30)

cath <- rbinom(1000, 1, 0.20)
evang <- rbinom(1000, 1, 0.24)
main <- rbinom(1000, 1, 0.18)
other.rel <- rbinom(1000, 1, 0.1)

bible <- round(runif(1000, 1, 7), 0)
bible <- ifelse(bible > 7, 7, bible)
bible <- ifelse(bible < 1, 1, bible)

pol.know <- round(runif(1000, 0, 2), 0)
pol.know <- ifelse(pol.know > 2, 2, pol.know)
pol.know <- ifelse(pol.know < 0, 0, pol.know)

pol.interest <- rbinom(1000, 1, 0.50)

group <- round(runif(1000, 1, 4), 0)
group <- ifelse(group > 4, 4, group)
group <- ifelse(group < 1, 1, group)

rights.treat <- ifelse(group == 1, 1, 0)
moral.treat <- ifelse(group == 2, 1, 0)
rights.attack.treat <- ifelse(group == 3, 1, 0)
control <- ifelse(group == 4, 1, 0)

issue.pos <- round(runif(1000, 1, 5), 0)
issue.pos <- ifelse(issue.pos > 5, 5, issue.pos)
issue.pos <- ifelse(issue.pos < 1, 1, issue.pos)

cand.eval.dv <- round(runif(1000, 0, 100),0)
cand.eval.dv <- ifelse(cand.eval.dv > 100, 100, issue.pos)
cand.eval.dv <- ifelse(cand.eval.dv < 0, 0, issue.pos)

cand.vote.dv <- round(runif(1000, 1, 5),0)
cand.vote.dv <- ifelse(cand.vote.dv > 5, 5, cand.vote.dv)
cand.vote.dv <- ifelse(cand.vote.dv < 1, 1, cand.vote.dv)


sim.data <- cbind(educ, income, gender, age, hisp, black, other,
                  know.lgbtq, PID, ideo, midwest, south, northeast, cath, main, other.rel, evang, bible,
                  pol.know, pol.interest,  # discrim, fire, rel.import, 
                  rights.treat, moral.treat, rights.attack.treat, control, #manip, 
                  cand.eval.dv, cand.vote.dv) #issue.agree, 
sim.data <- as.data.frame(sim.data)

# Candidate evaluation
fit1 <- lm(cand.eval.dv~rights.treat+moral.treat+rights.attack.treat+
             educ+income+gender+age+hisp+black+other+know.lgbtq+PID+ideo+midwest+south+
             northeast+cath+main+other.rel+evang+bible+pol.know+pol.interest, data=sim.data)
summary(fit1)

t.test(sim.data$cand.eval.dv[which(sim.data$rights.treat==1)],sim.data$cand.eval.dv[which(sim.data$control==0)])

library(stargazer)
stargazer(fit1)

# Vote likelihood
fit2 <- lm(cand.vote.dv~rights.treat+moral.treat+rights.attack.treat+
             educ+income+gender+age+hisp+black+other+know.lgbtq+PID+ideo+midwest+south+
             northeast+cath+main+other.rel+evang+bible+pol.know+pol.interest, data=sim.data)
summary(fit2)

