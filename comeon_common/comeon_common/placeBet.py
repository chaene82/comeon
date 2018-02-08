# -*- coding: utf-8 -*-
"""
Created on Thu Nov 16 12:31:14 2017

@author: haenec
"""

from .betbtc import betbtc
from .Pinnacle import pinnacle
from sqlalchemy.dialects.postgresql import insert
from .base import startBetLogging
from .getPrice import getBtcEurPrice
from .base import connect
from datetime import datetime
from sqlalchemy import update


log = startBetLogging("placeBet")

con, meta = connect()  
tbl_orderbook = meta.tables['tbl_orderbook']
tbl_offer = meta.tables['tbl_offer']
#tbl_tournament = meta.tables['tbl_tournament']
#tbl_match = meta.tables['tbl_match']  



def placeBet(odds_id, request_odds, request_stake, product_id=0, surebet_id=0, offer_id=0) :
    """
    Place a bet based on a odds ID and store it on the orderbook
    
    Args:
        odds_id (int) : the odds ID 
        request_odds (float) : The requested odds
        request_stake (float) : The requested stakes
        product_id (int) : the Number of the product for which the bet is placed
        surebet_id (int) : the surebet nummer (if exists)
        offer_id (int) : the number ot the offer (if exists)

    Returns:
       True: The placement was successful
       False: there was a problem placing the bet
    """  
    
    
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
        api = pinnacle()
        
        stake = request_stake
        currency = 'EUR'
        betid, message, resultset = api.placeBet(pinnalce_event_id, pin_line_id, bettyp_id, way, backlay, request_odds, request_stake)
        #betid, message, resultset = 0, '', ''

    elif bookie_id == 2 :
        #BetBTC
        api = betbtc('back')
        
        if way == 1:
            player_name = home_player_name
        else :
            player_name = away_player_name
            
        stake = request_stake / getBtcEurPrice()
        currency = 'BTC'
         

        
        betid, message, resultset = api.placeBet(betbtc_event_id, player_name, backlay, request_odds, stake)
    
    
    log.info("place Bet for [ID " + str(odds_id) + "] " + message + ", " + str(resultset) )
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


        
def placeOffer(place_odds_id, hedge_odds_id, offer_odds, hedge_oods, offer_laybet_stakes, hedge_stakes) :
    """
    Place a bet offer based on a odds ID and store it on the orderbook
    
    Args:
        place_odds_id (int) : the odds ID 
        hedge_odds_id (int) : id of the hedge odd
        offer_odds (float) : odds for the offer
        hedge_oods (float) : odds for the hedge offer
        offer_laybet_stakes (float) : Stakes for the offer
        hedge_stakes (float) : Stakes for the hedge bet

    Returns:
       True: The placement was successful
       False: there was a problem placing the bet
    """  
    
    dt = datetime.now()

    turnover_local = offer_laybet_stakes / getBtcEurPrice() 
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
    
    api = betbtc('lay')

    betid, message, resultset = api.placeOffer(betbtc_event_id, player_name, backlay, offer_odds, stake)

    if betid > 0:
        
        log.info("Offer placed")

        clause = insert(tbl_offer).values(odds_id = place_odds_id, \
                                               hedge_odds_id= hedge_odds_id, \
                                               hedge_odds=hedge_oods,\
                                               odds = offer_odds, \
                                               bookie_bet_id=betid,\
                                               turnover_eur = offer_laybet_stakes,\
                                               turnover_local=stake, \
                                               currency=currency, \
                                               betdate=dt,\
                                               status=1, \
                                               hedge_stakes=hedge_stakes,\
                                               update=dt)     
        resultset = con.execute(clause) 

        return True   
    else:
        log.info("Error by offer placement")     
        log.warning(resultset)   
    
        return False   
        
        
def closeOffer(offer_id) :
    """
    Close a open offer

    Args:
        offer_id (int) : the offer ID 

    Returns:
       True: The deletion was successful
       False: there was a problem deleting the offer
    
    """
    
    
    data = con.execute("SELECT offer_id, od.odds_id, e.betbtc_event_id, case when od.way = 1 then home_player_name else away_player_name end as player_name FROM public.tbl_offer o  inner join tbl_odds od using(odds_id)  inner join tbl_events e using(event_id) where offer_id = " + str(offer_id) + ";").fetchone()
    
    dt = datetime.now()
    
    player_name = data[3]
    betbtc_event_id = data[2]

    api = betbtc('lay')
    
    status = api.closeBet(betbtc_event_id, player_name)
    

    if status[0]['status'] == 'OK':
        log.info("offer successfull closed " + str(offer_id)) 

        v_offer_id = offer_id    
        clause = update(tbl_offer).where(tbl_offer.c.offer_id == v_offer_id).values(status=2, update=dt)     
        con.execute(clause)     
             
        return True   
    else:
        log.warning("Error by offer update for event if " )  
        
        #con.execute(clause)     
        
        return False  