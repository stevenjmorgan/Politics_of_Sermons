# Code  writes sermon .txt files to .JSON

# Iterate through all files
# Store in dictionary
# Write to JSON

import json
import os
import pandas as pd
import re
#import time

#time.sleep(5400)

os.chdir('C:/Users/steve/Dropbox/Dissertation/Data/')
#os.chdir('C:/Users/steve/Desktop/sermons_sample/')
#os.chdir('C:/Users/sum410/Dropbox')

#dir = 'C:/Users/sum410/Dropbox/PoliticsOfSermons/Data/MasterList/'
#dir = 'C:/Users/Steve/Dropbox/PoliticsOfSermons/MasterList/'
#dir = 'C:/Users/sum410/Dropbox/serms_reverse/'
dir = 'C:/Users/steve/Dropbox/serms_reverse/'

all_txt_files = os.listdir(dir)
all_txt_files = [x for x in all_txt_files if re.search('.txt', x)]

dir2 = 'C:/Users/steve/Dropbox/serms_forward/'
reverse_files = os.listdir(dir2)
reverse_files = [x for x in reverse_files if re.search('.txt', x)]
all_txt_files = all_txt_files + reverse_files

sermon = ""
j = 0

sermDict = {}
sermDict['sermonData'] = []

print('Beginning to ingest data...')

# Write dictionary to JSON file (saved as .txt)
with open('sermon7-22-19.JSON', 'w', encoding="utf8", errors='ignore') as outfile:

# Iterate through all files
    for txt in all_txt_files:

        j += 1
        if j % 1000 == 0:
            print("Iterated through " + str(j) + " sermons.")
        
        if j < 173632:
            txt_dir = dir + txt
            
        if j >= 173632:
            txt_dir = dir2 + txt

        author = ""
        date = ""
        denom = ""
        title = ""
        sermon = ""
        contributor_link = ''

        # Open each .txt files
        with open(txt_dir, 'r', encoding="utf8", errors='ignore') as f:

            # Initialize counter
            i = 0

            for line in f:

                # Increment counter each line in each file
                i += 1

                # Store first line as value for author key
                if i == 1:
                    author = line.strip()
                    #sermDict['author'] = line.strip()
                    #sermDict['author'].append(line.strip())

                # Store second line as value for date key
                if i == 2:
                    date = line.strip()
                    #sermDict['date'] = line.strip()

                # Store third line as value for denomination key
                if i == 3:
                    denom = line.strip()
                    #sermDict['denom'] = line.strip()
                    
                # Store fourth line as value for contributor link
                if i == 4:
                    contributor_link = line.strip()
                    
                # Store sixth line as value for title key
                if i == 6:
                    title = line.strip()

                # After the seventh line, save every line as value to sermon key
                if i > 7:
                    sermon = sermon + line.strip()

        sermDict['sermonData'].append({'author':author, 'date':date, 'denom':denom, 'title':title, 'contributor_link':contributor_link, 'sermon':sermon})
        #sermDict['sermonData'].append({'author':author, 'date':date, 'denom':denom, 'title':title, 'sermon':sermon})

    json.dump(sermDict, outfile, ensure_ascii=False) #encoding="utf8", errors='ignore'
    
    
# Convert dictionary to csv
sermon_df = pd.DataFrame.from_dict(sermDict['sermonData'])
sermon_df.shape
#sermon_df = sermon_df.drop_duplicates()
sermon_df = sermon_df['sermon'].drop_duplicates()
sermon_df.shape
sermon_df.to_csv('sermon_dataset7-22.csv', index = False)
