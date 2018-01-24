# -*- coding: utf-8 -*-

import pandas as pd
import math
import sqlite3
from sqlalchemy import create_engine, MetaData, select
from comeon_common import connect

from datetime import datetime, timedelta
#from comeon_common import connet


    
conn, meta = connect()


#import argparse

#parser = argparse.ArgumentParser(description='Calculate SwissTennis Model')
#
##parser.add_argument('--start_value', dest='accumulate', action='store_const',
##                   const=sum, default=max,
##                   help='sum the integers (default: find the max)')
#parser.add_argument('--start_value', type=float, default=1, help='Start Value for the model')
#parser.add_argument('--days', type=int, default=7, help='Days between runs')
#parser.add_argument('--weeks_back', type=int, default=52, help='How many weeks back')
#parser.add_argument('--name', type=str, default="SW1YALL", help='Name of the Model')
#parser.add_argument('--startDate', type=str, default="01/01/01", help='Model Start Date')
#
#
##parser.print_help()
#args = parser.parse_args()
### Parameters
#print(args)
#start_value = args.start_value
#days_between_run = args.days
#look_back_weeks = args.weeks_back
#ModelName = args.name
#StartDate = args.startDate
#
#print("Start Value", start_value)
#print("days_between_run", days_between_run)
#print("look_back_weeks", look_back_weeks)
#print("ModelName", ModelName)


def getSWRanking(unique_players, matchesList, ranking, start_value) :
    """
    get Ranking of the players
    """
    for i in range(1, 6) :
        print("Running Iteration", i)
        
        # adding ratings to matchlist
        W = 'W' + str(i - 1)
        Wnext = 'W' + str(i)
        match_rating_1 = pd.merge(matchesList, ranking, left_on='Player1', right_on='Player') 
        match_rating_1 = match_rating_1[['Date', 'Player1', 'Player2','Winner', W]]
        match_rating_1.columns = ['Date', 'Player1', 'Player2','Winner', 'W_P1']
        match_rating = pd.merge(match_rating_1, ranking, left_on='Player2', right_on='Player') 
        match_rating_w0 = pd.merge(matchesList, ranking, left_on='Player2', right_on='Player')
        match_rating_w0 = match_rating_w0[['W0']]
        #match_rating = pd.merge(match_rating_w0, ranking, left_on='Player2', right_on='Player')

        match_rating = match_rating[['Date', 'Player1', 'Player2','Winner', 'W_P1', W]]
        match_rating.columns = ['Date', 'Player1', 'Player2','Winner', 'W_P1', 'W_P2']
        match_rating['W_P1'] = match_rating_w0
        
        player_id = 0
        for player in unique_players:
            #print("Player ", player)
            # select match list
            matches = match_rating[match_rating['Player1'] == player]
            competion_value_win = 0
            competion_value_lose = 0
            for id, match in matches.iterrows() :
                if match['Winner']  == 1:                  
                    c_value = math.exp(match['W_P2']) + math.exp(match['W_P1'])
                    competion_value_win = competion_value_win + c_value
                    #print("gegner", match['Player2'])    
                    #print("Value W, Value L", match['W_P1'], match['W_P2'])                      
                    #print("competion_value_win", c_value)
                else :
                    c_value = math.exp(-match['W_P2']) + math.exp(-match['W_P1'])
                    competion_value_lose = competion_value_lose + c_value
                    #print("competion_value_lose",c_value) 
            #print("competion_value_win",competion_value_win)
            #print("competion_value_lose",competion_value_lose) 
            if competion_value_win != 0 :
                v1 = math.log(competion_value_win)
            else :
                v1 = 0
            if competion_value_lose != 0 :
                v2 = math.log(competion_value_lose)
            else :
                v2 = 0
            #print(player)
            #print("competion_value", v1, v2)
            competion_value = 0.5 * (v1  - v2)
            if competion_value == 0 :
                competion_value = start_value
            ranking.loc[player_id, Wnext] = competion_value
            player_id = player_id + 1
    return ranking

def modelSwisstennis(start_value=0.1, days_between_run=7, look_back_weeks=52, ModelName='SW1YALL', StartDate="01/01/01") :

    #conn = sqlite3.connect('/home/chrhae/dev/comeon/data/tennis-data.db')
    
    if ModelName == 'SW1YC' :
        tennis = pd.read_sql('SELECT "MatchDate" as Date, player1_id as Winner, player2_id as Loser FROM public.tbl_match  where te_link is not null and surface = \'Clay\'', conn)
    elif ModelName == 'SW1YH' :
        tennis = pd.read_sql('SELECT "MatchDate" as Date, player1_id as Winner, player2_id as Loser FROM public.tbl_match  where te_link is not null and surface = \'Hard\'', conn)
    elif ModelName == 'SW1YG' :
        tennis = pd.read_sql('SELECT "MatchDate" as Date, player1_id as Winner, player2_id as Loser FROM public.tbl_match  where te_link is not null and surface = \'Grass\'', conn)        
    else :
        tennis = pd.read_sql('SELECT "MatchDate" as Date, player1_id as Winner, player2_id as Loser FROM public.tbl_match  where te_link is not null', conn)
    #tennis = pd.read_excel("../tennis_all.xlsx")
    
   # tennis['Winner'] = tennis['winner']
   # tennis['Loser'] = tennis['loser']
    
    players = tennis.winner.append(tennis.loser)
    
    unique_players = players.unique()
    
    
    # generat W0 result
    
    ranking = pd.DataFrame(unique_players)
    ranking.columns = ['Player']
    ranking['W0'] = start_value
    
           
           
    # get match list
    matchesW = tennis[['date', 'winner','loser']]
    matchesW.columns = ['Date', 'Player1', 'Player2']
    matchesW['Winner'] = 1
    
    matchesL = tennis[['date', 'loser','winner']]
    matchesL.columns = ['Date', 'Player1', 'Player2']
    matchesL['Winner'] = 2
    
    
    frames = [matchesW, matchesL]
    matches = pd.concat(frames)    
    matchesList = matches.copy()
    matchesList['Date'] = pd.to_datetime(matchesList['Date'])
           
    #run 5 times
    
        
                
    pd.options.mode.chained_assignment = None         
    #StartDate = "01/01/01"
    FromDate = datetime.strptime(StartDate, "%m/%d/%y")
    
    #new_ranking = getSWRanking(unique_players, matchesList, ranking)
    
    new_ranking = pd.DataFrame()
    all_ranking = pd.DataFrame()
    
    while FromDate < datetime.now() :
        ToDate = FromDate+timedelta(days=days_between_run)
        LookBackDate = FromDate-timedelta(weeks=look_back_weeks)
        print("FromDate", FromDate)
        print("ToDate", ToDate)    
        print("LookBackDate", LookBackDate)     
    
         
        if not new_ranking.empty:
            ranking = new_ranking[['Player','W5']]
            ranking.columns = ['Player','W0']
            ranking['W0']
            ranking[ranking['W0'] == 0] = start_value
        else:
            ranking = pd.DataFrame(unique_players)
            ranking.columns = ['Player']
            ranking['W0'] = start_value
        
        current_matches = matchesList[(matchesList['Date'] < FromDate) & (matchesList['Date'] >= LookBackDate ) ] 
        if current_matches.empty :
            FromDate = ToDate
            next
        new_ranking = getSWRanking(unique_players, current_matches, ranking, start_value)
        
        curr_ranking = new_ranking[['Player','W5']]
        curr_ranking.columns = ['Player', ModelName]
        curr_ranking[ModelName][curr_ranking[ModelName] == 0] = start_value
        curr_ranking['FromDate'] = FromDate
        curr_ranking['ToDate'] = ToDate-timedelta(seconds=1)   
    
        curr_ranking.to_sql("temp_ranking_" + ModelName, conn, if_exists='append')
        #all_ranking = all_ranking.append(curr_ranking)           
                    
        FromDate = ToDate
        
        
    # loop trough all players
    
    
    
    #all_ranking.to_sql("temp_ranking_" + ModelName, conn, if_exists='replace')
    #all_ranking.to_csv("ranking_"+ ModelName +".csv")
    
def weeklyModelSwisstennis(start_value=0.1, days_between_run=7, look_back_weeks=52, ModelName='SW1YALL', date=datetime.now().date()) :
    
    ## ToDo: get just the data where needed in a weekly load
    
    if ModelName == 'SW1YC' :
        tennis = pd.read_sql('SELECT "MatchDate" as Date, player1_id as Winner, player2_id as Loser FROM public.tbl_match  where te_link is not null and surface = \'Clay\'', conn)
    elif ModelName == 'SW1YH' :
        tennis = pd.read_sql('SELECT "MatchDate" as Date, player1_id as Winner, player2_id as Loser FROM public.tbl_match  where te_link is not null and surface = \'Hard\'', conn)
    elif ModelName == 'SW1YG' :
        tennis = pd.read_sql('SELECT "MatchDate" as Date, player1_id as Winner, player2_id as Loser FROM public.tbl_match  where te_link is not null and surface = \'Grass\'', conn)        
    else :
        tennis = pd.read_sql('SELECT "MatchDate" as Date, player1_id as Winner, player2_id as Loser FROM public.tbl_match  where te_link is not null', conn)

    players = tennis.winner.append(tennis.loser)
    
    unique_players = players.unique()
    
    
    # generat W0 result
    
    ranking = pd.DataFrame(unique_players)
    ranking.columns = ['Player']
    ranking['W0'] = start_value
    
           
           
    # get match list
    matchesW = tennis[['date', 'winner','loser']]
    matchesW.columns = ['Date', 'Player1', 'Player2']
    matchesW['Winner'] = 1
    
    matchesL = tennis[['date', 'loser','winner']]
    matchesL.columns = ['Date', 'Player1', 'Player2']
    matchesL['Winner'] = 2
    
    
    frames = [matchesW, matchesL]
    matches = pd.concat(frames)    
    matchesList = matches.copy()
    matchesList['Date'] = pd.to_datetime(matchesList['Date'])    
    
    pd.options.mode.chained_assignment = None         
    #StartDate = "01/01/01"
    FromDate = date
    LastDate = date
    
    
    ## ToDo: remove the while loop
    while FromDate <= LastDate :
        ToDate = FromDate+timedelta(days=days_between_run)
        LookBackDate = FromDate-timedelta(weeks=look_back_weeks)
        print("FromDate", FromDate)
        print("ToDate", ToDate)    
        print("LookBackDate", LookBackDate)     
    
        
        ## ToDo: get Values from the last load
        if not new_ranking.empty:
            ranking = pd.read_sql('SELECT "Player", "' + ModelName + '"	FROM public."temp_ranking_SW1MALL" where ToDate = ' + date + ';', conn)
            ranking.columns = ['Player','W0']
            ranking['W0']
            ranking[ranking['W0'] == 0] = start_value
        else:
            ranking = pd.DataFrame(unique_players)
            ranking.columns = ['Player']
            ranking['W0'] = start_value
        
        current_matches = matchesList[(matchesList['Date'] < FromDate) & (matchesList['Date'] >= LookBackDate ) ] 
        if current_matches.empty :
            FromDate = ToDate
            next
        new_ranking = getSWRanking(unique_players, current_matches, ranking, start_value)
        
        curr_ranking = new_ranking[['Player','W5']]
        curr_ranking.columns = ['Player', ModelName]
        curr_ranking[ModelName][curr_ranking[ModelName] == 0] = start_value
        curr_ranking['FromDate'] = FromDate
        curr_ranking['ToDate'] = ToDate-timedelta(seconds=1)   
    
        curr_ranking.to_sql("temp_ranking_" + ModelName, conn, if_exists='append')
        #all_ranking = all_ranking.append(curr_ranking)           
                    
        FromDate = ToDate    