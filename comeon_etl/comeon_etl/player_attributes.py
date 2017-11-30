# -*- coding: utf-8 -*-

import pandas as pd
import math
import numpy as np
import sqlite3
from sqlalchemy import create_engine, MetaData
from comeon_common import connect

from datetime import datetime, timedelta
#from comeon_common import connet


    
conn, meta = connect()


#import argparse


def getScore(unique_players, matchesList) :
    """
    get Serice Score of a player
    """
    
    df_scores = pd.DataFrame()
    
    for player in unique_players:
        #print("calculate scores for player ", player)
        matches = matchesList[matchesList['Player1'] == player]
        service_score = np.mean((5 * matches['ace'] + matches['1st_in'] + matches['1st_won']) / (matches['svpt'] + matches['d_svpt']) )
        return_score = np.mean((2 * (matches['d_svpt'] - matches['d_1st_won']) + 3 * matches['bp_saved']) / (matches['svpt'] + matches['d_svpt']) )
        camp_score = np.mean( 2 * matches['bp_saved'] / matches['bp_faced'])
        fast_player_score = 1 - (np.mean(matches['minutes'] / 90) )
        front_runner_score = 0 if sum(matches['set1_winner']) == 0 else (sum(matches['set2_winner'][matches['set1_winner'] == 1]) / sum(matches['set1_winner']))
   

        
        d = {'player_id' : player, 
             'service_score' : service_score,
             'return_score' : return_score,
             'camp_score' : return_score,
             'fast_player_score' : camp_score,
             'front_runner_score' : front_runner_score
             }
             
        data = pd.DataFrame(d, index=[0])
        
        df_scores = df_scores.append(data)
    
    return df_scores

def playersAttributes(days_between_run=7, look_back_weeks=52, StartDate="01/01/01") :
    start_value = 0.5
    #conn = sqlite3.connect('/home/chrhae/dev/comeon/data/tennis-data.db')
    
    sql = """
    SELECT "MatchDate" as Date, player1_id as Winner, player2_id as Loser, 
    player1_ace as w_ace, player1_df as w_df, player1_svpt as w_svpt, player1_1st_in as w_1st_in, player1_1st_won as w_1st_won, 
    player2_ace as l_ace, player2_df as l_df, player2_svpt as l_svpt, player2_1st_in as l_1st_in, player2_1st_won as l_1st_won,
    player1_bp_faced as w_bp_faced, player1_bp_saved as w_bp_saved, player2_bp_faced as l_bp_faced, player2_bp_saved as l_bp_saved, minutes,
    case when player1_set1 > player2_set1 then 1 else 0 end as player1_winner_set1,
    case when player1_set1 < player2_set1 then 1 else 0 end as player2_winner_set1,
    case when player1_set2 > player2_set2 then 1 else 0 end as player1_winner_set2,
    case when player1_set2 < player2_set2 then 1 else 0 end as player2_winner_set2    
    FROM public.tbl_match  where te_link is not null
    """
    
    tennis = pd.read_sql(sql, conn) #  limit 100000', conn)
    tennis = tennis.dropna()    
   # tennis['Winner'] = tennis['winner']
   # tennis['Loser'] = tennis['loser']
    
    players = tennis.winner.append(tennis.loser)
    
    unique_players = players.unique()
    
    
    # generat W0 result
    
    
           
           
    # get match list
    matchesW = tennis[['date', 'winner','loser', 'w_ace','w_df', 'w_svpt', 'w_1st_in', 'w_1st_won', 'l_svpt', 'l_1st_won', 'w_bp_saved', 'w_bp_faced', 'minutes', 'player1_winner_set1', 'player1_winner_set2']]
    matchesW.columns = ['Date', 'Player1', 'Player2', 'ace','df', 'svpt', '1st_in', '1st_won', 'd_svpt', 'd_1st_won', 'bp_saved', 'bp_faced', 'minutes', 'set1_winner', 'set2_winner']
    matchesW['Winner'] = 1
    
    matchesL = tennis[['date', 'loser','winner', 'l_ace','l_df', 'l_svpt', 'l_1st_in', 'l_1st_won',  'w_svpt', 'w_1st_won', 'l_bp_saved', 'l_bp_faced', 'minutes', 'player2_winner_set1' , 'player2_winner_set2']]
    matchesL.columns = ['Date', 'Player1', 'Player2', 'ace','df', 'svpt', '1st_in', '1st_won', 'd_svpt', 'd_1st_won', 'bp_saved', 'bp_faced', 'minutes', 'set1_winner', 'set2_winner']
    matchesL['Winner'] = 2
    
    
    frames = [matchesW, matchesL]
    matches = pd.concat(frames)    
    matchesList = matches.copy()
    matchesList['Date'] = pd.to_datetime(matchesList['Date'])
           
    
        
                
    pd.options.mode.chained_assignment = None         
    #StartDate = "01/01/01"
    FromDate = datetime.strptime(StartDate, "%m/%d/%y")
    
    #new_ranking = getSWRanking(unique_players, matchesList, ranking)
       
    while FromDate < datetime.now() :
        ToDate = FromDate+timedelta(days=days_between_run)
        LookBackDate = FromDate-timedelta(weeks=look_back_weeks)
        print("FromDate", FromDate)
        print("ToDate", ToDate)    
        print("LookBackDate", LookBackDate)     
    
         

        
        current_matches = matchesList[(matchesList['Date'] < FromDate) & (matchesList['Date'] >= LookBackDate ) ] 
        if current_matches.empty :
            FromDate = ToDate
            next
        scores = getScore(unique_players, current_matches)
        
        scores = scores.fillna(start_value)        
        scores['FromDate'] = FromDate
        scores['ToDate'] = ToDate-timedelta(seconds=1)   
    
        scores.to_sql("tbl_players_attribute", conn, if_exists='append')
        #all_ranking = all_ranking.append(curr_ranking)           
        
        FromDate = ToDate
        
        
    # loop trough all players
    
    
    
    #all_ranking.to_sql("temp_ranking_" + ModelName, conn, if_exists='replace')
    #all_ranking.to_csv("ranking_"+ ModelName +".csv")
    
# testing
playersAttributes(days_between_run=7, look_back_weeks=52, StartDate="01/01/10")