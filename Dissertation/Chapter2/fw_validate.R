### This validates initial hand coding by comparing rights talk sermons
### to non-rights talk sermon via the Fightin words algorithm.

rm(list=ls())
#setwd("C:/Users/sum410/Dropbox/Dissertation/Data/Census")
#setwd("C:/Users/steve/Dropbox/Dissertation/Data/handcode")
setwd("C:/Users/SF515-51T/Desktop/Dissertation")

library(tm)
library(devtools)
#devtools::install_github("matthewjdenny/SpeedReader")
library(SpeedReader)
library(stargazer)
library(quanteda)
library(readtext)

# Read in hand label file
df <- read.csv('hand_code_sample_10-15_coded_no_text.csv', stringsAsFactors = F)

# Read in text files
load('text_hand_sample.RData')

df$text <- comb.df$clean
rm(comb.df)

# Remove words less than three characters
for (i in 1:nrow(df)) {
  df$cleaned[i] <- gsub('\\b\\w{1,2}\\b','',df$text[i])
}
df$cleaned[1]

# Prepare data for FW algorithm -> unigrams
quanteda_dtm <- quanteda::dfm(df$cleaned, stem = T, tolower = T, remove = stopwords("english"),
                              verbose = T, remove_punct = TRUE) # , ngrams = 2

# Convert to a slam::simple_triplet_matrix object
dtm <- convert_quanteda_to_slam(quanteda_dtm)

### Compare indices between slam matrix and dtm
length(dtm$dimnames$Docs) == length(quanteda_dtm@Dimnames$docs)

# Create dataframe for rights talk versus non-rights talk
rights <- as.data.frame(df[, c('ground_truth_rights')])
colnames(rights) <- 'Rights'
summary(is.na(rights$Rights))

# Create contigency table
cont.table <- contingency_table(metadata = rights,
                                document_term_matrix = dtm,
                                force_dense = F)
# Run FW algorithm
full.corp <- feature_selection(cont.table,
                               method = c("informed Dirichlet"),
                               alpha = 0.01,
                               rank_by_log_odds = F)
png('rights_nonrights_hand_label.png', width=15,height=12,units="in",res=100)
fightin_words_plot(full.corp, positive_category = "Rights Talk", 
                   negative_category = "Non-Rights Talk", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Rights Talk vs. Non-Rights Talk Sermons",
                   display_top_words = 20,
                   max_terms_to_display = 1e+10000)
dev.off()


###############################################################################################
### Bigrams
###############################################################################################
# Prepare data for FW algorithm -> unigrams and bigrams
quanteda_dtm <- quanteda::dfm(df$cleaned, stem = T, tolower = T, remove = stopwords("english"),
                              verbose = T, remove_punct = TRUE, ngrams = 1:2)

# Convert to a slam::simple_triplet_matrix object
dtm <- convert_quanteda_to_slam(quanteda_dtm)

### Compare indices between slam matrix and dtm
length(dtm$dimnames$Docs) == length(quanteda_dtm@Dimnames$docs)

# Create dataframe for rights talk versus non-rights talk
rights <- as.data.frame(df[, c('ground_truth_rights')])
colnames(rights) <- 'Rights'
rights[is.na(rights)] <- 0 ###

# Create contigency table
cont.table <- contingency_table(metadata = rights,
                                document_term_matrix = dtm,
                                force_dense = F)
# Run FW algorithm
full.corp <- feature_selection(cont.table,
                               method = c("informed Dirichlet"),
                               alpha = 0.01,
                               rank_by_log_odds = F)
png('rights_nonrights_hand_label_bigram.png', width=15,height=12,units="in",res=100)
fightin_words_plot(full.corp, positive_category = "Rights Talk", 
                   negative_category = "Non-Rights Talk", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Rights Talk vs. Non-Rights Talk Sermons",
                   display_top_words = 20,
                   max_terms_to_display = 1e+10000)
dev.off()


### Bigrams only
# Prepare data for FW algorithm -> bigrams only
quanteda_dtm <- quanteda::dfm(df$cleaned, stem = T, tolower = T, remove = stopwords("english"),
                              verbose = T, remove_punct = TRUE, ngrams = 2)

# Convert to a slam::simple_triplet_matrix object
dtm <- convert_quanteda_to_slam(quanteda_dtm)

### Compare indices between slam matrix and dtm
length(dtm$dimnames$Docs) == length(quanteda_dtm@Dimnames$docs)

# Create dataframe for rights talk versus non-rights talk
rights <- as.data.frame(df[, c('ground_truth_rights')])
colnames(rights) <- 'Rights'
rights[is.na(rights)] <- 0 ###

# Create contigency table
cont.table <- contingency_table(metadata = rights,
                                document_term_matrix = dtm,
                                force_dense = F)
# Run FW algorithm
full.corp <- feature_selection(cont.table,
                               method = c("informed Dirichlet"),
                               alpha = 0.01,
                               rank_by_log_odds = F)
png('rights_nonrights_hand_label_bigram_only.png', width=15,height=12,units="in",res=100)
fightin_words_plot(full.corp, positive_category = "Rights Talk", 
                   negative_category = "Non-Rights Talk", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Rights Talk vs. Non-Rights Talk Sermons",
                   display_top_words = 20,
                   max_terms_to_display = 1e+10000)
dev.off()



#### Trigrams
# Prepare data for FW algorithm -> trigrams only
quanteda_dtm <- quanteda::dfm(df$cleaned, stem = T, tolower = T, remove = stopwords("english"),
                              verbose = T, remove_punct = TRUE, ngrams = 3)

# Convert to a slam::simple_triplet_matrix object
dtm <- convert_quanteda_to_slam(quanteda_dtm)

### Compare indices between slam matrix and dtm
length(dtm$dimnames$Docs) == length(quanteda_dtm@Dimnames$docs)

# Create dataframe for rights talk versus non-rights talk
rights <- as.data.frame(df[, c('ground_truth_rights')])
colnames(rights) <- 'Rights'
rights[is.na(rights)] <- 0 ###

# Create contigency table
cont.table <- contingency_table(metadata = rights,
                                document_term_matrix = dtm,
                                force_dense = F)
# Run FW algorithm
full.corp <- feature_selection(cont.table,
                               method = c("informed Dirichlet"),
                               alpha = 0.01,
                               rank_by_log_odds = F)
png('rights_nonrights_hand_label_trigrams.png', width=15,height=12,units="in",res=100)
fightin_words_plot(full.corp, positive_category = "Rights Talk", 
                   negative_category = "Non-Rights Talk", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Rights Talk vs. Non-Rights Talk Sermons",
                   display_top_words = 20,
                   max_terms_to_display = 1e+10000)
dev.off()


##############################################################################################
### Full dataset -> predictions
serms.rights <- read.csv('sermon_final_rights_ml.csv', stringsAsFactors = F)
colnames(serms.rights)
summary(serms.rights$rights_talk_xgboost==1) # 3557

# Remove words less than three characters
for (i in 1:nrow(serms.rights)) {
  serms.rights$cleaned[i] <- gsub('\\b\\w{1,2}\\b','',serms.rights$cleaned[i])
}
serms.rights$cleaned[1]

# Prepare data for FW algorithm -> unigrams
quanteda_dtm <- quanteda::dfm(serms.rights$cleaned, stem = T, tolower = T, remove = stopwords("english"),
                              verbose = T, remove_punct = TRUE) # , ngrams = 2

# Convert to a slam::simple_triplet_matrix object
dtm <- convert_quanteda_to_slam(quanteda_dtm)

### Compare indices between slam matrix and dtm
length(dtm$dimnames$Docs) == length(quanteda_dtm@Dimnames$docs)

# Create dataframe for rights talk versus non-rights talk
rights <- as.data.frame(df[, c('ground_truth_rights')])
colnames(rights) <- 'Rights'
summary(is.na(rights$Rights))





##############################################################################################
### END
##############################################################################################
# Clean stop words
myDfm <- tokens(df$text) %>%
  tokens_remove("\\p{P}", valuetype = "regex", padding = TRUE) %>%
  tokens_remove(stopwords("english"), padding  = TRUE) %>%
  tokens_ngrams(n = 2) %>%
  dfm()

# Convert to a slam::simple_triplet_matrix object
dtm2 <- convert_quanteda_to_slam(myDfm)

# Create contigency table
cont.table2 <- contingency_table(metadata = rights,
                                document_term_matrix = dtm,
                                force_dense = F)

# Run FW algorithm
full.corp <- feature_selection(cont.table2,
                               method = c("informed Dirichlet"),
                               alpha = 0.01,
                               rank_by_log_odds = F)
