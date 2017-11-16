# -*- coding: utf-8 -*-
"""
Created on Tue Nov  7 17:43:20 2017

@author: haenec
"""

import json
from sqlalchemy import create_engine, MetaData, select
from sqlalchemy.dialects.postgresql import insert
from datetime import datetime
import numpy as np
from .betbtc import checkBetBtcBalance
from .Pinnacle import checkPinnacleBalance
from .tennis_config import *
from .getPrice import getBtcEurPrice
from .base import connect



def getBalance() :
    dt = datetime.now()
    con, meta = connect(pg_db, pg_user, pg_pwd, pg_host, pq_port)    
    
    
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
        print("Pinnacle Balance to small, please deposit ", pin_total)
    elif pin_total > bookie[9] :
        print("Pinnacle Balance to high, please withdraw ", pin_total)
        
    balance_sql = select([tbl_bookie]).where(tbl_bookie.columns.bookie_id == 2)
    bookie = con.execute(balance_sql).fetchone() 
    
    if betbtc_total < bookie[8] :
        print("BetBtc Balance to small, please deposit ", betbtc_total)
    elif betbtc_total > bookie[9] :
        print("BetBtc Balance to high, please withdraw ", betbtc_total)        
