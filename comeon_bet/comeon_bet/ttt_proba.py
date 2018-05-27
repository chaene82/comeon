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

stakes = 2


con, meta = connect()  


def place_ttt_bet(row) :
    loglocal = startBetLogging("common")
    winner_name = row['winner_player_name']
    winner_odds_id = row['winner_odds_id']
    winner_odds = row['winner_odds']
    winner_proba = row['winner_proba']


    
    calc_stakes = stakes
    
    status = placeBet(winner_odds_id, winner_odds, calc_stakes, product_id=7)
    #status = False
    
    if status :
    loglocal.warn("place bet on event '" + str(row['winner_player_name']) + \
                 "' winner " + str(winner_name) + \
                 " stakes : " + str(calc_stakes) + \
                 " odds : " + str(winner_odds) + \
                 " proba : " + str(winner_proba))
        
    return True



def ttt_proba() :

    sql = """
    SELECT * from v_ttt_next_events;
    """

    df_ttt_bet_events = pd.read_sql(sql, con)
    
    
    if not df_ttt_bet_events.empty :
        df_ttt_bet_events.apply(place_ttt_bet, axis=1)
        #good_away_winner.apply(place_ta_bet, axis=1)
        
    return True

