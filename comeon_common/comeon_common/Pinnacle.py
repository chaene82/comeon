#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Sep 10 16:19:16 2017

@author: chrhae
"""

import pinnacle
import pandas as pd
import json
import datetime
import os
from pinnacle.apiclient import APIClient

dir = os.path.dirname(__file__)
os.chdir(dir)

import urllib.request

api = APIClient('CH983245', 'Skoda1$$')

sport_ids = api.reference_data.get_sports()

def getPinnacleEventData():
    return api.market_data.get_fixtures(33)

def getPinnacleEventOdds():
    return api.market_data.get_odds(33)
    
data = api.market_data.get_fixtures(33)
    
#atp_list = []
#for i in tennis_leagues:
#    if i['name'][:3] == 'ATP' : 
#        print(i['name'])
#        print(i['id'])
#        atp_list.append(i['id'])
        

#tennis_periods =  api.reference_data.get_periods(33)       
#        
#tennis_events = api.market_data.get_fixtures(33) #, league_ids=atp_list)
#
#tennis_odds = api.market_data.get_odds(33)
#
##tennis_settled = api.market_data.get_settled_fixtures(33)
##
##home = tennis_odds['leagues'][0]['events'][0]['periods'][0]['moneyline']['home']
##away = tennis_odds['leagues'][0]['events'][0]['periods'][0]['moneyline']['away']
##
##home1 = tennis_odds['leagues'][0]['events'][0]['periods'][1]['moneyline']['home']
##away1 = tennis_odds['leagues'][0]['events'][0]['periods'][1]['moneyline']['away']
##
##
##3455
##
##matches = pd.DataFrame()
##d1 = tennis_events['league']
##for i in d1 :
##    tournament = (i['name'])
##    events = i['events'] 
##    
##    for event in events:
##        row = pd.DataFrame()
##        print(event['id'])
##        print(event['home'])
##        print(event['away'])
##        print(event['starts'])
##        
##        d = {'tournament' : tournament, 'pineventId' :  event['id'],
##             'startDate' : event['starts'],
##             'home' : event['home'], 'away' : event['away']}
##        #row['tournament'] = tornament
##        #row['pineventId'] = event['id']
##        #row['startDate'] = event['starts']
##        #row['home'] = event['home']
##        #row['away'] = event['away']
##        
##        data = pd.DataFrame([d], columns=d.keys())
##        matches = matches.append(data)
#
#
#
#tennis_matches_done = api.market_data.get_settled_fixtures(33) 
#
### Create a file repository
#
#now = datetime.datetime.now()
#date_id = now.strftime("%Y%m%d")
#
#
#with open("pinnacle/" + date_id + "_tennis_periods.json", 'w') as fp:
#    json.dump(tennis_periods, fp)
#    
#with open("pinnacle/" + date_id + "_tennis_events.json", 'w') as fp:
#    json.dump(tennis_events, fp)   
#    
#with open("pinnacle/" + date_id + "_tennis_odds.json", 'w') as fp:
#    json.dump(tennis_odds, fp)
#    
#with open("pinnacle/" + date_id + "_tennis_matches_done.json", 'w') as fp:
#    json.dump(tennis_matches_done, fp)       
