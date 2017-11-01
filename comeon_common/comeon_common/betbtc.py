# -*- coding: utf-8 -*-
"""
Created on Wed Oct 11 17:10:07 2017

@author: haenec
"""

import requests
import pandas as pd
import json

## to do: move that to the database
headers = {"Authorization":"Token token=4bb29bd1d3a647859fbf1f920814bf56"}

#leagues = requests.get("http://www.betbtc.co/api/sportsleagues/leagues?id=3",headers=headers).json()


def getBetBtcEventData():
    return requests.get("http://www.betbtc.co/api/event?sport=3",headers=headers).json()



def getBetBtcMaketOdds(event_id):
    data = requests.get("http://www.betbtc.co/api/market?id=" + str(event_id),headers=headers)
    return data.json()
    

#def placeBetBtcBet() :
#   return requests.get("http://www.betbtc.co/api/bet?id=" + str(event_id),headers=headers).json()
    
def checkBetBtcBalance() :
    balance = requests.get("http://www.betbtc.co/api/user/balance",headers=headers).json()
    availiable = balance[0]['Balance']
    blocked = balance[0]['Blocked']
    return availiable + blocked, availiable, blocked

#def checkBetBtcSettledBet() :
#    statement = requests.get("http://www.betbtc.co/api/user/statement",headers=headers).json()
    
    



#with open("betbtc/" + date_id + "_tennis_leagues.json", 'w') as fp:
#    json.dump(leagues, fp)
#    
#with open("betbtc/" + date_id + "_tennis_events.json", 'w') as fp:
#    json.dump(events, fp)    