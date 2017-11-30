# -*- coding: utf-8 -*-
"""
Created on Thu Nov 16 12:31:14 2017

@author: haenec
"""

from .betbtc import placeBetBtcBet, placeBetBtcOffer, updateBetBtcBet
from .Pinnacle import placePinnacleBet
from sqlalchemy.dialects.postgresql import insert
from .base import startBetLogging
from .getPrice import getBtcEurPrice
from .base import connect
from datetime import datetime


log = startBetLogging("checkBet")

con, meta = connect()  
tbl_orderbook = meta.tables['tbl_orderbook']
tbl_offer = meta.tables['tbl_offer']
#tbl_tournament = meta.tables['tbl_tournament']
#tbl_match = meta.tables['tbl_match']  



def placeBet(odds_id, request_odds, request_stake, product_id=0, surebet_id=0, offer_id=0) :
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
        betid, message, resultset = placePinnacleBet(pinnalce_event_id, pin_line_id, bettyp_id, way, backlay, request_odds, request_stake)
        #betid, message, resultset = 0, '', ''

    elif bookie_id == 2 :
        #BetBTC
        if way == 1:
            player_name = home_player_name
        else :
            player_name = away_player_name
            
        stake = request_stake / getBtcEurPrice()
        currency = 'BTC'
         
        #still deactivated
        print(betbtc_event_id)
        print(player_name)
        print(backlay)
        print(request_odds)
        print(float(stake))
        
        betid, message, resultset = placeBetBtcBet(betbtc_event_id, player_name, backlay, request_odds, stake)
        #status, message, resultset = 0, '', ''    
    
    
    log.info("place Bet for [ID " + str(odds_id) + "] " + message )
    log.debug("Full resultset :  " + str(resultset))
    
    if betid > 0:
        
              
        
        clause = insert(tbl_orderbook).values(product_id=product_id, \
                                               odds_id = odds_id, \
                                               bookie_id= bookie_id, \
                                               bookie_bet_id = betid, \
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
                                               offer_id=offer_id,\
                                               update=dt) 
            
        con.execute(clause) 
        
        return True
    else :

        return False


        
def placeOffer(place_odds_id, hedge_odds_id, offer_odds, hedge_oods, offer_laybet_stakes, hedge_laybet_stakes) :
    dt = datetime.now()

    turnover_local = turnover_eur / getBtcEurPrice()
    data = con.execute("SELECT odds_id, event_id, bettyp_id, bookie_id, way, backlay, odds_update, odds, home_player_name, away_player_name, pinnacle_league_id, pinnacle_event_id, betbtc_event_id, pin_line_id FROM public.tbl_odds o inner join public.tbl_events e using(event_id) where odds_id =" + str(place_odds_id) + ";").fetchone()
    
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

    if way == 1:
        player_name = home_player_name
    else :
        player_name = away_player_name
           
    stake = offer_laybet_stakes / getBtcEurPrice()
    currency = 'BTC'

    betid, message, resultset = placeBetBtcOffer(betbtc_event_id, player_name, backlay, offer_odds, stake)

    if betid > 0:
        
        log.info("Offer placed")

        clause = insert(tbl_offer).values(odds_id = place_odds_id, \
                                               hedge_odds_id= hedge_odds_id, \
                                               hedge_oods=hedge_oods,\
                                               odds = offer_odds, \
                                               bookie_bet_id=betid,\
                                               turnover_eur = offer_laybet_stakes,\
                                               turnover_local=stake, \
                                               currency=currency, \
                                               betdate=dt,\
                                               status=1, \
                                               hedge_stakes=hedge_laybet_stakes,\
                                               update=dt)     
        resultset = con.execute(clause) 

        return True   
    else:
        log.info("Error by offer placement")        
        return False   
        
        
def updateOffer(offer_id, offer_odds) :
    dt = datetime.now()



    if way == 1:
        player_name = home_player_name
    else :
        player_name = away_player_name
           
    stake = offer_laybet_stakes / getBtcEurPrice()
    currency = 'BTC'

    status, betid = updateBetBtcBet(betbtc_event_id, offer_odds)

    if status == 0:
        log.info("offer successfull update")              
        return True, betid   
    else:
        log.info("Error by offer update")        
        return False  