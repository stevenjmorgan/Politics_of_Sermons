# -*- coding: utf-8 -*-
"""
Created on Tue Sep  3 18:48:11 2019

@author: steve
"""

import pandas as pd
import os

#os.chdir('C:/Users/steve/Dropbox/Dissertation/Data/handcode')
os.chdir('C:/Users/SF515-51T/Desktop/Dissertation')

handcode = pd.read_csv('hand_code_sample_10-15.csv')
handcode['clean'][0]

#os.chdir('C:/Users/steve/Dropbox/Dissertation/Data/handcode/sermons_handcode')
os.chdir('C:/Users/SF515-51T/Desktop/Dissertation/handcode')

for i in range(0,500):
	file = 'hc_sermon' + str(i+1) + ".txt"

	textFile = open(file, 'w')
	textFile.write(handcode['clean'][i])
	textFile.close()
    
hc = handcode[['handcode_id', 'clean','fair_thresh', 'fair']]
hc.to_csv('sermons_to_be_coded.csv')