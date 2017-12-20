# -*- coding: utf-8 -*-
"""
Created on Thu Nov 16 12:31:14 2017

@author: haenec
"""

from .betbtc import betbtc
from .Pinnacle import checkPinnacleSettledBet
from sqlalchemy import select, update
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
    """
    Check for open bets in the orderbook and settle it if there are finish    
    Args:
        order_id (int) : the internal id in the orderbook
        
    Returns:
        store to the database
        
    """  
    dt = datetime.now()
    
    log.info("Checking for Order ID " + str(order_id))

    stmt = select([tbl_orderbook]).where(tbl_orderbook.c.order_id == order_id)
    
    lines = con.execute(stmt)    
    
    for line in lines :
        bookie_id = line['bookie_id']
        bet_id = line['bookie_bet_id']
        stakes = line['turnover_local']
        
        if bookie_id == 1 :
            #pinnacle bet 
            bet_status, winnings, odds, response = checkPinnacleSettledBet(bet_id)
            winnings = float(winnings) 
            winnings_local = winnings + float(stakes)
            winnings_eur = winnings + float(stakes)
            net_winnings_local = winnings
            net_winnings_eur = winnings            
        elif bookie_id == 2 :
            bet_status, winnings, odds, response = betbtc('back').checkBetBtcSettledBet(bet_id)
            win = float(winnings) + float(stakes)
            odds = float(odds) 


            winnings_eur = round(win * getBtcEurPrice(), 2)
            winnings_local = win
            net_winnings_eur = winnings_eur
            net_winnings_local = winnings_local   
        else :
            bet_status, winnings, odds, response = 'matched', 0, 0, 0
  
      
        odds = float(odds) 
        if bet_status == 'settled' :
            if winnings > 0 :
                status = 2
                log.warning("Bet won: Order ID " + str(order_id))
            else :
                status = 3
                log.warning("Bet lost: Order ID " + str(order_id))
                winnings_local = 0
                winnings_eur = 0
                net_winnings_local = 0
                net_winnings_eur = 0                    
                
            clause = update(tbl_orderbook).where(tbl_orderbook.columns.order_id == order_id).values({'eff_odds' : odds, 'bet_settlement_date' : dt, 'winnings_local' : winnings_local, 'winnings_eur' : winnings_eur, 'commission' : 0, 'net_winnings_eur' : net_winnings_eur, 'net_winnings_local' : net_winnings_local, 'status' : status, 'update' : dt})
            con.execute(clause) 
        else :
            clause = update(tbl_orderbook).where(tbl_orderbook.columns.order_id == order_id).values({'status' : 1, 'update' : dt})
            con.execute(clause)
            log.info("Bet not settled: Order ID " + str(order_id))            



def settleAllBets():
    """
    Loog for open bets and run a "settleBet" function for open bets    
    Args:
        -

    Returns:
        -
    """  
    stmt = select([tbl_orderbook.c.order_id]).where(tbl_orderbook.c.status == 1)
    
    order_ids = con.execute(stmt).fetchall()
    
    for id in order_ids:
        settleBet(id[0])
    
