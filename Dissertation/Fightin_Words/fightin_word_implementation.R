### This script applies Monroe et al.'s Fightin Words algorithm to analyze
### differences in language (at the lexical level) in the sermon dataset.

rm(list=ls())
#setwd("C:/Users/steve/Dropbox/Dissertation/Data")
setwd("C:/Users/sum410/Dropbox/Dissertation/Data")
#setwd('C:/Users/steve/Desktop/sermon_dataset')

library(tm)
library(devtools)
devtools::install_github("matthewjdenny/SpeedReader")
library(SpeedReader)
library(stargazer)
library(quanteda)
library(readtext)

load('final_dissertation_dataset7-27.RData')
colnames(serms.merge)

#### Create function???


summary(serms.merge$word.count)
serms.merge <- serms.merge[which(serms.merge$word.count > 75),]

serms.merge <- serms.merge[!is.na(serms.merge$gender.final),]

## Create dtm
# Only keep tokens that are all letters and of len 3 or greater
gc()
memory.limit()
memory.limit(size=64000)
quanteda_dtm <- quanteda::dfm(serms.merge$clean,
                              select = "[a-zA-Z]{3,}",
                              valuetype = "regex",#)
                              #tolower=TRUE,
                              #remove=c(",",".","-","\"","'","(",")",";",":",'[',']'), #stopwords(),
                              stem = TRUE)
save(quanteda_dtm, file = 'huge_dtm7-30.RData')
load('huge_dtm7-30.RData')

# Convert to a slam::simple_triplet_matrix object
dtm <- convert_quanteda_to_slam(quanteda_dtm)

### Compare indices between slam matrix and dtm
length(dtm$dimnames$Docs) == length(quanteda_dtm@Dimnames$docs)


# Corpus
# corp <- readtext(serms.merge, text_field = "clean")
# colnames(serms.merge)
# serms.merge$doc_id <- seq(1, nrow(serms.merge))
# serms.merge$text <- serms.merge$clean
# serms.merge <- serms.merge[,c(42,44,43,26,35,39,16)]
# serms.corpus <- corpus(serms.merge)
# summary(serms.corpus, 5)

# Create DTM
# quanteda_dtm <- quanteda::dfm(serms.corpus,
#                               #select = "[a-zA-Z]{3,}",
#                               #valuetype = "regex")
#                               tolower=TRUE,
#                               remove=c(",",".","-","\"","'","(",")",";",":",'[',']'), #stopwords(),
#                               stem = TRUE)



## Create df for variable of interest
# Covariate data
colnames(serms.merge)
doc_covariates <- serms.merge[,c('denom.fixed','date','state_parse','race',
                                 'gender.final')]



# Create dataframe for male vs. female
#summary(serms.merge$word.count)
gender <- as.data.frame(serms.merge[, c('gender.final')])
colnames(gender) <- 'gender.final'
gender$gender.final <- as.character(gender$gender.final)
#gender$Gender[gender$Gender == 'male'] <- 'Political'
#gender$Gender[gender$Gender == 'female'] <- 'Non-Political'

# Create contigency table
cont.table <- contingency_table(metadata = gender,
                                document_term_matrix = dtm,
                                force_dense = F)

## Run FW algorithm
full.corp <- feature_selection(cont.table, 
                               method = c("informed Dirichlet"),
                               alpha = 0.01,
                               rank_by_log_odds = F)
fightin_words_plot(full.corp, positive_category = "Male", 
                   negative_category = "Female", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Political vs. Non-Political Tweets",
                   display_top_words = 10)#,
                   #max_terms_to_display = 1e+10000)

## Plot results



### Male vs. female, black versus non-black, hispanic vs. non-hispanic, asian vs. non-asian
### Baptist vs. non-Baptist, Non-denom vs. rest, Independent vs. non-Independent
