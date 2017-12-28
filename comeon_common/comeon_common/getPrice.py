# -*- coding: utf-8 -*-
"""
Created on Tue Nov  7 12:47:33 2017

@author: haenec
"""
import requests


def getBtcEurPrice():
    """
    get the actual BTC EUR price on Kraken using the API of crypto watch    
    Args:
        -

    Returns:
        the actual price of BTC and EUR


    ToDo:
        Change to a better wrapper funtion
    
    
    """   
    response = requests.get("https://api.cryptowat.ch/markets/kraken/btceur/price").json()
    return float(response['result']['price'])

