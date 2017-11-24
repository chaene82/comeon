# -*- coding: utf-8 -*-
"""
Created on Wed Nov  1 14:27:52 2017

@author: haenec
"""

from sqlalchemy import create_engine, MetaData, select, update
from sqlalchemy.dialects.postgresql import insert
from datetime import datetime
import numpy as np
import math
from comeon_common import connect
from comeon_common import startBetLogging
from comeon_common import checkBetforPlace, placeBet

log = startBetLogging("laybet")
con, meta = connect()  
tbl_offer = meta.tables['tbl_offer']
tbl_events = meta.tables['tbl_events']


def calcLayOdds(back_odds=1.2, margin=0.1, invest=10) :
   # invest = 1
    
    back_stake = round(invest/back_odds, 2)
    max_lay = round(invest - back_stake, 2)
    lay_win = round(back_stake + (invest * margin), 2)
    odds_calc = (max_lay/lay_win) + 1
    if odds_calc < 2 :
        odds_round = round(odds_calc, 2)
    elif odds_calc < 6 :
        odds_round = math.floor(odds_calc *10 ) / 10
    else :
        odds_round = math.floor(odds_calc)
        
    # Testing Margin
    laybet_stakes = max_lay / (odds_round - 1) + max_lay
    win = laybet_stakes - invest
    calc_margin = win / invest
    
    if calc_margin > margin * 0.9 :
        return True, odds_round, laybet_stakes
    else:
        return False, 0, 0
    

def checkLayOdds(offerLayOdds, hedgeLayOdds, min_margin=0.05, invest=10) :
    status, odds, stake = calcLayOdds(hedgeLayOdds, min_margin, invest)
    if (status and odds >= offerLayOdds):
        log.info("laybet still okay")
        return True
    else :
        log.info("laybet no longer okay")
        return False        


calcLayOdds(1.735, 0.1, 10)
checkLayOdds(1.63, 1.68, 0.05, 10)








def placeSureBet(surebet_typ, event_id, surebet_id, home_odds_id, home_odds, home_stake, away_odds_id, away_odds, away_stake) :
    
    # get add required information
    
    log.debug("odds id " + str(home_odds_id))

    
    home_status = checkBetforPlace(home_odds_id, home_odds, home_stake)     
    away_status = checkBetforPlace(away_odds_id, away_odds, away_stake)
    
    if (home_stake <= away_stake) :
    
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
    dt = datetime.now()
    con, meta = connect()    
          
    tbl_odds = meta.tables['tbl_odds']
    
    
    #event_id = 362
    surebet_numbers = 0
    bettyps = [1]
    stake_total = 20
    margin = 0
    
    high_risk_margin = 0
    betbtc_margin = 4
    
    
    #ways = [1,2]
    bookies = [1,2]
    
    # Searching for Back surebets
    for bettyp in bettyps :
        for bookie in bookies :
    
            h = select([tbl_odds.columns.odds, tbl_odds.columns.odds_id])\
                      .where(tbl_odds.columns.event_id == event_id)\
                      .where(tbl_odds.columns.bettyp_id == bettyp)\
                      .where(tbl_odds.columns.bookie_id == bookie)\
                      .where(tbl_odds.columns.backlay == 1)\
                      .where(tbl_odds.columns.way == 1)            
                      
            h_odd = con.execute(h).fetchone()
            
            if h_odd == None or np.isnan(h_odd[0]) :
                continue
            
            for check_bookie in bookies :
                   
                a = select([tbl_odds.columns.odds, tbl_odds.columns.odds_id])\
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
                            home_return = (home_return - home_stake) * (1 - (betbtc_margin/100)) + home_stake
                        if check_bookie == 2 :
                            away_return = (away_return - away_stake) * (1 - (betbtc_margin/100)) + away_stake
                            
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
                                
                                surebetStatus = placeSureBet(surebet_typ, event_id, surebet_id, home_odds_id, home_odds, home_stake, away_odds_id, away_odds, away_stake)
                                
                                log.info("SureBet place? " + str(surebetStatus))  
                                
                                if surebetStatus :
                                    clause = update(tbl_surebet).where(tbl_surebet.columns.surebet_id == surebet_id).values(status=2)
                                    con.execute(clause) 
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
                                
                                surebetStatus = placeSureBet(surebet_typ, event_id, surebet_id, home_odds_id, home_odds, home_stake, away_odds_id, away_odds, away_stake)
                                
                                log.info("SureBet place? " + str(surebetStatus))  
                                
                                if surebetStatus :
                                    clause = update(tbl_surebet).where(tbl_surebet.columns.surebet_id == surebet_id).values(status=2)
                                    con.execute(clause) 
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
    con, meta = connect()  
    tbl_surebet = meta.tables['tbl_surebet']
    events = con.execute('Select event_id from tbl_events WHERE pinnacle_event_id is not null and betbtc_event_id is not null and "StartDateTime" >= now()' )
    for event in events :
        log.debug(event[0])
        searchSurebetEvent(event[0], tbl_surebet)
    
