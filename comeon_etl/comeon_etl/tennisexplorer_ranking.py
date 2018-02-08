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



##TODO
## get seed and remove it from the name
## handling tiebreak result better
## --> 
conn = sqlite3.connect('te_data.db')

def store_ranking_to_database (df) :

    df.to_sql('tmp_te_ranking', conn, if_exists='append')


def get_te_ranking(year = '2018', month = '01', day = '22', page = 1):

    url = 'http://www.tennisexplorer.com/ranking/atp-men/' + year + '?date=' + year + '-' + month + '-' + day +'&page=' + str(page)
    
    req = urllib.request.Request(url)
    #http://live-tennis.eu/en/official-atp-ranking
    response = urllib.request.urlopen(req)

    html = response.read()

    soup = BeautifulSoup(html, "html.parser")
    
    soup.unicode
    
    table = soup.find("tbody", attrs={"class": "flags"})
    
    if table is None:
        return pd.DataFrame()
    
    
    trs = table.findAll('tr')

    
    result = pd.DataFrame()
    
    strDate = day + '/' + month + '/' + year
    StartDate = datetime.strptime(strDate, "%d/%m/%Y")
    
    for tr in trs :
        #print(row)
        
#        if (tr.find("td" , attrs={"class": "no-data first"})) != None :
#            break

        player = tr.find("td" , attrs={"class": "t-name"}).text.strip() 
        if tr.find("td" , attrs={"class": "t-name"}).a :
           player_link = tr.find("td" , attrs={"class": "t-name"}).a.attrs['href'].strip()
        else :
           player_link = ''
        rank = tr.find("td" , attrs={"class": "rank first"}).text.strip() 
        points = tr.find("td" , attrs={"class": "long-point"}).text.strip() 
        


        ## putting data together    
        dict = { 'StartDate' : StartDate,
                 'player' : player,
                 'player_link' : player_link,
                 'rank' : rank, 
                 'points' : points
                }
        
        data = pd.DataFrame([dict])
        
        result = result.append(data, ignore_index=True) 
    
    
    return result


def etl_te_get_ranking(date=datetime.now().date()) :

    date = date
    todate = date
    cursor = conn.cursor()
    cursor.execute('''DROP TABLE IF EXISTS tmp_te_ranking''')
    conn.commit()
    cursor = conn.cursor()
    cursor.execute('''CREATE TABLE "tmp_te_ranking" ( "index" INTEGER, "StartDate" TIMESTAMP, "player" TEXT, "player_link" TEXT, "points" TEXT, "rank" TEXT )''')
    conn.commit()
    
    while date <= todate :
        
        print("Get Ranking for" , date )
        year = date.strftime('%Y')
        month = date.strftime('%m')
        day = date.strftime('%d')
        for i in range(1, 40) :
            print('Page ', i)
            df = get_te_ranking(year = year, month = month, day = day, page = i)
            if not df.empty:
                store_ranking_to_database(df)
            else:
                break
        
           # sleep_sec = random.randint(6,10)
           # print("sleep for (s) ", sleep_sec)
           # time.sleep(sleep_sec)
        
        date = date+timedelta(days=7)