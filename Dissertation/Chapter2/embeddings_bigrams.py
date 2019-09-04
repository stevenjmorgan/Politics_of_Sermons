# -*- coding: utf-8 -*-
"""
Created on Wed Sep  4 09:27:48 2019

@author: steve
"""

from gensim.models import Phrases
from gensim.models.phrases import Phraser
import pandas as pd
import warnings, os, string, nltk, re


documents = ["the mayor of new york was there", "machine learning can be useful sometimes","new york mayor was present"]

sentence_stream = [doc.split(" ") for doc in documents]
print(sentence_stream)

bigram = Phrases(sentence_stream, min_count=1, threshold=2, delimiter=b' ')
bigram_phraser = Phraser(bigram)

print(bigram_phraser)

for sent in sentence_stream:
    tokens_ = bigram_phraser[sent]

    print(tokens_)
    
    
###############################################################################

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

# Ignore warnings, set directory   
warnings.filterwarnings(action = 'ignore')
os.chdir('C:/Users/steve/Dropbox/Dissertation/Data/')

# Read in data
print('Reading in data...')
file_encoding = 'utf8'        # set file_encoding to the file encoding (utf8, latin1, etc.)
input_fd = open('sermons_pastor_names_7-24-19.csv', encoding=file_encoding, errors = 'backslashreplace')
serms = pd.read_csv(input_fd, encoding="utf-8")
serms = serms.drop("Unnamed: 0", axis=1)


# Subset first 10 doc's
smp = serms.head(10)
smp.columns
smp = smp[['clean']]
smp['clean'][0]



# Remove NaN, clean text
df = smp.dropna(subset=['clean'])
df['original_text'] = df['clean']
df['clean'] = df['clean'].apply(lambda x: remove_punct(x))
df['clean'] = df['clean'].apply(lambda x: tokenization(x.lower()))
stopword = nltk.corpus.stopwords.words('english')
stopword = [x for x in stopword if x != 'she']
stopword = [x for x in stopword if x != 'he']
stopword = [x for x in stopword if x != 'her']
stopword = [x for x in stopword if x != 'him']
stopword = [x for x in stopword if x != 'hers']
stopword = [x for x in stopword if x != 'his']
stopword = [x for x in stopword if x != 'herself']
stopword = [x for x in stopword if x != 'himself']
stopword = [x for x in stopword if x != 'hers']
stopword = [x for x in stopword if x != "she's"]
stopword = [remove_punct(x) for x in stopword]
df['clean'] = df['clean'].apply(lambda x: remove_stopwords(x))
ps = nltk.PorterStemmer()
df['clean'] = df['clean'].apply(lambda x: stemming(x))

df['clean'][0]

bigram = Phrases(sentence_stream, min_count=1, threshold=2, delimiter=b' ')
bigram_phraser = Phraser(bigram)

for doc in df['clean']:
    tokens_ = bigram_phraser[doc]

    print([x for x in tokens_ if re.search(' ', x)])