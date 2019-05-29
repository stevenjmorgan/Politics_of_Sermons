# Code  writes sermon .txt files to .JSON

# Iterate through all files
# Store in dictionary
# Write to JSON

import json
import os
import pandas as pd

os.chdir('C:/Users/steve/Dropbox/Dissertation/Data/')

#dir = 'C:/Users/sum410/Dropbox/PoliticsOfSermons/Data/MasterList/'
#dir = 'C:/Users/Steve/Dropbox/PoliticsOfSermons/MasterList/'
dir = 'C:/Users/steve/Dropbox/reverse_scraper/'

all_txt_files = os.listdir(dir)

sermon = ""
j = 0

sermDict = {}
sermDict['sermonData'] = []

print('Beginning to ingest data...')

# Write dictionary to JSON file (saved as .txt)
with open('sermon5-27.JSON', 'w', encoding="utf8", errors='ignore') as outfile:

# Iterate through all files
    for txt in all_txt_files:

        txt_dir = dir + txt

        j += 1
        if j % 1000 == 0:
            print("Iterate through " + str(j) + " sermons.")

        author = ""
        date = ""
        denom = ""
        title = ""
        sermon = ""

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

                # Store fifth line as value for title key
                if i == 5:
                    title = line.strip()

                # After the sixth line, save every line as value to sermon key
                if i > 6:
                    sermon = sermon + line.strip()

        sermDict['sermonData'].append({'author':author, 'date':date, 'denom':denom, 'title':title, 'sermon':sermon})
        #sermDict['sermonData'].append({'author':author, 'date':date, 'denom':denom, 'title':title, 'sermon':sermon})

    json.dump(sermDict, outfile, ensure_ascii=False) #encoding="utf8", errors='ignore'
    
    
# Convert dictionary to csv
sermon_df = pd.DataFrame.from_dict(sermDict['sermonData'])
sermon_df = sermon_df.drop_duplicates()
sermon_df.to_csv('sermon_dataset5-27.csv')
