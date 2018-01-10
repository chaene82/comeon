# -*- coding: utf-8 -*-
"""
Scripts for checking bets. 

@author: haenec
"""

from .base import connect
from .betbtc import betbtc
from .Pinnacle import pinnacle
from .base import startBetLogging
from .getPrice import getBtcEurPrice

log = startBetLogging("checkBet")

con, meta = connect()  
#tbl_player = meta.tables['tbl_player']
#tbl_tournament = meta.tables['tbl_tournament']
#tbl_match = meta.tables['tbl_match']  



def checkBetforPlace(odds_id, request_odds, request_stake) :
    """
    Check a bet postition on a bookie before place it
    For that, the same parameter was tested on the bet, but without placing. After that, it should
    be fine for placing a bet
    
    Args:
        odds_id (int): Id of the bet on the table odds.   
        requested_odds (float): The requested odds for placing the bet.    
        requested_stakes (float): The requested stakes in EUR.    

        
    Returns:
        True: The bet could be placed
        False: not possible to place the bet
        
    """    
    log.debug("check for odss to place odds id " + str(odds_id))
    
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
        api = pinnacle()
        
        balance = api.checkBalance()
        if request_stake > float(balance[1]):
            log.info("not enough balance on pinnacle for placing the odds id " + str(odds_id))
            return False
        
        status, message = api.checkBetForPlace(pinnalce_event_id, pinnacle_league_id, bettyp_id, way, backlay, request_odds, request_stake)

    elif bookie_id == 2 :
        #BetBTC
        api = betbtc('back')
        
        if way == 1:
            player_name = home_player_name
        else :
            player_name = away_player_name
        btc_stake = request_stake / getBtcEurPrice()
        balance = api.checkBalance()
        if btc_stake > float(balance[1]):
            log.info("not enough balance on betbtc for placing the odds id " + str(odds_id))
            return False
        
        
        status, message = api.checkBetForPlace(betbtc_event_id, player_name, backlay, request_odds, btc_stake)
    
    # Check for Balance
    
    
    
    
    log.info("checkBet for [ID " + str(odds_id) + "] " + message )
    
    if status == 0:
        return True
    else :
        return False


def checkOffer(offer_id) :
    """
    Check existing offer on the bookie market
    
    Args:
        odds_id (int): Id of the bet on the table odds.      
        
    Returns:
        status: status of the bet: 
                1 = unmatched
                2 = matched
        line: The information from the bookie
        
    """    
    api = betbtc('lay')
    betbtc_bet_id = con.execute("SELECT bookie_bet_id FROM public.tbl_offer where offer_id =" + str(offer_id) + ";").fetchone()[0]
    
    log.debug("checking for bet " + str(offer_id))
    status, matched, unmatched = api.checkOpenBet(betbtc_bet_id)    

    log.debug("Status of the bet " + str(offer_id) + " " + str(status))
    return status, matched, unmatched    