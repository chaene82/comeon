#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct 15 10:25:53 2017

@author: chrhae
"""


import pandas as pd
import sqlite3
from datetime import datetime
import sqlalchemy
from sqlalchemy import create_engine
from comeon_common import connect
#from .tennis_config import *



conn_sqllite3 = sqlite3.connect('te_data.db')
con_postgres, meta = connect()    

    
def etl_import_te_matchlist(conn_sqllite3, con_postgres, days = 10000) :
    print("load Tennis Explorer Matchlist")
    df_input = pd.read_sql('select * from tmp_te_matchlist where "MatchDate" > date("now","-' + str(days) + ' days") ', conn_sqllite3)
    
    df_input = df_input.drop_duplicates()
    df_input = df_input.drop('index', axis=1)
    

    # Change Data Type
    df_input['MatchDate'] = pd.to_datetime(df_input.MatchDate)
    df_input['away'] = df_input['away'].str.replace(r"\(.*\)","")
    df_input['away_odds'] = pd.to_numeric(df_input['away_odds'])
    df_input['away_result'] = pd.to_numeric(df_input['away_result'])
    df_input['away_score_1'] = pd.to_numeric(df_input['away_score_1'].astype('str').str[:1], errors='coerce')
    df_input['away_score_2'] = pd.to_numeric(df_input['away_score_2'].astype('str').str[:1], errors='coerce')
    df_input['away_score_3'] = pd.to_numeric(df_input['away_score_3'].astype('str').str[:1], errors='coerce')
    df_input['away_score_4'] = pd.to_numeric(df_input['away_score_4'].astype('str').str[:1], errors='coerce')
    df_input['away_score_5'] = pd.to_numeric(df_input['away_score_5'].astype('str').str[:1], errors='coerce')
    df_input['home'] = df_input['home'].str.replace(r"\(.*\)","")
    df_input['home_odds'] = pd.to_numeric(df_input['home_odds'])
    df_input['home_result'] = pd.to_numeric(df_input['home_result'])
    df_input['home_score_1'] = pd.to_numeric(df_input['home_score_1'].astype('str').str[:1], errors='coerce')
    df_input['home_score_2'] = pd.to_numeric(df_input['home_score_2'].astype('str').str[:1], errors='coerce')
    df_input['home_score_3'] = pd.to_numeric(df_input['home_score_3'].astype('str').str[:1], errors='coerce')
    df_input['home_score_4'] = pd.to_numeric(df_input['home_score_4'].astype('str').str[:1], errors='coerce')
    df_input['home_score_5'] = pd.to_numeric(df_input['home_score_5'].astype('str').str[:1], errors='coerce')
    
    df_input['away_link'] = df_input['away_link'].astype('str')
    df_input['home_link'] = df_input['home_link'].astype('str')
    
    df_input['match_link'] = df_input['match_link'].astype('str')
    df_input['tournament'] = df_input['tournament'].astype('str')
    df_input['tournament_link'] = df_input['tournament_link'].astype('str')
    
    df_input['update'] = pd.to_datetime('now')
    
    
    print("Store Tennis Explorer Matchlist")    
    df_input.to_sql(name='tbl_te_matchlist', con=con_postgres, if_exists='replace', index=False)
    

def etl_import_te_player(conn_sqllite3, con_postgres, days = 10000) :
    print("Load Tennis Explorer player list")    
            
    df_player = pd.read_sql('select * from tmp_te_player where etl_date > date("now","-' + str(days) + ' days") ', conn_sqllite3)
    df_player = df_player.drop_duplicates()
    
    df_player = df_player.drop('index', axis=1)
    
    df_player['etl_date'] = pd.to_datetime(df_player.etl_date)
    df_player['update'] = pd.to_datetime('now')
 
    print("Store Tennis Explorer player list")    

    df_player.to_sql('tbl_te_player', con_postgres, if_exists='replace')
    

def etl_import_te_matchdetails(conn_sqllite3, con_postgres, days = 10000) :
    print("Load Tennis Explorer match details")    
            
    df_matchdetails = pd.read_sql('select * from tmp_te_matches_details', conn_sqllite3)
    df_matchdetails = df_matchdetails.drop_duplicates()
      
    print("Store Tennis Explorer match details")    

    df_matchdetails.to_sql('tbl_te_matchdetails', con_postgres, if_exists='replace')


    
def etl_import_te_ranking(conn_sqllite3, con_postgres, days = 10000) :
    print("Load Tennis Explorer ranking list")    
    
    
    conn_sqllite3 = sqlite3.connect('te_data_ranking.db')
    con_postgres, meta = connect()    
            
    df_ranking = pd.read_sql('select * from tmp_te_ranking where "StartDate" > date("now","-' + str(days) + ' days") ', conn_sqllite3)
    df_ranking = df_ranking.drop_duplicates()
    
    df_ranking = df_ranking.drop('index', axis=1)
    
    df_ranking['StartDate'] = pd.to_datetime(df_ranking.StartDate)
    df_ranking['StartDate'] = pd.to_datetime(df_ranking.StartDate)
    df_ranking['rank'] = df_ranking['rank'].str[:-1]
    df_ranking['rank'] = df_ranking['rank'].astype('int')
 
    print("Store Tennis Explorer ranking list")    

    df_ranking.to_sql('tbl_te_ranking', con_postgres, if_exists='replace')    

    
    
def etl_import_te(days=100) :

    ## Testing
    etl_import_te_matchlist(conn_sqllite3, con_postgres, days=days)
    #etl_import_te_player(conn_sqllite3, con_postgres, days=days)
    #etl_import_te_ranking(conn_sqllite3, con_postgres, days=days)
    
def etl_import_te_daily_results(days=10000) :
    etl_import_te_matchlist(conn_sqllite3, con_postgres, days=days)
    

def etl_import_te_daily_player(days=10000) :
    etl_import_te_player(conn_sqllite3, con_postgres, days=days)

def etl_import_te_daily_matchdetails(days=10000) :
    etl_import_te_matchdetails(conn_sqllite3, con_postgres, days=days)    
    
def etl_import_te_weekly_ranking(days=10000) :
    etl_import_te_ranking(conn_sqllite3, con_postgres, days = days)