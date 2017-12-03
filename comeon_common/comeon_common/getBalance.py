# -*- coding: utf-8 -*-
"""
Scripts for handling all stuff checking Balances on the Bookma

@author: haenec
"""

from sqlalchemy import select
from sqlalchemy.dialects.postgresql import insert
from datetime import datetime
from .betbtc import checkBetBtcBalance
from .Pinnacle import checkPinnacleBalance
from .getPrice import getBtcEurPrice
from .base import connect, startBetLogging



def getBalance() :
    """
    Check the balance on all bookies (all accounts) and look for each bookie on the database, if the 
    Balance is in the range between min and max. If it is okay, do nothing, print a Info message,
    if not, print a Error message (including message to Slack)
    
    Args:
        None Parameter
        Get some information form the database
        
    Returns:
        -
        
    """
    dt = datetime.now()
    con, meta = connect()   
    log = startBetLogging("balance")
    
    
    tbl_balance = meta.tables['tbl_balance']
    tbl_bookie = meta.tables['tbl_bookie']
    
    
    betbtc_total, btbtc_availiable, betbtc_blocked = checkBetBtcBalance()
    pin_total, pin_availiable, pin_blocked = checkPinnacleBalance()    
    
    btceur = getBtcEurPrice()
    betbtc_total_eur = float(betbtc_total) * float(btceur)
    
    # Insert Pinnancle
    clause = insert(tbl_balance).values(bookie_id=1, \
                    total_balance=pin_total, \
                    total_balance_eur=pin_total, \
                    free_balance=pin_availiable, \
                    blocked_balance=pin_blocked, \
                    date=dt)
    con.execute(clause)
    
    # Insert betbetc
    clause = insert(tbl_balance).values(bookie_id=2, \
                    total_balance=betbtc_total, \
                    total_balance_eur=betbtc_total_eur, \
                    free_balance=btbtc_availiable, \
                    blocked_balance=betbtc_blocked, \
                    date=dt)
    con.execute(clause)    
    
    balance_sql = select([tbl_bookie]).where(tbl_bookie.columns.bookie_id == 1)
    bookie = con.execute(balance_sql).fetchone() 
    
    if pin_total < bookie[8] :
        log.error("Pinnacle Balance to small, please deposit " +str(pin_total))
    elif pin_total > bookie[9] :
        log.error("Pinnacle Balance to high, please withdraw " + str(pin_total))
    else:
        log.info("Pinnacle Balance okay by " + str(pin_total))
        
    balance_sql = select([tbl_bookie]).where(tbl_bookie.columns.bookie_id == 2)
    bookie = con.execute(balance_sql).fetchone() 
    
    if betbtc_total < bookie[8] :
        log.error("BetBtc Balance to small, please deposit " + str(betbtc_total))
    elif betbtc_total > bookie[9] :
        log.error("BetBtc Balance to high, please withdraw "+ str(betbtc_total))
    else :
        log.info("BetBtc Balance okay by " + str(betbtc_total))

    total_balance = pin_total + (betbtc_total_eur)
    
    log.info("Total Balance on the system " + str(total_balance) + " EUR")
