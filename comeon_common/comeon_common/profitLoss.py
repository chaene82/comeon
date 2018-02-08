# -*- coding: utf-8 -*-
"""
Scripts for handling all stuff checking Balances on the Bookma

@author: haenec
"""

from sqlalchemy import select
from datetime import datetime
from .base import connect, startBetLogging




def getProfitLoss() :
    """
    Daily Profit and Loss

    
    Args:
        None Parameter
        
    Returns:
        -
        
    """
    con, meta = connect()   
    log = startBetLogging('p_l')
    
       
    sql = """
    SELECT sum(winnings_eur - turnover_eur) as profitLoss
    FROM public.tbl_orderbook
    where bet_settlement_date = current_date - 1;
    """
    
    yesterday = con.execute(sql).fetchone()
    
    if yesterday[0] == None :
        yesterday = 0
    else :
        yesterday = float(yesterday[0])
    
    sql = """
    SELECT sum(winnings_eur - turnover_eur) as profitLoss
    FROM public.tbl_orderbook
    where date_trunc('month', bet_settlement_date) = date_trunc('month', current_date);
    """
    
    monthToDate = con.execute(sql).fetchone()    
   
    if monthToDate[0] == None :
        monthToDate = 0
    else :
        monthToDate = float(monthToDate[0])    
    
    sql = """
    SELECT sum(winnings_eur - turnover_eur) as profitLoss
    FROM public.tbl_orderbook
    where date_trunc('year', bet_settlement_date) = date_trunc('year', current_date);
    """
    
    yearToDate = con.execute(sql).fetchone() 

    if yearToDate[0] == None :
        yearToDate = 0
    else :
        yearToDate = float(yearToDate[0])
        
    # P&L Statement
 
    log.warning(str(yesterday) + " EUR (Profit yesterday)")
    log.warning(str(monthToDate) + " EUR (Profit month to date)")
    log.warning(str(yearToDate) + " EUR (Profit year to date)")
    

