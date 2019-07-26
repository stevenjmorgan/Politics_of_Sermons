# -*- coding: utf-8 -*-
"""
Created on Fri Jul 26 15:24:39 2019

@author: steve
"""

import pandas as pd
from ethnicolr import census_ln, pred_census_ln

names = [{'name': 'smith'}, {'name': 'zhang'},{'name': 'jackson'}]

df = pd.DataFrame(names)

#census_ln(df, 'name')
#census_ln(df, 'name', 2010)
pred_ethn = pred_census_ln(df, 'name')
pred_ethn.to_csv('sermon_dataset7-22.csv')

