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
import sqlite3




def store_matches_to_database(df) :
    conn = sqlite3.connect('ttt_data.db')
    df.to_sql('tmp_ttt_picks', conn, if_exists='append', index=False)
    



def get_actual_picks() :
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

            
            
    ttt_msgs = service.users().messages().list(userId='me',labelIds=['INBOX'], q="from:support@toptennistips.com newer_than:12h").execute()
    
    result = pd.DataFrame()
    
    if ttt_msgs['resultSizeEstimate'] != 0 :    
        for msg in ttt_msgs['messages']:
            msg_id = msg['id']
        
            message = service.users().messages().get(userId='me', id=msg_id, format='raw').execute()
                
            
            msg_str = base64.urlsafe_b64decode(message['raw'].encode('ASCII'))
            
            html = msg_str
            
            soup = BeautifulSoup(html, "html.parser")
                
            table = soup.find("table", attrs={"class": "templateDataTable"})
            
            trs = table.findAll("tr")
            
            
            
            for tr in trs :
                tds = tr.findAll("td")
                if len(tds) > 0 :
               
                    dict = { 'matchdatetime' : tds[0].text.strip(),
                         'match'    : tds[1].text.strip(),
                         'winner' : tds[2].text.strip(),
                         'win_proba' : float(tds[3].text.strip()[0:4]),
                         'at_odd' : float(tds[4].text.strip()),
                         'bet_value' : float(tds[5].text.strip()),
                         'event' : tds[6].text.strip(),
                         'level' : tds[7].text.strip(),
                
                
                
                             
                             #'html'       : html
                        }
                       
                    data = pd.DataFrame([dict])
                
                    result = result.append(data, ignore_index=True) 
    
    return (result)






def get_ttt_current():
    try :
        conn = sqlite3.connect('ttt_data.db')
        c = conn.cursor()
        c.execute("DELETE FROM tmp_ttt_picks")
        conn.commit()
        conn.close()
    except:
        print("error deleting file")
    
    
    result = get_actual_picks()
    
    store_matches_to_database(result)
        