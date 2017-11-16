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
from .betbtc import getBetBtcEventData, getBetBtcMaketOdds
from .Pinnacle import getPinnacleEventData, getPinnacleEventOdds
from .tennis_config import *
from .base import connect


    
def removeTime (datetime) :
    return datetime[:10]



def setBetBtcEvents(betbtc_event, tbl_events, con) :
    """
    add all new events to the table
    update existing events
    """
    dt = datetime.now()
    for event in betbtc_event :
        # looking for Match Odds
        if event[7] == "Match Odds" :
            print("betbtc_event_id" ,(event[0]))
            #print("betfair_event_id", (event[5]))
            #print("StartDate", (event[3]))
            #print("home_player_name", (event[6][0]['name']))
            #print("away_player_name", (event[6][1]['name']))
            
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

def setPinnacleEvents(pinnacle_event, tbl_events, con) :
    dt = datetime.now()
    for league in pinnacle_event['league'] :
        league_id = league['id']
        for event in league['events'] :
            if not "Set" in (event['home']) or not "Set" in (event['away']) : 
                print("pinnacle_event_id", event['id'])
                #print("StartDate", (event['starts']))
                #print("home_player_name", (event['home']))
                #print("away_player_name", (event['away']))
                #print("live", (event['liveStatus']))
                
                clause = insert(tbl_events).values(pinnacle_event_id=event['id'], \
                                                   pinnacle_league_id=league_id,\
                                                   StartDate=removeTime(event['starts']), \
                                                   StartDateTime=event['starts'], \
                                                   home_player_name=((event['home'])), \
                                                   away_player_name=((event['away'])), \
                                                   Live=(event['liveStatus']), \
                                                   LastUpdate=dt)
        
                clause = clause.on_conflict_do_update(
                index_elements=['StartDate', 'home_player_name','away_player_name'],
                set_=dict(pinnacle_event_id=event['id'], pinnacle_league_id=league_id, Live=(event['liveStatus']) ,LastUpdate=dt)
                )
                
                con.execute(clause)     
            



def getEvents() :
           
    con, meta = connect(pg_db, pg_user, pg_pwd, pg_host, pq_port)    
    
    
    tbl_events = meta.tables['tbl_events']
    
    betbtc_event = getBetBtcEventData()
    setBetBtcEvents(betbtc_event, tbl_events, con) 
                
    pinnacle_event = getPinnacleEventData()
    setPinnacleEvents(pinnacle_event, tbl_events, con)       
        
     

#getEvents()
    
    
    

    