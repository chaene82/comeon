# -*- coding: utf-8 -*-
"""
Created on Thu Nov 16 12:31:14 2017

@author: haenec
"""

from .base import connect
from .betbtc import checkBetBtcBetForPlace, checkBetBtcBalance
from .Pinnacle import checkPinnacleBetForPlace, checkPinnacleBalance
from .base import startBetLogging
from .getPrice import getBtcEurPrice

log = startBetLogging("checkBet")

con, meta = connect()  
#tbl_player = meta.tables['tbl_player']
#tbl_tournament = meta.tables['tbl_tournament']
#tbl_match = meta.tables['tbl_match']  

def checkBetforPlace(odds_id, request_odds, request_stake) :
    
    log.debug("odds id " + str(odds_id))
    
    data = con.execute("SELECT odds_id, event_id, bettyp_id, bookie_id, way, backlay, odds_update, odds, home_player_name, away_player_name, pinnacle_league_id, pinnacle_event_id, betbtc_event_id FROM public.tbl_odds o inner join public.tbl_events e using(event_id) where odds_id =" + str(odds_id) + ";").fetchone()
    
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
    
    if bookie_id == 1 :
        #Pinnacle
        # check balance
        balance = checkPinnacleBalance()
        if request_stake > float(balance[1]):
            log.info("not enough balance on pinnacle")
            return False
        
        status, message = checkPinnacleBetForPlace(pinnalce_event_id, pinnacle_league_id, bettyp_id, way, backlay, request_odds, request_stake)

    elif bookie_id == 2 :
        #BetBTC
        if way == 1:
            player_name = home_player_name
        else :
            player_name = away_player_name
        btc_stake = request_stake / getBtcEurPrice()
        balance = checkBetBtcBalance()
        if btc_stake > float(balance[1]):
            log.info("not enough balance on betbtc")
            return False
        
        
        status, message = checkBetBtcBetForPlace(betbtc_event_id, player_name, backlay, request_odds, btc_stake)
    
    # Check for Balance
    
    
    
    
    log.info("checkBet for [ID " + str(odds_id) + "] " + message )
    
    if status == 0:
        return True
    else :
        return False

