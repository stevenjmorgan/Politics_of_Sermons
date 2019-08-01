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

#load('final_dissertation_dataset7-27.RData')
serms.merge <- read.csv('sermons_processed.csv')
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


################################################################################
### Male vs. Female ####
################################################################################

# Create dataframe for male vs. female
#summary(serms.merge$word.count)
gender <- as.data.frame(serms.merge[, c('gender.final')])
colnames(gender) <- 'gender.final'
gender$gender.final <- as.character(gender$gender.final)
unique(gender$gender.final)
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
png('gender_unigram.png', width=12,height=8,units="in",res=100)
fightin_words_plot(full.corp, positive_category = "Male", 
                   negative_category = "Female", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Male vs. Female-Preached Sermons",
                   display_top_words = 10,
                   max_terms_to_display = 1e+10000)
dev.off()


# ##### N-Gram approach #######
# n.gram_dtm <- dfm(serms.merge$clean,
#                   remove = stopwords(),
#                   removeNumbers = TRUE,
#                   stem = TRUE,
#                   remove_punct = TRUE,
#                   ngrams=c(1,2))
# 
# n.grams <- convert_quanteda_to_slam(n.gram_dtm)
# 
# length(n.grams$dimnames$Docs) == length(n.gram_dtm@Dimnames$docs)
# 
# cont.table <- contingency_table(metadata = gender,
#                                 document_term_matrix = n.grams,
#                                 force_dense = T)
# 
# gender.ngram <- feature_selection(cont.table, 
#                                   method = c("informed Dirichlet"),
#                                   alpha = 0.01,
#                                    rank_by_log_odds = F)
# fightin_words_plot(gender.ngram, positive_category = "Male", 
#                    negative_category = "Female", 
#                    clean_publication_plots = FALSE,
#                    title = "Differences in Language: Male vs. Female-Preached Sermons",
#                    display_top_words = 10,
#                    max_terms_to_display = 1e+10000)


################################################################################
### Black vs. non-black ###
################################################################################

load('final_dissertation_dataset7-27.RData')
serms.merge <- serms.merge[which(serms.merge$word.count > 75),]

quanteda_dtm_black <- quanteda::dfm(serms.merge$clean,
                              select = "[a-zA-Z]{3,}",
                              valuetype = "regex",#)
                              #tolower=TRUE,
                              #remove=c(",",".","-","\"","'","(",")",";",":",'[',']'), #stopwords(),
                              stem = TRUE)

# Convert to a slam::simple_triplet_matrix object
dtm_black <- convert_quanteda_to_slam(quanteda_dtm_black)

### Compare indices between slam matrix and dtm
length(dtm_black$dimnames$Docs) == length(quanteda_dtm_black@Dimnames$docs)

# Create dataframe for black vs. non-black
black <- as.data.frame(serms.merge[, c('race')])
colnames(black) <- 'black'
black$black <- as.character(black$black)
unique(black$black)
black$black[black$black == 'black'] <- 'Black'
black$black[black$black != 'Black'] <- 'Non-Black'
unique(black$black)

# Create contigency table
cont.table.black <- contingency_table(metadata = black,
                                      document_term_matrix = dtm_black,
                                      force_dense = F)

## Run FW algorithm
full.corp.black <- feature_selection(cont.table.black,
                                     method = c("informed Dirichlet"),
                                     alpha = 0.01,
                                     rank_by_log_odds = F)

png('black_unigram.png', width=12,height=8,units="in",res=100)
fightin_words_plot(full.corp.black, positive_category = "Non-Black", 
                   negative_category = "Black", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Black vs. Non-Black-Preached Sermons",
                   display_top_words = 20,
                   max_terms_to_display = 1e+10000)
dev.off()


################################################################################
### Hispanic vs. non-Hispanic ###
################################################################################

# Create dataframe for Hispanic vs. non-Hispanic
hispanic <- serms.merge[which(serms.merge$spanish.count < 2),]

# English speaking dtm
quanteda_dtm_en <- quanteda::dfm(hispanic$clean,
                                 select = "[a-zA-Z]{3,}",
                                 valuetype = "regex",#)
                                 #tolower=TRUE,
                                 #remove=c(",",".","-","\"","'","(",")",";",":",'[',']'), #stopwords(),
                                 stem = TRUE)
# Convert to a slam::simple_triplet_matrix object
dtm.en <- convert_quanteda_to_slam(quanteda_dtm_en)

# Compare indices between slam matrix and dtm
length(dtm.en$dimnames$Docs) == length(quanteda_dtm_en@Dimnames$docs)

# Covariate df
hispanic <- as.data.frame(hispanic[, c('race')])
colnames(hispanic) <- 'hispanic'
hispanic$hispanic <- as.character(hispanic$hispanic)
unique(hispanic$hispanic)
hispanic$hispanic[hispanic$hispanic == 'hispanic'] <- 'Hispanic'
hispanic$hispanic[hispanic$hispanic != 'Hispanic'] <- 'Non-Hispanic'
unique(hispanic$hispanic)

# Create contigency table
cont.table.hispanic <- contingency_table(metadata = hispanic,
                                         document_term_matrix = dtm.en,
                                         force_dense = F)

## Run FW algorithm
full.corp.hispanic <- feature_selection(cont.table.hispanic,
                                        method = c("informed Dirichlet"),
                                        alpha = 0.01,
                                        rank_by_log_odds = F)

png('hispanic_unigram.png', width=12,height=8,units="in",res=100)
fightin_words_plot(full.corp.hispanic, positive_category = "Non-Hispanic", 
                   negative_category = "Hispanic", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Hispanics vs. Non-Hispanic-Preached Sermons (English Only)",
                   display_top_words = 18,
                   max_terms_to_display = 1e+10000)
dev.off()



################################################################################
##### Baptist vs. non-Baptist #####
################################################################################

load('final_dissertation_dataset7-27.RData')
serms.merge <- serms.merge[which(serms.merge$word.count > 75),]
unique(serms.merge$denom.fixed)

quanteda_dtm_bap <- quanteda::dfm(serms.merge$clean,
                                    select = "[a-zA-Z]{3,}",
                                    valuetype = "regex",#)
                                    #tolower=TRUE,
                                    #remove=c(",",".","-","\"","'","(",")",";",":",'[',']'), #stopwords(),
                                    stem = TRUE)

# Convert to a slam::simple_triplet_matrix object
#dtm_bap <- convert_quanteda_to_slam(quanteda_dtm_bap)
dtm_bap <- convert_quanteda_to_slam(quanteda_dtm_black)

# Compare indices between slam matrix and dtm
#length(dtm_bap$dimnames$Docs) == length(quanteda_dtm_bap@Dimnames$docs)
length(dtm_bap$dimnames$Docs) == length(quanteda_dtm_black@Dimnames$docs)

# Covariate df
baptist <- as.data.frame(serms.merge[, c('denom.fixed')])
colnames(baptist) <- 'baptist'
baptist$baptist <- as.character(baptist$baptist)
unique(baptist$baptist)
baptist$baptist[baptist$baptist == 'Baptist'] <- 'Baptist'
baptist$baptist[baptist$baptist != 'Baptist'] <- 'Non-Baptist'
unique(baptist$baptist)

# Create contigency table
cont.table.bap <- contingency_table(metadata = baptist,
                                         document_term_matrix = dtm_bap,
                                         force_dense = F)

## Run FW algorithm
full.corp.bap <- feature_selection(cont.table.bap,
                                        method = c("informed Dirichlet"),
                                        alpha = 0.01,
                                        rank_by_log_odds = F)

png('baptist_unigram.png', width=12,height=8,units="in",res=100)
fightin_words_plot(full.corp.bap, positive_category = "Baptist", 
                   negative_category = "Non-Baptist", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Baptist vs. Non-Baptist-Preached Sermons",
                   display_top_words = 18,
                   max_terms_to_display = 1e+10000)
dev.off()


################################################################################
######## Independent vs. Non-Indepenent #####
################################################################################

# Covariate df
independ <- as.data.frame(serms.merge[, c('denom.fixed')])
colnames(independ) <- 'independent'
independ$independent <- as.character(independ$independent)
unique(independ$independent)
independ$independent[independ$independent == 'Independent/Bible'] <- 'Independent'
independ$independent[independ$independent == 'Independent Bible'] <- 'Independent'
unique(independ$independent)
independ$independent[independ$independent != 'Independent'] <- 'Non-Independent'
unique(independ$independent)

# Create contigency table
cont.table.ind <- contingency_table(metadata = independ,
                                    document_term_matrix = dtm_bap,
                                    force_dense = F)

## Run FW algorithm
full.corp.ind <- feature_selection(cont.table.ind,
                                   method = c("informed Dirichlet"),
                                   alpha = 0.01,
                                   rank_by_log_odds = F)

png('ind_unigram.png', width=12,height=8,units="in",res=100)
fightin_words_plot(full.corp.ind, positive_category = "Non-Independent", 
                   negative_category = "Independent", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Independent vs. Non-Independent-Preached Sermons",
                   display_top_words = 18,
                   max_terms_to_display = 1e+10000)
dev.off()


################################################################################
######## Evangelical vs. Non-Evangelical #####
################################################################################

# Covariate df
evang <- as.data.frame(serms.merge[, c('denom.fixed')])
colnames(evang) <- 'evang'
evang$evang <- as.character(evang$evang)
unique(evang$evang)
evang$evang[evang$evang == 'Evangelical/Non-Denominational'] <- 'Evangelical/Non-Denominational'
evang$evang[evang$evang != 'Evangelical/Non-Denominational'] <- 'Non-Evangelical/Non-Denominational'
unique(evang$evang)


# Create contigency table
cont.table.evang <- contingency_table(metadata = evang,
                                    document_term_matrix = dtm_bap,
                                    force_dense = F)

## Run FW algorithm
full.corp.evang <- feature_selection(cont.table.evang,
                                   method = c("informed Dirichlet"),
                                   alpha = 0.01,
                                   rank_by_log_odds = F)

png('evangelical_unigram.png', width=12,height=8,units="in",res=100)
fightin_words_plot(full.corp.ind, positive_category = "Non-Evangelical/Non-Denominational", 
                   negative_category = "Evangelical/Non-Denominational", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Evangelical/Non-Denom. vs. Non-Evangelical/Non-Denom.-Preached Sermons",
                   display_top_words = 18,
                   max_terms_to_display = 1e+10000)
dev.off()

