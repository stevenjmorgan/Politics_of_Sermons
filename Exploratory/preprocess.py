# -*- coding: utf-8 -*-
"""
Cleans multiple documents of sermon corpus
Created on Wed Sep 26 13:22:46 2018
@author: sum410
"""

import os
import glob
import string
import nltk
#nltk.download()
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem.porter import PorterStemmer
import re
import pickle
import sys

os.chdir('C:/Users/sum410/Dropbox/PoliticsOfSermons/Data/SampleLDA')

# Empty list and read in files as elements again
# Read in sample sermon data
file_list = glob.glob(os.path.join(os.getcwd(),
    "C:/Users/sum410/Dropbox/PoliticsOfSermons/Data/MasterList", "*.txt"))
sample_serms = []
for file_path in file_list: #[0:25000]
    with open(file_path, encoding="utf8") as f_input:
        sample_serms.append(f_input.read()) # 3 sermons in list

# Apply word_tokenize to each element of the list called incoming_reports
tokenized_serms = [word_tokenize(doc) for doc in sample_serms]

## Remove punctuation
regex = re.compile('[%s]' % re.escape(string.punctuation))
tokenized_serms_no_punctuation = []

for serm in tokenized_serms:
    new_serm = []
    for token in serm: 
        new_token = regex.sub(u'', token)
        if not new_token == u'':
            new_serm.append(new_token)
    
    tokenized_serms_no_punctuation.append(new_serm)

print(len(tokenized_serms_no_punctuation))
#sys.exit(0)
    
## Remove stop words
tokenized_serms_no_stopwords = []
for serm in tokenized_serms_no_punctuation:
    new_term_vector = []
    for word in serm:
        if not word in stopwords.words('english'):
            new_term_vector.append(word)
    tokenized_serms_no_stopwords.append(new_term_vector)
            
print(len(tokenized_serms_no_stopwords))

## Remove numbers
nonstemmed_docs = []
for serm in tokenized_serms_no_stopwords:
    no_num_vector = []
    for word in serm:
        word = ''.join([i for i in word if not i.isdigit()])
        if word != '':
            no_num_vector.append(word)
    nonstemmed_docs.append(no_num_vector)
            
#nonstemmed_docs = list(filter(None, nonstemmed_docs))
print(len(nonstemmed_docs))

## Stem words
porter = PorterStemmer()
stemmed_docs = []
for doc in nonstemmed_docs:
    final_doc = []
    for word in doc:
        final_doc.append(porter.stem(word))
    stemmed_docs.append(final_doc)
    
print(len(stemmed_docs))

# Delete intermediate lists

del tokenized_serms_no_punctuation, tokenized_serms_no_stopwords

# Save stemmed and non-stemmed docs 
with open('saved_preprocess.pkl', 'wb') as f:  
    pickle.dump([nonstemmed_docs, stemmed_docs], f)

'''
# Open back up the objects:
with open('saved_preprocess.pkl', 'rb') as f:  
    nonstemmed_docs, stemmed_docs = pickle.load(f)
'''
