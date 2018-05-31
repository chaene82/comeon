#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct 15 17:08:25 2017

@author: chrhae
"""


import pandas as pd
from datetime import datetime
from comeon_common import connect
from comeon_common import checkPlayerExists



from sqlalchemy.dialects.postgresql import insert


con_postgres, meta = connect()  
tbl_ttt_events= meta.tables['tbl_ttt_events']


def get_player_id_from_table(name):
    # bad fix 
    name = name.replace('Samantha Stosur', 'Sam Stosur')
    
    return checkPlayerExists(name , con_postgres)

def get_event_id_from_table(row):
    home_player_id = row['home_player_id']
    away_player_id = row['away_player_id']

    event_id = con_postgres.execute("Select event_id from tbl_events WHERE "StartDateTime" >= (now() - '48:00:00'::interval) AND  home_player_id = " + str(home_player_id) + \
                                   "AND away_player_id = " + str(away_player_id) + "").fetchone()   
    if event_id == None :
        event_id = 0
    else:
        event_id = event_id[0]
    
    return event_id



def updateTTEvent(row) :
    dt = datetime.now()

    #print("update player", row['player_name'], )
    #print("dob", convertDate(row['player_dob']), )

    clause = insert(tbl_ttt_events).values(event_id=row['event_id'], \
                                          home_player_id=row['home_player_id'], \
                                          home_player_name=row['home_player_name'], \
                                          away_player_id=row['away_player_id'], \
                                          away_player_name=row['away_player_name'], \
                                          ttt_tournament = row['event'], \
                                          winner_name = row['winner'], \
                                          winner_player_id = row['winner_id'], \
                                          winner_proba = row['win_proba'],\
                                          way = row['way'],\
                                          update=dt) 

    clause = clause.on_conflict_do_update(
    index_elements=['event_id'],
    set_=dict(winner_proba=row['win_proba'], \
              update=dt) 
    )
    con_postgres.execute(clause)       
    
    
def getWinner(row) :
    
    if row['winner_id'] ==  row['home_player_id'] :
        way = 1
    else :
        way = 2
    return way


def etl_transform_ttt() :
    # get new TAX matches
    df_ttt_matchlist = pd.read_sql('select * from tbl_ttt_picks', con_postgres)
       
    df_ttt_matchlist['home_player_name'] = df_ttt_matchlist.match.str.split(' - ').str.get(0).str.strip()
    df_ttt_matchlist['away_player_name'] = df_ttt_matchlist.match.str.split(' - ').str.get(1).str.strip()

    
    df_ttt_matchlist['home_player_id']  = df_ttt_matchlist.home_player_name.apply(get_player_id_from_table)
    df_ttt_matchlist['away_player_id']  = df_ttt_matchlist.away_player_name.apply(get_player_id_from_table)
    df_ttt_matchlist['winner_id']  = df_ttt_matchlist.winner.apply(get_player_id_from_table)
    df_ttt_matchlist['event_id']  = df_ttt_matchlist.apply(get_event_id_from_table, axis=1)
    
    df_ttt_matchlist['way']  = df_ttt_matchlist.apply(getWinner, axis=1)

    
    
    
    df_ttt_matchlist.apply(updateTTEvent, axis=1)



