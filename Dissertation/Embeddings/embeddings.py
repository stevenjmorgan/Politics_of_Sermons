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
import sklearn
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
from nltk.stem import *
from nltk.stem import PorterStemmer
from nltk.tokenize import word_tokenize

def stem_sentences(sentence):
    tokens = sentence.split()
    stemmed_tokens = [ps.stem(token) for token in tokens]
    return ' '.join(stemmed_tokens)

def display_closestwords_tsnescatterplot(model, word):
     
    arr = np.empty((0,100), dtype='f')
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
    plt.savefig(word+'.png')
    plt.show()
  
# Ignore warnings, set directory   
warnings.filterwarnings(action = 'ignore')
os.chdir('C:/Users/sum410/Dropbox/Dissertation/Data/')
#os.chdir('C:/Users/steve/Dropbox/Dissertation/Data/')

# Read in data
print('Reading in data...')
file_encoding = 'utf8'        # set file_encoding to the file encoding (utf8, latin1, etc.)
input_fd = open('sermons_pastor_names_7-24-19.csv', encoding=file_encoding, errors = 'backslashreplace')
serms = pd.read_csv(input_fd, encoding="utf-8")
serms = serms.drop("Unnamed: 0", axis=1)


#mylist = []
#for chunk in pd.read_csv('sermon_dataset5-27.csv', chunksize=20000, index_col=False):
#    mylist.append(chunk)
#serms = pd.concat(mylist, axis= 0)
#serms = serms.drop("Unnamed: 0", axis=1)
#del(mylist,chunk)
#ex = serms['sermon'][0]

# Clean text data
print('Cleaning data...')
serms['clean'] = serms['clean'].str.replace('[^a-zA-Z]',' ').str.lower()
stop_re = '\\b'+'\\b|\\b'.join(nltk.corpus.stopwords.words('english'))+'\\b'
serms['clean'] = serms['clean'].str.replace(stop_re, '')
 
# Porter stem tokens
ps = PorterStemmer()
serms['clean'] = serms['clean'].apply(stem_sentences)



# Detect common phrases so that we may treat each one as its own word
#print('Detecting phrases...')
phrases = gensim.models.phrases.Phrases(serms['clean'].tolist())
phraser = gensim.models.phrases.Phraser(phrases)
train_phrased = phraser[serms['clean'].tolist()]
 
multiprocessing.cpu_count()
 
# Run w2v w/ default parameters
print('Running w2v!')
w2v = gensim.models.word2vec.Word2Vec(sentences=train_phrased,workers=8)
w2v.save('phrased_embeddings_7-26')
 
#print(w2v.most_similar('abort'))
#print(w2v.most_similar('gay'))
#print(w2v.most_similar('government'))

#print(w2v.most_similar('living'))
 
 
 
# Create CBOW model 
#model1 = gensim.models.Word2Vec(train_phrased, min_count = 5,  
#                              size = 300, window = 3) 
#model1.save('dim300_sermons')
# 
#print(model1.most_similar('abortion'))
#print(model1.most_similar('democrat'))
#print(model1.most_similar('republican'))
#print(model1.most_similar('government'))
#print(model1.most_similar('attain'))
#
#
#display_closestwords_tsnescatterplot(model1, 'abortion')
#display_closestwords_tsnescatterplot(model1, 'democrat')
#display_closestwords_tsnescatterplot(model1, 'republican')
#display_closestwords_tsnescatterplot(model1, 'government')
#display_closestwords_tsnescatterplot(model1, 'fetus')


# W/o phrases
sentences = serms['clean'].tolist()
sent = [x.split() for x in sentences]
model = Word2Vec(sent, min_count=2, size=100, window=5, workers = 8)
#model.save('unphrased_stemmed')
model.save("unphrased_stemmed_7-24.model")

#print(model.most_similar('abortion'))
print(model.most_similar('abort'))
print(model.most_similar('democrat'))
print(model.most_similar('obama'))
print(model.most_similar('gay'))
print(model.most_similar('trump'))
#print(model.most_similar('liberty'))
print(model.most_similar('liberti'))
print(model.most_similar('right'))
print(model.most_similar('amendment'))
print(model.most_similar('amend'))
print(model.most_similar('fetus'))
print(model.most_similar('unborn'))
print(model.most_similar('women'))
print(model.most_similar('suffrag'))

#display_closestwords_tsnescatterplot(model, 'abortion')

X = model[model.wv.vocab]
pca = PCA(n_components=2)
result = pca.fit_transform(X)

plt.scatter(result[:, 0], result[:, 1])


words = list(model.wv.vocab)
for i, word in enumerate(words):
	plt.annotate(word, xy=(result[i, 0], result[i, 1]))


words = list(model.wv.vocab)
for i, word in enumerate(words):
	plt.annotate(word, xy=(result[i, 0], result[i, 1]))
    
display_closestwords_tsnescatterplot(model, 'abortion')
display_closestwords_tsnescatterplot(model, 'rights')
display_closestwords_tsnescatterplot(model, 'liberties')
display_closestwords_tsnescatterplot(model, 'immigration')
display_closestwords_tsnescatterplot(model, 'gay')
display_closestwords_tsnescatterplot(model, 'homosexuality')
display_closestwords_tsnescatterplot(model, 'freedom')
display_closestwords_tsnescatterplot(model, 'religion')
display_closestwords_tsnescatterplot(model, 'muslim')
