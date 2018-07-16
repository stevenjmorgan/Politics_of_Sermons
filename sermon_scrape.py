# -*- coding: utf-8 -*-
import os
import re
import sys
import random
import time
from selenium import webdriver
from selenium.webdriver.common.by import By

reload(sys)
sys.setdefaultencoding('utf8')

# Function to convert unicode to ASCII -> needs improvement
'''def unicodetoascii(text):
    TEXT = (text.
            replace('\\xe2\\x80\\x99', "'").
            replace('\\xe2\\x80\\x90', '-').
            replace('\\xe2\\x80\\x91', '-').
            replace('\\xe2\\x80\\x92', '-').
            replace('\\xe2\\x80\\x93', '-').
            replace('\\xe2\\x80\\x94', '-').
            replace('\\xe2\\x80\\x94', '-').
            replace('\\xe2\\x80\\x98', "'").
            replace('\\xe2\\x80\\x9b', "'").
            replace('\\xe2\\x80\\x9c', '"').
            replace('\\xe2\\x80\\x9c', '"').
            replace('\\xe2\\x80\\x9d', '"').
            replace('\\xe2\\x80\\x9e', '"').
            replace('\\xe2\\x80\\x9f', '"').
            replace('\\xe2\\x80\\xa6', '...').#
            replace('\\xe2\\x80\\xb2', "'").
            replace('\\xe2\\x80\\xb3', "'").
            replace('\\xe2\\x80\\xb4', "'").
            replace('\\xe2\\x80\\xb5', "'").
            replace('\\xe2\\x80\\xb6', "'").
            replace('\\xe2\\x80\\xb7', "'").
            replace('\\xe2\\x81\\xba', "+").
            replace('\\xe2\\x81\\xbb', "-").
            replace('\\xe2\\x81\\xbc', "=").
            replace('\\xe2\\x81\\xbd', "(").
            replace('\\xe2\\x81\\xbe', ")")
            )
    return TEXT
'''

# Initiate web driver
path_to_chromedriver = 'C:/Users/smorgan/Desktop/chromedriver'
browser = webdriver.Chrome(executable_path = path_to_chromedriver)

# Open initial webpage
url = 'https://www.sermoncentral.com/Sermons/Search/?CheckedScriptureBookId=&keyword=&denominationFreeText=&maxAge=&ref=AdvancedSearch-HomeSermon'
browser.get(url)

serms = []

# Set seed for pseudo-randomness
seed = 24519
random.seed(seed)

# Set directory to store .txt files
os.chdir("C:/Users/smorgan/Desktop/scraping/dynamic/sermons")

### Itereate through each search result page
for i in range(0,10966): #10,960 or something crazy big

    time.sleep(random.randint(0,10))

    ### For each search result page
    # Store all href attributes in a list
    elems = browser.find_elements_by_xpath("//a[@href]")

    # Only retain desired links based on link syntax (many junk links are picked up)
    elems = [x for x in elems if re.search("https://www.sermoncentral.com/sermons/", str(x.get_attribute("href")))]
    elems = [x for x in elems if not re.search("sermons-on-", str(x.get_attribute("href")))]
    elems = [x for x in elems if not re.search("sermons-about-", str(x.get_attribute("href")))]

    # Only retain every other link since each desired link appears twice as href
    elems = elems[::2]

    #print len(elems) KEEP

    #serms = serms.append(elems)

    # Iterate through list of desired sermon links and append to master list
    for elem in elems:
        #print elem.get_attribute("href")
        serms.append(elem.get_attribute('href'))

    # Locate and store the "Next" button; click button to navigate to next page
    try:
        elm = browser.find_element_by_class_name('pagination-next')
        elm.click()
    except:
        pass

# Ensure correct number of sermon links stored in master list
#print len(serms) KEEP

#sermTitle = []
#sermAuth = []
#sermDenom = []
#sermDate = []
#sermonContent = []
title = ""
author = ""
date = ""
denom = ""
#scripture = ""
content = ""

counter = 0

### Navigate to each desired link and scrape desired contents
for i in serms[0:10]:

    time.sleep(random.randint(0,10))
    browser.get(i)

    # Scrape title
    title = browser.find_element_by_tag_name('h1').text
    #print title.text

    # Scrape tags for author and date; split to parse appropriate data
    author = browser.find_element_by_tag_name('h2').text
    author = author.split('Contributed by ')[1]
    date = author.split(' on ')[1]
    date = date.split(' (message ')[0]
    author = author.split(' on ')[0]
    #print author
    #print date

    # Scrape tag for denomination
    denom = browser.find_elements_by_class_name('meta-links')[2].text
    denom = denom.split('Denomination: ')[1]
    #print denom


    # Scrape tags for all p contents
    content = browser.find_element_by_class_name('detail-text').text.encode('utf-8', 'ignore') ### 'utf-8'
    content = re.sub('Preach Better with PRO', '', content)
    content = re.sub('Add your email to get started, plus get updates & offers from SermonCentral. Privacy Policy.', '', content)
    #print content
    fullContent = []
    fullContent.append(content)
    #print fullContent
    #print repr(content)


    ### Click "Next" button until all content is parsed; pass if on last page
    for j in range(0, 100):
        try:
            elm2 = browser.find_element_by_class_name('pagination-next')
            time.sleep(random.randint(0,10))
            elm2.click()
            #print browser.find_element_by_class_name('detail-text').text.encode("utf-8")
            fullContent.append(browser.find_element_by_class_name('detail-text').text.encode('utf-8', 'ignore')) ### 'utf-8'
        except:
            pass



    # Append data to lists
    #sermTitle.append(title)
    #sermAuth.append(author)
    #sermDenom.append(denom)
    #sermDate.append(date)
    #sermonContent.append(content)


    ### Write to .txt files
    counter += 1
    fileName = "Sermon" +  str(counter) + ".txt"
    print fileName
    textFile = open(fileName, 'w')
    textFile.write(author)
    textFile.write('\n')
    textFile.write(date)
    textFile.write('\n')
    textFile.write(denom)
    textFile.write('\n')
    textFile.write('\n')
    textFile.write(title)
    textFile.write('\n')
    textFile.write('\n')
    print type("\n\n".join(item.decode('utf-8', 'ignore') for item in fullContent)) ### str() may be issue with non-ASCII characters
    textFile.write("\n\n".join(item.encode('utf-8', 'ignore') for item in fullContent)) ### str() may be issue with non-ASCII characters
    #for item in fullContent:
    #    textFile.write()
    #textFile.write(content) #sermonContent with an append?
    textFile.close()
