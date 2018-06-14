# -*- coding: utf-8 -*-

### Steven Morgan
### Scraping Sermons from SermonCentral.com
### Code last updated June 14, 2018

from bs4 import BeautifulSoup
import urllib2, re, requests, bs4, os
#from selenium import webdriver
#from selenium.common.exceptions import NoSuchElementException
#from selenium.webdriver.common.keys import Keys
import time

# Create empty list to sermon urls
links = []

# Iterate through pages of sermon links
# The url for each page follows a set pattern
for i in range(1, 3): #20
    #time.sleep(15)
    x = 'https://www.sermoncentral.com/Sermons/Search/?page=' + str(i) + '&sortBy=Newest&keyword=&contributorId=&rewrittenurltype=&searchResultSort=Newest&CheckedScriptureBookId=&minRating=&maxAge=&denominationFreeText='
    try:
        resp = urllib2.urlopen(x)
    except:
        pass
    soup = BeautifulSoup(resp, from_encoding=resp.info().getparam('charset'))
    # Appends all sermon URLs to a list
    for link in soup.find_all('a', href=True):
        if re.search('/sermons/', str(link)) and re.search('SermonSerps', str(link)) and not re.search('/sermons/sermons-about', str(link)) and not re.search('/sermons/scripture', str(link)):
            print link['href']
            links = links + [link['href']]

# Should scrape 15 links per page
links = list(set(links))
print len(links)
#print '\n'
#print links
