# -*- coding: utf-8 -*-
"""
This is a first version of a wrapper for Bet Btc

ToDo:
    Rewrite is as a class
@author: haenec
"""

import requests
from json import dumps
import pandas as pd
import time
import yaml
import collections
import numpy as np
from .base import startBetLogging, removeTime
from urllib.parse import (
    urlencode, unquote, urlparse, parse_qsl, ParseResult
)

log = startBetLogging("BET BTC Wrapper")



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



## Class for as Wrapper


class betbtc:
    
    account = ''
    header = ''
    sports = ''
    
    def __init__(self, account):
        with open("config.yml", 'r') as ymlfile:
            self.account = account
            self.cfg = yaml.load(ymlfile)
            self.header=  {"Authorization":"Token token=" + self.cfg['betbtc']['api'][self.account]['token']}
            self.sports = self.cfg['betbtc']['api']['tennis']
 

                   
    
    def checkBalance(self) :
        """
        Check the Balance on the account  
        Args:
            -        
        Returns:
            total_balance : total balance (including placed open bets)
            availiable : availiable balance for betting
        blocked : placed balance
        
        """  
        balance = requests.get("http://www.betbtc.co/api/user/balance",headers=self.header).json()
        availiable = balance[0]['Balance']
        blocked = balance[0]['Blocked']
        return float(availiable) + float(blocked), availiable, blocked



    def getEvents(self):
        """
        get Open Events form BetBTC    
        Args:
            -        
        Returns:
            json : A list of events
            
        """  
        events = requests.get("http://www.betbtc.co/api/event?sport=" + str(self.sports), headers=self.header).json()    
        
        result = pd.DataFrame()
        for event in events :
        # looking for Match Odds
            if event[7] == "Match Odds" :
                log.info("betbtc_event_id "  + str(event[0]))
                bookie_event_id = event[0]
                StartDate        = removeTime(event[3])
                StartDateTime    = event[3]
                home_player_name = (event[6][0]['name'])
                away_player_name = (event[6][1]['name'])
                betfair_event_id = (event[5])
                
                dict = collections.OrderedDict({'bookie_event_id': bookie_event_id, 'StartDate' : StartDate, 'StartDateTime' : StartDateTime,
                                                'home_player_name' : home_player_name, 'away_player_name': away_player_name, 
                                                'betfair_event_id' : betfair_event_id})
                
                result = result.append(pd.DataFrame([dict]))
                
        return result

    
    def getOdds(self, bookie_event_id, home_name = None, away_name = None) :
        """
        get Open Odds form BetBTC    
        Args:
            event_id : event id        
        Returns:
            json : A list of odds
            
        """              
        #print(bookie_event_id)
        odds = requests.get("http://www.betbtc.co/api/market?id=" + str(bookie_event_id),headers=self.header).json()
        
        if len(odds) != 2:
            home_back = np.nan
            home_lay = np.nan
            away_back = np.nan
            away_lay = np.nan
            home_back_max = np.nan
            home_lay_max = np.nan
            away_back_max = np.nan
            away_lay_max = np.nan
        else :      
            
            if home_name in odds[0] :
                home_odd = list(odds[0].values())[0]
                home_back = home_odd['Back'][0][0]
                home_back_max = home_odd['Back'][0][1] if len(home_odd['Back'][0]) == 2 else np.nan
                home_lay = home_odd['Lay'][0][0]
                home_lay_max = home_odd['Lay'][0][1] if len(home_odd['Lay'][0]) == 2 else np.nan
            elif home_name in odds[1] :
                home_odd = list(odds[1].values())[0]             
                home_back = home_odd['Back'][0][0]
                home_back_max = home_odd['Back'][0][1] if len(home_odd['Back'][0]) == 2 else np.nan
                home_lay = home_odd['Lay'][0][0]
                home_lay_max = home_odd['Lay'][0][1] if len(home_odd['Lay'][0]) == 2 else np.nan
            
            if away_name in odds[0] :
                away_odd = list(odds[0].values())[0]
                away_back = away_odd['Back'][0][0]
                away_back_max = away_odd['Back'][0][1] if len(away_odd['Back'][0]) == 2 else np.nan
                away_lay = away_odd['Lay'][0][0]
                away_lay_max = away_odd['Lay'][0][1] if len(away_odd['Lay'][0]) == 2 else np.nan                
            elif away_name in odds[1] : 
                away_odd = list(odds[1].values())[0]
                away_back = away_odd['Back'][0][0]
                away_back_max = away_odd['Back'][0][1] if len(away_odd['Back'][0]) == 2 else np.nan
                away_lay = away_odd['Lay'][0][0]
                away_lay_max = away_odd['Lay'][0][1] if len(away_odd['Lay'][0]) == 2 else np.nan   
            else:
                home_back = np.nan
                home_lay = np.nan
                away_back = np.nan
                away_lay = np.nan       
                home_back_max = np.nan
                home_lay_max = np.nan
                away_back_max = np.nan
                away_lay_max = np.nan

        if not isinstance(home_back, float) : home_back = np.nan
        if not isinstance(home_lay, float)  : home_lay = np.nan
        if not isinstance(away_back, float) : away_back = np.nan
        if not isinstance(away_lay, float)  : away_lay = np.nan
        
                        
        dict_home_back = collections.OrderedDict({'bookie_event_id': bookie_event_id, 'bettype' : 1, 'backlay' : 1, 'way' : 1,
                             'odds' : home_back, 'minStake': 0, 'maxStake' : home_back_max, 'pin_line_id' : 0})

        dict_home_lay  = collections.OrderedDict({'bookie_event_id': bookie_event_id, 'bettype' : 1, 'backlay' : 2, 'way' : 1,
                             'odds' : home_lay, 'minStake': 0, 'maxStake' : home_lay_max, 'pin_line_id' : 0})                         

        dict_away_back = collections.OrderedDict({'bookie_event_id': bookie_event_id, 'bettype' : 1, 'backlay' : 1, 'way' : 2,
                             'odds' : away_back, 'minStake': 0, 'maxStake' : away_back_max, 'pin_line_id' : 0})

        dict_away_lay  = collections.OrderedDict({'bookie_event_id': bookie_event_id, 'bettype' : 1, 'backlay' : 2, 'way' : 2,
                             'odds' : away_lay, 'minStake': 0, 'maxStake' : away_lay_max, 'pin_line_id' : 0})                          
        
        result = pd.DataFrame()
        
        result = result.append([dict_home_back])
        result = result.append([dict_home_lay])                 
        result = result.append([dict_away_back])
        result = result.append([dict_away_lay])    
        
        return result


    def checkSettledBet(self, betbtc_bet_id) :
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
        response =  requests.get("http://www.betbtc.co/api/user/statement",headers=self.header).json()
        for line in response :
            if str(betbtc_bet_id) in line['description'] :
                if line['credit'] == None:
                    winnings = 0
                else :
                    winnings = line['credit']
                    
                odds = line['odd']
                return 'settled', winnings, odds, line
            
        status, matched, unmatched = self.checkOpenBet(betbtc_bet_id)
        
        if status == 1:
            return 'unmatched', 0, 0 ,matched
        elif status == 2:
            return 'matched', 0, 0, matched
        
        return 'Not Found', 0, 0, None       
    
    
    def checkOpenBet(self, betbtc_bet_id) :
        """
        Check for open bet (matched and unmatched)
        Args:
            betbtc_bet_id : betbtc id of the bet   
        Returns:
            status : 1 = matched
                     2 = unmatched
            lien : additional information about the bet
            
        """  
        response =  requests.get("http://www.betbtc.co/api/bet/",headers=self.header).json()
        matched_sum = 0
        unmatched_sum = 0
        for line in response :
            if betbtc_bet_id == line[0] :
                if line[2] == 'Unmatched' :      
                    unmatched_sum = unmatched_sum + line[6] 
                    #return 1, line
                elif line[2] == 'Matched' :
                    matched_sum = matched_sum + line[6] 
                    #return 2, line
        if (matched_sum > 0 and unmatched_sum > 0 ) :
            return 3, matched_sum, unmatched_sum
        elif (matched_sum > 0 and unmatched_sum == 0 ) :
            return 2, matched_sum, unmatched_sum
        elif (matched_sum == 0 and unmatched_sum > 0 ) :
            return 1, matched_sum, unmatched_sum      
        else :
            return 0, 0, 0

    def checkBetForPlace(self, betbtc_event_id, player_name, backlay, odds, stake) :   
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
    
        data = requests.get("http://www.betbtc.co/api/market?id=" + str(betbtc_event_id),headers=self.header).json()
        
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


    def placeBet(self, betbtc_event_id, player_name, backlay, odds, stake) :
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
    
        response = requests.post(url, headers=self.header)    
        data = response.json()
        if data[0]['status'] == 'OK' :
            status, line = self.checkOpenBet(data[0]['id'])
            if status == 2 :
                return data[0]['id'], "bet placed and matched", data
            if status == 1 :
                closeBetBtcBet(betbtc_event_id)
                return data[0]['id'], "bet placed and unmatched", data
            else :
                return data[0]['id'], "problem by checking bet", data
        else :
            return -1, "error placing bet, Errorcode", data
        
        

    def placeOffer(self, betbtc_event_id, player_name, backlay, odds, stake) :
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
    
        log.info("placing offer")
    
        url = add_url_params("https://www.betbtc.co/api/bet/", parameters)
    
        response = requests.post(url, headers=self.header)    
        data = response.json()
        if data[0]['status'] == 'OK' :
            return data[0]['id'], "offer placed", data
        else :
            return -1, "error placing bet, Errorcode", data




    def closeBet(self, betbtc_event_id, player_name) :
        """
        Close all bets on a event
        
        Args:
            betbtc_event_id : id of the event
            
        Returns:
            response : the response from the market
        """
    
        
        url = "https://www.betbtc.co/api/bet/"+str(betbtc_event_id)+"?selection=" + str(player_name)
        
        response =  requests.delete(url ,headers=self.header).json()
        
        return response    


    
    def updateBetBtcBet(self, betbtc_bet_id, odds) :
        """
        Update an existing bet with a odd --> do not use, not safe!!!!
        
        Args:
            betbtc_event_id : id of the event
            odds : new odds
            
        Returns:
            status : 0 = successfull
            betid: the new bet ID
        """
    
        response =  requests.get("http://www.betbtc.co/api/bet/",headers=self.header).json()
        for line in response :
            if betbtc_bet_id == line[0] :
                print(line)
                event_id = line[3]
                          
       
        url = "https://www.betbtc.co/api/bet/"+str(betbtc_bet_id)+"?odd="+str(odds)
        response_odds =  requests.put(url ,headers=self.header).json()
        print(response_odds)
        time.sleep(5)
    
        response =  requests.get("http://www.betbtc.co/api/bet/",headers=self.header).json()
        for line in response :
            if event_id == line[3] :
                if "lay" == line[7] and "Unmatched" in line[2] :
                    print(line)
                    betbtc_bet_id = line[0]    
        
        
        
        return 0, betbtc_bet_id 



    
