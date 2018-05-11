"""
Created on Mon Apr 23 09:35:46 2018

@author: haenec
"""

from flask import Flask
app = Flask(__name__)

@app.route("/")
def web():
    return "Hello World!"