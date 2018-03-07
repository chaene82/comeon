# -*- coding: utf-8 -*-
"""
Created on Mon Nov 13 17:25:55 2017

@author: haenec
"""

from datetime import datetime, timedelta
import os

from comeon_etl import  etl_te_get_matches, etl_import_te_daily_results, etl_transform_te_results, etl_import_te_daily_player, etl_te_get_missing_players
from comeon_etl import etl_transform_te_players, etl_transform_te_matchdetails, etl_import_te_daily_matchdetails
from comeon_etl import calcFairOdds, etl_te_get_matchesdetails, weeklyModelSwisstennis, etl_te_get_ranking, etl_import_te_weekly_ranking, createRanking
from comeon_common import startBetLogging

log = startBetLogging("etl")


#sqllite3_path = 'c:\\users/haenec/python/home/comeon/data/te_data.db'

todate = datetime.now().date() 
date = datetime.strptime("17/02/18", "%d/%m/%y").date()

#todate = date 



while date <= todate :
    
    log.info("load data for " + str(date))
    
    try:
        os.remove('te_data.db')
    except OSError:
        pass

    etl_te_get_matches(date)
    etl_import_te_daily_results(10000)
    etl_transform_te_results();
    
    etl_te_get_missing_players()
    etl_import_te_daily_player()
    etl_transform_te_players()
    
    etl_te_get_matchesdetails()
    etl_import_te_daily_matchdetails()
    etl_transform_te_matchdetails()
    
    calcFairOdds()
    
    if date.weekday() == 0 :        
        log.info("load weekly ranking for " + str(date))
        
        etl_te_get_ranking(date)
        etl_import_te_weekly_ranking()
        weeklyModelSwisstennis(start_value=0.1, days_between_run=7, look_back_weeks=52, ModelName='SW1YH', date=date)
        weeklyModelSwisstennis(start_value=0.1, days_between_run=7, look_back_weeks=52, ModelName='SW1YG', date=date)        
        weeklyModelSwisstennis(start_value=0.1, days_between_run=7, look_back_weeks=52, ModelName='SW1YC', date=date)        

        weeklyModelSwisstennis(start_value=0.1, days_between_run=7, look_back_weeks=52, ModelName='SW1YALL', date=date)
        weeklyModelSwisstennis(start_value=0.1, days_between_run=7, look_back_weeks=12, ModelName='SW3MALL', date=date)     
        weeklyModelSwisstennis(start_value=0.1, days_between_run=7, look_back_weeks=4, ModelName='SW1MALL', date=date)           
        
        createRanking(date)
     
    
    date = date + timedelta(days=1)
