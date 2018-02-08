#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep 14 17:01:56 2017

@author: chrhae
"""
import pandas as pd
from comeon_common import connect
from comeon_common import startBetLogging
from datetime import datetime, timedelta


conn, meta = connect()    
log = startBetLogging("create_ranking")


def createRanking(date) :
   
    log.info("Load ranking form Swisstennis")  
    sql = """
        select a."Player", a."FromDate", a."ToDate", a."SW1YALL",  b."SW3MALL", c."SW1MALL", d."SW1YG", e."SW1YH",  f."SW1YC"
        from "temp_ranking_SW1YALL" a
        left join "temp_ranking_SW3MALL" b using ("Player", "FromDate", "ToDate")
        left join "temp_ranking_SW1MALL" c using ("Player", "FromDate", "ToDate")        
        left join "temp_ranking_SW1YG" d using ("Player", "FromDate", "ToDate")
        left join "temp_ranking_SW1YH" e using ("Player", "FromDate", "ToDate")        
        left join "temp_ranking_SW1YC" f using ("Player", "FromDate", "ToDate") 
        where "FromDate" = date '{date}'         
        """
    d = {'date': date}
    sql = sql.format(**d)      
    
    sw_ranking = pd.read_sql(sql, conn)
    
    
    log.info("Load atp ranking form tennis explorer")    
    
    sql = """
         SELECT r."StartDate", p.player_id , r.points, r.rank, p.name_short
	       FROM public.tbl_te_ranking r
          inner join tbl_player p on (r.player_link = p.te_link)    
          where "StartDate" = date '{date}'         
          
        """
    d = {'date': date}
    sql = sql.format(**d)           
        
    atp_ranking = pd.read_sql(sql, conn)  
    
    if atp_ranking.empty :
        log.info("atp ranking empyt, load that form the previous week")  
        
        date_pre_week = date - timedelta(days=7)
        
        sql = """
             SELECT to_date as "StartDate", player_id ,  atp_points as points,  atp_rank as rank
    	       FROM public.tbl_rating 
              where from_date = date '{date}'         
              
            """
        d = {'date': date_pre_week }
        sql = sql.format(**d)           
            
        atp_ranking = pd.read_sql(sql, conn)         


    log.info("merge both together")
    
    ranking = pd.merge(sw_ranking, atp_ranking, how='inner', left_on=['Player','FromDate'], right_on = ['player_id','StartDate'])
    
    ranking = ranking[ranking['Player'] > 0]
    
    
    columns_select = ['Player', 'FromDate', 'ToDate', 'points', 'rank', 'SW1YG', 'SW1YH', 'SW1YC', 'SW1YALL', 'SW3MALL', 'SW1MALL']
    ranking_select = ranking[columns_select]
    
    columns_rename = ['player_id', 'from_date', 'to_date', 'atp_points', 'atp_rank', 'sw1yg', 'sw1yh', 'sw1yc', 'sw1yall', 'sw3mall', 'sw1mall']
    ranking_select.columns = columns_rename
    
    ranking_select = ranking_select.fillna(0.1)
    
    ranking_select['player_id'] = ranking_select['player_id'].astype('int32')
    ranking_select['atp_points'] = ranking_select['atp_points'].astype('float')
    
    log.info("store to database")

    
    ranking_select.to_sql("tbl_rating", conn, if_exists='append', index=False)
