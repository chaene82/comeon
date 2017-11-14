# -*- coding: utf-8 -*-
"""
Created on Mon Nov 13 17:25:55 2017

@author: haenec
"""


from comeon_etl import etl_import_sackmann,  etl_import_te

#sqllite3_path = 'c:\\users/haenec/python/home/comeon/data/te_data.db'

etl_import_te(days=400)
etl_import_sackmann(2017, "/home/chrhae/Documents/Privat/data/ffhs/DAS/ML/tennis_atp/")