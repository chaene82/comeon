# -*- coding: utf-8 -*-
"""
Created on Tue Sep 12 08:59:22 2017

@author: haenec
"""

import urllib.request
from bs4 import BeautifulSoup
import sqlite3
import pandas as pd




def store_matches_to_database(df) :
    conn = sqlite3.connect('ta_data.db')
    df.to_sql('tmp_ta_proba', conn, if_exists='append', index=False)
    


def get_ta_proba(tournament_url = "2018ATPHouston.html", round = [2,4,8,16,32,64]):

    url = tournament_url
    
    req = urllib.request.Request(url)
    #http://live-tennis.eu/en/official-atp-ranking
    response = urllib.request.urlopen(req)

    html = response.read()

    soup = BeautifulSoup(html, "html.parser")
    
    tour_title = soup.title.text
    
    result = pd.DataFrame()
    
    list_rounds = round
    
    for tournament_round in list_rounds :
        str_round = 'var proj' + str(tournament_round)
        print(url)
        
    
        long_string = str(soup)[str(soup).find(str_round):] 
        table_start = long_string.find('<table')
        table_end = long_string.find('</table>')
        string = long_string[table_start:table_end + 8]
    
        proba = BeautifulSoup(string, "html.parser")
        proba_table = proba.findAll('tr')
        
        for i in range(1, len(proba_table), 2) :
            
            if proba_table[i].a and proba_table[i].td.text != 'Bye' and proba_table[i+1].td.text != 'Bye' \
                                and proba_table[i].td.text[0:9] != 'Qualifier' and proba_table[i+1].td.text[0:9] != 'Qualifier' : 
              
                home_player = proba_table[i]
                home_player_tds = home_player.findAll('td')
                if not home_player_tds[0].a :
                    break
                home_player_name = home_player_tds[0].a.text
                home_player_proba = float(home_player_tds[2].text.strip('%'))
                #print(home_player_name, home_player_proba)
                
                #print(proba_table[i+1])
                away_player = proba_table[i+1]
                away_player_tds = away_player.findAll('td')
                if not away_player_tds[0].a :
                    break
                away_player_name = away_player_tds[0].a.text   
                
                away_player_proba = float(away_player_tds[2].text.strip('%'))
                #print(away_player_name, away_player_proba)
                
                
                        ## putting data together    
                dict = { 'tournament' : tour_title,
                         'home_player_name' :  home_player_name,
                         'away_player_name' :  away_player_name,
                         'home_player_proba' :  home_player_proba,
                         'away_player_proba' :  away_player_proba
                        }
                
                data = pd.DataFrame([dict])
                
                result = result.append(data, ignore_index=True) 
                                       
    return result


def get_current_tournament():

    
    url = 'http://www.tennisabstract.com'
    req = urllib.request.Request(url)
    
    response = urllib.request.urlopen(req)
    
    html = response.read()
    
    soup = BeautifulSoup(html, "html.parser")  
    
    tournaments = soup.findAll('a', href=True, text='Results and Forecasts')
    
    tournament_links = []
    
    for tournament in tournaments:
        tournament_links.append(tournament['href'])

    return tournament_links     
    
    

def get_ta_current():
    try :
        tournament_list = get_current_tournament()
        conn = sqlite3.connect('ta_data.db')
        c = conn.cursor()
        c.execute("DELETE FROM tmp_ta_proba")
        conn.commit()
        conn.close()
    except:
        print("error deleting file")
    
    
    for tournament in tournament_list:
        result = get_ta_proba(tournament_url = tournament, round = ['Current'])
    
        store_matches_to_database(result)
        



#def etl_te_get_matchesdetails_all() : 
#    
#    con, meta = connect()    
#    conn = sqlite3.connect('te_data.db')
#    
#    
#    sql = """
#          SELECT te_link, "MatchDate"
#        	FROM public.tbl_match
#            where "MatchDate" > '2017-01-01'::date
#        """
#    
#    match_list = con.execute(sql )
#    
#    
#    i = 0
#    for match in match_list :
#        link = match[0]
#        df = get_te_match(link)
#        store_matches_to_database(df, conn)
#        
#        i = i + 1
#        if i % 100 == 0:
#            print(i, "done")
