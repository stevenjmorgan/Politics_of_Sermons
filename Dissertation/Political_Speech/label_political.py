# -*- coding: utf-8 -*-
"""
Created on Wed Jul 31 16:58:46 2019

@author: steve
"""

import os, re, string, nltk
import pandas as pd

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
               for test_value in row["clean"]]

    if any(matches):
        return "Yes"
    else:
        return "No"
    
def count_func(row):
    matches = [test_value in political_dict 
               for test_value in row["clean"]]

    #print(len(matches))
    #print(type(matches))
    
    matches = [x for x in matches if x == True]
    #print(len(matches))
    return len(matches)

#    if any(matches):
#        
#        return len(matches)
#    else:
#        return 0


os.chdir(r'C:\Users\steve\Desktop\sermon_dataset')

serms = pd.read_csv('sermons_dataset_7-31.csv')

### Create list of political terms, find nearest neighbors from embeddings
political_dict = ['republican', 'democrat', 'congress',
                  'senate', 'gop', 'dem', 
                  'mcconel', 'schumer' 'speakerryan', 'trumpcar', 
                  'lawmak', 'senat', 
                  'legisl', 'dreamer',
                  'obama', 'racist',
                  'penc', 'constitut', 'potu', 'earmark',
                  'immigr', 'dreamer', 'daca', 'deport',
                  'muslim', 'racism', 'lgbtq',
                  'transgend', 'activist', 'freedom', 
                  'constitut', 'antilgbtq', 'racist', 
                  'liberti', 'civil', 'anticivil', 
                  'bigotri', 
                  'scotu', 'court', 'judici', 'nomine', 'gorusch',
                  'antilgbtq', 'clinton',
                  'penc', 'kennedi', 
                  'presidentelect', 'feder',
                  'protest', 'pelosi',
                  'policymak', 
                  'bipartisan', 'guncontrol', 'bipartisanship',
                  'congress',
                  'dreamact', 'legisl', 'medicaid', 'medicar', 
                  'aca', 'democraci', 'lgbt', #'inclus', 
                  'lgbtq', 
                  'genderequ',  #overturn
                  'filibust', 
                  'capitol',
                  'shutdown', #'swamp', 'senategop', #'advocaci', 'advoc',
                  'antiimigr',
                  'obamacar', #'mandat', 'affordablecareact', 'subsidi',
                  'repeal', #'repealandreplace', 'bailout', 'unlaw', 'penalti',
                  'taxbil', 'migrant', 'sanctuaryc', 'refuge', #'muslim', 
                  'asylum', 'salvadoran', 'elsalvador', 'detent', 'deport', 'incarcer',
                  'humanright', 'detain',# 'orlandoshoot', 'detain', 'arrest', 'jail',
                  'border',
                  'coal', 'discriminatori', 'antiabort', 'welfar', 'grassley',
                  'politician', #'sportsbet', 'govwast', 'antiunion', 'scotusblog',
                  #'stopillegalgambl', 'violat', 'hhsgov', 'doj', 'admin',
                  'aclu', 'partisan', 'constitut', 'govt', 'delegitim',
                  'transgend', 'unborn', 'abort', 'kamala',
                  'vote', 'ballot', 'voter', 'elect',
                  'abort', 'prolif', #'whatsprolifeabout','entitl', 'amend', 
                  'climatechang', 'environ','ideolog',# 'dissent', 'environment',  
                  'kavanaugh', 'singlepay', 
                  'unconstitut', 'ideologu', 'proabort', 'farmbil', 'antiabort',
                  'legislatur', #'ryanwhit', 'medicareforal', 
                  'nafta']


# Remove NaN, clean text
df = serms.dropna(subset=['clean'])
df['original_text'] = df['clean']
df['clean'] = df['clean'].apply(lambda x: remove_punct(x))
df['clean'] = df['clean'].apply(lambda x: tokenization(x.lower()))
stopword = nltk.corpus.stopwords.words('english')
df['clean'] = df['clean'].apply(lambda x: remove_stopwords(x))
ps = nltk.PorterStemmer()
df['clean'] = df['clean'].apply(lambda x: stemming(x))

### Match list of semantically related terms against tweets to determine if political
#df['is_political'] = df.apply(search_func, axis=1)

#df.to_csv('sermons_pol_variable7-31.csv')

df['pol_count'] = df.apply(count_func, axis=1)
df.to_csv('sermons_pol_variable7-31.csv',index_label = False)

#y = df.loc[0:30]
#y['clean'] = y['clean'].apply(lambda x: remove_punct(x))
#y['clean'] = y['clean'].apply(lambda x: tokenization(x.lower()))
#stopword = nltk.corpus.stopwords.words('english')
#y['clean'] = y['clean'].apply(lambda x: remove_stopwords(x))
#ps = nltk.PorterStemmer()
#y['clean'] = y['clean'].apply(lambda x: stemming(x))
#
#y['try_this'] = y.apply(count_func, axis=1)
