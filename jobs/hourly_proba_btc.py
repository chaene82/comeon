# -*- coding: utf-8 -*-
"""
Created on Mon Nov 13 17:25:55 2017

@author: haenec
"""


from comeon_etl import get_ta_current, etl_import_ta, etl_transform_ta
from comeon_common import getEvents
from comeon_common import getOdds
from comeon_bet import  ta_proba_btc





#sqllite3_path = 'c:\\users/haenec/python/home/comeon/data/te_data.db'

getEvents(bookies = ['betbtc'])
getOdds()
get_ta_current()
etl_import_ta()
etl_transform_ta()
ta_proba_btc()