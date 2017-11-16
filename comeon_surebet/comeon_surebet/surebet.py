# -*- coding: utf-8 -*-
"""
Created on Wed Nov  1 14:27:52 2017

@author: haenec
"""

from sqlalchemy import create_engine, MetaData, select
from sqlalchemy.dialects.postgresql import insert
from datetime import datetime
import numpy as np
from comeon_common import connect



def searchSurebetEvent(event_id, tbl_surebet) :
    dt = datetime.now()
    con, meta = connect()    
          
    tbl_odds = meta.tables['tbl_odds']
    
    
    #event_id = 362
    surebet_numbers = 0
    bettyps = [1]
    stake_total = 100
    margin = 0.25
    
    high_risk_margin = 1
    betbtc_margin = 4
    
    
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
                        print("home prop ", home_prob)
                        print("away prop ", away_prob)                        

                        if bookie == 2 :
                            home_return = (home_return - home_stake) * (1 - (betbtc_margin/100)) + home_stake
                        if check_bookie == 2 :
                            away_return = (away_return - away_stake) * (1 - (betbtc_margin/100)) + away_stake
                            
                        theoretical_winnings = (home_return * home_prob) + (away_return * away_prob)
                            
                        print("Theoretical Winnings ", theoretical_winnings)
                            
                        if min(home_return, away_return) - (stake_total) > 0 :

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
                                                   theoretical_winnings=theoretical_winnings,\
                                                   surebet_typ=1,\
                                                   update=dt)
                                
                                
                                con.execute(clause)  
                                
                                print("store to database")
                            else :
                                print("already exists in the database")
                                
                        elif (theoretical_winnings - (stake_total)) / (stake_total) * 100 > high_risk_margin :   
                            
                            print("high risk surebet found ", theoretical_winnings)
                            print("min profit ", min(home_return, away_return) - (stake_total) )
                            print("max profit ", max(home_return, away_return) - (stake_total) )                             

                            surebet_sql = select([tbl_surebet.c.event_id]).where(tbl_surebet.columns.event_id == event_id).where(tbl_surebet.columns.status == 1).where(tbl_surebet.columns.surebet_typ == 2)
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
                                                   theoretical_winnings=theoretical_winnings,\
                                                   surebet_typ=2,\
                                                   update=dt)
                                
                                
                                con.execute(clause)  
                                
                                print("store to database")
                            else :
                                print("already exists in the database")                            
                        
                        else :
                            
                            surebet_sql = select([tbl_surebet.c.event_id]).where(tbl_surebet.columns.event_id == event_id).where(tbl_surebet.columns.status == 5)
                            db_surebet_id = con.execute(surebet_sql).fetchone() 
                            print("No winnings after commissions !")
                            if db_surebet_id == None :
                            
                                clause = insert(tbl_surebet).values(event_id=event_id, \
                                                   home_bookie_id=bookie, \
                                                   away_bookie_id=check_bookie, \
                                                   home_odds=home_odds, \
                                                   away_odds=away_odds, \
                                                   min_profit=round((min(home_return, away_return) - (stake_total) ),2), \
                                                   max_profit=round((max(home_return, away_return) - (stake_total) ),2), \
                                                   status=5,\
                                                   theoretical_winnings=theoretical_winnings,update=dt)
                                
                                
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
    con, meta = connect()  
    tbl_surebet = meta.tables['tbl_surebet']
    events = con.execute('Select event_id from tbl_events WHERE pinnacle_event_id is not null and betbtc_event_id is not null and "StartDateTime" >= now()' )
    for event in events :
        print(event[0])
        searchSurebetEvent(event[0], tbl_surebet)
    
