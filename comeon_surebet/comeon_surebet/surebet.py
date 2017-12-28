# -*- coding: utf-8 -*-
"""
Created on Wed Nov  1 14:27:52 2017

@author: haenec
"""

from sqlalchemy import select, update
from sqlalchemy.dialects.postgresql import insert
from datetime import datetime
import numpy as np
from comeon_common import connect, getBtcEurPrice
from comeon_common import startBetLogging
from comeon_common import checkBetforPlace, placeBet

# load data from the configuration
import yaml
with open("config.yml", 'r') as ymlfile:
    cfg = yaml.load(ymlfile)

log = startBetLogging("surebet")
con, meta = connect()  
tbl_surebet = meta.tables['tbl_surebet']
tbl_events = meta.tables['tbl_events']



def checkStake(market_stake, bookie_stake, max_market_stake_btc):
    max_market_stake_btc = float(max_market_stake_btc) * getBtcEurPrice()
    if market_stake < max_market_stake_btc :
        return market_stake, bookie_stake
    elif market_stake >= max_market_stake_btc :
        new_market_stake = round(max_market_stake_btc - 1, 2)
        new_bookie_stake = round(bookie_stake * (new_market_stake / market_stake),2)
        return new_market_stake, new_bookie_stake
        


def placeSureBet(surebet_typ, event_id, surebet_id, home_odds_id, home_odds, home_stake, away_odds_id, away_odds, away_stake, home_bookie=0, away_bookie=0) :
    """
    Place a surebet on the selected bookies
     
    Args:
        surebet_typ (int): The type of the surebet  
        event_id (int): The event, on which the surebet is placed    
        surebet_id (int): ID of the surebet.    
        home_odds_id (int): home bet odds id
        away_odds_id (int): away bet odds id
        home_odds (float): home odds
        away_odds (float): away odds
        home_stake (float): home stakes
        away_stake (float): away away stakes       
        home_bookie (int): home booke id
        away_bookie (id): away bookie id
        
    Returns:
        True: if successful
        False: if there was an error
        
    """    
    # get add required information
    
    log.debug("odds id " + str(home_odds_id))

    
    home_status = checkBetforPlace(home_odds_id, home_odds, home_stake)     
    away_status = checkBetforPlace(away_odds_id, away_odds, away_stake)
    
    if home_bookie >= 2 :
        if home_status and away_status :
            home_bet_status = placeBet(home_odds_id, home_odds, home_stake, product_id=surebet_typ, surebet_id=surebet_id) 
            if home_bet_status :
                away_bet_status = placeBet(away_odds_id, away_odds, away_stake, product_id=surebet_typ, surebet_id=surebet_id) 
                if away_bet_status :
                    return True
                
    elif away_bookie >= 2 :
        if home_status and away_status :
            away_bet_status = placeBet(away_odds_id, away_odds, away_stake, product_id=surebet_typ, surebet_id=surebet_id) 
            if away_bet_status :
                home_bet_status = placeBet(home_odds_id, home_odds, home_stake, product_id=surebet_typ, surebet_id=surebet_id) 
                if home_bet_status :
                    return True
                
    elif (home_stake <= away_stake) :
    
        if home_status and away_status :
            home_bet_status = placeBet(home_odds_id, home_odds, home_stake, product_id=surebet_typ, surebet_id=surebet_id) 
            if home_bet_status :
                away_bet_status = placeBet(away_odds_id, away_odds, away_stake, product_id=surebet_typ, surebet_id=surebet_id) 
                if away_bet_status :
                    return True
    else :
        if home_status and away_status :
            away_bet_status = placeBet(away_odds_id, away_odds, away_stake, product_id=surebet_typ, surebet_id=surebet_id) 
            if away_bet_status :
                home_bet_status = placeBet(home_odds_id, home_odds, home_stake, product_id=surebet_typ, surebet_id=surebet_id) 
                if home_bet_status :
                    return True
    return False

def searchSurebetEvent(event_id, tbl_surebet) :
    """
    Search for a surebet event and if found, place it
     
    Args:
        event_id (int): The event, on which the surebet is placed    
        tbl_surebet (table): the table object for the tbl_surebet   

        
    Returns:
        True: if successful
        False: if there was an error
        
    """        
    
    dt = datetime.now()
    con, meta = connect()    
          
    tbl_odds = meta.tables['tbl_odds']
    
    
    #event_id = 362
    surebet_numbers = 0
    bettyps = [1]
    stake_total = cfg['surebet']['stake_total']
    margin = cfg['surebet']['margin']
    
    high_risk_margin = cfg['surebet']['high_risk_margin']
    betbtc_margin = cfg['surebet']['betbtc_margin']
    
    
    #ways = [1,2]
    bookies = [1,2]
    
    # Searching for Back surebets
    for bettyp in bettyps :
        for bookie in bookies :
    
            h = select([tbl_odds.columns.odds, tbl_odds.columns.odds_id, tbl_odds.columns.max_stake])\
                      .where(tbl_odds.columns.event_id == event_id)\
                      .where(tbl_odds.columns.bettyp_id == bettyp)\
                      .where(tbl_odds.columns.bookie_id == bookie)\
                      .where(tbl_odds.columns.backlay == 1)\
                      .where(tbl_odds.columns.way == 1)            
                      
            h_odd = con.execute(h).fetchone()
            
            if h_odd == None or np.isnan(h_odd[0]) :
                continue
            
            for check_bookie in bookies :
                   
                a = select([tbl_odds.columns.odds, tbl_odds.columns.odds_id, tbl_odds.columns.max_stake])\
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
                
                home_odds_id = h_odd[1]
                away_odds_id = a_odd[1]
                
                if not isinstance(home_odds, float) : home_odds = np.nan
                if not isinstance(away_odds, float) : away_odds = np.nan
                
                surebet = (1 / home_odds) +  (1 / away_odds)
                               
                if surebet < 1 :
                    log.info("surebet on event" + str(event_id))
                    log.info("home odds " + str(h_odd[0]) + " " + str(bookie) )
                    log.info("away odds " + str(a_odd[0]) + " " + str(check_bookie))    
                    
                    log.info("sure bet" + str((1 - surebet) * 100))
                    
                    if ((1 - surebet) * 100) > margin :
                    
                        home_prob = (1/surebet) / home_odds
                        away_prob = (1/surebet) / away_odds
                        
                                    
                        
                        home_stake = round(stake_total * home_prob,1)
                        away_stake = round(stake_total * away_prob,1)
                        
                        home_return = home_stake * home_odds
                        away_return = away_stake * away_odds
                        
                        log.info("home stake " + str(home_stake))
                        log.info("away stake " + str(away_stake))   
                        log.info("home return " + str(home_return))
                        log.info("away return " + str(away_return))  
                        log.info("home prop " + str(home_prob))
                        log.info("away prop " + str(away_prob))         
                        log.info("Home Odds " + str(home_odds_id))
                        log.info("Away Odds " + str(away_odds_id))                            

                        if bookie == 2 :
                            home_stake, away_stake = checkStake(home_stake, away_stake, h_odd[2])
                            home_return = (home_return - home_stake) * (1 - (betbtc_margin/100)) + home_stake
                        if check_bookie == 2 :
                            away_stake, home_stake  = checkStake(away_stake, home_stake, a_odd[2])
                            away_return = (away_return - away_stake) * (1 - (betbtc_margin/100)) + away_stake
                                          
                        stake_total = home_stake + away_stake                               
                            
                        theoretical_winnings = (home_return * home_prob) + (away_return * away_prob)
                            
                        log.info("Theoretical Winnings " + str(theoretical_winnings))
                            
                        if min(home_return, away_return) - (stake_total) > 0 :

                            log.info("min profit " + str(min(home_return, away_return) - (stake_total) ))
                            log.info("max profit " + str(max(home_return, away_return) - (stake_total) ))
                            
                        
                            
                            surebet_sql = select([tbl_surebet.c.event_id]).where(tbl_surebet.columns.event_id == event_id).where(tbl_surebet.columns.status == 1)
                            db_surebet_id = con.execute(surebet_sql).fetchone() 
                            surebet_typ=1
                            
                            if db_surebet_id == None :
                            
                                clause = insert(tbl_surebet).returning(tbl_surebet.columns.surebet_id).values(event_id=event_id, \
                                                   home_bookie_id=bookie, \
                                                   away_bookie_id=check_bookie, \
                                                   home_odds=home_odds, \
                                                   away_odds=away_odds, \
                                                   min_profit=round((min(home_return, away_return) - (stake_total) ),2), \
                                                   max_profit=round((max(home_return, away_return) - (stake_total) ),2), \
                                                   status=1,\
                                                   theoretical_winnings=theoretical_winnings,\
                                                   surebet_typ=surebet_typ,\
                                                   update=dt)
                                log.info("store to database")                                 
                                result = con.execute(clause)  
                                
                                for id in result :
                                    surebet_id = id[0]
                                
                                log.info("Surebet ID " + str(surebet_id))  
                                
                                surebetStatus = placeSureBet(surebet_typ, event_id, surebet_id, home_odds_id, home_odds, home_stake, away_odds_id, away_odds, away_stake, bookie, check_bookie)
                                
                                log.info("SureBet place? " + str(surebetStatus))  
                                
                                if surebetStatus :
                                    clause = update(tbl_surebet).where(tbl_surebet.columns.surebet_id == surebet_id).values(status=2)
                                    con.execute(clause) 
                                    log.warning("SureBet place in the event " + str(event_id))  

                                else :
                                    clause = update(tbl_surebet).where(tbl_surebet.columns.surebet_id == surebet_id).values(status=6)                              
                                    con.execute(clause) 
                                

                            else :
                               log.info("already exists in the database")
                                
                        elif (theoretical_winnings - (stake_total)) / (stake_total) * 100 > high_risk_margin :   
                            
                            log.info("high risk surebet found " + str(theoretical_winnings))
                            log.info("min profit " + str(min(home_return, away_return) - (stake_total) ))
                            log.info("max profit " + str(max(home_return, away_return) - (stake_total) ))                             

                            surebet_sql = select([tbl_surebet.c.event_id]).where(tbl_surebet.columns.event_id == event_id).where(tbl_surebet.columns.status == 1).where(tbl_surebet.columns.surebet_typ == 2)
                            db_surebet_id = con.execute(surebet_sql).fetchone() 
                            surebet_typ=2                            
                            
                            if db_surebet_id == None :
                            
                                clause = insert(tbl_surebet).returning(tbl_surebet.columns.surebet_id).values(event_id=event_id, \
                                                   home_bookie_id=bookie, \
                                                   away_bookie_id=check_bookie, \
                                                   home_odds=home_odds, \
                                                   away_odds=away_odds, \
                                                   min_profit=round((min(home_return, away_return) - (stake_total) ),2), \
                                                   max_profit=round((max(home_return, away_return) - (stake_total) ),2), \
                                                   status=1,\
                                                   theoretical_winnings=theoretical_winnings,\
                                                   surebet_typ=surebet_typ,\
                                                   update=dt)
                                
                                
                                log.info("store to database")                                 
                                result = con.execute(clause)  
                                
                                for id in result :
                                    surebet_id = id[0]
                                
                                log.info("Surebet ID " + str(surebet_id))  
                                
                                surebetStatus = placeSureBet(surebet_typ, event_id, surebet_id, home_odds_id, home_odds, home_stake, away_odds_id, away_odds, away_stake, bookie, check_bookie)
                                
                                log.info("SureBet place? " + str(surebetStatus))  
                                
                                if surebetStatus :
                                    clause = update(tbl_surebet).where(tbl_surebet.columns.surebet_id == surebet_id).values(status=2)
                                    con.execute(clause) 
                                    log.warning("SureBet place in the event " + str(event_id))  

                                else :
                                    clause = update(tbl_surebet).where(tbl_surebet.columns.surebet_id == surebet_id).values(status=6)                              
                                    con.execute(clause) 
                                    
                            else :
                                log.info("already exists in the database")                            
                        
                        else :
                            
                            surebet_sql = select([tbl_surebet.c.event_id]).where(tbl_surebet.columns.event_id == event_id).where(tbl_surebet.columns.status == 5)
                            db_surebet_id = con.execute(surebet_sql).fetchone() 
                            log.info("No winnings after commissions !")
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
                                log.info("store to database")
                            else :
                                log.info("already exists in the database")    

                            
                        
                        surebet_numbers = surebet_numbers + 1
                    else :
                        log.info("sure bet to small !")
         
                    

    
    if surebet_numbers == 0 :
        log.info("no surebet found for event " + str(event_id))



def searchSurebet() :
    """
    Search for open events with more then one matching bookie
     
    Args:
        -
        
    Returns:
        -
        
    """  
    con, meta = connect()  
    tbl_surebet = meta.tables['tbl_surebet']
    events = con.execute('Select event_id from tbl_events WHERE pinnacle_event_id is not null and betbtc_event_id is not null and "StartDateTime" >= now()' )
    for event in events :
        log.debug(event[0])
        searchSurebetEvent(event[0], tbl_surebet)
        
    log.info("no more events for a surebet")
    
