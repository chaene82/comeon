# -*- coding: utf-8 -*-
"""
Created on Mon Nov 13 17:25:55 2017

@author: haenec
"""


from comeon_etl import modelSwisstennis

modelSwisstennis(start_value=0.1, days_between_run=7, look_back_weeks=4, ModelName='SW1MALL', StartDate="01/01/01")
