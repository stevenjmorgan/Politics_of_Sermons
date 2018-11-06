# -*- coding: utf-8 -*-
"""
Created on Fri Nov  5 21:38:17 2018

@author: Steve
"""

from nltk.stem import PorterStemmer
from nltk.tokenize import sent_tokenize, word_tokenize
import nltk
import re
import numpy as np
import os
import glob
from sklearn.feature_extraction.text import TfidfVectorizer, CountVectorizer
from sklearn.decomposition import LatentDirichletAllocation
import sys
from importlib import reload
import gensim
from gensim import corpora
import pickle
from nltk.corpus import stopwords
from nltk.stem.wordnet import WordNetLemmatizer
import string
from nltk.corpus import stopwords
from nltk.tokenize import RegexpTokenizer
from gensim.models import CoherenceModel
import gensim.corpora as corpora
from gensim.utils import simple_preprocess
from gensim.test.utils import datapath
import pandas as pd
import random


random.seed(24519)
nltk.download('stopwords')

reload(sys)

#os.chdir('C:/Users/sum410/Dropbox/PoliticsOfSermons/Data/SampleLDA')
#os.chdir('C:/Users/Steve/Dropbox/PoliticsOfSermons/Data/SampleLDA')

os.environ['R_USER'] = 'D:/Anaconda3/Lib/site-packages/rpy2'

import rpy2.robjects as robjects
from rpy2.robjects import pandas2ri
pandas2ri.activate()

# Read in subset serms and store as panda dataframe (cleanedText, and pol_doc)
#readRDS = robjects.r['readRDS']
robjects.r['load'](".RData")
df = robjects.r['subsetSerms.RData']
df = pandas2ri.ri2py(df)
#df.head()

# Sample 10,000 documents for first iteration
df1 = df.sample(n = 10000, replace = False)

# Create dtm and merge back with pol_docs variable
countvec = CountVectorizer()
df1 = pd.DataFrame(countvec.fit_transform(df1.sermon_clean).toarray(), columns=countvec.get_feature_names())

# Split data into X and Y feature vectors and then train-test
X1 = df1.drop('pol_doc', axis=1)
y1 = df1['pol_doc']
X_train, X_test, y_train, y_test = train_test_split(X1, y1, test_size = 0.20)

# Create gridsearch function w/ cross-validation
def svc_param_selection(X, y, nfolds):
    Cs = [0.001, 0.01, 0.1, 1, 10]
    gammas = [0.001, 0.01, 0.1, 1]
    param_grid = {'C': Cs, 'gamma' : gammas}
    grid_search = GridSearchCV(svm.SVC(kernel='rbf'), param_grid, cv=nfolds)
    grid_search.fit(X, y)
    grid_search.best_params_
    return grid_search.best_params_

# Call SVM model (w/ default rbf), hyperparameterize, and run on sample
print(svc_param_selection(X1, y1, 10)) # Returns on average 0.001, 0.001
svclassifier = svm.SVC(kernel='rbf', gamma=0.001, C=0.001)
svclassifier.fit(X_train, y_train) #Runs for a while -> use cluster

# Generate confusion matrix
y_pred = svclassifier.predict(X_test)
print(confusion_matrix(y_test,y_pred))
print(classification_report(y_test,y_pred))

# Return top 20 coefficients
print(svclassifier.coef_.sort(reverse=True)[0:20])
# marriag, polit, conserv, liberti, gay, liber, progress


# Prepare data for second iteration
df2 = df.sample(n = 10000, replace = False)
df2 = pd.DataFrame(countvec.fit_transform(df2.sermon_clean).toarray(), columns=countvec.get_feature_names())
twoDF = (df1, df2)
df2 = pd.concat(twoDF, ignore_index = True)

# Relabel political doc.'s based on new keywords
for i in df2['liberti']:
    if i > 0:
        df2['pol_doc'][i] = 1

for i in df2['polit']:
    if i > 0:
        df2['pol_doc'][i] = 1


# Split data into X and Y feature vectors and then train-test
X2 = df2.drop('pol_doc', axis=1)
y2 = df2['pol_doc']
X_train, X_test, y_train, y_test = train_test_split(X2, y2, test_size = 0.20)

# Re-initialize SVM and run model
svclassifier = SVC()
svclassifier.fit(X_train, y_train)

# Generate confusion matrix
y_pred = svclassifier.predict(X_test)
print(confusion_matrix(y_test,y_pred))
print(classification_report(y_test,y_pred))

# Return top 20 coefficients
print(svclassifier.coef_.sort(reverse=True)[0:20])
# polit, gay, marriag, unborn, liber, progress, abort
