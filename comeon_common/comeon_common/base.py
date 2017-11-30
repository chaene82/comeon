# -*- coding: utf-8 -*-
"""
Created on Mon Nov 13 17:08:55 2017

@author: haenec
"""

from sqlalchemy import create_engine, MetaData, select
from sqlalchemy.dialects.postgresql import insert
import logging
from slacker_log_handler import SlackerLogHandler, NoStacktraceFormatter
from .tennis_config import *

## Internal functions
def connect(db=pg_db, user=pg_user, password=pg_pwd, host=pg_host, port=pq_port):
    '''Returns a connection and a metadata object'''
    # We connect with the help of the PostgreSQL URL
    # postgresql://federer:grandestslam@localhost:5432/tennis
    url = 'postgresql://{}:{}@{}:{}/{}'
    url = url.format(user, password, host, port, db)

    # The return value of create_engine() is our connection object
    con = create_engine(url , client_encoding='utf8')

    # We then bind the connection to MetaData()
    meta = MetaData()
    meta.reflect(con)

    return con, meta


def startBetLogging(application) :
    logger = logging.getLogger(application)
    logger.setLevel(logging.DEBUG)
    
    SLACK_API_TOKEN = "xoxb-280090289303-njD9i7HXqkuBUanGiT7LetuH"
    SLACK_CHANNEL = "#surebot"
    
    ch = logging.StreamHandler()
    ch.setLevel(logging.INFO)
    
    sh = SlackerLogHandler(SLACK_API_TOKEN, SLACK_CHANNEL, stack_trace=True)
    sh.setLevel(logging.ERROR)
    
    # No File Handler (Logging over Rundeck)
    #fh = logging.FileHandler(application + 'debug.log')
    #fh.setLevel(logging.DEBUG)
    
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    ch.setFormatter(formatter)
    #fh.setFormatter(formatter)
    
    #logger.addHandler(fh)
    logger.addHandler(ch)
    logger.addHandler(sh)

    
    return logger# -*- coding: utf-8 -*-


def stopBetLogging(application) :
    logger = logging.getLogger(application)
    
    ch = logging.StreamHandler()
    #fh = logging.FileHandler(application + 'debug.log')
    
    #logger.removeHandler(fh)
    logger.removeHandler(ch)