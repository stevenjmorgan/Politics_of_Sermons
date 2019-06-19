# -*- coding: utf-8 -*-
"""
Created on Tue Jun 18 19:01:48 2019

@author: steve
"""

import os
import pandas as pd
import warnings
import spacy
from spacy import displacy
from collections import Counter
import en_core_web_sm

warnings.filterwarnings(action = 'ignore')

os.chdir(r'C:\Users\steve\Dropbox\Dissertation\Data')

nlp = en_core_web_sm.load()

file_encoding = 'utf8'        # set file_encoding to the file encoding (utf8, latin1, etc.)
input_fd = open('us_sermons.csv', encoding=file_encoding, errors = 'backslashreplace')
serms = pd.read_csv(input_fd, encoding="utf-8")
serms = serms.drop("Unnamed: 0", axis=1)



# Example
doc = nlp('European authorities fined Google a record $5.1 billion on Wednesday for abusing its power in the mobile phone market and ordered the company to alter its practices')
type([(X.text, X.label_) for X in doc.ents]) #list
type([(X.text, X.label_) for X in doc.ents][0]) #tuple
type([(X.text, X.label_) for X in doc.ents][0][0]) #string
print([(X.text, X.label_) for X in doc.ents])

print([(X, X.ent_iob_, X.ent_type_) for X in doc])

from bs4 import BeautifulSoup
import requests
import re
def url_to_string(url):
    res = requests.get(url)
    html = res.text
    soup = BeautifulSoup(html, 'html5lib')
    for script in soup(["script", "style", 'aside']):
        script.extract()
    return " ".join(re.split(r'[\n\t]+', soup.get_text()))
ny_bb = url_to_string('https://www.nytimes.com/2018/08/13/us/politics/peter-strzok-fired-fbi.html?hp&action=click&pgtype=Homepage&clickSource=story-heading&module=first-column-region&region=top-news&WT.nav=top-news')
article = nlp(ny_bb)
len(article.ents)

labels = [x.label_ for x in article.ents]
Counter(labels)

items = [x.text for x in article.ents]
Counter(items).most_common(3)



### NLTK version w/ Stanford NLP
from nltk.tag.stanford import CoreNLPNERTagger

import nltk
import nltk.tag
import nltk.tag.stanford
from nltk.tag.stanford import NERTagger
java_path = r"C:\Program Files (x86)\Common Files\Oracle\Java\javapath\java.exe"
os.environ['JAVAHOME'] = java_path
st = NERTagger(r'C:\Users\steve\OneDrive\Desktop\stanford-ner-2018-10-16\classifiers\english.all.3class.distsim.crf.ser.gz', r'C:\Users\steve\OneDrive\Desktop\stanford-ner-2018-10-16\stanford-ner.jar')


from nltk.tag.stanford import StanfordNERTagger
st = StanfordNERTaggger(r'C:\Users\steve\OneDrive\Desktop\stanford-ner-2018-10-16\classifiers\english.all.3class.distsim.crf.ser.gz',r'C:\Users\steve\OneDrive\Desktop\stanford-ner-2018-10-16\stanford-ner.jar')
st.tag('Rami Eid is studying at Stony Brook University in NY'.split())


def get_continuous_chunks(tagged_sent):
    continuous_chunk = []
    current_chunk = []

    for token, tag in tagged_sent:
        if tag != "O":
            current_chunk.append((token, tag))
        else:
            if current_chunk: # if the current chunk is not empty
                continuous_chunk.append(current_chunk)
                current_chunk = []
    # Flush the final current_chunk into the continuous_chunk, if any.
    if current_chunk:
        continuous_chunk.append(current_chunk)
    return continuous_chunk


stner = CoreNLPNERTagger()
tagged_sent = stner.tag('Rami Eid is studying at Stony Brook University in NY'.split())

named_entities = get_continuous_chunks(tagged_sent)
named_entities_str_tag = [(" ".join([token for token, tag in ne]), ne[0][1]) for ne in named_entities]


print(named_entities_str_tag)



### Continuous names
def get_continuous_chunks(tagged_sent):
    continuous_chunk = []
    current_chunk = []

    for token, tag in tagged_sent:
        if tag != "O":
            current_chunk.append((token, tag))
        else:
            if current_chunk: # if the current chunk is not empty
                continuous_chunk.append(current_chunk)
                current_chunk = []
    # Flush the final current_chunk into the continuous_chunk, if any.
    if current_chunk:
        continuous_chunk.append(current_chunk)
    return continuous_chunk

ne_tagged_sent = [('Rami', 'PERSON'), ('Eid', 'PERSON'), ('is', 'O'), ('studying', 'O'), ('at', 'O'), ('Stony', 'ORGANIZATION'), ('Brook', 'ORGANIZATION'), ('University', 'ORGANIZATION'), ('in', 'O'), ('NY', 'LOCATION')]

named_entities = get_continuous_chunks(ne_tagged_sent)
named_entities = get_continuous_chunks(ne_tagged_sent)
named_entities_str = [" ".join([token for token, tag in ne]) for ne in named_entities]
named_entities_str_tag = [(" ".join([token for token, tag in ne]), ne[0][1]) for ne in named_entities]

print(named_entities)
print(named_entities_str)
print(named_entities_str_tag)
