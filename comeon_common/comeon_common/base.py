# -*- coding: utf-8 -*-
"""

Created on Mon Nov 13 17:08:55 2017

@author: haenec
"""

from sqlalchemy import create_engine, MetaData
import logging
from slacker_log_handler import SlackerLogHandler
#from .tennis_config import *

# load data from the configuration
import yaml
with open("config.yml", 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
    


def connect(db=cfg['database']['db'], user=cfg['database']['user'], password=cfg['database']['pwd'], host=cfg['database']['host'], port=cfg['database']['port']):
    """
    Returns a connection and a metadata object from the postgres DB
    
    Args:
        db (str): Name of the database to connect.   
        user (str): Name of the database user to connect.    
        password (str): the password for the user to connect.    
        host (str): Name or IP address of the node to connect.    
        port (int): Number of the db port.
        
    Returns:
        con: A database connection
        mate: a database meta object
        
    """
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
    """
    Initial the main logging function for comeon. 
    
    Normal message level is Info
    = Debug --> not show
    = Info --> Console (Rundeck)
    > Warn --> Console (Rundeck) & Slack
    
    Please use the following loglevels for messages:
        
        Debug : Application internal messages (just for debugging)
        Info  : Status information and some stuff to show on the console
        Warn  : Messages to the customer (no action required)
        Error : Messages to the customer (action required)
        Critical : not defined yet
        
    
    Args:
        applicatoin (str): Name of the applicaton 
        
    Returns:
        logger: the logger object
        
    Todo:
    * Send all Debug messaged to Kafka
        
    """    
    
    logger = logging.getLogger(application)
    logger.setLevel(logging.DEBUG)
    
    SLACK_API_TOKEN = cfg['log']['slack']['api_key']
    
    if application == 'surebet' :
        SLACK_CHANNEL = cfg['log']['slack']['surebet']['channel']
    elif application == 'laybet' :
        SLACK_CHANNEL = cfg['log']['slack']['laybet']['channel']
    elif application == 'balance' :
        SLACK_CHANNEL = cfg['log']['slack']['balance']['channel'] 
    elif application == 'etl' :
        SLACK_CHANNEL = cfg['log']['slack']['etl']['channel']     
    else :
        SLACK_CHANNEL = cfg['log']['slack']['common']['channel']        
    
    ch = logging.StreamHandler()
    ch.setLevel(logging.INFO)
    
    sh = SlackerLogHandler(SLACK_API_TOKEN, SLACK_CHANNEL, stack_trace=True)
    sh.setLevel(logging.WARN)
    
    
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    ch.setFormatter(formatter)
    
    logger.addHandler(ch)
    logger.addHandler(sh)

    
    return logger

    
    
def removeTime (datetime) :
    """
    CRemove the time form the datetime input
    
    Args:
        datetime:  a datetime variable
        
    Returns:
        a date 
        -
        
    """
    return datetime[:10]