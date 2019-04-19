# -*- coding: utf-8 -*-
"""
Created on Thu Apr 18 17:13:13 2019

@author: steve
"""

import os
import pandas as pd

os.chdir('C:/Users/steve/Dropbox/PoliticsOfSermons')

url_i_frames = 'https://simple.wikipedia.org/wiki/List_of_U.S._states_by_population'
meetings_df = pd.DataFrame()

table = pd.read_html(url_i_frames, header=0, index_col = False)[0]
table.columns
table = table.iloc[:, [2, 3]]
table = table.iloc[0:51,:]


table.to_csv('state_pop.csv', index=False)
