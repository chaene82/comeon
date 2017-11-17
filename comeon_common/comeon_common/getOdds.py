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



  
            
def setPinnacleEventOdds(pinnacle_odds, pinnacle_event_id, event_id, tbl_odds, con) :
    dt = datetime.now()

    for league in pinnacle_odds['leagues']:
        #print(league)
        for event in league['events']:
            if event['id'] == pinnacle_event_id:
                
                event_odds = event
                for line in event_odds['periods'] :
                    if 'moneyline' in event_odds['periods'][0] and line['number'] == 0 :
                        
                        home_ml = line['moneyline']['home']
                        away_ml = line['moneyline']['away']
                        
                        line_id = line['lineId']
        
                        
                        clause = insert(tbl_odds).values(event_id=event_id, \
                                                       bettyp_id = 1, \
                                                       way = 1, \
                                                       bookie_id = 1, \
                                                       backlay = 1,\
                                                       odds=home_ml, \
                                                       pin_line_id=line_id, \
                                                       odds_update=dt) 
        
                        clause = clause.on_conflict_do_update(
                        index_elements=['event_id', 'bettyp_id','way','bookie_id','backlay'],
                        set_=dict(odds=home_ml,pin_line_id=line_id,odds_update=dt)
                        )
                        
                        con.execute(clause)  
                        
                        clause = insert(tbl_odds).values(event_id=event_id, \
                                                       bettyp_id = 1, \
                                                       way = 2, \
                                                       bookie_id = 1, \
                                                       backlay = 1,\
                                                       odds=away_ml, \
                                                       pin_line_id=line_id, \
                                                       odds_update=dt) 
        
                        clause = clause.on_conflict_do_update(
                        index_elements=['event_id', 'bettyp_id','way','bookie_id','backlay'],
                        set_=dict(odds=away_ml,pin_line_id=line_id,odds_update=dt)
                        )
                        
                        con.execute(clause)                  
                

def setBetBecEventOdds(betbtc_event_id, event_id, home_name, away_name, tbl_odds, con) :
    dt = datetime.now()
    
    
    
    odds = getBetBtcMaketOdds(betbtc_event_id)
 
    
    if len(odds) != 2:
        home_back = np.nan
        home_lay = np.nan
        away_back = np.nan
        away_lay = np.nan
    else :      
        if home_name in odds[0] :
            home_odd = list(odds[0].values())[0]
            home_back = home_odd['Back'][0][0]
            home_lay = home_odd['Lay'][0][0]
        elif home_name in odds[1] :
            home_odd = list(odds[1].values())[0]
            home_back = home_odd['Back'][0][0]
            home_lay = home_odd['Lay'][0][0]
        
        if away_name in odds[0] :
            away_odd = list(odds[0].values())[0]
            away_back = away_odd['Back'][0][0]
            away_lay = away_odd['Lay'][0][0]
        elif away_name in odds[1] : 
            away_odd = list(odds[1].values())[0]
            away_back = away_odd['Back'][0][0]
            away_lay = away_odd['Lay'][0][0]

    if not isinstance(home_back, float) : home_back = np.nan
    if not isinstance(home_lay, float)  : home_lay = np.nan
    if not isinstance(away_back, float) : away_back = np.nan
    if not isinstance(away_lay, float)  : away_lay = np.nan
    
    
    
    
    
    clause = insert(tbl_odds).values(event_id=event_id,bettyp_id = 1,way = 1,bookie_id = 2,backlay = 1,odds=home_back, \
                                               odds_update=dt) 
    
    clause = clause.on_conflict_do_update(
    index_elements=['event_id', 'bettyp_id','way','bookie_id','backlay'],
    set_=dict(odds=home_back,odds_update=dt)
    )
    con.execute(clause)   
    
    clause = insert(tbl_odds).values(event_id=event_id, \
                                               bettyp_id = 1, \
                                               way = 1, \
                                               bookie_id = 2, \
                                               backlay = 2,\
                                               odds=home_lay, \
                                               odds_update=dt) 
    
    clause = clause.on_conflict_do_update(
    index_elements=['event_id', 'bettyp_id','way','bookie_id','backlay'],
    set_=dict(odds=home_lay,odds_update=dt)
    )
    con.execute(clause)  
    
    clause = insert(tbl_odds).values(event_id=event_id, \
                                               bettyp_id = 1, \
                                               way = 2, \
                                               bookie_id = 2, \
                                               backlay = 1,\
                                               odds=away_back,\
                                               odds_update=dt) 
    
    clause = clause.on_conflict_do_update(
    index_elements=['event_id', 'bettyp_id','way','bookie_id','backlay'],
    set_=dict(odds=away_back,odds_update=dt)
    )
    con.execute(clause)  

    clause = insert(tbl_odds).values(event_id=event_id, \
                                               bettyp_id = 1, \
                                               way = 2, \
                                               bookie_id = 2, \
                                               backlay = 2,\
                                               odds=away_lay, \
                                               odds_update=dt) 

    clause = clause.on_conflict_do_update(
    index_elements=['event_id', 'bettyp_id','way','bookie_id','backlay'],
    set_=dict(odds=away_lay,odds_update=dt)
    )
    con.execute(clause)  


def getOdds() :
           
    con, meta = connect(pg_db, pg_user, pg_pwd, pg_host, pq_port)    
    
    
    
    tbl_odds = meta.tables['tbl_odds']

    pinnacle_odds = getPinnacleEventOdds()
    
    dt = datetime.now()

    events = con.execute('Select pinnacle_event_id, event_id from tbl_events WHERE pinnacle_event_id is not null and betbtc_event_id is not null and "StartDateTime" >= now()' )
    for event in events :
        print(event[0])
        setPinnacleEventOdds(pinnacle_odds, event[0], event[1], tbl_odds, con)
    
    events = con.execute('Select betbtc_event_id, event_id, home_player_name, away_player_name from tbl_events WHERE pinnacle_event_id is not null and betbtc_event_id is not null and "StartDateTime" >= now()' )
    for event in events :
        print(event[0])
        setBetBecEventOdds(event[0], event[1], event[2], event[3], tbl_odds, con)
              
        
#getOdds()        



    

    
    
    

    