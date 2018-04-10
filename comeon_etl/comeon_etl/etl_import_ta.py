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



    

    
def etl_import_ta_current(conn_sqllite3, con_postgres) :
    print("load Tennis Abstract Matchlist")
    try:
        df_input = pd.read_sql('select * from tmp_ta_proba', conn_sqllite3)
    except:
        return
        
    
    
    df_input = df_input.drop_duplicates()
    

    # Change Data Type
   
    
    print("Store Tennis Abstract Matchlist")    
    df_input.to_sql(name='tbl_ta_proba', con=con_postgres, if_exists='replace', index=False)
    

    
    
def etl_import_ta() :
    conn_sqllite3 = sqlite3.connect('ta_data.db')
    con_postgres, meta = connect()

    etl_import_ta_current(conn_sqllite3, con_postgres)

