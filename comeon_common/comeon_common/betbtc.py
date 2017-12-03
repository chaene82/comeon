# -*- coding: utf-8 -*-
"""
This is a first version of a wrapper for Bet Btc

ToDo:
    Rewrite is as a class
@author: haenec
"""

import requests
from json import dumps
import time
from urllib.parse import (
    urlencode, unquote, urlparse, parse_qsl, ParseResult
)

import yaml
with open("config.yml", 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
    
cfg['betbtc']['api']['token']
    
## to do: move that to the database
headers = {"Authorization":"Token token=" + cfg['betbtc']['api']['token']}

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
    """
    get Open Events form BetBTC    
    Args:
        -        
    Returns:
        json : A list of events
        
    """  
    return requests.get("http://www.betbtc.co/api/event?sport=3",headers=headers).json()



def getBetBtcMaketOdds(event_id):
    """
    get Open Odds form BetBTC    
    Args:
        event_id : event id        
    Returns:
        json : A list of odds
        
    """      
    data = requests.get("http://www.betbtc.co/api/market?id=" + str(event_id),headers=headers)
    time.sleep(0.5)
    return data.json()
    

#def placeBetBtcBet() :
#   return requests.get("http://www.betbtc.co/api/bet?id=" + str(event_id),headers=headers).json()
    
def checkBetBtcBalance() :
    """
    Check the Balance on the account  
    Args:
        -        
    Returns:
        total_balance : total balance (including placed open bets)
        availiable : availiable balance for betting
        blocked : placed balance
        
    """  
    balance = requests.get("http://www.betbtc.co/api/user/balance",headers=headers).json()
    availiable = balance[0]['Balance']
    blocked = balance[0]['Blocked']
    return float(availiable) + float(blocked), availiable, blocked

def checkBetBtcSettledBet(betbtc_bet_id) :
    """
    check unsettled bests   
    Args:
        betbtc_bet_id (int) : the Number of the betbtc bet
    Returns:
        status : unmatched, matched oder not found
        winnings (float): the winnings on the bet
        odds (float) : the odds on the bet
        line (dict) : additional information about the bet
        
    """  
    response =  requests.get("http://www.betbtc.co/api/user/statement",headers=headers).json()
    for line in response :
        if str(betbtc_bet_id) in line['description'] :
            if line['credit'] == None:
                winnings = 0
            else :
                winnings = line['credit']
                
            odds = line['odd']
            return 'settled', winnings, odds, line
        
    status, line = checkBetBtcOpenBet(betbtc_bet_id)
    
    if status == 1:
        return 'unmatched', 0, 0 ,line
    elif status == 2:
        return 'matched', 0, 0, line
    
    return 'Not Found', 0, 0, None

def checkBetBtcOpenBet(betbtc_bet_id) :
    """
    Check for open bet (matched and unmatched)
    Args:
        betbtc_bet_id : betbtc id of the bet   
    Returns:
        status : 1 = matched
                 2 = unmatched
        lien : additional information about the bet
        
    """  
    response =  requests.get("http://www.betbtc.co/api/bet/",headers=headers).json()
    for line in response :
        if betbtc_bet_id == line[0] :
            if line[2] == 'Unmatched' :
                return 1, line
            elif line[2] == 'Matched' :
                return 2, line
    
    return 0, None
    
    
    
def checkBetBtcBetForPlace(betbtc_event_id, player_name, backlay, odds, stake) :   
    """
    Check if a odd still okay for place a bet
    
    Args:
        betbtc_bet_id : betbtc id of the bet   
        player_name : name of the player
        backlay : type of the bet
        odds : the requested odds
        stake : the requested stakes
    Returns:
        status : 0 = bet check successful
                 -1 = bet not found
                 -3 = Stake bigger then maxRiskStake
                 -4 = odds smaller then requested
        message : the message (look above)

        
    """  

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
                            return -4, "odds smaller then requested" + str(data)
                        if stake > btc_stake:
                            return -3, "Stake bigger then maxRiskStake" + str(data)
                    else :
                         if btc_odds > odds:
                            return -4, "odds smaller then requested" + str(data)                       
                    if stake > btc_stake:
                       return -3, "Stake bigger then maxRiskStake" + str(data)
                    return 0, "okay"
    return -1, "bet not found"
                            
            
def placeBetBtcBet(betbtc_event_id, player_name, backlay, odds, stake) :
    """
    Place a bet on betbtc
    
    Args:
        betbtc_bet_id : betbtc id of the bet   
        player_name : name of the player
        backlay : type of the bet
        odds : the requested odds
        stake : the requested stakes
    Returns:
        betid : betbtc bet id (if successful)
                -1 = error placing bet
        message : the message (look above)
        data : additional data
        
    """  
    if backlay == 1 :
        bettyp = 'back'
    elif backlay == 2 :
        bettyp = 'lay'
    
    parameters = {'market_id' : str(betbtc_event_id), 'selection' : player_name, 'odd' : str(odds), 'stake' : str(stake), 'bet_type' : bettyp}

    url = add_url_params("https://www.betbtc.co/api/bet/", parameters)

    response = requests.post(url, headers=headers)    
    data = response.json()
    if data[0]['status'] == 'OK' :
        status, line = checkBetBtcOpenBet(data[0]['id'])
        if status == 2 :
            return data[0]['id'], "bet placed and matched", data
        if status == 1 :
            closeBetBtcBet(betbtc_event_id)
            return data[0]['id'], "bet placed and unmatched", data
        else :
            return data[0]['id'], "problem by checking bet", data
    else :
        return -1, "error placing bet, Errorcode", data
        
        
def placeBetBtcOffer(betbtc_event_id, player_name, backlay, odds, stake) :
    """
    Place a bet offer on betbtc
    
    Args:
        betbtc_bet_id : betbtc id of the bet   
        player_name : name of the player
        backlay : type of the bet
        odds : the requested odds
        stake : the requested stakes
    Returns:
        betid : betbtc bet id (if successful)
                -1 = error placing bet
        message : the message (look above)
        data : additional data
        
    """  
    if backlay == 1 :
        bettyp = 'back'
    elif backlay == 2 :
        bettyp = 'lay'
    
    parameters = {'market_id' : str(betbtc_event_id), 'selection' : player_name, 'odd' : str(odds), 'stake' : str(stake), 'bet_type' : bettyp}

    url = add_url_params("https://www.betbtc.co/api/bet/", parameters)

    response = requests.post(url, headers=headers)    
    data = response.json()
    if data[0]['status'] == 'OK' :
        return data[0]['id'], "offer placed", data
    else :
        return -1, "error placing bet, Errorcode", data

    
    
def closeBetBtcBet(betbtc_event_id) :
    """
    Close all bets on a event
    
    Args:
        betbtc_event_id : id of the event
        
    Returns:
        response : the response from the market
    """

    
    url = "https://www.betbtc.co/api/bet/"+str(betbtc_event_id)+"?selection=all"
    
    response =  requests.delete(url ,headers=headers).json()
    return response    
    
    
def updateBetBtcBet(betbtc_bet_id, odds) :
    """
    Update an existing bet with a odd
    
    Args:
        betbtc_event_id : id of the event
        odds : new odds
        
    Returns:
        status : 0 = successfull
        betid: the new bet ID
    """

    response =  requests.get("http://www.betbtc.co/api/bet/",headers=headers).json()
    for line in response :
        if betbtc_bet_id == line[0] :
            print(line)
            event_id = line[3]
                      
   
    url = "https://www.betbtc.co/api/bet/"+str(betbtc_bet_id)+"?odd="+str(odds)
    response_odds =  requests.put(url ,headers=headers).json()
    print(response_odds)
    time.sleep(5)

    response =  requests.get("http://www.betbtc.co/api/bet/",headers=headers).json()
    for line in response :
        if event_id == line[3] :
            if "lay" == line[7] and "Unmatched" in line[2] :
                print(line)
                betbtc_bet_id = line[0]    
    
    
    
    return 0, betbtc_bet_id 
    
#def placePinnacleBet(event_id, type_id, way, backlay, odds, stake) :

#with open("betbtc/" + date_id + "_tennis_leagues.json", 'w') as fp:
#    json.dump(leagues, fp)
#    
#with open("betbtc/" + date_id + "_tennis_events.json", 'w') as fp:
#    json.dump(events, fp)    