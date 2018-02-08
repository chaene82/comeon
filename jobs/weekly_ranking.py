# -*- coding: utf-8 -*-
"""
Created on Mon Nov 13 17:25:55 2017

@author: haenec
"""

from datetime import datetime, timedelta
from comeon_etl import etl_te_get_ranking, etl_import_te_weekly_ranking


#sqllite3_path = 'c:\\users/haenec/python/home/comeon/data/te_data.db'

date = datetime.now().date() - timedelta(days=9)
etl_te_get_ranking(date)
etl_import_te_weekly_ranking()