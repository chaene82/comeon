#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Sep 10 16:19:16 2017

@author: chrhae
"""

import pinnacle
import pandas as pd
import json
import datetime
import os
from sqlalchemy import create_engine, MetaData, select
from pinnacle.apiclient import APIClient
from .tennis_config import *

dir = os.path.dirname(__file__)
os.chdir(dir)

import urllib.request



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

con, meta = connect(pg_db, pg_user, pg_pwd, pg_host, pq_port)
api = APIClient('CH983245', 'Skoda1$$')
sport_ids = api.reference_data.get_sports()

def getPinnacleEventData():
    return api.market_data.get_fixtures(33)

def getPinnacleEventOdds():
    return api.market_data.get_odds(33)
    
def checkPinnacleBalance() :
    account = api.account.get_account()
    availiable = account['availableBalance']
    blocked = account['outstandingTransactions']
    return availiable + blocked, availiable, blocked


def checkPinnacleBetForPlace(pin_event_id, pin_league_id, type_id, way, backlay, odds, stake) :
    sports_id = 33
#    pin_league_id = 10240
#    pin_event_id = 783630159
#    stake = 10
    if type_id == 1 :
        period_number = 0
        bettype = "MONEYLINE"
    
    if way == 1 :
        team = 'TEAM1'
    elif way == 2 :
        team = 'TEAM2'
    else:
        return -99, "way not correct"        
    
    bet_data = api.market_data.get_line(sports_id, league_id=pin_league_id, event_id=pin_event_id, period_number = period_number, bet_type = bettype, team=team)
    
    ## Check if the bet still okay
    
    if stake < bet_data['minRiskStake'] :
        return -2, "Stake smaller as minRiskStake" + str(bet_data)
        
    if stake > bet_data['maxRiskStake'] :
        return -3, "Stake bigger then maxRiskStake" + str(bet_data)
        
    if odds > bet_data['price'] : 
        return -4, "odds smaller then requested" + str(bet_data)
    
    balance = checkPinnacleBalance()
    
    if stake >= balance[0] :
        return -11, "Not enough balance"
        
    return 0, "okay"

def placePinnacleBet(pin_event_id, pin_line_id, type_id,  way, backlay, odds, stake) :
    sports_id = 33
    
    if type_id == 1 :
        period_number = 0
        bettype = "MONEYLINE"
    
    if way == 1 :
        team = 'TEAM1'
    elif way == 2 :
        team = 'TEAM2'
    else:
        return -99, "way not correct", None
        

    
    response = api.betting.place_bet(sports_id, pin_event_id, pin_line_id, period_number, bettype, stake, team=team, accept_better_line=True)
    if response['status'] == 'ACCEPTED' :
        print("bet places on event" , pin_event_id)        
        return response['betId'], "bet placed", response
    else :
        print("bet was not place")
        return -1, "error placing bet, Errorcode " + response['errorCode'], response
           

    
def checkPinnacleUnsettledBet(pin_bet_id) :   
    response = api.betting.get_bets(betids = pin_bet_id)
    
    return response['betStatus'], response


def checkPinnacleSettledBet(pin_bet_id) :
    response =  api.betting.get_bets(betids = pin_bet_id)
    if not response['bets'] :
        return 'not found', 0, 0, response
    odds = response['bets'][0]['price']
    if response['bets'][0]['betStatus'] == 'WON' :
        winnings = response['bets'][0]['win']
    elif response['bets'][0]['betStatus'] == 'LOSE':
        winnings = 0
    else:
        return 'not settled', 0, 0, response
    return 'settled', winnings, odds, response
        
 