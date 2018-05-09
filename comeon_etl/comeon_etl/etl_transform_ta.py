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
tbl_ta_events = meta.tables['tbl_ta_events']


def get_player_id_from_table(name):
    return checkPlayerExists(name , con_postgres)

def get_event_id_from_table(row):
    home_player_id = row['home_player_id']
    away_player_id = row['away_player_id']

    event_id = con_postgres.execute("Select event_id from tbl_events WHERE home_player_id = " + str(home_player_id) + \
                                   "AND away_player_id = " + str(away_player_id) + "").fetchone()   
    if event_id == None :
        event_id = 0
    else:
        event_id = event_id[0]
    
    return event_id



def updateTAEvent(row) :
    dt = datetime.now()

    #print("update player", row['player_name'], )
    #print("dob", convertDate(row['player_dob']), )

    clause = insert(tbl_ta_events).values(event_id=row['event_id'], \
                                          home_player_id=row['home_player_id'], \
                                          home_player_proba=row['home_player_proba'], \
                                          away_player_id=row['away_player_id'], \
                                          away_player_proba=row['away_player_proba'], \
                                          ta_tournament = row['tournament'], \
                                          update=dt) 

    clause = clause.on_conflict_do_update(
    index_elements=['event_id'],
    set_=dict(home_player_proba=row['home_player_proba'], \
              away_player_proba=row['away_player_proba'], \
              update=dt) 
    )
    con_postgres.execute(clause)       
    


def etl_transform_ta() :
    # get new TAX matches
    df_ta_matchlist = pd.read_sql('select * from tbl_ta_proba where home_player_proba > 0 and home_player_proba < 100', con_postgres)
    
    df_ta_matchlist['home_player_id']  = df_ta_matchlist.home_player_name.apply(get_player_id_from_table)
    df_ta_matchlist['away_player_id']  = df_ta_matchlist.away_player_name.apply(get_player_id_from_table)
    df_ta_matchlist['event_id']  = df_ta_matchlist.apply(get_event_id_from_table, axis=1)
    
    
    df_ta_matchlist.apply(updateTAEvent, axis=1)



