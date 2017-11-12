#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct 15 10:25:53 2017

@author: chrhae
"""


import pandas as pd

from datetime import datetime
from sqlalchemy import create_engine






now = datetime.now()




def connect(user, password, db, host='localhost', port=5432):
    '''Returns a connection and a metadata object'''
    # We connect with the help of the PostgreSQL URL
    # postgresql://federer:grandestslam@localhost:5432/tennis
    url = 'postgresql://{}:{}@{}:{}/{}'
    url = url.format(user, password, host, port, db)

    # The return value of create_engine() is our connection object
    con = create_engine(url, client_encoding='utf8')

    # We then bind the connection to MetaData()

    return con

    
    
def etl_import_sackmann_player(con_postgres, sackmann_player_path) :

    players = pd.read_csv(sackmann_player_path,  sep=',' ,encoding='iso-8859-1', header=None)
    players.columns=["id", "firstname", "lastname", "plays", "dob", "IOC"]
    
    players['id'] = players['id'].astype('int')
    players['firstname'] = players['firstname'].astype('str')
    players['lastname'] = players['lastname'].astype('str')
    players['dob'] = players['dob'].fillna(0).astype(int)
    players['IOC'] = players['IOC'].astype('str')
    
    players['update'] = pd.to_datetime('now')
    
    players.iloc[0:].to_sql('tbl_sackmann_players', con_postgres, if_exists='replace')


def etl_import_sackmann_matchlist(con_postgres,sackmann_starting_year, sackmann_atp_matchs, sackmann_chall_matchs, sackmann_futures_matchs) :

    matches = pd.DataFrame()
    for year in range(sackmann_starting_year, now.year + 1) :
        print(year)
        usecols = range(49)
        print(sackmann_atp_matchs.format(year))
        match_year = pd.read_csv(sackmann_atp_matchs.format(year),  usecols=usecols, index_col=False ,encoding='iso-8859-1')
        matches = matches.append(match_year)
        print(sackmann_chall_matchs.format(year))
        match_year = pd.read_csv(sackmann_chall_matchs.format(year),  usecols=usecols, index_col=False ,encoding='iso-8859-1')
        matches = matches.append(match_year)
        print(sackmann_futures_matchs.format(year))
        match_year = pd.read_csv(sackmann_futures_matchs.format(year),  usecols=usecols, index_col=False ,encoding='iso-8859-1')
        matches = matches.append(match_year)
        
    matches.to_sql('tbl_sackmann_match', con_postgres, if_exists='replace')


    
def etl_import_sackmann (year, path) :
    con_postgres = connect('tennis', 'tennis', 'tennis', port=5433)    

    
    sackmann_starting_year = year
    sackmann_player_path = path + "atp_players.csv"
    sackmann_atp_matchs = path + "atp_matches_{}.csv"
    sackmann_chall_matchs = path + "atp_matches_qual_chall_{}.csv"
    sackmann_futures_matchs = path + "atp_matches_futures_{}.csv"
    
## Testing
    etl_import_sackmann_player(con_postgres, sackmann_player_path)
    etl_import_sackmann_matchlist(con_postgres,sackmann_starting_year, sackmann_atp_matchs, sackmann_chall_matchs, sackmann_futures_matchs)

etl_import_sackmann(2017, "/home/chrhae/Documents/Privat/data/ffhs/DAS/ML/tennis_atp/")