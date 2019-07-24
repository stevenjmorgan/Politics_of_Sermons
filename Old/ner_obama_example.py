# -*- coding: utf-8 -*-
"""
Created on Mon Jul  8 13:47:19 2019

@author: sum410
"""

import nltk
from nltk.tag import StanfordNERTagger
from nltk.tokenize import word_tokenize
from nltk.tag import pos_tag
import os
import re
import pandas as pd

def preprocess(sent):
    sent = nltk.word_tokenize(sent)
    sent = nltk.pos_tag(sent)
    return sent


java_path = "C:/Program Files/Java/jre1.8.0_181/bin/java.exe"
os.environ['JAVAHOME'] = java_path

st = StanfordNERTagger('C:/Users/sum410/Dropbox/stanford-ner-2018-10-16/classifiers/english.all.3class.distsim.crf.ser.gz',
					   'C:/Users/sum410/Dropbox/stanford-ner-2018-10-16/stanford-ner.jar',
					   encoding='utf-8')

text = 'While in France, Christine Lagarde discussed short-term stimulus efforts in a recent interview with the Wall Street Journal.'

tokenized_text = word_tokenize(text)
classified_text = st.tag(tokenized_text)

print(classified_text)

ex = 'European authorities fined Google a record $5.1 billion on Wednesday for abusing its power in the mobile phone market and ordered the company to alter its practices'
sent = preprocess(ex)
sent

pattern = 'NP: {<DT>?<JJ>*<NN>}'
cp = nltk.RegexpParser(pattern)
cs = cp.parse(sent)
print(cs)


obama_serm = r'C:\Users\sum410\Dropbox\Dissertation\Data\sermons\reverse_scraper\Sermon_20000099600.txt'
with open(obama_serm, 'r', encoding="utf8") as file:
    data = file.read()

tokenized_text = word_tokenize(data)
classified_text = st.tag(tokenized_text)

another_obama = r'C:\Users\sum410\Dropbox\Dissertation\Data\sermons\reverse_scraper\Sermon_20000096442.txt'
with open(another_obama, 'r', encoding="utf8") as file:
    data = file.read()

tokenized_text = word_tokenize(data)
classified_text = st.tag(tokenized_text)

people = [x[0] for x in classified_text if x[1] == 'PERSON']
people = ', '.join(people)


### Read in sermon dataset
file_encoding = 'utf8'        # set file_encoding to the file encoding (utf8, latin1, etc.)
input_fd = open(r'C:\Users\sum410\Dropbox\Dissertation\Data\us_sermons.csv', encoding=file_encoding, errors = 'backslashreplace')
serms = pd.read_csv(input_fd, encoding="utf-8")
serms = serms.drop("Unnamed: 0", axis=1)

    
serms['people_entities'][0]
serms['people_entities'][1]
serms['people_entities'][2]
serms['people_entities'][100000]

# Create list of names
dfToList = serms['people_entities'].tolist()
type(dfToList[0])

my_list = dfToList[0].split(", ")
my_list
list(set(my_list))

serms.to_csv('sermons_ner.csv')



# Find all unique names
unique_names = list()
for i in range(0, len(dfToList)):
    
    serm_name_list = dfToList[i].split(', ')
    names = list(set(serm_name_list))
    
    for j in range(0, len(names)):
        unique_names.append(names[j])
    
len(unique_names)
unique_names = list(set(unique_names))
len(unique_names)
unique_names

unique_names = [x for x in unique_names if not re.search('[0-9]', x)]
len(unique_names)

with open('ner_results.txt', 'w', encoding="utf-8") as f:
    for item in unique_names:
        f.write("%s\n" % item)
f.close()
