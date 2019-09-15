rm(list=ls())
setwd("C:/Users/steve/Dropbox/Dissertation/Data/handcode")

library(stringr)

load('C:/Users/steve/Dropbox/Dissertation/Data/sermons_mfd_7-30.RData')

#pat <- paste0(c('war', 'religion', 'attack'), collapse = '|')

serms.merge$clean <- tolower(serms.merge$clean)

serms.merge$attack_rel <- str_count(serms.merge$clean, 'war on religion')
summary(serms.merge$attack_rel > 1)

serms.merge$war <- str_count(serms.merge$clean, ' war')
serms.merge$religion <- str_count(serms.merge$clean, ' religion')
serms.merge$attack <- str_count(serms.merge$clean, ' attack')

serms.merge$war.on.rel <- ifelse(serms.merge$war > 0 & serms.merge$religion > 0 & serms.merge$attack > 0, 1, 0)
summary(serms.merge$war.on.rel == 1) #1547/nrow(serms.merge) = 0.012

war.on.rel <- serms.merge[which(serms.merge$war.on.rel == 1),]
war.on.rel$clean[3]


#install.packages("devtools")
library("devtools")
devtools::install_github("matthewjdenny/SpeedReader")
library(SpeedReader)
library(Rcpp)
library(tm)
library(RTextTools)
library(SnowballC)
library(quanteda)

serms.merge$clean <- gsub('[[:punct:]]+', '', serms.merge$clean)
serms.merge$clean <- trimws(serms.merge$clean)

# Create document-term matrix
serms.dtm <- quanteda::dfm(serms.merge$clean, stem = FALSE, ngrams = 1)

# Convert to a slam::simple_triplet_matrix object:
dtm <- convert_quanteda_to_slam(serms.dtm)


# Create dataframe for political/non-political
pol.nonpol <- as.data.frame(serms.merge[, c('war.on.rel')])
colnames(pol.nonpol) <- 'War_On_Religion'
#pol.nonpol$War_On_Religion <- as.character(pol.nonpol$War_On_Religion)
pol.nonpol$War_On_Religion[pol.nonpol$War_On_Religion == 1] <- 'War On Religion'
pol.nonpol$War_On_Religion[pol.nonpol$War_On_Religion == 0] <- 'Not War On Religion'

# Create contigency table
cont.table <- contingency_table(metadata = pol.nonpol,
                                document_term_matrix = dtm)

# Fightin' Words approach
#png("political-nonpolitical.png",width=12,height=8,units="in",res=100)
#dev.copy(png,"myfile.png",width=8,height=6,units="in",res=100)
#dev.off()
full.corp <- feature_selection(cont.table, 
                               method = c("informed Dirichlet"),
                               alpha = 0.01,
                               rank_by_log_odds = F)
fightin_words_plot(full.corp, positive_category = "Non-Political", 
                   negative_category = "Political", 
                   clean_publication_plots = FALSE,
                   title = "Differences in Language: Political vs. Non-Political Tweets",
                   display_top_words = 10,
                   max_terms_to_display = 1e+10000)#: 
#Raw Z-scores, Weak Informed Dirichlet Prior")
dev.off()