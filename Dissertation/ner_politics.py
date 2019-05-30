# -*- coding: utf-8 -*-
"""
Created on Thu May 30 16:39:41 2019

@author: steve
"""

import os
import pandas as pd
import nltk
from nltk.tokenize import word_tokenize
from nltk.tag import pos_tag

def preprocess(sent):
    sent = nltk.word_tokenize(sent)
    sent = nltk.pos_tag(sent)
    return sent


os.chdir('C:/Users/steve/Dropbox/Dissertation/Data/')

serms = pd.read_csv('sermon_dataset5-27.csv')

ex = serms['sermon'][0]
sent = preprocess(ex)
sent

pattern = 'NP: {<DT>?<JJ>*<NN>}'
cp = nltk.RegexpParser(pattern)
cs = cp.parse(sent)
print(cs)


## IOB tagging
from nltk.chunk import conlltags2tree, tree2conlltags
from pprint import pprint
iob_tagged = tree2conlltags(cs)
pprint(iob_tagged)


## SpaCy approach
import spacy
from spacy import displacy
from collections import Counter
import en_core_web_sm
nlp = en_core_web_sm.load()

[(X.text, X.label_) for X in nlp(ex).ents]

[(X, X.ent_iob_, X.ent_type_) for X in nlp(ex)]
labels = [x.label_ for x in nlp(ex).ents]
Counter(labels)

items = [x.text for x in  nlp(ex).ents]
Counter(items).most_common(3)