from flask import Flask, render_template, request, redirect
import mysql.connector
import root_password as rp

app = Flask(__name__)
db = mysql.connector.connect(host="localhost", user="root", password=rp.get_password(), database="tourn")

@app.route('/Home')
def home():
    return render_template('home.html')

@app.route('/Tournament')
def tournament():
    return render_template('tournament.html')

if __name__ == "__main__":
    app.run(debug=True)
