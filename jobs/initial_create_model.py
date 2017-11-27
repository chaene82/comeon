# -*- coding: utf-8 -*-
"""
Created on Mon Nov 13 17:25:55 2017

@author: haenec
"""


from comeon_etl import modelSwisstennis
from comeon_etl import createRanking

#modelSwisstennis(start_value=0.1, days_between_run=7, look_back_weeks=52, ModelName='SW1YH', StartDate="01/02/17")
#modelSwisstennis(start_value=0.1, days_between_run=7, look_back_weeks=52, ModelName='SW1YG', StartDate="01/02/17")
#modelSwisstennis(start_value=0.1, days_between_run=7, look_back_weeks=52, ModelName='SW1YC', StartDate="01/02/17")


#modelSwisstennis(start_value=0.1, days_between_run=7, look_back_weeks=4, ModelName='SW1MALL', StartDate="01/02/17")
#modelSwisstennis(start_value=0.1, days_between_run=7, look_back_weeks=52, ModelName='SW1YALL', StartDate="01/02/17")
#modelSwisstennis(start_value=0.1, days_between_run=7, look_back_weeks=12, ModelName='SW3MALL', StartDate="01/02/17")


createRanking()