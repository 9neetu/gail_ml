from flask import Flask,render_template
from data import Customers
import json

app = Flask(__name__)

Customers = Customers()

@app.route("/")
def home():
    return render_template('home.html')

@app.route("/RFM_Classes")
def rfm():
    return render_template('RFM_Classes.json')

@app.route("/championsjs")
def championsjs():
    return render_template('champions.js')

@app.route("/rmfclassification")
def rmf():
    return render_template('rmfclassification.html')

@app.route("/salesprediction")
def sales():
    return render_template('salesprediction.html')


@app.route('/rmfclassification/champions')
def champions():
    return render_template('champions.html')

if __name__=="__main__":
    app.run(debug=True)
