# This script impliments an STM on the open-ended responses
# to MTurk survey experiment data.

rm(list=ls())
setwd("C:/Users/SF515-51T/Desktop/Dissertation/Ch3")

library(stm)
library(ggplot2)

load('final_cleaned_mturk.RData')
mturk <- mturk.sub
rm(mturk.sub)



# Remove observations w/ no open-ended answer
mturk <- mturk[which(mturk$text != ''),] #1196 (from 1248)

### Impute missing values -> just do this in the analysis script and load in the DF
#install.packages("VIM")
#library(VIM)

#mice_plot <- aggr(mturk, col=c('navyblue','yellow'),
#                  numbers=TRUE, sortVars=TRUE,
#                  labels=names(mturk), cex.axis=.7,
#                  gap=3, ylab=c("Missing data","Pattern"))


# Last value carried forward (for now)
library(zoo)
mturk <- na.locf(mturk)

# GOP versus non-GOP
mturk$gop.bi <- ifelse(mturk$PID >= 4, 1, 0)
summary(mturk$gop.bi==1)

# Church attenders (weekly) versus non-attenders
mturk$church.bi <- ifelse(mturk$rel.attend >= 4, 1, 0)

# Treatment group as ordered factor w/ control as reference
mturk$ordered.treat <- relevel(factor(mturk$group), ref = "Control")

# Pre-process text data
processed <- textProcessor(mturk$text, metadata = mturk, onlycharacter = TRUE)
out <- prepDocuments(processed$documents, processed$vocab, processed$meta)
docs <- out$documents
vocab <- out$vocab
meta  <- out$meta

# Remove sparse terms (less than 3 documents)
png('remove_thresh.png', width = 1080)
plotRemoved(processed$documents, lower.thresh = seq(1, 200, by = 100))
dev.off()
out <- prepDocuments(processed$documents, processed$vocab, processed$meta, 
                     lower.thresh = 3, upper.thresh= 1067) # 3 docs removed

### Don't run
# Calculate optimal number of topics
storage <- searchK(out$documents, out$vocab, K = seq(2,75,1),
                   #prevalence =~ s(integer.seq), 
                   data = meta)

save(storage, file = 'many_models_2_75.RData')
#plot(storage$results$semcoh, storage$results$exclus)

ggplot(storage$results[which(storage$results$K > 2 & storage$results$K < 51),], aes(x=semcoh, y=exclus)) + 
  geom_text(aes(label=K)) + #+ geom_point() + 
  labs(x="Semantic Coherence", y="Exclusivity") + theme_bw()
ggsave('sem_excl_tradeoff_mturk_3-50.pdf')


### Fit STM w/ k = 7 topics
mturkfit <- stm(documents = out$documents, vocab = out$vocab, K = 7,
                       prevalence =~ rights+ attack + moral + control + evang.self.ident + church.bi + #ordered.treat
                       gay.know + support.gays + evang.belief.score, max.em.its = 1000,  data = out$meta, init.type = "Spectral",
                       seed = 24519)
save(mturkfit, file = 'mturk_7k.RData')

pdf('topic_proportions_7k.pdf')
plot(mturkfit, type = "summary", xlim = c(0, .4), main = '')
dev.off()

# Make a tables with top words
library(plyr)
library(xtable)

labels <- c('Pharmacist Duty', 'Individual Liberties', 'Health', 'Refusal of Service', 'Religious Freedom', 'Miscellaneous', 'Discrimination')

class(labelTopics(mturkfit))
prob <- labelTopics(mturkfit, n=7)$prob
frex <- labelTopics(mturkfit, n=7)$frex
#lift <- labelTopics(mturkfit, n=5)$lift
dat <- data.frame(labels)
names(dat) <- "Labels"
dat$Probability <- apply(prob, 1 , paste , collapse = ", " )
dat$FREX <- apply(frex, 1 , paste , collapse = ", " )
#dat$Lift <- apply(lift, 1 , paste , collapse = ", " )

# Export to html
print(xtable(dat), type = "latex", file="stm_mturk_7k.tex")
print(xtable(dat), type = "html", file="stm_mturk_7k.html")


### Model topic prevalence
#out$meta <- within(out$meta, group <- relevel(group, ref = 'Control'))
prep.mturk <- estimateEffect(1:7 ~ rights + attack + moral + evang.self.ident + church.bi + 
                               gay.know + support.gays + evang.belief.score, mturkfit,
                           meta = out$meta, uncertainty = "Global")
summary(prep.mturk)
#library(stargazer)
#stargazer(prep.mturk)

# Rights frame
pdf('rights_stm.pdf')
plot(prep.mturk, covariate = "rights",
     model = mturkfit, method = "difference",
     cov.value1 = 1, cov.value2 = 0,
     xlab = "Control                                                                               Rights Frame",
     main = "Estimated Marginal Effect of Rights Frame: Topic Prevalence",
     xlim = c(-.05, .05), 
     labeltype = "custom",
     custom.labels = labels)
dev.off()

# Moral frame
pdf('moral_stm.pdf')
plot(prep.mturk, covariate = "moral",
     model = mturkfit, method = "difference",
     cov.value1 = 1, cov.value2 = 0,
     xlab = "Control                                                                               Moral Frame",
     main = "Estimated Marginal Effect of Moral Frame: Topic Prevalence",
     xlim = c(-.05, .05), 
     labeltype = "custom",
     custom.labels = labels)
dev.off()

# Attack frame
pdf('attack_stm.pdf')
plot(prep.mturk, covariate = "attack",
     model = mturkfit, method = "difference",
     cov.value1 = 1, cov.value2 = 0,
     xlab = "Control                                                                               Attack + Rights Frame",
     main = "Estimated Marginal Effect of Attack and Rights Frame: Topic Prevalence",
     xlim = c(-.05, .05), 
     labeltype = "custom",
     custom.labels = labels)
dev.off()

# Evangelical identifiers
pdf('evang_ident_stm.pdf')
plot(prep.mturk, covariate = "evang.self.ident",
     model = mturkfit, method = "difference",
     cov.value1 = 1, cov.value2 = 0,
     xlab = "Non-Evangelical                                                                         Evangelical",
     main = "Estimated Marginal Effect of Evangelical Self-Identification: Topic Prevalence",
     xlim = c(-.12, .14), 
     labeltype = "custom",
     custom.labels = labels)
dev.off()

# Effect of evangelical score
png('evang_belief_duty_libert.png')
plot(prep.mturk, covariate = "evang.belief.score", topics = c(1, 2),
     model = mturkfit, method = "continuous", 
     #cov.value1 = 0, cov.value2 = 6,
     xlab = "Less Evangelical ... More Evangelical",
     main = "Effect of Evangelical Beliefs",
     #xlim = c(-.1, .1), 
     labeltype = "custom",
     custom.labels = labels[1:2])
dev.off()

png('evang_belief_refuse_rel_freedom.png')
plot(prep.mturk, covariate = "evang.belief.score", topics = c(4, 5),
     model = mturkfit, method = "continuous", 
     #cov.value1 = 0, cov.value2 = 6,
     xlab = "Less Evangelical ... More Evangelical",
     main = "Effect of Evangelical Beliefs",
     #xlim = c(-.1, .1), 
     labeltype = "custom",
     custom.labels = labels[4:5])
dev.off()

png('evang_belief_discrim.png')
plot(prep.mturk, covariate = "evang.belief.score", topics = c(7),
     model = mturkfit, method = "continuous", 
     #cov.value1 = 0, cov.value2 = 6,
     xlab = "Less Evangelical ... More Evangelical",
     main = "Effect of Evangelical Beliefs",
     #xlim = c(-.1, .1), 
     labeltype = "custom",
     custom.labels = labels[7])
dev.off()


################ Multiply in original dataframe, run separate STM?
### Interaction of evangelical and attack treatment
# inter.prep <- estimateEffect(1:7 ~ rights + attack + moral + church.bi + 
#                                gay.know + support.gays + evang.belief.score + attack:evang.belief.score,
#                                mturkfit,
#                              meta = out$meta, uncertainty = "Global")
# summary(inter.prep)

#plot(inter.prep, covariate = "atack:evang.belief.score",
#     model = mturkfit, method = "difference",
#     cov.value1 = 1, cov.value2 = 0,
#     xlab = "Control                                                                               Rights Frame",
#     main = "Estimated Marginal Effect of Rights Frame: Topic Prevalence",
#     xlim = c(-.05, .05), 
#     labeltype = "custom",
#     custom.labels = labels)

#####################################################################################
### Content
poliblogContent <- stm(out$documents, out$vocab, K = 20,
                      prevalence =~ rating + s(day), content =~ rating,
                      max.em.its = 75, data = out$meta, init.type = "Spectral")