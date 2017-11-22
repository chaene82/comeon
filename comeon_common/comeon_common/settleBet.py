# -*- coding: utf-8 -*-
"""
Created on Thu Nov 16 12:31:14 2017

@author: haenec
"""

from .betbtc import placeBetBtcBet
from .Pinnacle import placePinnacleBet
from sqlalchemy.dialects.postgresql import insert
from .base import startBetLogging
from .getPrice import getBtcEurPrice
from .base import connect
from datetime import datetime


log = startBetLogging("settle")

con, meta = connect()  
tbl_orderbook = meta.tables['tbl_orderbook']
#tbl_tournament = meta.tables['tbl_tournament']
#tbl_match = meta.tables['tbl_match']  



def settleBet(order_id) :
    dt = datetime.now()
    data = con.execute("SELECT odds_id, event_id, bettyp_id, bookie_id, way, backlay, odds_update, odds, home_player_name, away_player_name, pinnacle_league_id, pinnacle_event_id, betbtc_event_id, pin_line_id FROM public.tbl_odds o inner join public.tbl_events e using(event_id) where odds_id =" + str(odds_id) + ";").fetchone()
    
    event_id = data[1]
    bettyp_id = data[2]
    bookie_id = data[3]
    way = data[4]
    backlay = data[5]
    odds = data[7]
    home_player_name = data[8]
    away_player_name = data[9]
    pinnacle_league_id = data[10]
    pinnalce_event_id = data[11]
    betbtc_event_id = data[12]
    pin_line_id = data[13]
    
    if bookie_id == 1 :
        #Pinnacle
        # still deactivted
        
        stake = request_stake
        currency = 'EUR'
        #bet_id, message, resultset = placePinnacleBet(pinnalce_event_id, pin_line_id, bettyp_id, way, backlay, request_odds, request_stake)
        bet_id, message, resultset = 1, '', ''
        
        if bet_id > 0:
            status == 0
        else :
            status = -1

    elif bookie_id == 2 :
        #BetBTC
        if way == 1:
            player_name = home_player_name
        else :
            player_name = away_player_name
            
        stake = request_stake / getBtcEurPrice()
        currency = 'BTC'
         
        #still deactivated
        #bet_id, message, resultset = placeBetBtcBet(betbtc_event_id, player_name, backlay, request_odds, stake)
        bet_id, message, resultset = 1, '', ''   
        
        if (bet_id > 0 and message == "bet placed and matched") :
            status == 0
        else :
            status = -1
    
    
    log.info("place Bet for [ID " + str(odds_id) + "] " + message )
    log.debug("Full resultset :  " + str(resultset))
    
    if status == 0:
              
        
        clause = insert(tbl_orderbook).values(product_id=product_id, \
                                               odds_id = odds_id, \
                                               bookie_id= bookie_id, \
                                               bookie_bet_id = bet_id, \
                                               backlay_id = backlay,\
                                               bettype_id=bettyp_id, \
                                               way=way, \
                                               odds=request_odds,\
                                               turnover_eur=request_stake, \
                                               turnover_local=stake, \
                                               Currency=currency,\
                                               betdate=dt,\
                                               status=1,\
                                               surebet_id=surebet_id, \
                                               update=dt) 
            
        con.execute(clause) 
        
        return True
    else :
        
        return False

