#!/usr/bin/env py/thon3
# -*- coding: utf-8 -*-
"""
Script for look for events (an event is a Tennis Match)

@author: chrhae
"""

from sqlalchemy.dialects.postgresql import insert
from datetime import datetime
from .betbtc import getBetBtcEventData, getBetBtcMaketOdds
from .Pinnacle import getPinnacleEventData, getPinnacleEventOdds
from .base import connect, startBetLogging, removeTime


log = startBetLogging("Events")




def setBetBtcEvents(betbtc_event, tbl_events, con) :
    """
    Look from the output of the betbet event json, read events and store it to 
    the database
    
    Args:
        betbtc_event (json): The list of all events from betbtc
        tbl_events (:obj:`table`): The table object.
        con: the database connection

    Returns:


    ToDo:
        Change to a better wrapper funtion
    
    
    """
    dt = datetime.now()
    for event in betbtc_event :
        # looking for Match Odds
        if event[7] == "Match Odds" :
            log.info("betbtc_event_id "  + str(event[0]))
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
    """
    Look from the output of the pinnacle event json, read events and store it to 
    the database
    
    Args:
        pinnacle_event (json): The list of all events from pinnacle
        tbl_events (:obj:`table`): The table object.
        con: the database connection

    Returns:


    ToDo:
        Change to a better wrapper funtion
    
    
    """
    dt = datetime.now()
    for league in pinnacle_event['league'] :
        league_id = league['id']
        for event in league['events'] :
            if not "Set" in (event['home']) or not "Set" in (event['away']) : 
                log.info("pinnacle_event_id " + str(event['id']))
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
    """
    A function to get all open events from the bookie
    
    Args:
        

    Returns:


    ToDo:
        Change to a better wrapper funtion
    
    
    """
           
    con, meta = connect()    
    
    
    tbl_events = meta.tables['tbl_events']
    
    betbtc_event = getBetBtcEventData()
    setBetBtcEvents(betbtc_event, tbl_events, con) 
                
    pinnacle_event = getPinnacleEventData()
    setPinnacleEvents(pinnacle_event, tbl_events, con)       
        
     

#getEvents()
    
    
    

    