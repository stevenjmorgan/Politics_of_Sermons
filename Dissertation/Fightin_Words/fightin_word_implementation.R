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

load('final_dissertation_dataset7-27.RData')
colnames(serms.merge)

#### Create function???



## Create dtm
# Only keep tokens that are all letters and of len 3 or greater
gc()
memory.limit()
memory.limit(size=56000)
quanteda_dtm <- quanteda::dfm(serms.merge$clean,
                              select = "[a-zA-Z]{3,}",
                              valuetype = "regex")#,tolower=TRUE,
                              #remove=c(stopwords(),",",".","-","\"","'","(",")",";",":"))
save(quanteda_dtm, file = 'huge_dtm7-30.RData')

# Convert to a slam::simple_triplet_matrix object
dtm <- convert_quanteda_to_slam(quanteda_dtm)

## Create df for variable of interest
# Covariate data
colnames(serms.merge)
doc_covariates <- serms.merge[,c('denom.fixed','date','state_parse','race',
                                 'gender.final')]


## Create contingency table
# Create a contingency table with all possible covariate combinations:
cont_table <- contingency_table(metadata = doc_covariates,
                                document_term_matrix = dtm)#,
                                #variables_to_use = c(5))

# Create dataframe for political/non-political
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

## Plot results



### Male vs. female, black versus non-black, hispanic vs. non-hispanic, asian vs. non-asian
### Baptist vs. non-Baptist, Non-denom vs. rest, Independent vs. non-Independent
