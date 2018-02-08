#!/usr/bin/env py/thon3
# -*- coding: utf-8 -*-
"""
Script for look for events (an event is a Tennis Match)

@author: chrhae
"""

from sqlalchemy.dialects.postgresql import insert
from sqlalchemy import update
from datetime import datetime
import pandas as pd
from .betbtc import betbtc
from .Pinnacle import pinnacle
from .Matchbook import matchbook
from .Betdaq import betdaq
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

api_matchbook = matchbook()
api_betbtc = betbtc('back')
api_pinnacle = pinnacle()
api_betdaq = betdaq()


def checkPlayerExists(player_name, con) :
    
    
    sql = """
    Select event_player_id     
    from tbl_event_player   
    WHERE metaphone(pin_player_name, 12) = metaphone('{player_name}', 12) or 
    metaphone(betbtc_player_name, 12) = metaphone('{player_name}', 12) or 
    metaphone(matchbook_player_name, 12) = metaphone('{player_name}', 12) or 
    metaphone(betdaq_player_name, 12) = metaphone('{player_name}', 12) or 
    metaphone(betfair_player_name, 12) = metaphone('{player_name}', 12) or
    metaphone(left(pin_player_name, 1) || substring(pin_player_name, position(' ' in pin_player_name)), 12) = metaphone('{player_name}', 12) 

    """
    
    d = { 'player_name': player_name }
    
    sql = sql.format(**d)
    
    resultset = con.execute(sql).fetchone()
    
    if resultset == None :
        player_id = -1
    else :
        player_id = resultset[0]
    
    return player_id





def getPlayerId(player_name, con, bookie) :
    """ 
    use the player name to get a player id
    
    arg:
        player_name (str) a player name (as R Federer or Roger Federer)
    return:
        player_id
    
    """
    
    #get player_id, if it exists
    player_id = None
    
    player_name = player_name.replace("'","")
    
    if bookie == 'pinnacle' :
        player_id = con.execute("Select event_player_id from tbl_event_player WHERE pin_player_name = '" + str(player_name) + "'").fetchone()
    
        if player_id == None :
            log.info("New Player for Pinnacle " + str(player_name))
            
            player_id = checkPlayerExists(player_name, con)
            if (player_id == -1) :            
                stm = insert(tbl_event_player).values(pin_player_name=player_name)
                con.execute(stm)    
                player_id = con.execute("Select event_player_id from tbl_event_player WHERE pin_player_name = '" + str(player_name) + "'").fetchone()      
            
            else :
                stm = update(tbl_event_player).where(tbl_event_player.c.event_player_id == player_id).values(pin_player_name=player_name)
                con.execute(stm)   

    if bookie == 'betbtc' :
        player_id = con.execute("Select event_player_id from tbl_event_player WHERE betbtc_player_name = '" + str(player_name) + "'").fetchone()
       
    
        if player_id == None :
            log.info("New Player for betbtc " + str(player_name))
            
            player_id = checkPlayerExists(player_name, con)
            if (player_id == -1) :            
                stm = insert(tbl_event_player).values(betbtc_player_name=player_name)
                con.execute(stm)    
                player_id = con.execute("Select event_player_id from tbl_event_player WHERE betbtc_player_name = '" + str(player_name) + "'").fetchone()

            else :
                stm = update(tbl_event_player).where(tbl_event_player.c.event_player_id == player_id).values(betbtc_player_name=player_name)
                con.execute(stm)

    if bookie == 'matchbook' :
        player_id = con.execute("Select event_player_id from tbl_event_player WHERE matchbook_player_name = '" + str(player_name) + "'").fetchone()
       
    
        if player_id == None :
            log.info("New Player for matchbook " + str(player_name))
            
            player_id = checkPlayerExists(player_name, con)
            if (player_id == -1) :            
                stm = insert(tbl_event_player).values(matchbook_player_name=player_name)
                con.execute(stm)    
                player_id = con.execute("Select event_player_id from tbl_event_player WHERE matchbook_player_name = '" + str(player_name) + "'").fetchone()

            else :
                stm = update(tbl_event_player).where(tbl_event_player.c.event_player_id == player_id).values(matchbook_player_name=player_name)
                con.execute(stm)

    if bookie == 'betdaq' :
        player_id = con.execute("Select event_player_id from tbl_event_player WHERE betdaq_player_name = '" + str(player_name) + "'").fetchone()
       
    
        if player_id == None :
            log.info("New Player for betdaq " + str(player_name))
            
            player_id = checkPlayerExists(player_name, con)
            if (player_id == -1) :            
                stm = insert(tbl_event_player).values(betdaq_player_name=player_name)
                con.execute(stm)    
                player_id = con.execute("Select event_player_id from tbl_event_player WHERE betdaq_player_name = '" + str(player_name) + "'").fetchone()

            else :
                stm = update(tbl_event_player).where(tbl_event_player.c.event_player_id == player_id).values(betdaq_player_name=player_name)
                con.execute(stm)

                
    if type(player_id) != int :
        player_id = 0
    return player_id



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
                                           #home_player_name=row['home_player_name'], \
                                           #away_player_name=row['away_player_name'], \
                                           home_player_id=home_player_id, \
                                           away_player_id=away_player_id, \
                                           Live=row['live'], \
                                           LastUpdate=dt)

        clause = clause.on_conflict_do_update(
        index_elements=['StartDate', 'home_player_id','away_player_id'],
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
        index_elements=['StartDate', 'home_player_id','away_player_id'],
        set_=dict(betbtc_event_id=row['betbtc_event_id'], LastUpdate=dt)
        )
                
        con.execute(clause)
    
    elif bookie == 'matchbook' :
            
        clause = insert(tbl_events).values(matchbook_event_id=row['matchbook_event_id'], \
                                           StartDate=row['StartDate'], \
                                           StartDateTime=row['StartDateTime'], \
                                           betfair_event_id=row['betfair_event_id'], \
                                           #home_player_name=row['home_player_name'], \
                                           #away_player_name=row['away_player_name'], \
                                           home_player_id=home_player_id, \
                                           away_player_id=away_player_id, \
                                           LastUpdate=dt)
                
        clause = clause.on_conflict_do_update(
        index_elements=['StartDate', 'home_player_id','away_player_id'],
        set_=dict(matchbook_event_id=row['matchbook_event_id'], LastUpdate=dt)
        )
                
        con.execute(clause)
        
    elif bookie == 'betdaq' :
            
        clause = insert(tbl_events).values(betdaq_event_id=row['betdaq_event_id'], \
                                           StartDate=row['StartDate'], \
                                           StartDateTime=row['StartDateTime'], \
                                           betfair_event_id=row['betfair_event_id'], \
                                           #home_player_name=row['home_player_name'], \
                                           #away_player_name=row['away_player_name'], \
                                           home_player_id=home_player_id, \
                                           away_player_id=away_player_id, \
                                           LastUpdate=dt)
                
        clause = clause.on_conflict_do_update(
        index_elements=['StartDate', 'home_player_id','away_player_id'],
        set_=dict(betdaq_event_id=row['betdaq_event_id'], LastUpdate=dt)
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
        bookie_api = api_pinnacle
    elif bookie == "betbtc" :
        bookie_api = api_betbtc
    elif bookie == "matchbook" :
        bookie_api = api_matchbook          
    elif bookie == "betdaq" :
        bookie_api = api_betdaq      
        
    df_api_events =  bookie_api.getEvents()
    
    frames = [df_events, df_api_events]
    
    df_concat_events = pd.concat(frames)
    
    #Rename Bookue Column
    if bookie == "pinnacle" :
        df_concat_events.rename(columns={'bookie_event_id': 'pinnacle_event_id'}, inplace=True)
    elif bookie == "betbtc" :
        df_concat_events.rename(columns={'bookie_event_id': 'betbtc_event_id'}, inplace=True)
    elif bookie == "matchbook" :
        df_concat_events.rename(columns={'bookie_event_id': 'matchbook_event_id'}, inplace=True)
    elif bookie == "betdaq" :
        df_concat_events.rename(columns={'bookie_event_id': 'betdaq_event_id'}, inplace=True)        
    
    df_concat_events.apply((lambda x: updateEvents(x, bookie, tbl_events, con)), axis=1)
    
       
        
def getEvents() :        
    ## create, updated events
        
            
    bookies = ['betbtc', 'pinnacle', 'matchbook', 'betdaq']
    
    for bookie in bookies :
        log.info("bookie : " + bookie)
        getBookieEvents(bookie)



## This function us just for a release update:
def updateEventsPlayerID():
    events = con.execute('Select event_id, home_player_name, away_player_name from tbl_events WHERE home_player_id is null or away_player_id is null' )
    
    for event in events :
        log.info("update players on the event " + str(event[0]))
        event_id = event[0]
        
        home_player_id = getPlayerId(str(event[1]), con, 'pinnalce')
        away_player_id = getPlayerId(str(event[2]), con, 'pinnalce')    
        
        stm = update(tbl_events).where(tbl_events.c.event_id == event_id).values(home_player_id=home_player_id,away_player_id=away_player_id)
        con.execute(stm)        
    