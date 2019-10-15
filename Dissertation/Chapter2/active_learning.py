# -*- coding: utf-8 -*-
"""
Created on Tue Oct 15 19:13:35 2019

@author: SF515-51T
"""

import os, re, nltk, string, xgboost
import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer, TfidfTransformer, TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics  import accuracy_score, recall_score, precision_score, f1_score
from sklearn import svm
from sklearn import model_selection, preprocessing, linear_model, naive_bayes, metrics, svm
from sklearn import decomposition, ensemble
from sklearn.model_selection import KFold, cross_val_score
from sklearn.ensemble import RandomForestClassifier

def remove_punct(text):
    text  = "".join([char for char in text if char not in string.punctuation])
    text = re.sub('[0-9]+', '', text)
    return text

def tokenization(text):
    text = re.split('\W+', text)
    return text

def remove_stopwords(text):
    text = [word for word in text if word not in stopword]
    return text

def stemming(text):
    text = [ps.stem(word) for word in text]
    return text

def remove_small_tokens(text):
    text = [word for word in text if len(word) > 2]
    return text

def train_model(classifier, feature_vector_train, label, feature_vector_valid):
    # fit the training dataset on the classifier
    classifier.fit(feature_vector_train, label)
    
    # predict the labels on validation dataset
    predictions = classifier.predict(feature_vector_valid)
    
    return metrics.accuracy_score(predictions, valid_y), metrics.recall_score(predictions, valid_y), metrics.precision_score(predictions, valid_y), metrics.f1_score(predictions, valid_y),


os.chdir('C:/Users/SF515-51T/Desktop/Dissertation')

# Read in hand labels
df = pd.read_csv('hand_code_sample_10-15_coded_no_text.csv', index_col = False)
text = pd.read_csv('text.csv', index_col = False)

df['text'] = text['clean']
del(text)

### Predict rights talk
df['ground_truth_rights'].describe()
df['ground_truth_rights'].value_counts() # 95 instances of rights talk

df['text'][0]

# Clean text
df['clean'] = df['text'].apply(lambda x: remove_punct(x))
df['clean'] = df['clean'].apply(lambda x: tokenization(x.lower()))
stopword = nltk.corpus.stopwords.words('english')
df['clean'] = df['clean'].apply(lambda x: remove_stopwords(x))
ps = nltk.PorterStemmer()
df['clean'] = df['clean'].apply(lambda x: stemming(x))
df['clean'] = df['clean'].apply(lambda x: remove_small_tokens(x))
df['clean'][0]
#type(df['clean'][0])
df['cleaned'] = df['clean'].apply(lambda x: ', '.join(map(str, x)))
df['cleaned'] = df['cleaned'].str.replace(',', '')
df['cleaned'][0]

# Vectorize, train-test split
vectorizer = TfidfVectorizer(max_features=10000, max_df = 0.8, min_df = 3)
train_x, valid_x, train_y, valid_y = model_selection.train_test_split(df['cleaned'], df['ground_truth_rights'], test_size=0.3, random_state=24519)

# label encode the target variable 
encoder = preprocessing.LabelEncoder()
train_y = encoder.fit_transform(train_y)
valid_y = encoder.fit_transform(valid_y)

# Transform tf-idf
vectorizer.fit(df['cleaned'])
vectorizer.get_feature_names()[0:10]
vectorizer.vocabulary_ #6740

xtrain_tfidf =  vectorizer.transform(train_x)
xvalid_tfidf =  vectorizer.transform(valid_x)

xtrain_tfidf.shape
xvalid_tfidf.shape


### Models
# SVM - Linear
clf = svm.SVC(kernel='linear')
linear_svm_results = train_model(clf, xtrain_tfidf, train_y, xvalid_tfidf)
print(linear_svm_results)

# SVM - RBF
clf = svm.SVC(kernel='rbf')
rbf_svm_results = train_model(clf, xtrain_tfidf, train_y, xvalid_tfidf)
print(rbf_svm_results)

# Naive Bayes
clf = naive_bayes.MultinomialNB()
bayes_results = train_model(clf, xtrain_tfidf, train_y, xvalid_tfidf)
print(bayes_results)

# Logistic regression
clf = linear_model.LogisticRegression()
log_results = train_model(clf, xtrain_tfidf, train_y, xvalid_tfidf)
print(log_results)

# RF on Word Level TF IDF Vectors
clf = ensemble.RandomForestClassifier()
rf_results = train_model(clf, xtrain_tfidf, train_y, xvalid_tfidf)
print(rf_results)

# Weighted RF on Word Level TF IDF Vectors
w = 1000 # The weight for the positive class
RF = RandomForestClassifier(class_weight={0: 1, 1: w})
weighted_rf_results = train_model(RF, xtrain_tfidf, train_y, xvalid_tfidf)
print(weighted_rf_results)

# XGBoost
clf = xgboost.XGBClassifier()
xgb_results = train_model(clf, xtrain_tfidf, train_y, xvalid_tfidf)
print(xgb_results)