# This code runs a series of LDA models varying the number of topics returned.
# Models are saved and topics are evaluated for prevalence of political content.

from nltk.stem import PorterStemmer
from nltk.tokenize import sent_tokenize, word_tokenize
import nltk
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

reload(sys)
#sys.setdefaultencoding('utf8') #Does not matter for python3

os.chdir('C:/Users/sum410/Dropbox/PoliticsOfSermons/Data/SampleLDA')

# Read in sample sermon data
file_list = glob.glob(os.path.join(os.getcwd(),
    "C:/Users/sum410/Dropbox/PoliticsOfSermons/Data/MasterList", "*.txt"))
sample_serms = []
for file_path in file_list[1:5]:
    with open(file_path, encoding="utf8") as f_input:
        sample_serms.append(f_input.read())

print(type(sample_serms[0]))

# Pre-process data
from nltk.corpus import stopwords
from nltk.stem.wordnet import WordNetLemmatizer
import string
from numpy import array

'''serms = array.empty(5)
serms['text'] = array(sample_serms)

sys.exit()

serms['wordcount'] = serms.apply(lambda x: len(str(x).split(" ")))'''


'''
stop = set(stopwords.words('english'))
exclude = set(string.punctuation)
lemma = WordNetLemmatizer()
def clean(doc):
    stop_free = " ".join([i for i in doc.lower().split() if i not in stop])
    punc_free = ''.join(ch for ch in stop_free if ch not in exclude)
    num_free = ''.join([j for j in punc_free if not j.isdigit()])
    no_small = ''.join([w for w in num_free if len(w)>2])
    normalized = " ".join(lemma.lemmatize(word) for word in no_small.split())
    #no_small = ' '.join([w for w in normalized if len(w)>3])
    #no_small = [w for w in normalized if len(w) < 3]
    return normalized

doc_clean = [clean(doc).split() for doc in sample_serms]
#print type(sample_serms[1])
print(doc_clean)
'''

#sample_serms = [preprocessing(x) for x in sample_serms]

#sys.exit()


# Converting list of documents (corpus) into Document Term Matrix using dictionary prepared above.
dictionary = corpora.Dictionary(doc_clean)
doc_term_matrix = [dictionary.doc2bow(doc) for doc in doc_clean]

Lda = gensim.models.ldamodel.LdaModel
ldamodel = Lda(doc_term_matrix, num_topics=5, id2word = dictionary, passes=999)
print(ldamodel.print_topics(num_topics=5, num_words=10))

# save the model to disk
'''filename = 'finalized_model.sav'
pickle.dump(ldamodel, open(filename, 'wb'))'''

num_topics = 5
topic_words = []
for i in range(num_topics):
    tt = ldamodel.get_topic_terms(i,20)
    topic_words.append([dictionary[pair[0]] for pair in tt])

print(topic_words[0])
print(topic_words[1])
print(topic_words[2])
print(topic_words[3])
print(topic_words[4])


# Vectorize data
tf_vectorizer = CountVectorizer(max_df=0.95, min_df=2, max_features=100000, stop_words='english')
tf = tf_vectorizer.fit_transform(sample_serms)
tf_feature_names = tf_vectorizer.get_feature_names()
#print tf_feature_names[250:260]

# Set number of topics to be calculated
no_topics = 25

# Run LDA
lda = LatentDirichletAllocation(n_components=no_topics, max_iter=999, learning_method='online', learning_offset=50.,random_state=0).fit(tf)

# Display topics
def display_topics(model, feature_names, no_top_words):
    for topic_idx, topic in enumerate(model.components_):
        print("Topic %d:" % (topic_idx+1))
        print(" ".join([feature_names[i]
                        for i in topic.argsort()[:-no_top_words - 1:-1]]))

no_top_words = 10
display_topics(lda, tf_feature_names, no_top_words)
