# -*- coding: utf-8 -*-
"""
Created on Mon Jan  6 09:58:21 2020

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
from sklearn.linear_model import SGDClassifier

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

def search_func(row):
    matches = [test_value in political_dict 
               for test_value in row["cleaned"].split(' ')]

    if any(matches):
        return 1
    else:
        return 0


os.chdir('C:/Users/SF515-51T/Desktop/Dissertation')

warnings.filterwarnings("ignore")

# Read in full dataset
full = pd.read_csv('sermon_final.csv')#, index_col = False)
full.shape


# Read in hand labels
df = pd.read_csv('hand_code_sample_10-15_coded_no_text.csv', index_col = False)
text = pd.read_csv('text.csv', index_col = False)

df['text'] = text['clean']

#df = pd.read_csv('political_active_1st_round.csv', index_col = False)


# Clean text
df['text'][0]
df['clean'] = df['text'].apply(lambda x: remove_punct(x))
df['clean'] = df['clean'].apply(lambda x: tokenization(x.lower()))
stopword = nltk.corpus.stopwords.words('english')
df['clean'] = df['clean'].apply(lambda x: remove_stopwords(x))
ps = nltk.PorterStemmer()
df['clean'] = df['clean'].apply(lambda x: stemming(x))
df['clean'] = df['clean'].apply(lambda x: remove_small_tokens(x))
#df['clean'][0]
#type(df['clean'][0])
df['cleaned'] = df['clean'].apply(lambda x: ', '.join(map(str, x)))
df['cleaned'] = df['cleaned'].str.replace(',', '')
df['cleaned'][0]

full['clean'][0]
full['clean'] = full['clean'].apply(lambda x: remove_punct(x))
full['clean'] = full['clean'].apply(lambda x: tokenization(x.lower()))
full['clean'] = full['clean'].apply(lambda x: remove_stopwords(x))
full['clean'] = full['clean'].apply(lambda x: stemming(x))
full['clean'] = full['clean'].apply(lambda x: remove_small_tokens(x))
#df['clean'][0]
#type(df['clean'][0])
full['clean'] = full['clean'].apply(lambda x: ', '.join(map(str, x)))
full['clean'] = full['clean'].str.replace(',', '')
full['clean']

# Label political documents
political_dict = ['republican', 'democrat', 'congress', 'senate', 'gop', 'dem', 
                 'mcconel', 'schumer', 'trumpcar', 'lawmak', 'senat', 'legisl', 
                 'obama', 'racist', 'constitut', 'immigr', 'dreamer', 'daca', 
                 'deport', 'muslim', 'racism', 'lgbtq', 'transgend', 'activist',
                 'freedom', 'constitut', 'antilgbtq', 'liberti', 'civil', 
                 'anticivil','bigotri', 'judici', 'nomine', 'gorusch', 'clinton', 
                 'kennedi', 'feder','protest', 'pelosi','policymak', 'bipartisan',
                 'bipartisanship','congress', 'legisl', 'medicaid', 'medicar', 
                 'aca', 'democraci', 'lgbt', 'lgbtq', 'filibust', 'capitol',
                 'antiimigr','obamacar','migrant', 'refuge','asylum',
                 'salvadoran', 'elsalvador', 'detent', 'deport', 'incarcer',
                 'detain','border', 'discriminatori', 'antiabort', 'welfar', 
                 'grassley','politician', 'aclu', 'partisan', 'delegitim',
                 'transgend', 'unborn', 'abort', 'kamala', 'vote', 'ballot', 
                 'voter','abort', 'prolif', 'environ','ideolog', 
                 'kavanaugh','unconstitut', 'ideologu', 'proabort','antiabort',
                 'legislatur', 'homosexual', 'president', 'abortion']

df['is_political'] = df.apply(search_func, axis=1)
df['is_political'].value_counts() # 256 instances of political speech


### DV imbalance
df['ground_truth_pol'] = df['is_political']
df['ground_truth_pol'].value_counts() # 256 instances of political speech

# Train-test split
train_x, valid_x, train_y, valid_y = model_selection.train_test_split(df['cleaned'], df['ground_truth_pol'], test_size=0.3, random_state=24519)

###### Implement SVM - linear
vectorizer = TfidfVectorizer(max_features=10000, max_df = 0.8, min_df = 3, ngram_range=(1, 2))
vectorizer.fit(df['cleaned'])
#vectorizer.fit(full['cleaned'])
xtrain_tfidf = vectorizer.fit_transform(train_x)
xtrain_tfidf = xtrain_tfidf.toarray()

model = svm.SVC(kernel='linear', probability = True)

a=model.fit(xtrain_tfidf, train_y)
model.score(xtrain_tfidf, train_y)

feature_names = vectorizer.get_feature_names() 
coefs_with_fns = sorted(zip(model.coef_[0], feature_names)) 

y=pd.DataFrame(coefs_with_fns)
y.columns='coefficient','word'
y.sort_values(by='coefficient')
y

### Extract top coefficients
coef = np.ravel(model.coef_[0]) #.to_dense
top_positive_coefficients = np.argsort(coef)[-20:]
top_negative_coefficients = np.argsort(coef)[:20]
top_coefficients = np.hstack([top_negative_coefficients, top_positive_coefficients])

import matplotlib.pyplot as plt
top_features=20
xyz = vectorizer.get_feature_names()
plt.figure(figsize=([15, 12]))
#plt.figure()
colors = ['red' if c < 0 else 'blue' for c in coef[top_coefficients]]
plt.bar(np.arange(2 * top_features), coef[top_coefficients], color=colors)
feature_names = np.array(xyz)
plt.xticks(np.arange(1, 1 + 2 * top_features), feature_names[top_coefficients], rotation=60, ha='right')
plt.tick_params(axis='x', labelsize=18)
#plt.show()
plt.savefig('top_political_words_rd1.png')


# Evaluate model
xvalid_tfidf = vectorizer.transform(valid_x)
xvalid_tfidf = xvalid_tfidf.toarray()

print(xtrain_tfidf.shape)
print(xvalid_tfidf.shape)

model = svm.SVC(kernel='linear', probability = True)
model.fit(xtrain_tfidf, train_y) # Class weight, coef0, degree?

# predict the labels on validation dataset
predictions = model.predict(xvalid_tfidf)

print(metrics.accuracy_score(predictions, valid_y))
print(metrics.recall_score(predictions, valid_y))
print(metrics.precision_score(predictions, valid_y))
print(metrics.f1_score(predictions, valid_y))


# Run on full dataset, extract probabilities