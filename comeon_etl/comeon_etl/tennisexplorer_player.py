# -*- coding: utf-8 -*-
"""
Created on Tue Sep 12 08:59:22 2017

@author: haenec
"""

import urllib.request
from bs4 import BeautifulSoup
import pandas as pd
import sqlite3
import re
import random
import time
from datetime import datetime, timedelta
from comeon_common import connect







def store_player_to_database (df) :
    conn = sqlite3.connect('te_data.db')

    df.to_sql('tmp_te_player', conn, if_exists='append')
    
    conn.close()


def get_te_player(player_url = "/player/laaksonen/"):

    url = 'http://www.tennisexplorer.com/' + player_url 
    
    req = urllib.request.Request(url)
    #http://live-tennis.eu/en/official-atp-ranking
    response = urllib.request.urlopen(req)

    html = response.read()

    soup = BeautifulSoup(html, "html.parser")
    
    soup.unicode
    
    table = soup.find("table", attrs={"class": "plDetail"})
    
    if table is None:
        return pd.DataFrame()
    

    tds = table.findAll('td')
    #divs = tds[1].findAll('div')
    
    player_name =  tds[1].h3.text
    if  soup.find('div', text=re.compile(r'Country')):                   
        player_country = soup.find('div', text=re.compile(r'Country')).text.replace('Country: ', '')
    else :
        player_country = ""
    if  soup.find('div', text=re.compile(r'Born')) :
        player_dob =  soup.find('div', text=re.compile(r'Born')).text.replace('Born: ', '') 
    else :
        player_dob = ''
    player_sex =  soup.find('div', text=re.compile(r'Sex')).text.replace('Sex: ', '')
    if soup.find('div', text=re.compile(r'Plays')) :
        player_plays = soup.find('div', text=re.compile(r'Plays')).text.replace('Plays: ', '')
    else :
        player_plays = ''

                        

    
    result = pd.DataFrame()
    
    ## putting data together    
    dict = { 'player_name' : player_name,
             'player_country' : player_country,
             'player_dob' : player_dob,
             'player_sex' : player_sex, 
             'player_plays' : player_plays,
             'player_url' : player_url,
             'etl_date'   : datetime.now()
            }
       
    data = pd.DataFrame([dict])
        
    result = result.append(data, ignore_index=True) 
    
    
    return result






def getplayer() :
    conn = sqlite3.connect('te_data.db')

    
    home = pd.read_sql("SELECT DISTINCT home_link from tmp_te_matchlist ", conn)
    away = pd.read_sql("SELECT DISTINCT away_link from tmp_te_matchlist ", conn)
    
    home_list = home.home_link.tolist()
    away_list = away.away_link.tolist()
    
    players = home_list  + away_list
    players = list(set(players))
    
    
    i = 0
    for link in players:
        #print(link)
        #print(i)
        link = link.replace('â' , 'a')
        df = get_te_player(link)
        store_player_to_database(df)
        #sleep_sec = random.randint(3,5)
        #print("sleep for (s) ", sleep_sec)
        #time.sleep(sleep_sec)
        i = i + 1


def etl_te_get_missing_players() :
    con, meta = connect()    
    
#    conn = sqlite3.connect('te_data.db')
#    
#    cursor = conn.cursor()
#    cursor.execute('''TRUNCATE TABLE  tmp_te_player;''')
#    conn.commit()


    players = con.execute('SELECT te_link FROM public.tbl_player where te_link is not null and plays is null;' )
    
    for link_list in players:
        link = link_list[0]
        print(link)
        link = link.replace('â' , 'a')
        df = get_te_player(link)
        store_player_to_database(df)
