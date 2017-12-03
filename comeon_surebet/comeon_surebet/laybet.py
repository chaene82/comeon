"""
Created on Wed Nov  1 14:27:52 2017

ToDo:
    Finish it for Version 0.0.5

@author: haenec
"""

from sqlalchemy import create_engine, MetaData, select, update
from sqlalchemy.dialects.postgresql import insert
from datetime import datetime
import numpy as np
import math
from comeon_common import connect
from comeon_common import startBetLogging
from comeon_common import checkBetforPlace, placeBet, checkOffer, placeOffer

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
        return True, odds_round, laybet_stakes, back_stake
    else:
        return False, 0, 0, 0
    

def checkLayOdds(offerLayOdds, hedgeLayOdds, min_margin=0.05, invest=10) :
    status, odds, stake = calcLayOdds(hedgeLayOdds, min_margin, invest)
    if (status and odds >= offerLayOdds):
        log.info("laybet still okay")
        return True
    else :
        log.info("laybet no longer okay")
        return False        


calcLayOdds(5, 0.1, 20)
checkLayOdds(1.63, 1.68, 0.05, 10)


def placeLayBet(odds_id) :
    laybot_bookie = 2
    backbet_bookie = 1
    
    # Check if laybet already exist and give the odds
    hedge_odds_result  = con.execute('SELECT odds, event_id, bettyp_id, bookie_id, way, backlay, odds_id FROM tbl_odds WHERE odds_id = ' + str(odds_id)).fetchone()
    hedge_odds = hedge_odds_result[0]
    event_id = hedge_odds_result[1]
    bettyp_id = hedge_odds_result[2]
    way = hedge_odds_result[3] 
    backlay =  hedge_odds_result[4]
    hedge_odds_id =  hedge_odds_result[5]

    
    place_odds_result = con.execute('SELECT odds_id, odds FROM tbl_odds WHERE event_id = ' + str(event_id) + 'and bettyp_id = ' + str(bettyp_id) + 'and way = ' + str(way) + 'and backlay = 2 and bookie_id = ' + str(laybot_bookie)).fetchone()
    
    place_odds_id = place_odds_result[0]
    place_offer_odd = place_odds_result[1]
    odds_status, offer_odds, offer_laybet_stakes, hedge_laybet_stakes = calcLayOdds(hedge_odds)
    
    
    if (offer_odds >= place_offer_odd or math.isnan(place_offer_odd))  :
        log.info("add offer on event id " + str(event_id))
        
        placeOffer(place_odds_id, hedge_odds_id, offer_odds, hedge_odds, offer_laybet_stakes, hedge_laybet_stakes)
        
        
def updateLayBet(odds_id, offer_id) :
    laybot_bookie = 2
    backbet_bookie = 1
    
    # Check if laybet already exist and give the odds
    hedge_odds_result  = con.execute('SELECT odds, event_id, bettyp_id, bookie_id, way, backlay, odds_id FROM tbl_odds WHERE odds_id = ' + str(odds_id)).fetchone()
    hedge_odds = hedge_odds_result[0]
    event_id = hedge_odds_result[1]
    bettyp_id = hedge_odds_result[2]
    way = hedge_odds_result[3] 
    backlay =  hedge_odds_result[4]
    hedge_odds_id =  hedge_odds_result[5]

    
    place_odds_result = con.execute('SELECT odds_id, odds FROM tbl_odds WHERE event_id = ' + str(event_id) + 'and bettyp_id = ' + str(bettyp_id) + 'and way = ' + str(way) + 'and backlay = 2 and bookie_id = ' + str(laybot_bookie)).fetchone()
    
    place_odds_id = place_odds_result[0]
    place_offer_odd = place_odds_result[1]
    odds_status, offer_odds, offer_laybet_stakes, hedge_laybet_stakes = calcLayOdds(hedge_odds)
    
    
    if (offer_odds >= place_offer_odd or math.isnan(place_offer_odd))  :
        log.info("update offer on event id " + str(event_id))
        
        status, bet_id = updateOffer(place_odds_id, offer_id, offer_odds, offer_laybet_stakes)
        if status == 0 :
                    clause = update(tbl_offer).where(tbl_offer.columns.offer_id == offer_id).values(status=1, odds=offer_odds, update=dt)
                    con.execute(clause) 
        else :
            log.info("error offer on event id " + str(event_id))

            
        
        
def checkLayBet(offer_id) :
    dt = datetime.now()
    invest = 10
    product_id = 4
    bettyp_id=1

    laybot_bookie = 2
    backbet_bookie = 1
    
    # Check if laybet already exist and give the odds
    offer  = con.execute('SELECT odds_id, hedge_odds_id, odds, hedge_odds, turnover_eur, turnover_local, currency, status, bookie_bet_id FROM tbl_offer WHERE offer_id = ' + str(offer_id)).fetchone()
    odds_id = offer[0]
    hedge_odds_id = offer[1]
    hedge_odds = offer[4]
    oods = offer[2]
    stake_eur = offer[5] 
    stake_local =  offer[6]
    currency =  offer[7]
    status =  offer[8]
    bookie_bet_id = offer[9]

    offer_bookie_status = checkOffer(offer_id)
    
    if offer_bookie_status == 0 :
        ## no bet exists
        log.info("Offer no longer exists, close it")
        clause = update(tbl_offer).where(tbl_offer.columns.offer_id == offer_id).values(status=2, update=dt)
        con.execute(clause) 
        
    elif offer_bookie_status == 1 :
        ## no unmatched 
        log.info("Offer still unmatched, check hedge bet")
        eff_hedge_odds = con.execute('SELECT odds FROM tbl_odds WHERE odds_id = ' + str(hedge_odds_id)).fetchone()[0]
        if checkLayOdds(eff_odds, eff_hedge_odds, invest=float(stake_eur)) :
            # Odd no longer okay, change it
            log.info("update offer")
            updateLayBet(odds_id, offer_id)

    
        
    elif offer_bookie_status == 2 :
        ##  matched     
        log.info("Offer matched, hedge it")
        hedge_bet_status = placeBet(hedge_odds_id, hedge_odds, invest, product_id=product_id, surebet_id=0, offer_id=odds_id) 

                
        clause = insert(tbl_orderbook).values(product_id=product_id, \
                                               odds_id = odds_id, \
                                               bookie_id= laybot_bookie, \
                                               bookie_bet_id = bookie_bet_id, \
                                               backlay_id = 2,\
                                               bettype_id=bettyp_id, \
                                               way=0, \
                                               odds=oods,\
                                               turnover_eur=stake_eur, \
                                               turnover_local=stake_local, \
                                               Currency=currency,\
                                               betdate=dt,\
                                               status=1,\
                                               surebet_id=0, \
                                               offer_id=offer_id,\
                                               update=dt) 
            
        con.execute(clause) 
        
        clause = update(tbl_offer).where(tbl_offer.columns.offer_id == offer_id).values(status=3, update=dt)
        con.execute(clause)         

    return True

        
def searchLayBetOffer() :
    concurrent_open_bets = 5
    con, meta = connect()  
    #tbl_surebet = meta.tables['tbl_surebet']
    open_offers = con.execute('SELECT count (offer_id) FROM tbl_offer WHERE status = 1').fetchone()
    if open_offers[0] < concurrent_open_bets :
        odds = con.execute('Select odds_id from tbl_odds o INNER JOIN tbl_events e using(event_id) WHERE e.pinnacle_event_id is not null and e.betbtc_event_id is not null and e."StartDateTime" >= now() and o.bookie_id = 1 and odds_id not in (select hedge_odds_id from tbl_offer)' )
        for odds_id in odds :
            log.info(odds_id[0])
            placeLayBet(odds_id[0])

            
def checkOffers():
    open_offer_ids = con.execute('SELECT offer_id FROM tbl_offer WHERE status = 1').fetchall()
    for offer_id in open_offer_ids :
        offer_id = offer_id[0]
        log.info("Check Offer with offer ID " + str(offer_id))
        checkLayBet(offer_id)
