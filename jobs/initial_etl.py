# -*- coding: utf-8 -*-
"""
Created on Mon Nov 13 17:25:55 2017

@author: haenec
"""


from comeon_etl import etl_import_sackmann,  etl_import_te
from comeon_etl import etl_transform_te, etl_transform_sackmann

#sqllite3_path = 'c:\\users/haenec/python/home/comeon/data/te_data.db'

etl_import_te(days=10000)
etl_import_sackmann(2010)

etl_transform_te()
etl_transform_sackmann()