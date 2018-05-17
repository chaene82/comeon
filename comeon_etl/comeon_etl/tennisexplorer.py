# -*- coding: utf-8 -*-
"""
Created on Tue Sep 12 08:59:22 2017

@author: haenec
"""

import urllib.request
from bs4 import BeautifulSoup
import pandas as pd
from datetime import datetime, timedelta, timezone
from sqlalchemy import create_engine
import re
import sqlite3
import time
import random
import pytz


timezone = pytz.timezone("Europe/Zurich")


##TODO
## get seed and remove it from the name
## handling tiebreak result better
## --> 


def store_matchlist_to_database (df) :
    conn = sqlite3.connect('te_data.db')

    df.to_sql('tmp_te_matchlist', conn, if_exists='append')


def get_te_matchlist(year = '2018', month = '05', day = '07', match_type="atp-single"):

    url = 'http://www.tennisexplorer.com/matches/?type=' + match_type + '&year' + year + '&month=' + month + '&day=' + day
    
    req = urllib.request.Request(url)
    #http://live-tennis.eu/en/official-atp-ranking
    response = urllib.request.urlopen(req)

    html = response.read()

    soup = BeautifulSoup(html, "html.parser")
    
    soup.unicode
    
    table = soup.find("table", attrs={"class": "result"})
    
    trs = table.findAll('tr')
    
    result = []
          
    for tr in trs :
        #print(row)

        
        ## searching for match link
        
        if 'bott' in tr['class'] :   
            match_link = tr.find("td", text="info").a.attrs['href'].strip()
            result.append(match_link)
            continue
        
    return result

def get_te_match(match_url = "/match-detail/?id=1680141", matchtype='single', tour='atp'):
    result_id = 5

    url = 'http://www.tennisexplorer.com' + str(match_url) 
    
    id = int(url.split('=')[1])
    
    req = urllib.request.Request(url)
    #http://live-tennis.eu/en/official-atp-ranking
    response = urllib.request.urlopen(req)

    html = response.read()

    soup = BeautifulSoup(html, "html.parser")
    
    soup.unicode
    
    event = {}
    event['tennisexplorer_id'] = id
    
    
    center = soup.find("div", attrs={"id": "center"})
    
    event['matchtype'] = matchtype
    event['tour'] = tour
    event['event_name'] = center.find("h1", attrs={"class": "bg"}).text
    
    
    event_details = center.find("div")
    event_date, event_time, tournament, round, surface = event_details.text.split(',')
    
    if event_date == 'Today' :
        event_date = datetime.now().strftime("%d.%m.%Y")

    start = datetime.strptime(event_date + ' '+ event_time.strip(), '%d.%m.%Y %H:%M')
    start_ts = timezone.localize(start)
    

    event['datetime'] = {'startdatetime' : start_ts, 'date' : start_ts.date(), 'start_time' : event_time.strip(),\
                         'year' : start_ts.year, 'month' : start_ts.month, 'day' : start_ts.day, \
                         'weekday' : start_ts.weekday(), 'calendar_week' : start_ts.isocalendar()[1], \
                         'hour' : start_ts.hour, 'minutes' : start_ts.minute}
    event['tournament'] = tournament.strip()
    event['round'] = round.strip()
    event['surface'] = surface.strip()
    
    players = center.findAll("th", attrs={"class": "plName"})
    players_tbody = center.find("tbody")
        
    # get player name
    playerA = players[0]
    playerB = players[1]  
    
    if playerA.text > playerB.text :
        change_sort = True
    else :
        change_sort = False
    
    if change_sort :
        player1 = playerB
        player2 = playerA
    else :
        player1 = playerA
        player2 = playerB  
        
    # get player details
    
    player_left_attributes =  players_tbody.findAll('td', {"class" : "tl"})
    player_righ_attributes =  players_tbody.findAll('td', {"class" : "tr"})
    
    if change_sort :
        player1_attr = player_left_attributes
        player2_attr = player_righ_attributes
    else :
        player1_attr = player_righ_attributes
        player2_attr = player_left_attributes  

            
        
        
    dict_player1 = {'name' : player1.text, 'te_link' : player1.a.attrs['href'].strip(), \
                    'ranking_pos' : player1_attr[0].text, 'date_of_birth' : player1_attr[1].text, \
                    'height' : player1_attr[2].text, 'weight' : player1_attr[3].text, \
                    'plays' : player1_attr[4].text, 'turn_pro' : player1_attr[5].text}

    dict_player2 = {'name' : player2.text, 'te_link' : player2.a.attrs['href'].strip(), \
                    'ranking_pos' : player2_attr[0].text, 'date_of_birth' : player2_attr[1].text, \
                    'height' : player2_attr[2].text, 'weight' : player2_attr[3].text, \
                    'plays' : player2_attr[4].text, 'turn_pro' : player2_attr[5].text}
    
    event['player1'] = dict_player1
    event['player2'] = dict_player2
    
    
    # Result
    thead_result = center.find("thead")
    td_result_sets  = thead_result.find("td").text.split("(")[0]
    if td_result_sets != '\xa0' :
        td_result_games = thead_result.find("td").text.split("(")[1][:-1]
        sets = td_result_games.split(',')
    
        
        
        player_left_sets = td_result_sets[0:1]
        player_right_sets = td_result_sets[4:5]
        
        sets_player_left = {}
        sets_player_right = {}
        i = 0
        for set in sets :
            i = i + 1
            set_text = str(i)
            sets_player_left.update({set_text : int(set.split('-')[0].strip()[0:1])})
            sets_player_right.update({set_text : int(set.split('-')[1].strip()[0:1])})
        
        player1 = {'sets' : player_left_sets, 'set_results' : sets_player_left}
        player2 = {'sets' : player_right_sets, 'set_results' : sets_player_right}
            
        
        if change_sort :
            player1_result = {'sets' : player_right_sets, 'set_results' : sets_player_right}
            player2_result = {'sets' : player_left_sets, 'set_results' : sets_player_left}    
            result = td_result_sets[::-1]
        else :
            player1_result = {'sets' : player_left_sets, 'set_results' : sets_player_left}
            player2_result = {'sets' : player_right_sets, 'set_results' : sets_player_right}
            result = td_result_sets
        
        event['result'] = {'result' : result}
        event['result']['player1'] = player1_result
        event['result']['player2'] = player2_result
        event['status'] = 'complete'
    else:
        event['status'] = 'planned'
        
    # Head to Head
    headtohead = center.findAll("h2", attrs={"class": "bg"})[0].text
    head_to_head_formated = headtohead[-5:]
    if head_to_head_formated != '-head' :
        player_left_head_to_head = int(head_to_head_formated[:1])
        player_right_head_to_head = int(head_to_head_formated[-1:])
    
        
        if change_sort :
            head_to_head = {'head-to-head' : head_to_head_formated[::-1], \
                            'player1' : player_right_head_to_head, \
                            'player2' : player_left_head_to_head}
        else :
            head_to_head = {'head-to-head' : head_to_head_formated, \
                            'player1' : player_left_head_to_head, \
                            'player2' : player_right_head_to_head}
         
        event['head-to-head'] =  head_to_head
    else :
        result_id = result_id - 1
        
    # ODDS
    
#    odds_tabs = soup.findAll("ul", attrs={"class": "tabs"})[2]
    
    #odds_table = soup.findAll('table')[5]
    odds_result = soup.findAll('table', attrs={"class": "result"})
    odds_ou = soup.findAll('table', attrs={"class": "odds-ou"})
    odds_ah = soup.findAll('table', attrs={"class": "odds-ah"})
    odds_cs = soup.findAll('table', attrs={"class": "odds-cs"})
    
    event['te_odds'] = {}
   
    # Result Odds  
    if odds_result != [] :
        odds_table = odds_result[result_id].findAll('tr')
        
        #if odds_table[0]['class'] == 'one' or odds_table[0]['class'] == 'two' : 
        
        odds = {}
        for tr in odds_table:
            if ((tr.a) and (tr['class'] == ['one'] or tr['class'] == ['two'])) :
                bookie = tr.a.text.replace('\xa0','').lower()
                odds_left = float(tr.findAll('td', {'class' : 'k1'})[0].find(text=True))
                odds_right = float(tr.findAll('td', {'class' : 'k2'})[0].find(text=True))
                if change_sort :
                    player1_odds = odds_right
                    player2_odds = odds_left
                else :
                    player1_odds = odds_left
                    player2_odds = odds_right     
                odds.update({bookie : {'player1' : player1_odds, 'player2' : player2_odds}})
                #odds[bookie] = {'player1' : player1_odds, 'player2' : player2_odds}
                #odds[bookie].update({'bookie' : bookie'player1' : player1_odds, 'player2' : player2_odds})
                #odds[bookie].update({'player1' : player1_odds, 'player2' : player2_odds})
                
                #print(bookie, odds_left, odds_right)
    #            if 'Pinnacle' in tr.a.text :
    #                tds_home = tr.findAll('td', {'class' : 'k1'})
    #                tds_away = tr.findAll('td', {'class' : 'k2'})
    #                odds_home = float(tds_home[0].find(text=True))
    #                odds_away = float(tds_away[0].find(text=True))
                   
        event['te_odds'] = {'result' : odds }
    
    # Over,Under Odds
    if odds_ou != [] :
        odds_table_ou = odds_ou[0].findAll('tr')
        
        odds = {}
        for tr in odds_table_ou :
            if tr.a :
                bookie = tr.a.text.replace('\xa0','').lower()
                value = tr.find('td', attrs={'class' : 'value'}).text
                over = tr.find('td', attrs={'class' : 'k1'}).text[:4]
                under = tr.find('td', attrs={'class' : 'k2'}).text[:4]
                #print(bookie, value, over, under)
                
                if value in odds :
                    odds[value].update({bookie : {'over' : over, 'under' : under}})
                else :
                    odds[value] = {bookie : {'over' : over, 'under' : under}}
                
                
        event['te_odds']['over_under'] =  odds 

    # Asia Handicap Odds
    if odds_ah != [] :

        odds_table_ah = odds_ah[0].findAll('tr')
        
        odds = {}
        for tr in odds_table_ah :
            try :
                if tr['class'] == ['odds-type'] :
                    ah_bet_type = tr.text.replace("\n",'')
                    continue
            except :
                continue
            
            if tr.a :
                bookie = tr.a.text.replace('\xa0','').lower()
                value = tr.find('td', attrs={'class' : 'value'}).text
                odds_left = tr.find('td', attrs={'class' : 'k1'}).text[:4]
                odds_right = tr.find('td', attrs={'class' : 'k2'}).text[:4]
                #print(bookie, ah_bet_type, odds_left, odds_right)
                if change_sort :
                    player1_odds = odds_right
                    player2_odds = odds_left
                else :
                    player1_odds = odds_left
                    player2_odds = odds_right    
                
                if ah_bet_type in odds :
                    odds[ah_bet_type].update({bookie : {'player1' : player1_odds, 'player2' : player2_odds}})
                else :
                    odds[ah_bet_type] = {bookie : {'player1' : player1_odds, 'player2' : player2_odds}}
                
                
        event['te_odds']['ah'] =  odds         
    
    # correct Score Odds
    if odds_cs != [] :
        odds_table_cs = odds_cs[0].findAll('tr')
        
        odds = {}
        for tr in odds_table_cs :
            if tr.a :
                bookie = tr.a.text.replace('\xa0','').lower()
                value = tr.find('td', attrs={'class' : 'value'}).text
                odds_cs = tr.find('td', attrs={'class' : 'k1'}).text[:4]
                #print(bookie, value, odds)
                
                if value in odds :
                    odds[value].update({bookie : {'odds' : odds_cs}})
                else :
                    try :
                        odds[value] = {bookie : {'odds' : odds_cs}}
                    except:
                        continue
                
                
        event['te_odds']['correct_score'] =  odds 
                
    return event


#test 

i = 0
matches = get_te_matchlist(year = '2018', month = '05', day = '11', match_type="atp-single")
for match in matches :
    #try :
        print(match)
        events = get_te_match(match_url = match)
        print(events['event_name'], events['status'])
        i = i +1
        print(i)
        if i > 2 :
            break
    #except :
        #print("error", match)
    
    