# -*- coding: utf-8 -*-
"""
Created on Mon Nov 13 17:25:55 2017

@author: haenec
"""

from datetime import datetime, timedelta
import os

from comeon_etl import  etl_te_get_matches, etl_import_te_daily_results, etl_transform_te_results, etl_import_te_daily_player, etl_te_get_missing_players
from comeon_etl import etl_transform_te_players, etl_transform_te_matchdetails, etl_import_te_daily_matchdetails
from comeon_etl import calcFairOdds, etl_te_get_matchesdetails_all, weeklyModelSwisstennis, etl_te_get_ranking, etl_import_te_weekly_ranking, createRanking
from comeon_common import startBetLogging

log = startBetLogging("etl")


#sqllite3_path = 'c:\\users/haenec/python/home/comeon/data/te_data.db'
#todate = date 




    
try:
    os.remove('te_data.db')
except OSError:
    pass



etl_te_get_matchesdetails_all()
etl_import_te_daily_matchdetails()
etl_transform_te_matchdetails()
    

