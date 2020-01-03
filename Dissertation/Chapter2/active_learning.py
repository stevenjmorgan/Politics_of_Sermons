# -*- coding: utf-8 -*-
"""
Created on Tue Oct 15 19:13:35 2019

@author: SF515-51T
"""

import os, re, nltk, string, xgboost, warnings
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
    
    return "Accuracy: ", metrics.accuracy_score(predictions, valid_y), 'Recall: ', metrics.recall_score(predictions, valid_y), 'Precision: ', metrics.precision_score(predictions, valid_y), 'F1: ', metrics.f1_score(predictions, valid_y)


os.chdir('C:/Users/SF515-51T/Desktop/Dissertation')

warnings.filterwarnings("ignore")

# Read in full dataset
full = pd.read_csv('sermon_final.csv')#, index_col = False)
full.shape

#full['spanish.count'].describe()
#full = full[['doc_id','clean']]

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
vectorizer.fit(df['cleaned'])
print(vectorizer.vocabulary_)
train_x, valid_x, train_y, valid_y = model_selection.train_test_split(df['cleaned'], df['ground_truth_rights'], test_size=0.3, random_state=24519)

# label encode the target variable 
#encoder = preprocessing.LabelEncoder()
#train_y = encoder.fit_transform(train_y)
#valid_y = encoder.fit_transform(valid_y)

# Transform tf-idf
#vectorizer.fit(df['cleaned'])
print(vectorizer.get_feature_names()[0:10])
print(vectorizer.vocabulary_) #6740

### Try with count vectorizer
vectorizer = CountVectorizer(max_features=10000, max_df = 0.8, min_df = 3)
vectorizer.fit_transform(df['cleaned'])

#xtrain_tfidf =  vectorizer.transform(train_x)
#xvalid_tfidf =  vectorizer.transform(valid_x)

xtrain_tfidf =  vectorizer.fit_transform(train_x)
xvalid_tfidf =  vectorizer.fit_transform(valid_x)

xtrain_tfidf.shape
xvalid_tfidf.shape


### Models
# SVM - Linear
clf = svm.SVC(kernel='linear', probability = True)
#linear_svm_results = train_model(clf, xtrain_tfidf, train_y, xvalid_tfidf)
#print(linear_svm_results)

# Extract coefficients
clf.fit(xtrain_tfidf, train_y) # Class weight, coef0, degree?
    
# predict the labels on validation dataset
predictions = clf.predict(xvalid_tfidf)

print(metrics.accuracy_score(predictions, valid_y))
print(metrics.recall_score(predictions, valid_y))
print(metrics.precision_score(predictions, valid_y))
print(metrics.f1_score(predictions, valid_y))

print(predictions[0:10]) # all zero's


### Recall that a linear SVM creates a hyperplane that uses support vectors to 
### maximise the distance between the two classes. The weights obtained from 
### svm.coef_ represent the vector coordinates which are orthogonal to the 
### hyperplane and their direction indicates the predicted class. The absolute 
### size of the coefficients in relation to each other can then be used to 
### determine feature importance for the data separation task.
print(clf.coef_)

#clf.score(x,y)


### Try with count vectorizer
feature_names = vectorizer.get_feature_names() 
coefs_with_fns = sorted(zip(clf.coef_[0], feature_names)) 
df=pd.DataFrame(coefs_with_fns)
df.columns='coefficient','word'
df.sort_values(by='coefficient')





coef = np.ravel(clf.coef_)
top_positive_coefficients = np.argsort(coef)[-20:]
top_negative_coefficients = np.argsort(coef)[:20]
top_coefficients = np.hstack([top_negative_coefficients, top_positive_coefficients])

top_features=20
top_features = vectorizer.get_feature_names()
plt.figure(figsize=(15, 5))
colors = ['red' if c < 0 else 'blue' for c in coef[top_coefficients]]
plt.bar(np.arange(2 * top_features), coef[top_coefficients], color=colors)
feature_names = np.array(feature_names)
plt.xticks(np.arange(1, 1 + 2 * top_features), feature_names[top_coefficients], rotation=60, ha='right')
plt.show()

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



#### Run on non-labeled data
full['clean'] = full['clean'].apply(lambda x: remove_punct(x))
full['clean'] = full['clean'].apply(lambda x: tokenization(x.lower()))
#stopword = nltk.corpus.stopwords.words('english')
full['clean'] = full['clean'].apply(lambda x: remove_stopwords(x))
#ps = nltk.PorterStemmer()
full['clean'] = full['clean'].apply(lambda x: stemming(x))
full['clean'] = full['clean'].apply(lambda x: remove_small_tokens(x))
#full['clean'][0]
#type(df['clean'][0])
full['cleaned'] = full['clean'].apply(lambda x: ', '.join(map(str, x)))
full['cleaned'] = full['cleaned'].str.replace(',', '')
#full['cleaned'][0]
new_tfidf = vectorizer.transform(full['cleaned'])
print(new_tfidf.shape) # 121037, 6740

clf
predictions = clf.predict(new_tfidf)
unique, counts = np.unique(predictions, return_counts=True)
unique
counts
full['rights_talk_xgboost'] = predictions
full['rights_talk_xgboost'].describe()
full['rights_talk_xgboost'].value_counts()

full.to_csv('sermon_final_rights_ml_11-15.csv')

###############################################################################
### Bigram approach -> does not work well
#tfidf = TfidfVectorizer(max_features=7000, max_df = 0.5, min_df = 3, stop_words = 'english', ngram_range=(1,2))
#xtrain_tfidf =  tfidf.fit_transform(train_x)
#xvalid_tfidf =  tfidf.fit_transform(valid_x)
#xtrain_tfidf.shape
#xvalid_tfidf.shape
#
## SVM -> linear
#clf = svm.SVC(kernel='linear')
#linear_svm_results = train_model(clf, xtrain_tfidf, train_y, xvalid_tfidf)
#print(linear_svm_results)
#
## XGBoost
#clf = xgboost.XGBClassifier()
#xgb_results = train_model(clf, xtrain_tfidf, train_y, xvalid_tfidf)
#print(xgb_results)
#
##vectorizer.fit_transform(arr)
#feature_names = tfidf.get_feature_names()
#corpus_index = [n for n in corpus]
#rows, cols = tfs.nonzero()
#for row, col in zip(rows, cols):
#    print((feature_names[col], corpus_index[row]), tfs[row, col])