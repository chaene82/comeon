"""
Created on Wed Nov  1 14:27:52 2017

ToDo:
    Finish it for Version 0.0.5

@author: haenec
"""


import pandas as pd
from comeon_common import connect
from comeon_common import startBetLogging
from comeon_common import placeBet


# load data from the configuration
import yaml
with open("config.yml", 'r') as ymlfile:
    cfg = yaml.load(ymlfile)

stakes = 1.5
margin = 5 #prcent better bet 


log = startBetLogging("common")
con, meta = connect()  


def place_ta_bet(row) :
    if row['winner'] == 'home' :
        winner_name = row['home_player_name']
        winner_odds_id = row['home_odds_id']
        winner_odds = row['home_odds']
        winner_proba = row['home_player_proba']
    else :
        winner_name = row['away_player_name']
        winner_odds_id = row['away_odds_id']        
        winner_odds = row['away_odds']
        winner_proba = row['away_player_proba']
    log.warn("place bet on event '" + str(row['home_player_name']) + " vs " + str(row['away_player_name']) + \
             "' winner " + str(winner_name) + \
             " odds : " + str(winner_odds) + \
             " proba : " + str(winner_proba))
    
    placeBet(winner_odds_id, winner_odds, stakes, product_id=5)
    
    return True


def ta_proba() :

    sql = """
    SELECT e.event_id, e."StartDateTime",
            e.home_player_id, h.pin_player_name as home_player_name, ta.home_player_proba, oh.odds as home_odds, oh.odds_id as home_odds_id,
            e.away_player_id, a.pin_player_name as away_player_name, ta.away_player_proba, oa.odds as away_odds, oa.odds_id as away_odds_id
    	FROM public.tbl_events e
        inner join public.tbl_event_player h on (e.home_player_id = h.event_player_id)
        inner join public.tbl_event_player a on (e.away_player_id = a.event_player_id)
    	inner join public.tbl_ta_events ta on (e.event_id = ta.event_id)
        inner join public.tbl_odds oh on (e.event_id = oh.event_id)
        inner join public.tbl_odds oa on (e.event_id = oa.event_id)
        Where e."StartDateTime" >= NOW()  and  e."StartDateTime" <= (NOW() + INTERVAL '2 hours' )
        and oh.bookie_id = 1 and oh.way=1
        and oa.bookie_id = 1 and oa.way=2
        and oh.odds_id not in (select odds_id from public.tbl_orderbook)
        and oa.odds_id not in (select odds_id from public.tbl_orderbook);
    """
    df_ta_bet_events = pd.read_sql(sql, con)
    
    if df_ta_bet_events.empty :
        return False
    
    df_ta_bet_events['home_odds_proba'] = (1 / df_ta_bet_events['home_odds']) * 100
    df_ta_bet_events['away_odds_proba'] = (1 / df_ta_bet_events['away_odds']) * 100
    
    
    home_winner = df_ta_bet_events[df_ta_bet_events['home_player_proba'] > 50]
    away_winner = df_ta_bet_events[df_ta_bet_events['away_player_proba'] > 50]
       
    good_home_winner = home_winner[home_winner['home_player_proba'] >= (home_winner['home_odds_proba'] + margin) ]
    if not good_home_winner.empty :
        good_home_winner['winner'] = 'home'
    
    good_away_winner = away_winner[away_winner['away_player_proba'] >= (away_winner['away_odds_proba'] + margin) ]
    if not good_away_winner.empty :    
        good_away_winner['winner'] = 'away'
    
    if not (good_home_winner.empty or good_away_winner.empty) :  
        good_winners = pd.concat([good_home_winner, good_away_winner])
    elif not good_home_winner.empty :
        good_winners = good_home_winner
    elif not good_away_winner.empty :
        good_winners = good_away_winner
    else :
        return False
    
    if not good_winners.empty :
        good_winners.apply(place_ta_bet, axis=1)
        #good_away_winner.apply(place_ta_bet, axis=1)
        
    return True

