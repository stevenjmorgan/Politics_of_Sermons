# -*- coding: utf-8 -*-
"""
Created on Fri Oct  5 09:59:49 2018

@author: sum410
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

nltk.download('stopwords')

reload(sys)

os.chdir('C:/Users/sum410/Dropbox/PoliticsOfSermons/Data/SampleLDA')

# Read in sample sermon data
file_list = glob.glob(os.path.join(os.getcwd(),
    "C:/Users/sum410/Dropbox/PoliticsOfSermons/Data/MasterList", "*.txt"))
sample_serms = []
for file_path in file_list:
    with open(file_path, encoding="utf8") as f_input:
        sample_serms.append(f_input.read())

# Clean documents
texts = []
en_stop = stopwords.words('english')
tokenizer = RegexpTokenizer(r'\w+')
p_stemmer = PorterStemmer()
for i in sample_serms:
    # clean and tokenize document string
    raw = i.lower()
    nonum = ''.join([i for i in raw if not i.isdigit()])
    nopunc = "".join(l for l in nonum if l not in string.punctuation)
    nothree = re.sub(r'\b\w{1,2}\b', '', nopunc)
    tokens = tokenizer.tokenize(nothree)
    # remove stop words from tokens
    stopped_tokens = [i for i in tokens if not i in en_stop]
    # stem tokens
    stemmed_tokens = [p_stemmer.stem(i) for i in stopped_tokens]
    # add tokens to list
    texts.append(stemmed_tokens)

# Create dtm
dictionary = corpora.Dictionary(texts)
doc_term_matrix = [dictionary.doc2bow(doc) for doc in texts]

# Run LDA and calculate perplexity and coherence
'''
Lda = gensim.models.ldamodel.LdaModel
ldamodel = Lda(doc_term_matrix, num_topics=25, id2word = dictionary)
print(ldamodel.print_topics(num_topics=25, num_words=10))
print('\nPerplexity: ', ldamodel.log_perplexity(doc_term_matrix))
coherence_model_lda = CoherenceModel(model=ldamodel, texts=texts, dictionary=dictionary, coherence='u_mass') # u_mass
print(coherence_model_lda)
coherence_model_lda.get_coherence()
coherence_lda = coherence_model_lda.get_coherence()
print(coherence_lda)
'''

### Iteratively LDA
coherence_values = []
perplex_values = []
model_list = []
Lda = gensim.models.ldamodel.LdaModel
for num_topics in range(5, 10):
    model = Lda(doc_term_matrix, num_topics=num_topics, id2word = dictionary)
    model_list.append(model)
    coherencemodel = CoherenceModel(model=model, texts=texts, dictionary=dictionary, coherence='u_mass')
    coherence_values.append(coherencemodel.get_coherence())
    #perplexmodel = ldamodel.log_perplexity(doc_term_matrix)
    perplex_values.append(model.log_perplexity(doc_term_matrix))
    temp_file = datapath("model")
    model.save(temp_file)
    
# Graph coherence and perplexity by # of topics
import matplotlib.pyplot as plt
limit=10; start=5;
x = range(5, 10)
plt.plot(x, coherence_values)
plt.xlabel("Num Topics")
plt.ylabel("Coherence score")
plt.legend(("coherence_values"), loc='best')
plt.show()

plt.plot(x, perplex_values)
plt.xlabel("Num Topics")
plt.ylabel("Perplexity score")
plt.legend(("perplexity_values"), loc='best')
plt.show()
