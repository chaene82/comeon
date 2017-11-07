# -*- coding: utf-8 -*-
"""
Created on Wed Nov  1 14:27:52 2017

@author: haenec
"""

from sqlalchemy import create_engine, MetaData, select
from sqlalchemy.dialects.postgresql import insert
from datetime import datetime
import numpy as np
from .tennis_config import *


def connect(db, user, password, host='localhost', port=5433):
    '''Returns a connection and a metadata object'''
    # We connect with the help of the PostgreSQL URL
    # postgresql://federer:grandestslam@localhost:5432/tennis
    url = 'postgresql://{}:{}@{}:{}/{}'
    url = url.format(user, password, host, port, db)

    # The return value of create_engine() is our connection object
    con = create_engine(url, client_encoding='utf8')

    # We then bind the connection to MetaData()
    meta = MetaData()
    meta.reflect(con)

    return con, meta


def searchSurebetEvent(event_id, tbl_surebet) :
    dt = datetime.now()
    con, meta = connect(pg_db, pg_user, pg_pwd, pg_host, pq_port)    
          
    tbl_odds = meta.tables['tbl_odds']
    
    
    #event_id = 362
    surebet_numbers = 0
    bettyps = [1]
    stake_total = 100
    margin = 0
    
    #ways = [1,2]
    bookies = [1,2]
    
    # Searching for Back surebets
    for bettyp in bettyps :
        for bookie in bookies :
    
            h = select([tbl_odds.columns.odds])\
                      .where(tbl_odds.columns.event_id == event_id)\
                      .where(tbl_odds.columns.bettyp_id == bettyp)\
                      .where(tbl_odds.columns.bookie_id == bookie)\
                      .where(tbl_odds.columns.backlay == 1)\
                      .where(tbl_odds.columns.way == 1)            
                      
            h_odd = con.execute(h).fetchone()  
            
            if h_odd == None or np.isnan(h_odd[0]) :
                continue
            
            for check_bookie in bookies :
                   
                a = select([tbl_odds.columns.odds])\
                          .where(tbl_odds.columns.event_id == event_id)\
                          .where(tbl_odds.columns.bettyp_id == bettyp)\
                          .where(tbl_odds.columns.bookie_id == check_bookie)\
                          .where(tbl_odds.columns.backlay == 1)\
                          .where(tbl_odds.columns.way == 2)            
                      
                a_odd = con.execute(a).fetchone()   
               
                if a_odd == None or np.isnan(a_odd[0]) :
                    continue
                
                home_odds = h_odd[0]
                away_odds = a_odd[0]
                
                if not isinstance(home_odds, float) : home_odds = np.nan
                if not isinstance(away_odds, float) : away_odds = np.nan
                
                surebet = (1 / home_odds) +  (1 / away_odds)
                               
                if surebet < 1 :
                    print("surebet on event", event_id)
                    print("home odds", h_odd[0], bookie, )
                    print("away odds", a_odd[0], check_bookie)    
                    
                    print("sure bet", (1 - surebet) * 100)
                    
                    if ((1 - surebet) * 100) > margin :
                    
                        home_prob = (1/surebet) / home_odds
                        away_prob = (1/surebet) / away_odds
                                    
                        
                        home_stake = round(stake_total * home_prob,1)
                        away_stake = round(stake_total * away_prob,1)
                        
                        home_return = home_stake * home_odds
                        away_return = away_stake * away_odds
                        
                        print("home stake ", home_stake)
                        print("away stake ", away_stake)   
                        print("home return ", home_return)
                        print("away return ", away_return)  

                        if bookie == 2 :
                            home_return = home_return * 0.96
                        if check_bookie == 2 :
                            away_return = away_return * 0.96
                            
                        if min(home_return, away_return) - (stake_total) > 0 :
                        
                            print("home stake ", home_stake)
                            print("away stake ", away_stake)   
                            print("home return ", home_return)
                            print("away return ", away_return)  
                            
                            print("min profit ", min(home_return, away_return) - (stake_total) )
                            print("max profit ", max(home_return, away_return) - (stake_total) ) 
                            
                            surebet_sql = select([tbl_surebet.c.event_id]).where(tbl_surebet.columns.event_id == event_id).where(tbl_surebet.columns.status == 1)
                            db_surebet_id = con.execute(surebet_sql).fetchone() 
                            
                            if db_surebet_id == None :
                            
                                clause = insert(tbl_surebet).values(event_id=event_id, \
                                                   home_bookie_id=bookie, \
                                                   away_bookie_id=check_bookie, \
                                                   home_odds=home_odds, \
                                                   away_odds=away_odds, \
                                                   min_profit=round((min(home_return, away_return) - (stake_total) ),2), \
                                                   max_profit=round((max(home_return, away_return) - (stake_total) ),2), \
                                                   status=1,\
                                                   update=dt)
                                
                                
                                con.execute(clause)  
                                
                                print("store to database")
                            else :
                                print("already exists in the database")
                        
                        else :
                            
                            surebet_sql = select([tbl_surebet.c.event_id]).where(tbl_surebet.columns.event_id == event_id).where(tbl_surebet.columns.status == 5)
                            db_surebet_id = con.execute(surebet_sql).fetchone() 
                            print("No winnings after comision !")
                            if db_surebet_id == None :
                            
                                clause = insert(tbl_surebet).values(event_id=event_id, \
                                                   home_bookie_id=bookie, \
                                                   away_bookie_id=check_bookie, \
                                                   home_odds=home_odds, \
                                                   away_odds=away_odds, \
                                                   min_profit=round((min(home_return, away_return) - (stake_total) ),2), \
                                                   max_profit=round((max(home_return, away_return) - (stake_total) ),2), \
                                                   status=5,\
                                                   update=dt)
                                
                                
                                con.execute(clause) 
                                print("store to database")
                            else :
                                print("already exists in the database")    

                            
                        
                        surebet_numbers = surebet_numbers + 1
                    else :
                        print("sure bet to small !")
         
                    

    
    if surebet_numbers == 0 :
        print("no surebet found for event", event_id)


def searchSurebet() :
    con, meta = connect(pg_db, pg_user, pg_pwd, pg_host, pq_port)  
    tbl_surebet = meta.tables['tbl_surebet']
    events = con.execute('Select event_id from tbl_events WHERE pinnacle_event_id is not null and betbtc_event_id is not null and "StartDateTime" >= now()' )
    for event in events :
        print(event[0])
        searchSurebetEvent(event[0], tbl_surebet)
    
