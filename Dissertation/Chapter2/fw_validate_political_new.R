### This validates initial hand coding by comparing political sermons
### to non-political sermons via the Fightin words algorithm.

setwd("C:/Users/SF515-51T/Desktop/Dissertation")

library(tm)
library(devtools)
#devtools::install_github("matthewjdenny/SpeedReader")
library(SpeedReader)
library(stargazer)
library(quanteda)
library(readtext)

#load('serms_with_measures.RData')

#serms.merge <- serm.final
#set.seed(24519)
#smp.serms <- serms.merge[sample(nrow(serms.merge[which(serms.merge$pol.var==0),]), 4000), ] #4000
#x <- serms.merge[sample(nrow(serms.merge[which(serms.merge$pol.var==1),]), 1000), ]
#smp.serms <- rbind(smp.serms, x)
#rm(x)

set.seed(24519)
smp.serms <- serms.merge[sample(nrow(serms.merge), 40000), ]

# Remove words less than three characters
#for (i in 1:nrow(smp.serms)) {
#  smp.serms$cleaned[i] <- gsub('\\b\\w{1,2}\\b','',smp.serms$cleaned[i])
#}
#smp.serms$cleaned[1]

smp.serms$clean[1]
smp.serms$cleaned <- smp.serms$clean

# Prepare data for FW algorithm -> unigrams
quanteda_dtm <- quanteda::dfm(smp.serms$cleaned, stem = F, tolower = F, #remove = stopwords("english"),
                              verbose = T, remove_punct = F) # , ngrams = 2

# Convert to a slam::simple_triplet_matrix object
dtm <- convert_quanteda_to_slam(quanteda_dtm)

### Compare indices between slam matrix and dtm
length(dtm$dimnames$Docs) == length(quanteda_dtm@Dimnames$docs)

# Create dataframe for political versus non-political
pol <- as.data.frame(smp.serms[, c('pol.final')])
colnames(pol) <- 'political'
pol$political <- ifelse(pol$political == 1, 'political', 'non-political')
summary(is.na(pol$political))
unique(pol$political)

# Create contigency table
cont.table <- contingency_table(metadata = pol,
                                document_term_matrix = dtm,
                                force_dense = F)
# Run FW algorithm
full.corp <- feature_selection(cont.table,
                               method = c("informed Dirichlet"),
                               alpha = 0.01,
                               rank_by_log_odds = F)
png('pol_nonpol_uni_new1-9.png', width=15,height=12,units="in",res=100)
fightin_words_plot(full.corp, positive_category = "Non-Political Sermons", 
                   negative_category = "Political Sermons", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Political vs. Non-Political Sermons",
                   display_top_words = 20,
                   max_terms_to_display = 1e+10000)
dev.off()


######################################################################################################
### Unigrams and bigrams
# Prepare data for FW algorithm -> unigrams
quanteda_dtm <- quanteda::dfm(smp.serms$cleaned, stem = F, tolower = F, remove = stopwords("english"),
                              verbose = T, remove_punct = F, ngrams = 1:2)

# Convert to a slam::simple_triplet_matrix object
dtm <- convert_quanteda_to_slam(quanteda_dtm)

### Compare indices between slam matrix and dtm
length(dtm$dimnames$Docs) == length(quanteda_dtm@Dimnames$docs)

# Create contigency table
cont.table <- contingency_table(metadata = pol,
                                document_term_matrix = dtm,
                                force_dense = F)
# Run FW algorithm
full.corp <- feature_selection(cont.table,
                               method = c("informed Dirichlet"),
                               alpha = 0.01,
                               rank_by_log_odds = F)
png('pol_nonpol_uni_bi.png', width=15,height=12,units="in",res=100)
fightin_words_plot(full.corp, positive_category = "Non-Political Sermons", 
                   negative_category = "Political Sermons", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Political vs. Non-Political Sermons",
                   display_top_words = 20,
                   max_terms_to_display = 1e+10000)
dev.off()


######################################################################################################
### Bigrams only
# Prepare data for FW algorithm -> bi
#load('serms_with_measures.RData')
#set.seed(24519)
#smp.serms <- serms.merge[sample(nrow(serms.merge), 40000), ]
gc()
quanteda_dtm <- quanteda::dfm(smp.serms$cleaned, stem = F, tolower = F, #remove = stopwords("english"),
                              verbose = T, remove_punct = F, ngrams = 2)

# Convert to a slam::simple_triplet_matrix object
dtm <- convert_quanteda_to_slam(quanteda_dtm)

### Compare indices between slam matrix and dtm
length(dtm$dimnames$Docs) == length(quanteda_dtm@Dimnames$docs)

# Create contigency table
cont.table <- contingency_table(metadata = pol,
                                document_term_matrix = dtm,
                                force_dense = F)
# Run FW algorithm
full.corp <- feature_selection(cont.table,
                               method = c("informed Dirichlet"),
                               alpha = 0.01,
                               rank_by_log_odds = F)
png('pol_nonpol_bi_new_1-9.png', width=15,height=12,units="in",res=100)
fightin_words_plot(full.corp, positive_category = "Non-Political Sermons", 
                   negative_category = "Political Sermons", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Political vs. Non-Political Sermons",
                   display_top_words = 20,
                   max_terms_to_display = 1e+10000)
dev.off()



######################################################################################################
### Rights talk
######################################################################################################
### Bigrams

# Create dataframe for rights versus non-rights
pol <- as.data.frame(smp.serms[, c('rights.final')])
colnames(pol) <- 'Rights'
pol$Rights <- ifelse(pol$Rights == 1, 'Rights', 'Non-Rights')
summary(is.na(pol$Rights))
unique(pol$Rights)

# Create contigency table
cont.table <- contingency_table(metadata = pol,
                                document_term_matrix = dtm,
                                force_dense = F)
# Run FW algorithm
full.corp <- feature_selection(cont.table,
                               method = c("informed Dirichlet"),
                               alpha = 0.01,
                               rank_by_log_odds = F)

png('rights_nonrights_bi_new_1-9.png', width=15,height=12,units="in",res=100)
fightin_words_plot(full.corp, positive_category = "Non-Rights Talk Sermons", 
                   negative_category = "Rights Talk Sermons", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Rights Talk vs. Non-Rights Talk Sermons",
                   display_top_words = 20,
                   max_terms_to_display = 1e+10000)
dev.off()


### Unigrams
# Prepare data for FW algorithm -> unigrams
quanteda_dtm <- quanteda::dfm(smp.serms$cleaned, stem = F, tolower = F, #remove = stopwords("english"),
                              verbose = T, remove_punct = F) # , ngrams = 2

# Convert to a slam::simple_triplet_matrix object
dtm <- convert_quanteda_to_slam(quanteda_dtm)

### Compare indices between slam matrix and dtm
length(dtm$dimnames$Docs) == length(quanteda_dtm@Dimnames$docs)

# Create dataframe for political versus non-political
pol <- as.data.frame(smp.serms[, c('rights.final')])
colnames(pol) <- 'Rights'
pol$Rights <- ifelse(pol$Rights == 1, 'Rights', 'Non-Rights')
summary(is.na(pol$Rights))
unique(pol$Rights)

# Create contigency table
cont.table <- contingency_table(metadata = pol,
                                document_term_matrix = dtm,
                                force_dense = F)
# Run FW algorithm
full.corp <- feature_selection(cont.table,
                               method = c("informed Dirichlet"),
                               alpha = 0.01,
                               rank_by_log_odds = F)

png('rights_nonrights_uni_new_1-9.png', width=15,height=12,units="in",res=100)
fightin_words_plot(full.corp, positive_category = "Non-Rights Talk Sermons", 
                   negative_category = "Rights Talk Sermons", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Rights Talk vs. Non-Rights Talk Sermons",
                   display_top_words = 20,
                   max_terms_to_display = 1e+10000)
dev.off()



######################################################################################################
### Attack
######################################################################################################
### Bigrams

# Create dataframe for rights versus non-rights
pol <- as.data.frame(smp.serms[, c('attack.final')])
colnames(pol) <- 'Attack'
pol$Attack <- ifelse(pol$Attack == 1, 'Attack', 'Non-Attack')
summary(is.na(pol$Attack))
unique(pol$Attack)

# Create contigency table
cont.table <- contingency_table(metadata = pol,
                                document_term_matrix = dtm,
                                force_dense = F)
# Run FW algorithm
full.corp <- feature_selection(cont.table,
                               method = c("informed Dirichlet"),
                               alpha = 0.01,
                               rank_by_log_odds = F)

png('Attack_nonAttack_bi_new_1-9.png', width=15,height=12,units="in",res=100)
fightin_words_plot(full.corp, positive_category = "Attack Sermons", 
                   negative_category = "Non-Attack Sermons", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Attack on Religion vs. Non-Attack Sermons",
                   display_top_words = 20,
                   max_terms_to_display = 1e+10000)
dev.off()


### Unigrams
# Create dataframe for rights versus non-rights
pol <- as.data.frame(smp.serms[, c('attack.final')])
colnames(pol) <- 'Attack'
pol$Attack <- ifelse(pol$Attack == 1, 'Attack', 'Non-Attack')
summary(is.na(pol$Attack))
unique(pol$Attack)

# Create contigency table
cont.table <- contingency_table(metadata = pol,
                                document_term_matrix = dtm,
                                force_dense = F)
# Run FW algorithm
full.corp <- feature_selection(cont.table,
                               method = c("informed Dirichlet"),
                               alpha = 0.01,
                               rank_by_log_odds = F)

png('Attack_nonAttack_uni_new_1-9.png', width=15,height=12,units="in",res=100)
fightin_words_plot(full.corp, positive_category = "Attack Sermons", 
                   negative_category = "Non-Attack Sermons", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Attack on Religion vs. Non-Attack Sermons",
                   display_top_words = 20,
                   max_terms_to_display = 1e+10000)
dev.off()

