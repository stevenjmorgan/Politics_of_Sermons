# -*- coding: utf-8 -*-
"""
Created on Mon May 20 12:54:34 2019

@author: sum410
"""

import os
import csv
import re
#import random
import warnings
import time
#from selenium import webdriver
#from selenium.webdriver.firefox.firefox_binary import FirefoxBinary
#from selenium.webdriver.common.by import By
from urllib.request import urlopen
from bs4 import BeautifulSoup
import urllib
import urllib.request


warnings.filterwarnings("ignore")

os.chdir(r"C:\Users\steve\Dropbox\Dissertation\Data\pastors")

name = ''
church = ''
job = ''
denom = ''
address = ''
location = ''
misc = ''

# .csv file where extracted metadata will be stored
fout = open("pastor_meta7-8.csv", "w")
outfilehandle = csv.writer(fout,
                           delimiter=",",
                           quotechar='"',
                           quoting=csv.QUOTE_NONNUMERIC)
localrow = []
localrow.append("name")
localrow.append("church")
localrow.append('job')
localrow.append('denom')
localrow.append('address')
localrow.append('location')
outfilehandle.writerow(localrow)

counter = 0

# Iterate through all search result pages
for i in range(0,508): #508
    
    time.sleep(1)
    
    # Open pastor search webpage
    url = 'https://www.sermoncentral.com/Contributors/Search/?page=' + str(i+1) + '&sortBy=Newest&keyword=&rewrittenurltype=&searchResultSort=Newest&denominationFreeText='
    
    # BeautifulSoup approach
    html = urlopen(url)
    bsObj = BeautifulSoup(html.read())
    
     # Store all hyperlinks, refine to only include pastor links (15 per page)
    pastor_links = []
    for link in bsObj.find_all('a'):
        pastor_links.append(link.get('href'))
    
    pastor_links = [x for x in pastor_links if (re.search('/contributors/', str(x)) and re.search('-profile-', str(x)))]
    pastor_links = list(set(pastor_links))
    len(pastor_links)
    
    # Change links to set to first page of sermon
    pastor_links = ['https://www.sermoncentral.com' + x for x in pastor_links]
    
    
    # Iterate through pastor pages
    for j in range(0, len(pastor_links)):
        
        counter += 1
        
        # Open pastor profile
        pastor_html = urlopen(pastor_links[j])
        pastor_bsObj = BeautifulSoup(pastor_html.read())
        
        try:
            name = pastor_bsObj.find('div', class_='info offset-100').find('h4').text.strip()
        except:
            print('Error parsing pastor name!')
            name = ''
            pass
        
        try:
            church = pastor_bsObj.find('div', class_='info offset-100').find('p').text.split(':')[1].strip()
        except:
            print('Error parsing church name!')
            church = ''
            pass
        
        try:
            job = pastor_bsObj.find('div', class_='info offset-100').select('p')[1].text.split(':')[1].strip()
        except:
            print('Error parsing job!')
            job = ''
            pass
        
        try:
            denom = pastor_bsObj.find('div', class_='info offset-100').select('p')[3].text.split(':')[1].strip()
        except:
            print('Error parsing denomination!')
            denom = ''
            pass
        
        try:
            location = pastor_bsObj.find('div', class_='detail-txt').find('p').text.strip()
        except:
            print('Error parsing location!')
            location = ''
            pass
        #print repr(location.replace('\n', '\n'))
        #print re.sub('\r', '', str(location))
        try:
            location =  " ".join(location.split())
        except:
            pass
        try:
            address = pastor_bsObj.find('div', class_='detail-txt').find('p').text.split('\n')[2].strip()
        except:
            print('Error parsing address!')
            address = ''
            pass
        
        ### Grab education and experience and other text (misc. assignment)
        #pastor_bsObj.find('div', class_='detail-txt').find_all('p')


        ## Grab image url
        imgs = pastor_bsObj.findAll("div", {"class":"image width-100"})
        if len(imgs) > 1:
            print('Error!!! More than 1 image parsed!')
            print(len(imgs))
        try:
            image_url = imgs[0].img['data-src']
            urllib.request.urlretrieve(image_url, os.path.basename('pastor' + str(counter) + '_' + str(name) + '.png'))
        except:
            print('Error parsing image!')
            pass
        
        
        # Write to .csv
        localrow = []
        localrow.append(name)
        localrow.append(church)
        localrow.append(job)
        localrow.append(denom)
        localrow.append(address)
        localrow.append(location)
        outfilehandle.writerow(localrow)
        
# Finish writing to the .csv file and close it so the process is complete
fout.close()