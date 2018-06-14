# -*- coding: utf-8 -*-

### Steven Morgan
### Scraping Sermons from SermonCentral.com
### Code last updated June 14, 2018

'''
To Do:      -Deal with top contents better (date, denomination, spacing)
            -Iterate through pages within each sermon link
'''

from bs4 import BeautifulSoup
import urllib2, re, requests, bs4, os, random
import numpy as np
#from selenium import webdriver
#from selenium.common.exceptions import NoSuchElementException
#from selenium.webdriver.common.keys import Keys
import time

# Create empty list to sermon urls
links = []

# Set seed
random.seed(24519)

# Iterate through search result pages of sermon links
for i in range(1, 2): #20
    x = 'https://www.sermoncentral.com/Sermons/Search/?page=' + str(i) + '&sortBy=Newest&keyword=&contributorId=&rewrittenurltype=&searchResultSort=Newest&CheckedScriptureBookId=&minRating=&maxAge=&denominationFreeText='
    try:
        resp = urllib2.urlopen(x)
    except:
        pass
    soup = BeautifulSoup(resp, from_encoding=resp.info().getparam('charset'))
    #time.sleep(np.random.normal(15, 3.5))

    # Appends all sermon URLs to a list
    for link in soup.find_all('a', href=True):
        if link['href'] not in links and re.search('/sermons/', str(link)) and re.search('SermonSerps', str(link)) and not re.search('/sermons/sermons-about', str(link)) and not re.search('/sermons/scripture', str(link)):
            print link['href']
            links = links + [link['href']]
            #time.sleep(random.randint(5, 10))

# Should scrape 15 links per page
links = list(set(links))
print len(links)

counter = 1
#os.makedirs('sermon_docs')
os.chdir('sermon_docs')
for link in links[0:1]:
    link1 = 'https://www.sermoncentral.com' + str(link)
    res = requests.get(link1)
    noStarchSoup = bs4.BeautifulSoup(res.text, 'html5lib')
    #title = noStarchSoup.select('h1')
    title = noStarchSoup.title.string
    subtitle = str(noStarchSoup.h2.text).strip()
    #subtitle = noStarchSoup.select('h2')
    content = noStarchSoup.select('p')
    #content = noStarchSoup.find_all('div', class_='paragraph')
    sermon = open('sermon' + str(counter) + '.txt', 'w') #subtitle

    counter += counter

    for i in range(len(content)):
        if i == 0:
            sermon.write(title)
            sermon.write('\n')
            sermon.write('subtitle')
            sermon.write('\n')

        sermon.write(content[i].getText().encode('utf-8'))
        sermon.write('\n')

    #print title, '\n'
    #print subtitle
    #print content
    #print soup.get_text()
