# -*- coding: utf-8 -*-
import os
import re
from selenium import webdriver
from selenium.webdriver.common.by import By

# Function to convert unicode to ASCII -> needs improvement
def unicodetoascii(text):
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

# Initiate web driver
path_to_chromedriver = 'C:/Users/smorgan/Desktop/chromedriver'
browser = webdriver.Chrome(executable_path = path_to_chromedriver)

# Open initial webpage
url = 'https://www.sermoncentral.com/Sermons/Search/?CheckedScriptureBookId=&keyword=&denominationFreeText=&maxAge=&ref=AdvancedSearch-HomeSermon'
browser.get(url)

serms = []

### Itereate through each search result page
for i in range(0,2): #10,960 or something crazy big

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
    elm = browser.find_element_by_class_name('pagination-next')
    elm.click()

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
content = ""

counter = 0

### Navigate to each desired link and scrape desired contents
for i in serms[0:2]:
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
    content = browser.find_element_by_class_name('detail-text').text.encode("utf-8") ###
    #print repr(content)

    '''
    ### Click "Next" button until all content is parsed
    elm2 = browser.find_element_by_class_name('pagination-next')
    for i in range(0,5):
        elm2.click
        content.append(browser.find_element_by_class_name('detail-text').text.encode("utf-8")) ###
    '''


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
    textFile.write(content) #sermonContent with an append?
    textFile.close()




'''
### For each search result page
# Store all href attributes in a list
elems = browser.find_elements_by_xpath("//a[@href]")

# Only retain desired links based on link syntax (many junk links are picked up)
elems = [x for x in elems if re.search("https://www.sermoncentral.com/sermons/", str(x.get_attribute("href")))]
elems = [x for x in elems if not re.search("sermons-on-", str(x.get_attribute("href")))]
elems = [x for x in elems if not re.search("sermons-about-", str(x.get_attribute("href")))]

# Only retain every other link since each desired link appears twice as href
elems = elems[::2]

print len(elems)
for elem in elems:
    print elem.get_attribute("href")
'''
