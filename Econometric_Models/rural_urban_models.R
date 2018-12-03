rm(list=ls())
setwd("C:/Users/steve/Dropbox/PoliticsOfSermons")

library(stringr)
library(car)

load('merge_geo.RData')

# Only keep first five digits of zip codes
serms.merge$zip.clean <- substr(serms.merge$zip, 0, 5)

# Load in rural-urban zip code data
zip.geo <- read.csv('zip_geo.csv', header = T, stringsAsFactors = F)

# Add leading zeros
zip.geo$zip.clean <- str_pad(zip.geo$zip, 5, pad = "0")

# Merge rural-urban zip code data with sermon dataset
serms.merge <- merge(serms.merge, zip.geo, by = 'zip.clean', all.x = TRUE)

# Recode rural-urban variable
serms.merge <- serms.merge[!is.na(serms.merge$ru2003),]
serms.merge$rural <- recode(serms.merge$ru2003, "1 = 0; 2 = 0; 3 = 0; 4 = 0;
                            5 = 0; 6 = 0; 7 = 0; else = 1")
serms.merge$rural <- ifelse(serms.merge$ru2003 > 3, 1, 0)


## Model rural-urban divide interacted with evangelical
logit.rural <- glm(stringent.dich ~ evang + other + elect.szn.2wk + south + west + nc + rural + rural:evang, 
                family = binomial(link = 'logit'), data = serms.merge)
summary(logit.rural)

library(Zelig)
re.logit <- zelig(stringent.dich ~ evang + other + south + west + nc + rural +
                    elect.szn.2wk + evang:rural, model = 'relogit', 
                  data = serms.merge,
                  tau = 3432/86723, case.control = c('weighting'))
summary(re.logit)

library(dotwhisker)
dwplot(logit.rural, dodge_size = 0.8, conf.level = .90, dot_args = list(size = 3, pch = 21, fill = "white"),
       vline = geom_vline(xintercept = 0, colour = "grey60", linetype = 2)) %>% # plot line at zero _behind_ coefs
  relabel_predictors(c(evang = "Evangelical",                       
                       other = "Other/Non-Denom.", 
                       south = "South", 
                       west = "West", 
                       nc = "North Central", 
                       rural = 'Rural',
                       elect.szn.2wk = "Election in 4 Weeks",
                       'evang:rural' = "Evangelical * Rural")) +
  theme_bw() + theme(legend.position="none")
ggsave('logit_rural_int_dotplot.pdf')

## No interaction
logit.rural <- glm(stringent.dich ~ evang + other + elect.szn.2wk + south + west + nc + rural, 
                   family = binomial(link = 'logit'), data = serms.merge)
summary(logit.rural)

library(dotwhisker)
dwplot(logit.rural, conf.level = .90, dot_args = list(size = 3, pch = 21, fill = "red"),
       vline = geom_vline(xintercept = 0, colour = "grey60", linetype = 2)) %>% # plot line at zero _behind_ coefs
  relabel_predictors(c(evang = "Evangelical",                       
                       other = "Other/Non-Denom.", 
                       south = "South", 
                       west = "West", 
                       nc = "North Central", 
                       rural = 'Rural',
                       elect.szn.2wk = "Election in 4 Weeks")) +
  theme_bw() + theme(legend.position="none")
#        theme(scale_colour_grey())
ggsave('logit_rural_dotplot.pdf')


# Recode rural and suburban
serms.merge$suburb <- recode(serms.merge$ru2003, "1 = 0; 2 = 0; 3 = 1; 4 = 1;
                            5 = 1; 6 = 1; 7 = 0; else = 0")
serms.merge$rur_3 <- recode(serms.merge$ru2003, "1 = 0; 2 = 0; 3 = 0; 4 = 0;
                            5 = 0; 6 = 0; 7 = 1; 8 = 1; 9 = 1")

