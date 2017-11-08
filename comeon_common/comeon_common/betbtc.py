# -*- coding: utf-8 -*-
"""
Created on Wed Oct 11 17:10:07 2017

@author: haenec
"""

import requests
import pandas as pd
import json
from json import dumps
import time
from urllib.parse import (
    urlencode, unquote, urlparse, parse_qsl, ParseResult
)

## to do: move that to the database
headers = {"Authorization":"Token token=4bb29bd1d3a647859fbf1f920814bf56"}

#leagues = requests.get("http://www.betbtc.co/api/sportsleagues/leagues?id=3",headers=headers).json()



def add_url_params(url, params):
    """ Add GET params to provided URL being aware of existing.

    :param url: string of target URL
    :param params: dict containing requested params to be added
    :return: string with updated URL

    >> url = 'http://stackoverflow.com/test?answers=true'
    >> new_params = {'answers': False, 'data': ['some','values']}
    >> add_url_params(url, new_params)
    'http://stackoverflow.com/test?data=some&data=values&answers=false'
    """
    # Unquoting URL first so we don't loose existing args
    url = unquote(url)
    # Extracting url info
    parsed_url = urlparse(url)
    # Extracting URL arguments from parsed URL
    get_args = parsed_url.query
    # Converting URL arguments to dict
    parsed_get_args = dict(parse_qsl(get_args))
    # Merging URL arguments dict with new params
    parsed_get_args.update(params)

    # Bool and Dict values should be converted to json-friendly values
    # you may throw this part away if you don't like it :)
    parsed_get_args.update(
        {k: dumps(v) for k, v in parsed_get_args.items()
         if isinstance(v, (bool, dict))}
    )

    # Converting URL argument to proper query string
    encoded_get_args = urlencode(parsed_get_args, doseq=True)
    # Creating new parsed result object based on provided with new
    # URL arguments. Same thing happens inside of urlparse.
    new_url = ParseResult(
        parsed_url.scheme, parsed_url.netloc, parsed_url.path,
        parsed_url.params, encoded_get_args, parsed_url.fragment
    ).geturl()

    return new_url


def getBetBtcEventData():
    return requests.get("http://www.betbtc.co/api/event?sport=3",headers=headers).json()



def getBetBtcMaketOdds(event_id):
    data = requests.get("http://www.betbtc.co/api/market?id=" + str(event_id),headers=headers)
    time.sleep(1)
    return data.json()
    

#def placeBetBtcBet() :
#   return requests.get("http://www.betbtc.co/api/bet?id=" + str(event_id),headers=headers).json()
    
def checkBetBtcBalance() :
    balance = requests.get("http://www.betbtc.co/api/user/balance",headers=headers).json()
    availiable = balance[0]['Balance']
    blocked = balance[0]['Blocked']
    return float(availiable) + float(blocked), availiable, blocked

def checkBetBtcSettledBet(betbtc_bet_id) :
    response =  requests.get("http://www.betbtc.co/api/user/statement",headers=headers).json()
    for line in response :
        if betbtc_bet_id == line['id'] :
            return 'Settled', line
    
    return 'Not Found', None

def checkBetBtcOpenBet(betbtc_bet_id) :
    response =  requests.get("http://www.betbtc.co/api/bet/",headers=headers).json()
    for line in response :
        if betbtc_bet_id == line[0] :
            return line
    
    return 'Not Found', None
    
    
    
def checkBetBtcBetForPlace(betbtc_event_id, player_name, backlay, odds, stake) :   

    data = getBetBtcMaketOdds(betbtc_event_id)
    
    if backlay == 1 :
        bettyp = 'Back'
    else:
        bettyp = 'Lay'
        
    
    for line in data:
        if player_name in line:
            for key, value in line[player_name].items():
                if bettyp in key:
                    print(value)
                    btc_odds = value[0][0]
                    btc_stake = value[0][1]
                    if backlay == 1 :
                        if btc_odds < odds:
                            return -4, "odds smaller then requested"
                        if stake > btc_stake:
                            return -3, "Stake bigger then maxRiskStake"
                    else :
                         if btc_odds > odds:
                            return -4, "odds smaller then requested"                       
                    if stake > btc_stake:
                       return -3, "Stake bigger then maxRiskStake"
                    return 0, "okay"
    return -1, "bet not found"
                            
            
def placeBetBtcBet(betbtc_event_id, player_name, backlay, odds, stake) :
    if backlay == 1 :
        bettyp = 'back'
    elif backlay == 2 :
        bettyp = 'lay'
    
    parameters = {'market_id' : str(betbtc_event_id), 'selection' : player_name, 'odd' : str(odds), 'stake' : str(stake), 'bet_type' : bettyp}

    url = add_url_params("https://www.betbtc.co/api/bet/", parameters)

    response = requests.post(url, headers=headers)    
    data = response.json()
    return data
    
    
    
def closeBetBtcBet(betbtc_event_id) :

    
    url = "https://www.betbtc.co/api/bet/"+betbtc_event_id+"?selection=all"
    
    response =  requests.delete(url ,headers=headers).json()
    return response    
    
    
#def placePinnacleBet(event_id, type_id, way, backlay, odds, stake) :

#with open("betbtc/" + date_id + "_tennis_leagues.json", 'w') as fp:
#    json.dump(leagues, fp)
#    
#with open("betbtc/" + date_id + "_tennis_events.json", 'w') as fp:
#    json.dump(events, fp)    