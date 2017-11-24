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


def placeLayBet(odds_id) :
    laybot_bookie = 2
    backbet_bookie = 1
    
    # Check if laybet already exist and give the odds
    hedge_odds_result  = con.execute('SELECT odds, event_id, bettyp_id, bookie_id, way, backlay FROM tbl_odds WHERE odds_id = ' + str(odds_id)).fetchone()
    hedge_odds = hedge_odds_result[0]
    event_id = hedge_odds_result[1]
    bettyp_id = hedge_odds_result[2]
    if hedge_odds_result[3] == 1 :
        way = 2
    else :
        way = 1 
    backlay =  hedge_odds_result[4]
    
    place_odds_result = con.execute('SELECT odds_id, odds FROM tbl_odds WHERE event_id = ' + str(event_id) + 'and bettyp_id = ' + str(bettyp_id) + 'and way = ' + str(way) + 'and backlay = 2 and bookie_id = ' + str(laybot_bookie)).fetchone()
    
    place_odds_id = place_odds_result[0]
    place_offer_odd = place_odds_result[1]
    odds_status, offer_odds, offer_laybet_stakes = calcLayOdds(hedge_odds)
    
    
    if (offer_odds >= place_offer_odd or math.isnan(place_offer_odd))  :
        log.info("add offer on event id " + str(event_id))
        
        placeOffer(place_odds_id, offer_odds, offer_laybet_stakes)





def searchLayBetOffer() :
    con, meta = connect()  
    #tbl_surebet = meta.tables['tbl_surebet']
    open_odds = con.execute('SELECT count (offer_id) FROM tbl_offer WHERE status = 1').fetchone()
    odds = con.execute('Select odds_id from tbl_odds o INNER JOIN tbl_events e using(event_id) WHERE e.pinnacle_event_id is not null and e.betbtc_event_id is not null and e."StartDateTime" >= now() and o.bookie_id = 1 and odds_id not in (select hedge_odds_id from tbl_offer)' )
    for odds_id in odds :
        log.info(odds_id[0])

    
