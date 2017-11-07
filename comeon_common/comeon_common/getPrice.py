# -*- coding: utf-8 -*-
"""
Created on Tue Nov  7 12:47:33 2017

@author: haenec
"""
import requests
import json


def getEthEurPrice():
    response = requests.get("https://api.cryptowat.ch/markets/kraken/btceur/price").json()
    return response['result']['price']

