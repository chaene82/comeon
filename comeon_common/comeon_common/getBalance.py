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
from .getPrice import getEthEurPrice

## Internal functions
def connect(db, user, password, host='localhost', port=5433):
    '''Returns a connection and a metadata object'''
    # We connect with the help of the PostgreSQL URL
    # postgresql://federer:grandestslam@localhost:5432/tennis
    url = 'postgresql://{}:{}@{}:{}/{}'
    url = url.format(user, password, host, port, db)

    # The return value of create_engine() is our connection object
    con = create_engine(url, client_encoding='utf8')

    # We then bind the connection to MetaData()
    meta = MetaData()
    meta.reflect(con)

    return con, meta



def getBalance() :
    dt = datetime.now()
    con, meta = connect(pg_db, pg_user, pg_pwd, pg_host, pq_port)    
    
    
    tbl_balance = meta.tables['tbl_balance']
    
    betbtc_total, btbtc_availiable, betbtc_blocked = checkBetBtcBalance()
    pin_total, pin_availiable, pin_blocked = checkPinnacleBalance()    
    
    btceur = getEthEurPrice()
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