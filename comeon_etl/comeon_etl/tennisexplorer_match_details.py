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
import numpy as np
from datetime import datetime, timedelta
from comeon_common import connect





def store_html_file(string, link):
    folder = "tennisexplorer"
    match_id = ''.join(x for x in link if x.isdigit())
    filepath = folder + "/" + match_id + ".html"
    with open(filepath, "w+") as text_file:
        text_file.write(str(string))




def store_matches_to_database(df, conn) :

    df.to_sql('tmp_te_matches_details', conn, if_exists='append', index=False)
    


def get_te_match(match_url = "/match-detail/?id=1629042"):

    url = 'http://www.tennisexplorer.com/' + str(match_url) 
    
    req = urllib.request.Request(url)
    #http://live-tennis.eu/en/official-atp-ranking
    response = urllib.request.urlopen(req)

    html = response.read()

    soup = BeautifulSoup(html, "html.parser")
    
    soup.unicode
    
    odds_table = soup.findAll('table')[5]
    
    odds_trs = odds_table.findAll('tr')
    odds_home = np.nan
    odds_away = np.nan
    
    
    for tr in odds_trs:
        if (tr.a) :
            if 'Pinnacle' in tr.a.text :
                tds_home = tr.findAll('td', {'class' : 'k1'})
                tds_away = tr.findAll('td', {'class' : 'k2'})
                odds_home = float(tds_home[0].find(text=True))
                odds_away = float(tds_away[0].find(text=True))
               
       
    if soup.find(text=re.compile(r'hard')) :  
        #print("hard surface")
        surface = 'hard'
    elif soup.find(text=re.compile(r'clay')) :  
        #print("clay surface")  
        surface = 'clay'        
    elif soup.find(text=re.compile(r'grass')) :  
        #print("grass surface")          
        surface = 'grass'        
    elif soup.find(text=re.compile(r'indoor')) :  
        #print("indoor surface") 
        surface = 'indoor'                
    else :
        #print("surface unknown")        
        surface = 'unknown'                
                            
    ## putting data together    
    dict = { 'match_link' : match_url,
             'surface'    : surface,
             'player1_pin_odds' : odds_home,
             'player2_pin_odds' : odds_away,
             
             #'html'       : html
            }
       
    data = pd.DataFrame([dict])
    
    #store_html_file(html, match_url)
    
    
            
    return data


def etl_te_get_matchesdetails() : 
    
    con, meta = connect()    
    conn = sqlite3.connect('te_data.db')
    
    
    sql = """
        SELECT te_link
        	FROM public.tbl_match
            where surface is null;
        """
    
    match_list = con.execute(sql )
    
    
    i = 0
    for match in match_list :
        link = match[0]
        df = get_te_match(link)
        store_matches_to_database(df, conn)
        
        i = i + 1
        if i % 100 == 0:
            print(i, "done")


def etl_te_get_matchesdetails_all() : 
    
    con, meta = connect()    
    conn = sqlite3.connect('te_data.db')
    
    
    sql = """
          SELECT te_link, "MatchDate"
        	FROM public.tbl_match
            where "MatchDate" > '2017-01-01'::date
        """
    
    match_list = con.execute(sql )
    
    
    i = 0
    for match in match_list :
        link = match[0]
        df = get_te_match(link)
        store_matches_to_database(df, conn)
        
        i = i + 1
        if i % 100 == 0:
            print(i, "done")
