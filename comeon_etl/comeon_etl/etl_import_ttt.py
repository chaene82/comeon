#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct 15 10:25:53 2017

@author: chrhae
"""


import pandas as pd
import sqlite3
from datetime import datetime
from sqlalchemy import create_engine
from comeon_common import connect
#from .tennis_config import *



    

    
def etl_import_ttt_current(conn_sqllite3, con_postgres) :
    print("load Top Tennis Tip Picks")
    try:
        df_input = pd.read_sql('select * from tmp_ttt_picks', conn_sqllite3)
    except:
        return
        
    
    
    df_input = df_input.drop_duplicates()
    

    # Change Data Type
   
    
    print("Store TTT Picks")    
    df_input.to_sql(name='tbl_ttt_picks', con=con_postgres, if_exists='replace', index=False)
    

    
    
def etl_import_ttt() :
    conn_sqllite3 = sqlite3.connect('ttt_data.db')
    con_postgres, meta = connect()

    etl_import_ttt_current(conn_sqllite3, con_postgres)

