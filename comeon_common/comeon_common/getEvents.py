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



"""
To Do:
    
- Check if Event exists before checking Player
- Add Player to the table it it not exists
- Check Player with strange Character (Quotes)

"""



def getPlayerId(player_name, con) :
    """ 
    use the player name to get a player id
    
    arg:
        player_name (str) a player name (as R Federer or Roger Federer)
    return:
        player_id or -1 if not matches
    
    """
    search_char = 12
    
    string_name = ' '.join(reversed(player_name.split(' ')))
    
    resultset = con.execute("Select player_id, name_long, name_short from tbl_player WHERE metaphone(name_short, " + str(search_char) + ") = metaphone('" + string_name + "', " + str(search_char) + ")" ).fetchall()
    if len(resultset) == 0 :
        resultset = con.execute("Select player_id, name_long, name_short from tbl_player WHERE metaphone(name_long, " + str(search_char) + ") = metaphone('" + string_name + "', " + str(search_char) + ")" ).fetchall()
    if len(resultset) == 1 :
        ## Good match
        id = resultset[0][0]
        print(id)
        return id
    else:
        return -1



def updateEvents(row, bookie, tbl_events, con) :
    """    
    
    """
    dt = datetime.now()
    
    
    home_player_id = getPlayerId(row['home_player_name'], con)
    away_player_id = getPlayerId(row['away_player_name'], con)
    
    print ("home player id", home_player_id)
    print ("away player id", away_player_id)
        
    
    if bookie == 'pinnacle' :
        clause = insert(tbl_events).values(pinnacle_event_id=row['pinnacle_event_id'], \
                                           pinnacle_league_id=row['pinnacle_league_id'],\
                                           StartDate=row['StartDate'], \
                                           StartDateTime=row['StartDateTime'], \
                                           home_player_name=row['home_player_name'], \
                                           away_player_name=row['away_player_name'], \
                                           home_player_id=home_player_id, \
                                           away_player_id=away_player_id, \
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
                                           home_player_id=home_player_id, \
                                           away_player_id=away_player_id, \
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
    #print (bookie)
    if bookie == "pinnacle" :
        bookie_api = pinnacle()
    elif bookie == "betbtc" :
        bookie_api = betbtc('back')        
        
    df_api_events =  bookie_api.getEvents()
    
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
        log.info("bookie : " + bookie)
        getBookieEvents(bookie)

    