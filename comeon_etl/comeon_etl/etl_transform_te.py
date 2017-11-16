#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct 15 17:08:25 2017

@author: chrhae
"""


import pandas as pd
import numpy as np
from sqlalchemy import create_engine, MetaData, select
from datetime import datetime
from comeon_common import connect


from sqlalchemy.dialects.postgresql import insert

con_postgres, meta = connect()  
tbl_player = meta.tables['tbl_player']
tbl_tournament = meta.tables['tbl_tournament']
tbl_match = meta.tables['tbl_match']  


def convertDate(date):
    try:
        return datetime.strptime(date, '%d. %m. %Y')
    except:
        return None
        
def splitName(Name) :
    name_list = Name.rsplit(' ', 1)
    last_name = name_list[0]
    first_name = name_list[1]
    return first_name, last_name


def createPlayer(row) :
    
    print("create player ")
    
    home_link = row['home_link']
    home_player_id = con_postgres.execute("Select player_id from tbl_player WHERE te_link = '" + home_link +"'").fetchone()
    
    if home_player_id is None:
        clause = insert(tbl_player).values(name_short=row['home'], \
                                                   te_link = row['home_link']) 
    
        con_postgres.execute(clause)  
        home_player_id = con_postgres.execute("Select player_id from tbl_player WHERE te_link = '" + home_link +"'").fetchone()
    
    away_link = row['away_link']
    away_player_id = con_postgres.execute("Select player_id from tbl_player WHERE te_link = '" + away_link +"'").fetchone()
    
    if away_player_id is None:
        clause = insert(tbl_player).values(name_short=row['away'], \
                                                   te_link = row['away_link']) 
    
        con_postgres.execute(clause)  
        away_player_id = con_postgres.execute("Select player_id from tbl_player WHERE te_link = '" + away_link +"'").fetchone()
 

def updatePlayer(row) :
    dt = datetime.now()

    print("update player", row['player_name'], )
    print("dob", convertDate(row['player_dob']), )
    
    first_name, last_name = splitName(row['player_name'])
    player_link = row['player_url']
    clause = insert(tbl_player).values(name_long=row['player_name'], \
                                       firstname=first_name, \
                                       lastname=last_name, \
                                       plays = row['player_plays'], \
                                       country = row['player_country'], \
                                       te_link = row['player_url'], \
                                       dayofbirth = convertDate(row['player_dob']), \
                                       update=dt) 

    clause = clause.on_conflict_do_update(
    index_elements=['te_link'],
    set_=dict(name_long=row['player_name'], \
              firstname=first_name, \
              lastname=last_name, \
              plays = row['player_plays'], \
              country = row['player_country'], \
              dayofbirth = convertDate(row['player_dob']), \
              update=dt) 
    )
    con_postgres.execute(clause)         

    
def createTournament(row) :
    tournament_link = row['tournament_link'] 
    tournament_id = con_postgres.execute("Select tournament_id from tbl_tournament WHERE te_link = '" + tournament_link +"'").fetchone()

    if tournament_id is None:
        clause = insert(tbl_tournament).values(name=row['tournament'], \
                                               te_link = row['tournament_link']) 
    
        con_postgres.execute(clause)  
        tournament_id = con_postgres.execute("Select tournament_id from tbl_tournament WHERE te_link = '" + tournament_link +"'").fetchone()
    

def createMatch(row) :
    ## This port should be optimised
    dt = datetime.now()

    home_link = row['home_link']
    home_player_id = con_postgres.execute("Select player_id from tbl_player WHERE te_link = '" + home_link +"'").fetchone()
    away_link = row['away_link']
    away_player_id = con_postgres.execute("Select player_id from tbl_player WHERE te_link = '" + away_link +"'").fetchone()
    tournament_link = row['tournament_link'] 
    tournament_id = con_postgres.execute("Select tournament_id from tbl_tournament WHERE te_link = '" + tournament_link +"'").fetchone()

    if row['home_result'] > row['away_result'] : 
        winner = 1 
    else : 
        winner = 2 
    
    score = str(row['home_result'])[:1] + ':' + str(row['away_result'])[:1]
    MatchDateYearWeek = int(str(row['MatchDate'].to_datetime().year) + str('%02d' % row['MatchDate'].to_datetime().isocalendar()[1]))
        
    # insert or update new Match (event)
    clause = insert(tbl_match).values(tournament_id=tournament_id[0], \
                                               MatchDate = row['MatchDate'], \
                                               MatchDateYearWeek = MatchDateYearWeek, \
                                               time = row['time'], \
                                               player1_id=home_player_id[0], \
                                               player2_id=away_player_id[0], \
                                               player1_set1=row['home_score_1'], \
                                               player1_set2=row['home_score_2'], \
                                               player1_set3=row['home_score_3'], \
                                               player1_set4=row['home_score_4'], \
                                               player1_set5=row['home_score_5'], \
                                               player2_set1=row['away_score_1'], \
                                               player2_set2=row['away_score_2'], \
                                               player2_set3=row['away_score_3'], \
                                               player2_set4=row['away_score_4'], \
                                               player2_set5=row['away_score_5'], \
                                               player1_odds=row['home_odds'], \
                                               player2_odds=row['away_odds'], \
                                               te_link=row['match_link'], \
                                               winner=winner, \
                                               score =score, \
                                               update=dt) 

    clause = clause.on_conflict_do_update(
    index_elements=['MatchDate', 'player1_id','player2_id'],
    set_=dict(player1_set1=row['home_score_1'], \
              player1_set2=row['home_score_2'], \
              player1_set3=row['home_score_3'], \
              player1_set4=row['home_score_4'], \
              player1_set5=row['home_score_5'], \
              player2_set1=row['away_score_1'], \
              player2_set2=row['away_score_2'], \
              player2_set3=row['away_score_3'], \
              player2_set4=row['away_score_4'], \
              player2_set5=row['away_score_5'], \
              player1_odds=row['home_odds'], \
              player2_odds=row['away_odds'], \
              te_link=row['match_link'], \
              winner=winner, \
              score =score, \
              update=dt) 
    )
    con_postgres.execute(clause)  
        
        
def transform_te_match(con_postgres):

    df_matchlist = pd.read_sql('select * from tbl_te_matchlist', con_postgres)
    
    # Building up Player table (tbl_player)
    
   
    df_matchlist.apply(createPlayer, axis = 1)
    df_matchlist.apply(createTournament, axis = 1)
    df_matchlist.apply(createMatch, axis = 1)

    
def transform_te_player(con_postgres):
    df_player = pd.read_sql('select * from tbl_te_player', con_postgres)
    
    df_player.apply(updatePlayer, axis = 1)
    

def etl_transform_te():
    transform_te_match(con_postgres)
    transform_te_player(con_postgres)