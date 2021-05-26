from flask import Flask, render_template, request, redirect
import mysql.connector

app = Flask(__name__)

@app.route('/Home')
def home():
    return render_template('home.html')

@app.route('/Tournament')
def tournament():
    return render_template('tournament.html')

if __name__ == "__main__":
    app.run(debug=True)
