#!/usr/bin/env py/thon3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct 12 17:53:37 2017

@author: chrhae
"""

import json
from sqlalchemy import create_engine, MetaData, select
from sqlalchemy.dialects.postgresql import insert
from datetime import datetime
import numpy as np
from betbtc import getBetBtcEventData, getBetBtcMaketOdds
from pinnacle import getPinnacleEventData, getPinnacleEventOdds
from tennis_config import *


## Internal functions
def connect(db, user, password, host='localhost', port=5433):
    '''Returns a connection and a metadata object'''
    # We connect with the help of the PostgreSQL URL
    # postgresql://federer:grandestslam@localhost:5432/tennis
    url = 'postgresql://{}:{}@{}:{}/{}'
    url = url.format(user, password, host, port, db)

    # The return value of create_engine() is our connection object
    con = create_engine(url, client_encoding='utf8')

    # We then bind the connection to MetaData()
    meta = MetaData(bind=con, reflect=True)

    return con, meta
    
def removeTime (datetime) :
    return datetime[:10]



def setBetBtcEvents(betbtc_event, tbl_events) :
    """
    add all new events to the table
    update existing events
    """
    dt = datetime.now()
    for event in betbtc_event :
        # looking for Match Odds
        if event[7] == "Match Odds" :
            print("betbtc_event_id" ,(event[0]))
            print("betfair_event_id", (event[5]))
            print("StartDate", (event[3]))
            print("home_player_name", (event[6][0]['name']))
            print("away_player_name", (event[6][1]['name']))
            
            clause = insert(tbl_events).values(betbtc_event_id=event[0], \
                                               StartDate=removeTime(event[3]), \
                                               StartDateTime=event[3], \
                                               betfair_event_id=(event[5]), \
                                               home_player_name=(event[6][0]['name']), \
                                               away_player_name=(event[6][1]['name']), \
                                               LastUpdate=dt)
            
            clause = clause.on_conflict_do_update(
            index_elements=['StartDate', 'home_player_name','away_player_name'],
            set_=dict(LastUpdate=dt)
            )
            
            con.execute(clause)

def setPinnacleEvents(pinnacle_event, tbl_events) :
    dt = datetime.now()
    for league in pinnacle_event['league'] :
        for event in league['events'] :
            print("pinnacle_event_id", event['id'])
            print("StartDate", (event['starts']))
            print("home_player_name", (event['home']))
            print("away_player_name", (event['away']))
            print("live", (event['liveStatus']))
            
            clause = insert(tbl_events).values(pinnacle_event_id=event['id'], \
                                               StartDate=removeTime(event['starts']), \
                                               StartDateTime=event['starts'], \
                                               home_player_name=((event['home'])), \
                                               away_player_name=((event['away'])), \
                                               Live=(event['liveStatus']), \
                                               LastUpdate=dt)
    
            clause = clause.on_conflict_do_update(
            index_elements=['StartDate', 'home_player_name','away_player_name'],
            set_=dict(pinnacle_event_id=event['id'],Live=(event['liveStatus']) ,LastUpdate=dt)
            )
            
            con.execute(clause)     
            



def getEvents() :
           
    con, meta = connect(pg_db, pg_user, pg_pwd, pg_host, pq_port)    
    
    
    tbl_events = meta.tables['tbl_events']
    tbl_odds = meta.tables['tbl_odds']
    
    betbtc_event = getBetBtcEventData()
    setBetBtcEvents(betbtc_event, tbl_events) 
                
    pinnacle_event = getPinnacleEventData()
    setPinnacleEvents(pinnacle_event, tbl_events)       
        
     


    
    
    

    