# -*- coding: utf-8 -*-
"""
Created on Fri May 31 10:32:56 2019

@author: sum410
"""

import os
import pandas as pd
import warnings, gensim, nltk, multiprocessing
from nltk.tokenize import sent_tokenize, word_tokenize
from gensim.models import Word2Vec
from sklearn.manifold import TSNE
import matplotlib.pyplot as plt
import numpy as np


def display_closestwords_tsnescatterplot(model, word):
     
    arr = np.empty((0,300), dtype='f')
    word_labels = [word]
 
    # get close words
    close_words = model.similar_by_word(word)
     
    # add the vector for each of the closest words to the array
    arr = np.append(arr, np.array([model[word]]), axis=0)
    for wrd_score in close_words:
        wrd_vector = model[wrd_score[0]]
        word_labels.append(wrd_score[0])
        arr = np.append(arr, np.array([wrd_vector]), axis=0)
         
    # find tsne coords for 2 dimensions
    tsne = TSNE(n_components=2, random_state=0)
    np.set_printoptions(suppress=True)
    Y = tsne.fit_transform(arr)
 
    x_coords = Y[:, 0]
    y_coords = Y[:, 1]
    # display scatter plot
    plt.scatter(x_coords, y_coords)
 
    for label, x, y in zip(word_labels, x_coords, y_coords):
        plt.annotate(label, xy=(x, y), xytext=(0, 0), textcoords='offset points')
    plt.xlim(x_coords.min()-50, x_coords.max()+50)
    plt.ylim(y_coords.min()-50, y_coords.max()+50)
    plt.show()
  
# Ignore warnings, set directory   
warnings.filterwarnings(action = 'ignore')
os.chdir('C:/Users/sum410/Dropbox/Dissertation/Data/')

# Read in data
serms = pd.read_csv('sermon_dataset5-27.csv')
#ex = serms['sermon'][0]

# Clean text data
serms['sermon'] = serms['sermon'].str.replace('[^a-zA-Z]',' ').str.lower()
stop_re = '\\b'+'\\b|\\b'.join(nltk.corpus.stopwords.words('english'))+'\\b'
serms['sermon'] = serms['sermon'].str.replace(stop_re, '')
 
# Detect common phrases so that we may treat each one as its own word
phrases = gensim.models.phrases.Phrases(serms['sermon'].tolist())
phraser = gensim.models.phrases.Phraser(phrases)
train_phrased = phraser[serms['sermon'].tolist()]
 
multiprocessing.cpu_count()
 
# Run w2v w/ default parameters
w2v = gensim.models.word2vec.Word2Vec(sentences=train_phrased,workers=4)
w2v.save('w2v_v1')
 
w2v.most_similar('abortion')
w2v.most_similar('gay')
w2v.most_similar('government')
 
 
 
# Create CBOW model 
model1 = gensim.models.Word2Vec(train_phrased, min_count = 10,  
                              size = 300, window = 3) 
model1.save('dim300')
 
model1.most_similar('treaty')
model1.most_similar('legal')
model1.most_similar('violence')
 
 

     
     
 
display_closestwords_tsnescatterplot(model1, 'violence')
display_closestwords_tsnescatterplot(model1, 'legal')
display_closestwords_tsnescatterplot(model1, 'democracy')
display_closestwords_tsnescatterplot(model1, 'security')
