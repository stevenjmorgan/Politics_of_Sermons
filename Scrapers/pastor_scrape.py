# -*- coding: utf-8 -*-

# This code scrapes information on pastor profiles from sermoncentral.com

import os
import re
import sys
import random
import csv
import time
from bs4 import BeautifulSoup
import urllib2
import requests
from urlparse import urljoin

reload(sys)
sys.setdefaultencoding('utf8')


# 7,288 search result pages, 15 results per page

# Set seed for pseudo-randomness
seed = 24519
random.seed(seed)

# Set directory to store .csv file
os.chdir("C:/Users/sum410/Dropbox/PoliticsOfSermons/")

# .csv file where extracted metadata will be stored
fout = open("pastor_meta.csv", "wb")
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

### Itereate through each search result page
for i in range(1, 485):

    time.sleep(random.randint(0,10))

    search_page = 'https://www.sermoncentral.com/Contributors/Search/?page=' + str(i) + '&sortBy=Views&keyword=&rewrittenurltype=&searchResultSort=Views&denominationFreeText='

    try:
		resp = urllib2.urlopen(search_page)
    except:
        pass

    soup = BeautifulSoup(resp, from_encoding=resp.info().getparam('charset'), features = 'html.parser')

    # Create empty list to store press release urls
    links = []

    for link in soup.find_all('a', href=True):
		if re.search('/contributors/', str(link)) and re.search('profile', str(link)):
			#print link['href']
			links = links + [link['href']]

    # Remove duplicate links
    links = list(set(links))
    #print '\n'.join(str(p) for p in links)
    print len(links)
    print "This is page " + str(i)

    # Iterate through pastor links scraped from search results page
    for j in links:

        # Open each pastor profile page
        pastor_page = urljoin('https://www.sermoncentral.com', j)
        pastor_page = urllib2.urlopen(pastor_page)
        pastor_soup = BeautifulSoup(pastor_page, from_encoding=resp.info().getparam('charset'), features = 'html.parser')

        # Initialize variables to store pastor data
        name = ''
        church = ''
        job = ''
        denom = ''
        address = ''
        location = ''
        
        # Scrape pastor info
        try:
            name = pastor_soup.find('div', class_='info offset-100').find('h4').text.strip()
        except:
            pass
        try:
            church = pastor_soup.find('div', class_='info offset-100').find('p').text.split(':')[1].strip()
        except:
            pass
        try:
            job = pastor_soup.find('div', class_='info offset-100').select('p')[1].text.split(':')[1].strip()
        except:
            pass
        try:
            denom = pastor_soup.find('div', class_='info offset-100').select('p')[3].text.split(':')[1].strip()
        except:
            pass
        try:
            location = pastor_soup.find('div', class_='detail-txt').find('p').text.strip()
        except:
            pass
        #print repr(location.replace('\n', '\n'))
        #print re.sub('\r', '', str(location))
        try:
            location =  " ".join(location.split())
        except:
            pass
        try:
            address = pastor_soup.find('div', class_='detail-txt').find('p').text.split('\n')[2].strip()
        except:
            pass

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
