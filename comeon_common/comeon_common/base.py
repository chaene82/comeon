# -*- coding: utf-8 -*-
"""
Created on Mon Nov 13 17:08:55 2017

@author: haenec
"""

from sqlalchemy import create_engine, MetaData, select
from sqlalchemy.dialects.postgresql import insert
from .tennis_config import *

## Internal functions
def connect(db=pg_db, user=pg_user, password=pg_pwd, host=pg_host, port=pq_port):
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