#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Sep 10 16:19:16 2017

@author: chrhae
"""

import pandas as pd
from betdaq.apiclient import APIClient
import collections
from .base import startBetLogging, removeTime
import yaml



log = startBetLogging("betdaq Wrapper")



## Class for as Wrapper



class betdaq:
    
    sports_id = 100005
    api = ''
    odds = None
    
    def __init__(self):
        with open("config.yml", 'r') as ymlfile:
            self.cfg = yaml.load(ymlfile)          
            self.api = APIClient(self.cfg['betdaq']['api']['username'] , self.cfg['betdaq']['api']['password'] )
                  
    
    def checkBalance(self) :
        """
        CCheck the balance on pinnacle
        
        Args:
            
        Returns:
            total_balance : total balance (including placed open bets)
            availiable : availiable balance for betting
            blocked : placed balance
        """ 
        account = self.api.account.get_account_balances()
        availiable = account['available_funds']
        blocked = account['exposure']
        
        return availiable + blocked, availiable, blocked


    def getEvents(self) :
        """
        Get all open events on pinnacle
        
        Args:
            
        Returns:
            json : the list of the events
        """        
        result = pd.DataFrame()
        
        events =  self.api.marketdata.get_sport_markets(self.sports_id)
        for event in events :
            if event['market_name'] == 'Match Betting' :
                
                print(event['event_name'])
                log.info("betdaq event id " + str(event['event_id']))
                bookie_event_id = event['event_id']
                  
                StartDate        = removeTime(event['market_start_time'])
                StartDateTime    = event['market_start_time']
                home_player_name = event['event_name'].split(' v ')[0] 
                if not home_player_name[0].isalpha() :
                    home_player_name = home_player_name[6:]
                away_player_name = event['event_name'].split(' v ')[1]
           
                dict = collections.OrderedDict({'bookie_event_id': bookie_event_id, 'StartDate' : StartDate, 'StartDateTime' : StartDateTime,
                                                    'home_player_name' : home_player_name, 'away_player_name': away_player_name})
                    
                result = result.append(pd.DataFrame([dict]))
                
        return result
    
    
    
    def getOdds(self, bookie_event_id, home_name = None, away_name = None) :
        """
        Get all open odds on pinnacle
        
        Args:      
        """
        if self.odds == None :
            self.odds = self.api.market_data.get_odds(self.sports_id)
            
            
        result = pd.DataFrame()
        
        for league in self.odds['leagues']:
            for event in league['events']:
                if event['id'] == bookie_event_id:
                   # print(bookie_event_id)
                    
                    event_odds = event
                    i = 0
                    for line in event_odds['periods'] :
                        if 'moneyline' in event_odds['periods'][i] and line['number'] == 0 :
                            #print(line)
                            
                            home_ml = line['moneyline']['home']
                            away_ml = line['moneyline']['away']
                            
                            line_id = line['lineId']
                            
                            home_back = collections.OrderedDict({'bookie_event_id': bookie_event_id, 'bettype' : 1, 'backlay' : 1, 'way' : 1,
                                             'odds' : home_ml, 'minStake': 0, 'maxStake' : 0, 'pin_line_id' : line_id})                            
 

                            away_back = collections.OrderedDict({'bookie_event_id': bookie_event_id, 'bettype' : 1, 'backlay' : 1, 'way' : 2,
                                             'odds' : away_ml, 'minStake': 0, 'maxStake' : 0, 'pin_line_id' : line_id})
           
                            result = result.append([home_back])
                            result = result.append([away_back])
         
                        i = i +1
                        
                    

                        
        return result
            
        
        
    def checkBetForPlace(self, pin_event_id, pin_league_id, type_id, way, backlay, odds, stake) :
        """
        Check if a odd still okay for place a bet
        
        Args:
            pin_event_id : pinnacle id of the bet   
            pin_league_id : pinnacle league id
            type_id: bettyp id
            way : home or away
            backlay : type of the bet
            odds : the requested odds
            stake : the requested stakes
        Returns:
            status : 0 = bet check successful
                     -1 = bet not found
                     -3 = Stake bigger then maxRiskStake
                     -4 = odds smaller then requested
                     -11 = not enough balance
                     -99 = way not correct
            message : the message (look above)
    
            
        """  
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
        
        bet_data = self.api.market_data.get_line(sports_id, league_id=pin_league_id, event_id=pin_event_id, period_number = period_number, bet_type = bettype, team=team)
        
        ## Check if the bet still okay
        
        if stake < bet_data['minRiskStake'] :
            return -2, "Stake smaller as minRiskStake (stake" + str(stake) + ") "  + str(bet_data)
            
        if stake > bet_data['maxRiskStake'] :
            return -3, "Stake bigger then maxRiskStake (stake" + str(stake) + ") "  + str(bet_data)
            
        if odds > bet_data['price'] : 
            return -4, "odds smaller then requested" + str(bet_data)
        
        balance = self.checkBalance()
        
        if stake >= balance[0] :
            return -11, "Not enough balance"
            
        return 0, "okay"       


    def placeBet(self, pin_event_id, pin_line_id, type_id,  way, backlay, odds, stake) :
        """
        Place a bet on pinnalce
        
        Args:
            pin_event_id : pinnacle id of the bet   
            pin_league_id : pinnacle league id
            type_id: bettyp id
            way : home or away
            backlay : type of the bet
            odds : the requested odds
            stake : the requested stakes
        Returns:
            status : True = bet successful placed
                     False = error bet placing bet
            message : the message (look above)
            response : response for the bookie
    
            
        """  
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
            
    
        
        response = self.api.betting.place_bet(sports_id, pin_event_id, pin_line_id, period_number, bettype, stake, team=team, accept_better_line=True)
        if response['status'] == 'ACCEPTED' :
            log.info("bet places on event " + str(pin_event_id))        
            return response['betId'], "bet placed", response
        else :
            log.info("bet was not place")
            return -1, "error placing bet, Errorcode " + response['errorCode'], response


        
    def checkUnsettledBet(self, pin_bet_id) :   
        """
        Checking the status of a unsettled bet
        
        Args:
            pin_bet_id : Bet id
        Returns:
            status : the status of the bet
            response : the complete response for the bookie
        """
        
        response = self.api.betting.get_bets(betids = pin_bet_id)
        
        return response['betStatus'], response
    
    
    def checkSettledBet(self, pin_bet_id) :
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
        response =  self.api.betting.get_bets(betids = pin_bet_id)
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



            


