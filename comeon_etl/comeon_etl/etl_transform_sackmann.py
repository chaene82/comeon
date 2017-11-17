#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct 15 17:08:25 2017

@author: chrhae
"""


import pandas as pd
import numpy as np
from sqlalchemy import create_engine, MetaData, select, update
from datetime import datetime
from comeon_common import connect
import psycopg2
from sqlalchemy.dialects.postgresql import insert





con_postgres, meta = connect()  
tbl_player = meta.tables['tbl_player']
tbl_match = meta.tables['tbl_match']  


def updateSackmannPlayer(row) :
    dt = datetime.now()
    
    #print("update player", row['firstname'], row['lastname'] )
    
    ## searching for existing player in the table:
    #print("Select player_id from tbl_player WHERE firstname = '" + row['firstname'] +"' AND lastname = '" + row['lastname'] +"' ")
    player_id = con_postgres.execute("Select player_id from tbl_player WHERE firstname = '" + row['firstname'] +"' AND lastname = '" + row['lastname'] +"' ").fetchone()

    #print("looking for player", player_id)
    if player_id != None :
        
        #print("update Player", player_id[0])
     
    
        clause = update(tbl_player).values(sackmann_id=row['id'], \
                                           IOC=row['IOC'], \
                                           update=dt). \
                                    where(tbl_player.c.player_id==player_id[0])
        #print(clause)
        con_postgres.execute(clause)         

    
def updateSackmannMatches(row) :
    # ToDo: 2 week events
    #print(row)
    
    dt = datetime.now()
#    print("new row")
    

    home_sackmann_id = int(row['winner_id'])
    home_player_id = con_postgres.execute("Select player_id from tbl_player WHERE sackmann_id = " + str(home_sackmann_id)).fetchone()
    away_sackmann_id = int(row['loser_id'])
    away_player_id = con_postgres.execute("Select player_id from tbl_player WHERE sackmann_id = " + str(away_sackmann_id)).fetchone()
    
    if home_player_id == None :
        return None
    if away_player_id == None :
        return None
        
    
    
    tourney_date_str = str(row['tourney_date'])
    year = tourney_date_str[0:4]
    month = tourney_date_str[4:6] 
    day = tourney_date_str[6:8] 
    date = year + '-' + month + '-' + day
    week = '%02d' % datetime.strptime(date, '%Y-%m-%d').isocalendar()[1]
    MatchDateYearWeek = int(year + str(week))
#    print(MatchDateYearWeek)
        

    stm = select([tbl_match.c.match_id]).\
                 where(tbl_match.c.player1_id == home_player_id[0]).\
                 where(tbl_match.c.player2_id == away_player_id[0]).\
                 where(tbl_match.c.MatchDateYearWeek == MatchDateYearWeek)
    
    tbl_match_id = con_postgres.execute(stm).fetchone()  
    
    if tbl_match_id != None :
        #print("Match found for ID ", tbl_match_id[0])
        # insert or update new Match (event)
        stm = update(tbl_match).where(tbl_match.columns.match_id==tbl_match_id[0]).\
                 values(surface=row['surface'],
                        sm_tourney_level=row['tourney_level'],\
                        player1_seed=row['winner_seed'],\
                        player1_entry=row['winner_entry'],\
                        player2_seed=row['loser_seed'],\
                        player2_entry=row['loser_entry'],\
                        player1_age=row['winner_age'],\
                        player2_age=row['loser_age'],\
                        sm_player1_rank=row['winner_rank'],\
                        sm_player1_rank_point=row['winner_rank_points'],\
                        sm_player2_rank=row['loser_rank'],\
                        sm_player2_rank_point=row['loser_rank_points'],\
                        minutes=row['minutes'],\
                        best_of=row['best_of'],\
                        round=row['round'],\
                        player1_ace=row['w_ace'],\
                        player1_df=row['w_df'],\
                        player1_svpt=row['w_svpt'],\
                        player1_1st_in=row['w_1stIn'],\
                        player1_1st_won=row['w_1stWon'],\
                        player1_2nd_won=row['w_2ndWon'],\
                        player1_sv_games=row['w_SvGms'],\
                        player1_bp_saved=row['w_bpSaved'],\
                        player1_bp_faced=row['w_bpFaced'],\
                        player2_ace=row['l_ace'],\
                        player2_df=row['l_df'],\
                        player2_svpt=row['l_svpt'],\
                        player2_1st_in=row['l_1stIn'],\
                        player2_1st_won=row['l_1stWon'],\
                        player2_2nd_won=row['l_2ndWon'],\
                        player2_sv_games=row['l_SvGms'],\
                        player2_bp_saved=row['l_bpSaved'],\
                        player2_bp_faced=row['l_bpFaced'],\
                        update=dt)
        #print(str(stm))
        #print(str(stm))
        con_postgres.execute(stm)

    elif row['minutes'] >0 :
        #print("New Match")
        # insert or update new Match (event)
        stm = insert(tbl_match).\
                 values(surface=row['surface'],      
                        player1_id=home_player_id[0],\
                        player2_id=away_player_id[0],\
                        MatchDateYearWeek=MatchDateYearWeek,\
                        sm_tourney_level=row['tourney_level'],\
                        player1_seed=row['winner_seed'],\
                        player1_entry=row['winner_entry'],\
                        player2_seed=row['loser_seed'],\
                        player2_entry=row['loser_entry'],\
                        player1_age=row['winner_age'],\
                        player2_age=row['loser_age'],\
                        sm_player1_rank=row['winner_rank'],\
                        sm_player1_rank_point=row['winner_rank_points'],\
                        sm_player2_rank=row['loser_rank'],\
                        sm_player2_rank_point=row['loser_rank_points'],\
                        minutes=row['minutes'],\
                        best_of=row['best_of'],\
                        round=row['round'],\
                        player1_ace=row['w_ace'],\
                        player1_df=row['w_df'],\
                        player1_svpt=row['w_svpt'],\
                        player1_1st_in=row['w_1stIn'],\
                        player1_1st_won=row['w_1stWon'],\
                        player1_2nd_won=row['w_2ndWon'],\
                        player1_sv_games=row['w_SvGms'],\
                        player1_bp_saved=row['w_bpSaved'],\
                        player1_bp_faced=row['w_bpFaced'],\
                        player2_ace=row['l_ace'],\
                        player2_df=row['l_df'],\
                        player2_svpt=row['l_svpt'],\
                        player2_1st_in=row['l_1stIn'],\
                        player2_1st_won=row['l_1stWon'],\
                        player2_2nd_won=row['l_2ndWon'],\
                        player2_sv_games=row['l_SvGms'],\
                        player2_bp_saved=row['l_bpSaved'],\
                        player2_bp_faced=row['l_bpFaced'],\
                        update=dt)
        #print(str(stm))
        #print(str(stm))
        con_postgres.execute(stm)        


        
def transform_sackmann_match():

    df_matchlist = pd.read_sql('select * from tbl_sackmann_match', con_postgres)
   
    # Building up Player table (tbl_player)
       
    df_matchlist.apply(updateSackmannMatches, axis = 1)

    
def transform_sackmanm_player():
    df_player = pd.read_sql("select * from tbl_sackmann_players where id != 207686", con_postgres)
    
    df_player.apply(updateSackmannPlayer, axis = 1)
    

def etl_transform_sackmann():

    transform_sackmanm_player()
    transform_sackmann_match()

    
