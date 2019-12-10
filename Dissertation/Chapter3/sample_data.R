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

  
vars <- c('education', 'income', 'gender', 'age', 'hisp', 'black', 'other',
          'know.lgbtq', 'PID', 'ideo', 'region', 'rel.trad', 'evang', 'bible',
          'rel.import', 'pol.know', 'discrim', 'fire', 'pol.interest', 
          'rights.treat', 'moral.treat', 'rights.attack.treat', 'manip', 
          'issue.agree', 'cand.eval.dv', 'cand.vote.dv')