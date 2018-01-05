#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep 14 17:01:56 2017

@author: chrhae
"""
import pandas as pd
from comeon_common import connect
from sqlalchemy import update
from comeon_common import startBetLogging

conn, meta = connect()    
log = startBetLogging("calculate fair odds")
tbl_match = meta.tables['tbl_match']  


def updateSQLfairbet(row) :
    
    
    stm = update(tbl_match).where(tbl_match.columns.match_id==row['match_id']).\
                 values(player1_proba=row['player1_proba'],
                        player2_proba=row['player2_proba'],\
                        player1_fair_odds=row['player1_fair_odds'],\
                        player2_fair_odds=row['player2_fair_odds'])

    conn.execute(stm)

def calcFairOdds() :
   
    log.info("Load Data")  
    sql = """
        SELECT match_id, player1_odds, player2_odds
        FROM public.tbl_match
        where player1_proba is null
        --limit 10000
        """
    
    
    df = pd.read_sql(sql, conn)
    
    df['bet_prob'] = 1 / (( 1 / df['player1_odds']) + ( 1 / df['player2_odds']))
    df['player1_proba'] = df['bet_prob'] / df['player1_odds']
    df['player2_proba'] = df['bet_prob'] / df['player2_odds']    
    df['player1_fair_odds'] = 1 / df['player1_proba']
    df['player2_fair_odds'] = 1 / df['player2_proba']
    
    df.apply(updateSQLfairbet, axis=1)

