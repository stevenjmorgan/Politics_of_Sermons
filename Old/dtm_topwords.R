library("tm")
library("devtools")
devtools::install_github("matthewjdenny/SpeedReader")
library(SpeedReader)
library(stargazer)
library(quanteda)

setwd("C:/Users/sum410/Dropbox/PoliticsOfSermons")

#file <- 'C:/Users/sum410/Dropbox/PoliticsOfSermons/Data/sermon_10-21.JSON'

#load('political_sermons_data.RData')

#s <- Source(serms.merge$sermon.clean)
corpus <- Corpus(VectorSource(serms.merge$sermon.clean))

m <- DocumentTermMatrix(corpus)

freq <- colSums(as.matrix(m))

findFreqTerms(m,75000) # words appearing more than 600 times

findMostFreqTerms(m,10)


c2 <- tm_map(corpus, removeWords, stopwords("english"))
m2 <- DocumentTermMatrix(c2)
findFreqTerms(m2, 400) # words appearing more than 500 times


# bi-grams
top <- topfeatures(dfm(serms.merge$sermon.clean, ngrams = 1, verbose = FALSE))
top

top.bi <- topfeatures(dfm(serms.merge$sermon.clean, ngrams = 2, verbose = FALSE))
top.bi


### Fightin' Words
# Subset dataframe
baptist.ucc <- serms.merge[which(serms.merge$denom == 'Baptist' | serms.merge$denom == 'Christian/Church Of Christ'),]
#ucc <- serms.merge[which(serms.merge$denom == 'Christian/Church Of Christ'),]

# Create document-term matrix
bap.ucc.dtm <- quanteda::dfm(baptist.ucc$sermon.clean, stem = TRUE, ngrams = 1)

# Convert to a slam::simple_triplet_matrix object:
dtm <- convert_quanteda_to_slam(bap.ucc.dtm)

# Create dataframe for country of speaker
denom.features <- as.data.frame(baptist.ucc[, c('denom')])
colnames(denom.features) <- 'Denomination'
denom.features$Denomination <- as.character(denom.features$Denomination)
unique(denom.features$Denomination)

# Create contigency table
cont.table <- contingency_table(metadata = denom.features,
                                        document_term_matrix = dtm)

bapt.uss.feat <- feature_selection(cont.table, 
                                       method = c("informed Dirichlet"),
                                       alpha = 0.05)
png("baptist_cofc.png",width=12,height=8,units="in",res=100)
fightin_words_plot(bapt.uss.feat, positive_category = "Baptist", 
                   negative_category = "Church Of Christ", 
                   clean_publication_plots = FALSE,
                   title = "Difference in Language between Baptist and Church of Christ",
                   size_terms_by_frequency = FALSE,
                   display_top_words=20,
                   max_terms_to_display = 1000000)
dev.off()



evang.ucc <- serms.merge[which(serms.merge$denom == 'Independent/Bible' | serms.merge$denom == 'Christian/Church Of Christ'),]
#ucc <- serms.merge[which(serms.merge$denom == 'Christian/Church Of Christ'),]

# Create document-term matrix
evang.ucc.dtm <- quanteda::dfm(evang.ucc$sermon.clean, stem = TRUE, ngrams = 1)

# Convert to a slam::simple_triplet_matrix object:
dtm <- convert_quanteda_to_slam(evang.ucc.dtm)

# Create dataframe for country of speaker
denom.features <- as.data.frame(evang.ucc[, c('denom')])
colnames(denom.features) <- 'Denomination'
denom.features$Denomination <- as.character(denom.features$Denomination)
unique(denom.features$Denomination)

# Create contigency table
cont.table <- contingency_table(metadata = denom.features,
                                document_term_matrix = dtm)

evang.uss.feat <- feature_selection(cont.table, 
                                   method = c("informed Dirichlet"),
                                   alpha = 0.05)
png("ind_cofc.png",width=12,height=8,units="in",res=100)
fightin_words_plot(evang.uss.feat, positive_category = "Church Of Christ", 
                   negative_category = "Independent/Bible", 
                   clean_publication_plots = FALSE,
                   title = "Difference in Language between Church Of Christ and Independent/Bible",
                   size_terms_by_frequency = FALSE,
                   display_top_words=20,
                   max_terms_to_display = 1000000)
dev.off()

# Group number of sermons in each year
year.group <- count(serms.merge, "year")
year.group$rel <- round(100 * year.group$freq / sum(year.group$freq),2)

# Table of sermons by year
stargazer(year.group, type = 'latex', summary = FALSE, rownames = FALSE,
          covariate.labels = c('Year', '# of Sermons', '% of Corpus'), 
          column.sep.width = '10pt', digits = 2, header = FALSE)



##### MF
# Create quanteda corpus
#unsc <- unsc[,-10]
colnames(serms.merge)[names(serms.merge) == "sermon"] <- "text"
colnames(serms.merge)[names(serms.merge) == "doc_id"] <- "doc"
serms.merge.corp <- corpus(serms.merge)

install_github("kbenoit/quanteda.dictionaries") #input int corresponding w/ "None"
library(quanteda.dictionaries)

mf.serms <- liwcalike(serms.merge.corp,
                     dictionary = data_dictionary_MFD)

serms.merge <- cbind(serms.merge, mf.serms)
