# -*- coding: utf-8 -*-
"""
Created on Tue Sep 12 08:59:22 2017

@author: haenec
"""

import urllib.request
from bs4 import BeautifulSoup
import pandas as pd
from datetime import datetime, timedelta
from sqlalchemy import create_engine
import re
import sqlite3
import time
import random
from comeon_common import connect


##TODO
## get seed and remove it from the name
## handling tiebreak result better
## --> 


def store_matchlist_to_database (df) :
    conn = sqlite3.connect('te_data.db')

    df.to_sql('tmp_te_matchlist', conn, if_exists='replace')


def get_te_matchlist(year = '2010', month = '09', day = '05'):

    url = 'http://www.tennisexplorer.com/results/?type=atp-single&year=' + year + '&month=' + month + '&day=' + day
    
    req = urllib.request.Request(url)
    #http://live-tennis.eu/en/official-atp-ranking
    response = urllib.request.urlopen(req)

    html = response.read()

    soup = BeautifulSoup(html, "html.parser")
    
    soup.unicode
    
    table = soup.find("table", attrs={"class": "result"})
    
    trs = table.findAll('tr')

    
    result = pd.DataFrame()
    
    strDate = day + '/' + month + '/' + year
    MatchDate = datetime.strptime(strDate, "%d/%m/%Y")
    
    for tr in trs :
        #print(row)
        
        if (tr.find("td" , attrs={"class": "no-data first"})) != None :
            break

        
        ## searching for tournament
        
        if tr['class'][0] == 'head' :
            td = tr.find("td" , attrs={"class": "t-name"})
            tournament = td.text.strip()
            if td.a :
                tournament_link = td.a.attrs['href'].strip()   
            else :
                tournament_link = ''
            #tournament_link = tr.find("td" , attrs={"class": "t-name"}).a['href']                                    
            print(tournament)
            #print(tournament_link)
            
            continue
        
        ## searching for home player 
        
        if 'bott' in tr['class'] :
            time = tr.find("td" , attrs={"class": "first time"}).text.strip() 
            home = tr.find("td" , attrs={"class": "t-name"}).text.strip() 
            if tr.find("td" , attrs={"class": "t-name"}).a :
                home_link = tr.find("td" , attrs={"class": "t-name"}).a.attrs['href'].strip()
            else :
                home_link + '' 
            if tr.find("td" , attrs={"class": "result"}) :
                home_result = tr.find("td" , attrs={"class": "result"}).text.strip() 
            else :
                home_result = ''
            i = 1
            for td in tr.findAll("td" , attrs={"class": "score"}):
                globals()["home_score_" + str(i)] = td.text
                i = i + 1
            home_odds = tr.find("td" , attrs={"class": "coursew"}).text.strip()  
            away_odds = tr.find("td" , attrs={"class": "course"}).text.strip()     
            match_link = tr.find("td", text="info").a.attrs['href'].strip()
            continue

        ## searching for away player 
            
        else :
            #print(tr)
            away = tr.find("td" , attrs={"class": "t-name"}).text.strip() 
            if tr.find("td" , attrs={"class": "t-name"}).a:
                away_link = tr.find("td" , attrs={"class": "t-name"}).a.attrs['href'].strip()
            else :
                away_link = ''
            if tr.find("td" , attrs={"class": "result"}) :
                away_result = tr.find("td" , attrs={"class": "result"}).text.strip() 
            else :
                away_result = ''
            i = 1
            for td in tr.findAll("td" , attrs={"class": "score"}):
                globals()["away_score_" + str(i)] = td.text
                i = i + 1          

        ## putting data together    
        dict = { 'MatchDate' : MatchDate,
                 'tournament' :  tournament, 'tournament_link' :  tournament_link,
                 'time' : time,
                 'home' : home, 'home_link' : home_link, 'home_result' : home_result,
                 'home_score_1' : home_score_1, 'home_score_2' : home_score_2, 'home_score_3' : home_score_3, 'home_score_4' : home_score_4, 'home_score_5' : home_score_5,   
                 'away' : away, 'away_link' : away_link, 'away_result' : away_result,
                 'away_score_1' : away_score_1, 'away_score_2' : away_score_2, 'away_score_3' : away_score_3, 'away_score_4' : away_score_4, 'away_score_5' : away_score_5,   
                 'home_odds' : home_odds, 'away_odds' : away_odds,
                 'match_link' : match_link
                }
        
        data = pd.DataFrame([dict])
        
        result = result.append(data, ignore_index=True) 
    
    
    return result


def etl_te_get_matches(date = datetime.now().date() - timedelta(days=1)) : 

    #strDate = '28/08/2017'
    #endDate = '20/09/2017'
    #date = datetime.strptime(strDate, "%d/%m/%Y") 
    #todate = datetime.strptime(endDate, "%d/%m/%Y") 
    date = date
    todate = date
    
    
    while date <= todate :
        
        print("Get Matchlist for" , date )
        year = date.strftime('%Y')
        month = date.strftime('%m')
        day = date.strftime('%d')
        df = get_te_matchlist(year = year, month = month, day = day)
        if not df.empty:
            store_matchlist_to_database(df)
        
        #sleep_sec = random.randint(6,10)
        #print("sleep for (s) ", sleep_sec)
        #time.sleep(sleep_sec)
        
        date = date+timedelta(days=1)