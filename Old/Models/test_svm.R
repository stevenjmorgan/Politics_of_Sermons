# This code predicts whether doc's are political or not

rm(list=ls())
#setwd("C:/Users/Steve/Dropbox/PoliticsOfSermons")
setwd("C:/Users/sum410/Dropbox/PoliticsOfSermons")
#setwd("~/GitHub/Politics_of_Sermons/Clean")

load('political_sermons_data.RData')

library(e1071)
library(tm)

train <- head(serms.merge, 200)
train <- train[,c(3,16,20)]
names(train)[2] <- 'text'

serm.corp <- DataframeSource(train)
serm.corp <- VCorpus(serm.corp)

serm.dtm <- as.data.frame(as.matrix(DocumentTermMatrix(serm.corp)))
serm.dtm$pol.doc <- ifelse(serm.dtm$god > 0, 1, 0)

classifier <- svm(formula = pol.doc ~ ., data = serm.dtm)
summary(classifier)
print(classifier)
