# -*- coding: utf-8 -*-
"""
Created on Fri Jul 26 15:24:39 2019

@author: steve
"""

import pandas as pd
from ethnicolr import census_ln, pred_census_ln
import os
import string

rem = string.punctuation
pattern = r"[{}]".format(rem)

os.chdir('C:/Users/steve/Dropbox/Dissertation/Data')

# Read in data
serm_data = pd.read_csv('sermons_pastor_names_7-24-19.csv', index_col = False,
                         encoding = 'latin-1')

#names = [{'name': 'smith'}, {'name': 'zhang'},{'name': 'jackson'}]

# Extract last name of each pastor
serm_data['author_cleaned'] = serm_data['author'].str.replace(pattern,' ')
serm_data['author_cleaned'] = serm_data['author_cleaned'].str.strip()
serm_data['author_cleaned'] = serm_data['author_cleaned'].str.replace(r' Sr',r'')
serm_data['author_cleaned'] = serm_data['author_cleaned'].str.replace(r' Jr\.',r'')
serm_data['author_cleaned'] = serm_data['author_cleaned'].str.replace(r' Jr',r'')
serm_data['author_cleaned'] = serm_data['author_cleaned'].str.replace(r' Jr',r'')
serm_data['last_name'] = serm_data['author_cleaned'].str.extract(r'\b(\w+)$', expand=True)
serm_data.columns

#df = pd.DataFrame(serm_data['last_name'])
#len(df.last_name.unique())
#df = df.drop_duplicates()
#df.shape

#census_ln(df, 'name')
#census_ln(df, 'name', 2010)
pred_ethn = pred_census_ln(serm_data, 'last_name')
pred_ethn.to_csv('pastor_ethnicity_census_7-26.csv')
pred_ethn.columns
