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


           
con, meta = connect()        
    
tbl_events = meta.tables['tbl_events']
tbl_event_player = meta.tables['tbl_event_player']


def checkPlayerExists(player_name, con) :
    
    
    sql = """
    Select event_player_id     
    from tbl_event_player   
    WHERE metaphone(pin_player_name, 12) = metaphone('{player_name}', 12)
    """
    
    d = { 'player_name': player_name }
    
    sql = sql.format(**d)
    
    resultset = con.execute(sql).fetchone()
    
    if resultset == None :
        player_id = -1
    else :
        player_id = resultset[0]
    
    return player_id


checkPlayerExists("Roger Federer", con)
checkPlayerExists("Rolf Federer", con)



def getPlayerId(player_name, con, bookie) :
    """ 
    use the player name to get a player id
    
    arg:
        player_name (str) a player name (as R Federer or Roger Federer)
    return:
        player_id or -1 if not matches
    
    """
    
    #get player_id, if it exists
    
    if bookie == 'pinnacle' :
        player_id = con.execute("Select event_player_id from tbl_event_player WHERE pin_player_name = '" + str(player_name) + "'").fetchone()
       
    
        if player_id == None :
            log.info("New Player for Pinnacle " + str(player_name))
            
            stm = insert(tbl_event_player).values(pin_player_name=player_name)
            con.execute(stm)    
            player_id = con.execute("Select event_player_id from tbl_event_player WHERE pin_player_name = '" + str(player_name) + "'").fetchone()


    return player_id[0]

def updateEvents(row, bookie, tbl_events, con) :
    """    
    
    """
    dt = datetime.now()
    
    
    home_player_id = getPlayerId(row['home_player_name'], con, bookie)
    away_player_id = getPlayerId(row['away_player_name'], con, bookie)
    
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

    