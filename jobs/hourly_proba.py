# -*- coding: utf-8 -*-
"""
Created on Mon Nov 13 17:25:55 2017

@author: haenec
"""


from comeon_etl import get_ta_current, etl_import_ta, etl_transform_ta, get_ttt_current, etl_import_ttt, etl_transform_ttt
from comeon_common import getEvents
from comeon_common import getOdds
from comeon_bet import ta_proba, ttt_proba, ta_proba_fix, ta_proba_value





sqllite3_path = 'c:\\users/haenec/python/home/comeon/data/te_data.db'

getEvents(bookies = ['pinnacle'])
getOdds()
try :
    get_ta_current()
except: 
    print("Error loading new TA results")
etl_import_ta()
etl_transform_ta()
ta_proba()
#ta_proba_fix()
ta_proba_value()

# get TTT data
try :
    get_ttt_current()
    etl_import_ttt()
    etl_transform_ttt()
except: 
    print("Error fetching emails (ttt)")    
ttt_proba()