# Code  writes sermon .txt files to .JSON

# Iterate through all files
# Store in dictionary
# Write to JSON

import json
import os
import csv

dir = 'C:/Users/Steve/Dropbox/PoliticsOfSermons/MasterList/'

all_txt_files = os.listdir(dir)

sermon = ""

sermDict = {}

# Iterate through all files
for txt in all_txt_files:

    txt_dir = dir + txt

    # Open each .txt files
    with open(txt_dir, 'rb') as f:

        # Initialize counter
        i = 0

        for line in f:

            # Increment counter each line in each file
            i += 1

            # Store first line as value for author key
            if i == 1:
                #author = line.strip()
                sermDict['author'] = line.strip()

            # Store second line as value for date key
            if i == 2:
                #date = line.strip()
                sermDict['date'] = line.strip()

            # Store third line as value for denomination key
            if i == 3:
                #denom = line.strip()
                sermDict['denom'] = line.strip()

            # Store fifth line as value for title key
            if i == 5:
                title = line.strip()

            # After the sixth line, save every line as value to sermon key
            if i > 6:
                sermon = sermon + line.strip()

                sermDict['sermon'] = sermon

# Write dictionary to JSON file (saved as .txt)
with open('sermonJSON.txt', 'w') as outfile:
    json.dump(sermDict, outfile)
