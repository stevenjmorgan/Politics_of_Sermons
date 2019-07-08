# -*- coding: utf-8 -*-
"""
Created on Mon Jul  8 17:51:04 2019

@author: steve
"""

import logging
import requests
from api import BetaFaceAPI #C:\Users\steve\OneDrive\Documents\GitHub\Politics_of_Sermons\Dissertation
import os

request = requests.get('https://www.betafaceapi.com/')
print(request.text)

print(request.status_code)

os.chdir(r'C:\Users\steve\OneDrive\Documents\GitHub\Politics_of_Sermons\Dissertation')

api_key = 'd45fd466-51e2-4701-8da8-04351c872236'
api_secret = '171e8465-f548-401d-b63b-caf0dc28df5f'

logging.basicConfig(level = logging.INFO)
client = BetaFaceAPI()

client.upload_face(r'C:/Users/steve/Dropbox/Dissertation/Data/pastors/pastor2_Stephen Smith.png', 'sum410@psu.edu')#, 'obama@ami-lab.ro')
matches = client.recognize_faces('/Users/aismail/Desktop/obama_suparat.jpg', 'ami-lab.ro')



os.chdir('C:\Users\steve\OneDrive\Documents\GitHub\Politics_of_Sermons\Dissertation\request_templates')
