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

# Pre-process text data
processed <- textProcessor(mturk$text, metadata = mturk, onlycharacter = TRUE)
out <- prepDocuments(processed$documents, processed$vocab, processed$meta)
docs <- out$documents
vocab <- out$vocab
meta  <- out$meta

# Remove sparse terms (less than 3 documents)
plotRemoved(processed$documents, lower.thresh = seq(1, 200, by = 100))
out <- prepDocuments(processed$documents, processed$vocab, processed$meta, 
                     lower.thresh = 3, upper.thresh= 1067) # 3 docs removed

# Calculate optimal number of topics
storage <- searchK(out$documents, out$vocab, K = seq(2,75,1),
                   #prevalence =~ s(integer.seq), 
                   data = meta)

save(storage, file = 'many_models_2_75.RData')

plot(storage$results$semcoh, storage$results$exclus)

ggplot(storage$results, aes(x=semcoh, y=exclus)) + geom_text(aes(label=K)) + #+ geom_point() + 
  labs(x="Semantic Coherence", y="Exclusivity") + theme_bw()
ggsave('sem_excl_tradeoff_mturk_2-75.pdf')


poliblogPrevFit <- stm(documents = out$documents, vocab = out$vocab, K = 20, 
                       prevalence =~ rating + s(day), max.em.its = 75, 
                       data = out$meta, init.type = "Spectral")
