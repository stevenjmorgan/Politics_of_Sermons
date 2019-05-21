# -*- coding: utf-8 -*-
"""
Created on Mon May 20 12:54:34 2019

@author: sum410
"""

import os
import re
#import random
import warnings
import time
#from selenium import webdriver
#from selenium.webdriver.firefox.firefox_binary import FirefoxBinary
#from selenium.webdriver.common.by import By
from urllib.request import urlopen
from bs4 import BeautifulSoup


warnings.filterwarnings("ignore")

os.chdir("C:/Users/steve/OneDrive/Desktop/test")

# Initiate web driver
#path_to_chromedriver = 'C:/Users/Steve/Desktop/chromedriver'
#binary = FirefoxBinary('C:/Users/sum410/Desktop/geckodriver')
#browser = webdriver.Chrome(executable_path = path_to_chromedriver)
#browser = webdriver.Firefox(executable_path='C:/Users/Steve/Dropbox/geckodriver.exe')
#browser = webdriver.Firefox(executable_path='C:/Users/sum410/Dropbox/geckodriver.exe')

# Initialize variables
title = ""
author = ""
date = ""
denom = ""
sermon_text = "" 
counter = 2747
error_counter = 0

# Iterate through all search result pages
for i in range(183,11503): #range(0,11503)

    time.sleep(1)
    
    # Open initial webpage
    #url = 'https://www.sermoncentral.com/Sermons/Search/?CheckedScriptureBookId=&keyword=&denominationFreeText=&maxAge=&ref=AdvancedSearch-HomeSermon'
    url = 'https://www.sermoncentral.com/Sermons/Search/?page=' + str(i+1) + '&sortBy=Newest&keyword=&contributorId=&rewrittenurltype=&searchResultSort=Newest&CheckedScriptureBookId=&minRating=&maxAge=&denominationFreeText='
    
    # BeautifulSoup approach
    html = urlopen(url)
    bsObj = BeautifulSoup(html.read())
    
    # Store all hyperlinks, refine to only include sermon links (15 per page)
    serm_links = []
    for link in bsObj.find_all('a'):
        serm_links.append(link.get('href'))
    #len(serm_links)
    serm_links = [x for x in serm_links if (re.search('/sermons/', str(x)) and not re.search('/sermons/scripture/', str(x)) and not re.search('/sermons/search/', str(x)))]
    serm_links = list(set(serm_links))
    
    # Change links to set to first page of sermon
    #serm_page1 = [x.replace("?ref=SermonSerps","?page=1&wc=800") for x in serm_links]
    serm_page1 = ['https://www.sermoncentral.com' + x for x in serm_links]
    
    # Stop running if blocked
    if error_counter > 200:
        break
     
    # Iterate through each sermon scraped from each search result page
    for serm in range(0, len(serm_page1)):
        
        #time.sleep(1)
        
        # Open sermon link
        try:
            html = urlopen(serm_page1[serm])
            bsObj = BeautifulSoup(html.read())
        except:
            print('Error accessing URL!')
            print(serm_page1[serm])
            error_counter += 1
            pass
        
        # Determine number of pages sermon spans
        try:
            found = re.findall('value = (.+?);', str(bsObj.find_all('a', class_ = 'page')))
            found = [int(x) for x in found]
            max_pages = max(found)
        except:
            max_pages = 1
            
        #print(max_pages)
                   
        ### Scrape page 1 contents
        #print(serm_page1[serm])
        try:
            title = bsObj.title.text.strip()
        except:
            print('Error parsing title!')
            print(serm_page1[serm])
            title = ''
            pass
        try:
            author = re.split(' on ', re.split('Contributed by ', bsObj.h2.text.strip())[1])[0]
        except:
            print('Error parsing author!')
            print(serm_page1[serm])
            author = ''
            pass
        try:
            date = re.split(' on ', re.split('Contributed by ', bsObj.h2.text.strip())[1])[1].split(' (message ')[0]
        except:
            print('Error parsing date!')
            print(serm_page1[serm])
            date = ''
            pass
        try:    
            denom = re.split('Denomination: ', bsObj.findAll(class_ = "meta-links")[1].text)[1].strip()
        except:
            print('Error parsing denomination!')
            print(serm_page1[serm])
            denom = ''
            pass
        try:
            content = bsObj.find(class_='detail-text', ).findAll('p')
            sermon_text = ''
            for element in content:
                sermon_text += '\n' + ''.join(element.findAll(text = True))
        except:
            print('Error parsing sermon content!')
            print(serm_page1[serm])
            sermon_text = ''
            pass
        
        # Change name of link
        serm_page1 = [x.replace("?ref=SermonSerps","?page=1&wc=800") for x in serm_page1]
            
        # Iterate through pages of each sermon
        for page in range(1, max_pages):
            
            ### Scrape other pages' contents
            page = serm_page1[serm].replace(str("?page=1&wc=800"),str("?page=" + str(page+1) + "&wc=800"))
            #print(page)
            
            try:
                soup = BeautifulSoup(urlopen(page).read())
            #print(soup.findAll(text=True))
            except:
                print('Error scraping other pages!')
                print(serm_page1[serm])
                break
                #pass
            
            ### Append to sermon data
            content = ''
            try:
                content = soup.find(class_='detail-text', ).findAll('p')
                for element in content:
                    sermon_text += '\n' + ''.join(element.findAll(text = True))
            except:
                print('Error scraping other page text!')
                pass
                    
                
        # Write to .txt files
        counter += 1
        fileName = "Sermon" +  str(counter) + ".txt"
        print('Writing:', fileName)
        textFile = open(fileName, 'w', encoding='utf-8')
        try:
            textFile.write(author)
        except:
            pass
        try:
            textFile.write('\n')
        except:
            pass
        try:
            textFile.write(date)
        except:
            pass
        try:
            textFile.write('\n')
        except:
            pass
        try:
            textFile.write(denom)
        except:
            pass
        try:
            textFile.write('\n')
        except:
            pass
        try:
            textFile.write('\n')
        except:
            pass
        try:
            textFile.write(title)
        except:
            pass
        try:
            textFile.write('\n')
        except:
            pass
        try:
            textFile.write(sermon_text) 
        except:
            pass
        try:
            textFile.close()
        except:
            pass
        