# -*- coding: utf-8 -*-
"""
Created on Mon Jul 15 14:59:05 2019

@author: sum410
"""

import requests, json, os
import pandas as pd

def getGenders(names):
	url = ""
	cnt = 0
	if not isinstance(names,list):
		names = [names,]
	
	for name in names:
		if url == "":
			url = "name[0]=" + name
		else:
			cnt += 1
			url = url + "&name[" + str(cnt) + "]=" + name
		

	req = requests.get("https://api.genderize.io?" + url)
	results = json.loads(req.text)
	
	retrn = []
	for result in results:
		if result["gender"] is not None:
			retrn.append((result["gender"], result["probability"], result["count"]))
		else:
			retrn.append((u'None',u'0.0',0.0))
	return retrn

if __name__ == '__main__':
	print(getGenders(["Brian","Apple","Jessica","Zaeem","NotAName"]))
    

#os.chdir("C:/Users/sum410/Dropbox/Dissertation/Data")
os.chdir("C:/Users/steve/Dropbox/Dissertation/Data")

# Read in data
sermons = pd.read_csv('us_sermons_7-15-19.csv', encoding = "ISO-8859-1")
sermons['first.name'][1000]

unique_first_names = sermons['first.name'].unique()

#print(getGenders('Alan'))
#name = 'Alan'
#names = getGenders(name)
#names_list = [x for t in names for x in t]
#names_list.insert(0, name)



#{"name":"kim","gender":"female","probability":"0.90","count":687}

# Name-gender dataframe
name_gen_df = pd.DataFrame(columns = ['Name', 'Gender', 'Probability', 'Count'])
for i in range(0, len(unique_first_names)):
    
    #print(i)
    #print(unique_first_names[i])
    
    try:
        results = getGenders(unique_first_names[i])
        names_list = [x for t in results for x in t]
        names_list.insert(0, unique_first_names[i])
        
        s = pd.Series(names_list, index=name_gen_df.columns)
        name_gen_df = name_gen_df.append(s, ignore_index=True) 

    except:
        names_list = ['','','','']
        name_gen_df = name_gen_df.append(pd.Series(names_list, index=name_gen_df.columns), ignore_index=True) 
        pass

for i in range(996, len(unique_first_names)):
    
    #print(i)
    #print(unique_first_names[i])
    
    try:
        results = getGenders(unique_first_names[i])
        names_list = [x for t in results for x in t]
        names_list.insert(0, unique_first_names[i])
        
        s = pd.Series(names_list, index=name_gen_df.columns)
        name_gen_df = name_gen_df.append(s, ignore_index=True) 

    except:
        names_list = ['','','','']
        name_gen_df = name_gen_df.append(pd.Series(names_list, index=name_gen_df.columns), ignore_index=True) 
        pass
    
name_gen_df.to_csv('first_name_gender.csv')