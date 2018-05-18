# -*- coding: utf-8 -*-
"""
Created on Fri May 18 08:21:42 2018

@author: haenec
"""
from __future__ import print_function
from apiclient.discovery import build
from httplib2 import Http
from oauth2client import file, client, tools
import base64
from bs4 import BeautifulSoup
import pandas as pd




# Setup the Gmail API
SCOPES = 'https://www.googleapis.com/auth/gmail.readonly'
store = file.Storage('credentials.json')
creds = store.get()
if not creds or creds.invalid:
    flow = client.flow_from_clientsecrets('client_secret_195389700512-1gscoh1moo86k7878o93pmi7j1l4uiv5.apps.googleusercontent.com.json', SCOPES)
    creds = tools.run_flow(flow, store)
service = build('gmail', 'v1', http=creds.authorize(Http()))

# Call the Gmail API
results = service.users().labels().list(userId='me').execute()
labels = results.get('labels', [])
if not labels:
    print('No labels found.')
else:
    print('Labels:')
    for label in labels:
        print(label['name'])
        
        
ttt_msgs = service.users().messages().list(userId='me',labelIds=['INBOX'], q="from:support@toptennistips.com newer_than:5d").execute()

if ttt_msgs['resultSizeEstimate'] != 0 :
    msg_id = ttt_msgs['messages'][0]['id']
    
message = service.users().messages().get(userId='me', id=msg_id, format='raw').execute()
    

msg_str = base64.urlsafe_b64decode(message['raw'].encode('ASCII'))

html = msg_str

soup = BeautifulSoup(html, "html.parser")
    
table = soup.find("table", attrs={"class": "templateDataTable"})

#trs = table.findAll("tr")




df = pd.read_html(table,skiprows=1)

