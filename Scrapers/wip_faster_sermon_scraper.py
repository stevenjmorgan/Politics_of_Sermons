# -*- coding: utf-8 -*-
"""
Created on Mon May 20 12:54:34 2019

@author: sum410
"""

import os
import re
import random
import time
from selenium import webdriver
from selenium.webdriver.firefox.firefox_binary import FirefoxBinary
from selenium.webdriver.common.by import By
from urllib.request import urlopen
from bs4 import BeautifulSoup

# Initiate web driver
#path_to_chromedriver = 'C:/Users/sum410/Desktop/geckodriver'
#binary = FirefoxBinary('C:/Users/sum410/Desktop/geckodriver')
#browser = webdriver.Chrome(executable_path = path_to_chromedriver)
browser = webdriver.Firefox(executable_path='C:/Users/sum410/Desktop/geckodriver.exe')

# Open initial webpage
#url = 'https://www.sermoncentral.com/Sermons/Search/?CheckedScriptureBookId=&keyword=&denominationFreeText=&maxAge=&ref=AdvancedSearch-HomeSermon'
url = 'https://www.sermoncentral.com/Sermons/Search/?page=1&sortBy=Newest&keyword=&contributorId=&rewrittenurltype=&searchResultSort=Newest&CheckedScriptureBookId=&minRating=&maxAge=&denominationFreeText='
browser.get(url)

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
serm_page1 = [x.replace("?ref=SermonSerps","?page=1&wc=800") for x in serm_links]
serm_page1 = ['https://www.sermoncentral.com' + x for x in serm_page1]

# Iterate through all pages
x = serm_page1[0]
#for i in range(0,20):
    