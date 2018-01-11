#!/usr/bin/env py/thon3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct 12 17:53:37 2017

@author: chrhae
"""

from sqlalchemy.dialects.postgresql import insert
from datetime import datetime
import pandas as pd
import numpy as np
from .betbtc import betbtc
from .Pinnacle import pinnacle
from .Matchbook import matchbook
from .Betdaq import betdaq
from .base import connect, startBetLogging


log = startBetLogging("getOdds")
dt = datetime.now()
  
api_betbtc = betbtc('back')
api_pinnacle = pinnacle()
api_matchbook = matchbook()
api_betdaq = betdaq()


def updateOdds(row, tbl_odds, conn):

    clause = insert(tbl_odds).values(event_id=row['event_id'], \
                                   bettyp_id = row['bettype'], \
                                   way = row['way'], \
                                   bookie_id = row['bookie_id'], \
                                   backlay = row['backlay'],\
                                   odds= row['odds'], \
                                   pin_line_id= row['pin_line_id'], \
                                   max_stake= row['maxStake'], \
                                   odds_update=dt) 

    clause = clause.on_conflict_do_update(
    index_elements=['event_id', 'bettyp_id','way','bookie_id','backlay'],
    set_=dict(odds=row['odds'],pin_line_id=row['pin_line_id'],max_stake= row['maxStake'],odds_update=dt)
    )
    
    conn.execute(clause)  

                
                    


def getOdds() :
    """
    Look for open odds
    
    Args:

    Returns:


    ToDo:
        Change to a better wrapper funtion
        Change it on this way, that it's could be called by a event ID
    
    
    """    
           
    con, meta = connect()    
      
    tbl_odds = meta.tables['tbl_odds']

    

    events = con.execute('Select event_id, betbtc_event_id, pinnacle_event_id, home_player_name, away_player_name, matchbook_event_id. betdaq_event_id  from tbl_events WHERE pinnacle_event_id is not null and betbtc_event_id is not null and "StartDateTime" >= now()' )
    for event in events :
        log.info("Looking for odds on the event " + str(event[0]))
        df_betbtc   = api_betbtc.getOdds(event[1], event[3], event[4])
        df_betbtc['bookie_id'] = 2
        df_pinnacle = api_pinnacle.getOdds(event[2])
        df_pinnacle['bookie_id'] = 1  
        df_matchbook = api_matchbook.getOdds(event[5])
        df_matchbook['bookie_id'] = 5 
        df_betdaq = betdaq.getOdds(event[6])
        df_betdaq['bookie_id'] = 3                  
                   
        frames = [df_betbtc, df_pinnacle, df_matchbook, df_betdaq]
    
        df_concat_odds = pd.concat(frames)
        df_concat_odds['event_id'] = event[0]
                   
        df_concat_odds.apply((lambda x: updateOdds(x, tbl_odds, con)), axis=1)
                   
        
        #setPinnacleEventOdds(pinnacle_odds, event[0], event[1], tbl_odds, con)   
        
    log.info("no more events")
              
        
#getOdds()        



    

    
    
    

    