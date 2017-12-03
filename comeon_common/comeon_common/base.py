# -*- coding: utf-8 -*-
"""
Example Google style docstrings.

This module demonstrates documentation as specified by the `Google Python
Style Guide`_. Docstrings may extend over multiple lines. Sections are created
with a section header and a colon followed by a block of indented text.

Example:
    Examples can be given using either the ``Example`` or ``Examples``
    sections. Sections support any reStructuredText formatting, including
    literal blocks::

        $ python example_google.py

Section breaks are created by resuming unindented text. Section breaks
are also implicitly created anytime a new section starts.

Attributes:
    module_level_variable1 (int): Module level variables may be documented in
        either the ``Attributes`` section of the module docstring, or in an
        inline docstring immediately following the variable.

        Either form is acceptable, but the two should not be mixed. Choose
        one convention to document module level variables and be consistent
        with it.

Todo:
    * For module TODOs
    * You have to also use ``sphinx.ext.todo`` extension

.. _Google Python Style Guide:
   http://google.github.io/styleguide/pyguide.html


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
        SLACK_CHANNEL = cfg['log']['slack']['klaybet']['channel']
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