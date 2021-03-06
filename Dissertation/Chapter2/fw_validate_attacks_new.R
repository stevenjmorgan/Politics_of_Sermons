### This validates initial hand coding by comparing attack on religion talk sermons
### to non-attack on religion talk sermons via the Fightin words algorithm.

setwd("C:/Users/SF515-51T/Desktop/Dissertation")

library(tm)
library(devtools)
#devtools::install_github("matthewjdenny/SpeedReader")
library(SpeedReader)
library(stargazer)
library(quanteda)
library(readtext)

#attacks <- read.csv('coded_attack_fw.csv', stringsAsFactors = F)

# Remove words less than three characters
#for (i in 1:nrow(attacks)) {
#  attacks$cleaned[i] <- gsub('\\b\\w{1,2}\\b','',attacks$text[i])
#}
#attacks$cleaned[1]

serm.final$clean[1]
serm.final$cleaned <- serm.final$clean

set.seed(3336)
smp.serms <- serm.final[sample(nrow(serm.final[which(serm.final$attack_final_active_pred==0),]), 4000), ] #4000
x <- serm.final[sample(nrow(serm.final[which(serm.final$attack_final_active_pred==1),]), 1000), ]
smp.serms <- rbind(smp.serms, x)
rm(x)

# Prepare data for FW algorithm -> unigrams
quanteda_dtm <- quanteda::dfm(smp.serms$cleaned, stem = T, tolower = T, remove = stopwords("english"),
                              verbose = T, remove_punct = TRUE) # , ngrams = 2

# Convert to a slam::simple_triplet_matrix object
dtm <- convert_quanteda_to_slam(quanteda_dtm)

### Compare indices between slam matrix and dtm
length(dtm$dimnames$Docs) == length(quanteda_dtm@Dimnames$docs)

# Create dataframe for rights talk versus non-rights talk
attack <- as.data.frame(smp.serms[, c('attack_final_active_pred')])
colnames(attack) <- 'attacks'
summary(is.na(attack$attacks))

# Create contigency table
cont.table <- contingency_table(metadata = attack,
                                document_term_matrix = dtm,
                                force_dense = F)
# Run FW algorithm
full.corp <- feature_selection(cont.table,
                               method = c("informed Dirichlet"),
                               alpha = 0.01,
                               rank_by_log_odds = F)
png('attacks_nonattacks_hand_label.png', width=15,height=12,units="in",res=100)
fightin_words_plot(full.corp, positive_category = "Attack on Religion Rhetoric", 
                   negative_category = "Non-Attack Talk", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Attack on Religion vs. Non-Attack Rhetoric Sermons",
                   display_top_words = 20,
                   max_terms_to_display = 1e+10000)
dev.off()


############################################################################################3
### Unigrams and bigrams
# Prepare data for FW algorithm -> unigrams and bigrams
quanteda_dtm <- quanteda::dfm(attacks$cleaned, stem = T, tolower = T, remove = stopwords("english"),
                              verbose = T, remove_punct = TRUE, ngrams = 1:2)

# Convert to a slam::simple_triplet_matrix object
dtm <- convert_quanteda_to_slam(quanteda_dtm)

### Compare indices between slam matrix and dtm
length(dtm$dimnames$Docs) == length(quanteda_dtm@Dimnames$docs)


# Create contigency table
cont.table <- contingency_table(metadata = attack,
                                document_term_matrix = dtm,
                                force_dense = F)
# Run FW algorithm
full.corp <- feature_selection(cont.table,
                               method = c("informed Dirichlet"),
                               alpha = 0.01,
                               rank_by_log_odds = F)
png('attacks_nonattacks_hand_label_uni_bi.png', width=15,height=12,units="in",res=100)
fightin_words_plot(full.corp, positive_category = "Attack on Religion Rhetoric", 
                   negative_category = "Non-Attack Talk", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Attack on Religion vs. Non-Attack Rhetoric Sermons",
                   display_top_words = 20,
                   max_terms_to_display = 1e+10000)
dev.off()


############################################################################################3
### Bigrams only
# Prepare data for FW algorithm -> unigrams and bigrams
quanteda_dtm <- quanteda::dfm(attacks$cleaned, stem = T, tolower = T, remove = stopwords("english"),
                              verbose = T, remove_punct = TRUE, ngrams = 2)

# Convert to a slam::simple_triplet_matrix object
dtm <- convert_quanteda_to_slam(quanteda_dtm)

### Compare indices between slam matrix and dtm
length(dtm$dimnames$Docs) == length(quanteda_dtm@Dimnames$docs)


# Create contigency table
cont.table <- contingency_table(metadata = attack,
                                document_term_matrix = dtm,
                                force_dense = F)
# Run FW algorithm
full.corp <- feature_selection(cont.table,
                               method = c("informed Dirichlet"),
                               alpha = 0.01,
                               rank_by_log_odds = F)
png('attacks_nonattacks_hand_label_bi.png', width=15,height=12,units="in",res=100)
fightin_words_plot(full.corp, positive_category = "Attack on Religion Rhetoric: Bigrams", 
                   negative_category = "Non-Attack Talk", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Attack on Religion vs. Non-Attack Rhetoric Sermons",
                   display_top_words = 18,
                   max_terms_to_display = 1e+10000)
dev.off()
