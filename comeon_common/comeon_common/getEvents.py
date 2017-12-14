#!/usr/bin/env py/thon3
# -*- coding: utf-8 -*-
"""
Script for look for events (an event is a Tennis Match)

@author: chrhae
"""

from sqlalchemy.dialects.postgresql import insert
from datetime import datetime
import pandas as pd
from .betbtc import betbtc
from .Pinnacle import pinnacle
from .base import connect, startBetLogging, removeTime

log = startBetLogging("Events")





def updateEvents(row, bookie, tbl_events, con) :
    """    
    
    """
    dt = datetime.now()
    
    if bookie == 'pinnacle' :
        clause = insert(tbl_events).values(pinnacle_event_id=row['pinnacle_event_id'], \
                                           pinnacle_league_id=row['pinnacle_league_id'],\
                                           StartDate=row['StartDate'], \
                                           StartDateTime=row['StartDateTime'], \
                                           home_player_name=row['home_player_name'], \
                                           away_player_name=row['away_player_name'], \
                                           Live=row['live'], \
                                           LastUpdate=dt)

        clause = clause.on_conflict_do_update(
        index_elements=['StartDate', 'home_player_name','away_player_name'],
        set_=dict(pinnacle_event_id=row['pinnacle_event_id'], pinnacle_league_id=row['pinnacle_league_id'], Live=row['live'] ,LastUpdate=dt)
        )
        
        con.execute(clause)          
        
    elif bookie == 'betbtc' :
            
        clause = insert(tbl_events).values(betbtc_event_id=row['betbtc_event_id'], \
                                           StartDate=row['StartDate'], \
                                           StartDateTime=row['StartDateTime'], \
                                           betfair_event_id=row['betfair_event_id'], \
                                           home_player_name=row['home_player_name'], \
                                           away_player_name=row['away_player_name'], \
                                           LastUpdate=dt)
                
        clause = clause.on_conflict_do_update(
        index_elements=['StartDate', 'home_player_name','away_player_name'],
        set_=dict(LastUpdate=dt)
        )
                
        con.execute(clause)


def getBookieEvents(bookie) :
    """
    A function to get all open events from the bookie
    
    Args:
        

    Returns:


    ToDo:
        Change to a better wrapper funtion
    
    
    """
           
    con, meta = connect()        
    
    tbl_events = meta.tables['tbl_events']
    
    # get a full dataframe
    
    df_events = pd.DataFrame(columns=['bookie_event_id', 'StartDate', 'StartDateTime', 'home_player_name', 'away_player_name', 'live', 'pinnacle_league_id', 'betfair_event_id'])
    
   
    ## Get List with events
    print (bookie)
    if bookie == "pinnacle" :
        api = pinnacle()
    elif bookie == "betbtc" :
        api = betbtc('back')        
        
    df_api_events =  api.getEvents()
    
    frames = [df_events, df_api_events]
    
    df_concat_events = pd.concat(frames)
    
    #Rename Bookue Column
    if bookie == "pinnacle" :
        df_concat_events.rename(columns={'bookie_event_id': 'pinnacle_event_id'}, inplace=True)
    elif bookie == "betbtc" :
        df_concat_events.rename(columns={'bookie_event_id': 'betbtc_event_id'}, inplace=True)
    
    df_concat_events.apply((lambda x: updateEvents(x, bookie, tbl_events, con)), axis=1)
    
       
        
def getEvents() :        
    ## create, updated events
        
            
    bookies = ['betbtc', 'pinnacle']
    
    for bookie in bookies :
        getBookieEvents(bookie)

    